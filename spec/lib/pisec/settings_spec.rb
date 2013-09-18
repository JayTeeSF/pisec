require 'spec_helper'
require 'stringio'

# given
describe Pisec::Settings do
  let(:namespace) { "Pisec" }
  #let(:config_file_dir) { "#{Rails.root}/spec/support/config" }
  #let(:config_file_name) { "settings.sh" }

  def key(name, space=nil)
    space ? "#{space}_#{name}" : name.to_s
  end

  let(:renamed_data) {
    {
      key("foo", "otherspace").upcase => {key("foo") => "foo value"},
      key("bar", "otherspace").upcase => {key("bar") => "bar value"},
      key("baz", "otherspace").upcase => {key("baz") => "baz value"}
    }
  }

  let(:default_data) {
    {
      key("foo", namespace).upcase => {key("foo") => "foo value"},
      key("bar", namespace).upcase => {key("bar") => "bar value"},
      key("baz", namespace).upcase => {key("baz") => "baz value"}
    }
  }

  let(:default_args) { default_data }
  let(:settings) { Pisec::Settings.new(default_args) }

  context "compare settings" do
    it "recognizes setting objects with same namespaces" do
      expect( Pisec::Settings.load({}, :ns1) ).to eq(
        Pisec::Settings.load({}, :ns1)
      )
    end

    it "distinguishes setting objects with different namespaces" do
      expect( Pisec::Settings.load({}, :ns1) ).to_not eq(
        Pisec::Settings.load({}, :ns2)
      )
    end
  end

  context "create settings" do
    it "loads an equivalent settings object" do
      expect( Pisec::Settings.load(default_data) ).to eq(Pisec::Settings.new(default_args))
    end
  end

  let(:blank_settings) { Pisec::Settings.new }
  #when
  context "invalid config" do
    let(:invalid_config) { nil }
    it "loads an equivalent settings object" do
      blank_settings.load( default_data )
      expect( blank_settings ).to eq(Pisec::Settings.new(default_args))
    end

    it "raises a RuntimeError when loading invalid config" do
      expect { blank_settings.load( invalid_config ) }.to raise_error(RuntimeError)
    end
  end

  context "valid config" do
    context "that is escaped" do
      let(:config_string) { %Q{export #{key('ADMIN_ROLE_NAME', namespace).upcase}=%Q/{\"#{key('admin_role_name')}\":\"admin\"}/} }
      let(:yaml) { StringIO.new(config_string) }
      let(:expected_data) {
        {
          key("ADMIN_ROLE_NAME", namespace).upcase => {key("admin_role_name") => "admin"},
        }
      }

      it "loads correctly" do
        expected = Pisec::Settings.new(expected_data, :namespace => namespace)

        Pisec::Settings.should_receive(:_open_file).and_return( yaml )
        got = Pisec::Settings.load_file( :yaml_file_name, namespace )
        expect(got).to eq(expected)
      end

      context "getting values" do
        it "retrieves the key's value" do
          settings_object = Pisec::Settings.new(expected_data, :namespace => namespace)
          expect(settings_object.get("admin_role_name")).to eq("admin")
        end
      end
    end

    context "that is empty" do
      it "raises a RuntimeError for an unknown key" do
        expect { blank_settings.get( :unknown_key, :namespace => namespace ) }.to raise_error(RuntimeError)
        expect { blank_settings.get( :unknown_key ) }.to raise_error(RuntimeError)
      end
    end
  end
end
