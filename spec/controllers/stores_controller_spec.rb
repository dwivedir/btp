require 'rails_helper'

RSpec.describe StoresController, :type => :controller do
  describe "method index" do
    it "should respond success" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "should be an Array" do
      attr1 = create(:store)
      attr2 = create(:store, :location => "/home/fake")
      get :index
      files = assigns(@stores)
      expect(files[:stores].first).to eq(attr1)
      expect(files[:stores].second).to eq(attr2)
    end
  end

  describe "method show and edit" do
    it "should respond success" do
      get :show, :id => 1
      expect(response).to be_success
      expect(response).to have_http_status(200)
      get :edit, :id => 1
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "should return the proper record" do
      attr1 = create(:store)
      get :show, :id => 1
      file = assigns(@store)
      expect(file[:store]).to eq(attr1)
      get :edit, :id => 1
      file = assigns(@store)
      expect(file[:store]).to eq(attr1)
    end
  end

  describe "method update " do
    it "should update the attributes" do
      attr1 = create(:store)
      attr2 = build(:store, :location => "/home/fake")
      attr = attributes_for(:store, :location => "/home/fake")
      post :update, {:id => 1}.merge(:store => attr)
      expect(Store.first.location).to eq(attr[:location])
    end
  end
  
  describe "method destroy" do
    it "should delete the record" do
      attr1 = create(:store)
      attr2 = create(:store, :location => "/home/fake")
      post :destroy, :id => 1
      expect(Store.first).to eq(attr2)
    end
  end

end
