require 'rails_helper'

RSpec.describe Store, :type => :model do
  describe "make_dir" do
    it "should make the directory" do
      dir = "#{Rails.root}/abcd"
      Store.make_dir(dir)
      expect(File.directory? dir).to eq(true)
      FileUtils.rm_rf(dir)
    end
  end

  describe "about table" do
    it "should be valid" do
      file = build(:store)
      expect(file).to be_valid
      file = create(:store)
      expect(file).to be_valid
    end
  end
end
