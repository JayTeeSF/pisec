require 'spec_helper'

# given
describe Pisec do
  let(:name_space) { "PISpec" }
  #let(:config_file_dir) { "#{Rails.root}/spec/support/config" }
  #let(:config_file_name) { "settings.sh" }


  let(:settings) { Pisec::Settings.new }
  #when
  context "invalid config" do
    it "raises a RuntimeError when loading invalid config" do
      expect( settings.load( invalid_config ) ).to raise_error(RuntimeError)
    end
  end

  context "valid config" do
  context "that is empty" do
  # let(:config) { %Q{export #{name_space}_ADMIN_ROLE_NAME="{\"admin_role_name\":\"admin\"}"} }
    it "raises a RuntimeError for an unknown key" do
      expect( settings.get( :unknown_key, :name_space => name_space ) ).to raise_error(RuntimeError)
      expect( settings.get( :unknown_key ) ).to raise_error(RuntimeError)
    end
  end
  end
end
