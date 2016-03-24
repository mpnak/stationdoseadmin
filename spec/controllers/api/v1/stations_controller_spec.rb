require 'rails_helper'

RSpec.describe Api::V1::StationsController, type: :controller do
  describe "GET #show" do
    before(:each) do
      @station = FactoryGirl.create :station
      @user = FactoryGirl.create :user
      @station_link = @station.user_station_links.where(user: @user).first_or_create
      @station_link.saved_station = true
      @station_link.save
      request.headers['Authorization'] =  @user.auth_token
      get :show, id: @station.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      @station_link.reload

      _response = json_response[:station]
      expect(_response[:name]).to eql @station.name
      expect(_response[:undergroundness]).to eql @station_link.undergroundness
      expect(_response[:saved_station]).to eql @station_link.saved_station
    end

    it { should respond_with 200 }
  end

  describe "#index" do

  end

  describe "#generate_tracks" do

    before(:each) do
      @station = FactoryGirl.create :station
      @user = FactoryGirl.create :user
    end

    it "should generate tracks without a user" do
      post :generate_tracks, id: @station.id, format: :json
      _response = json_response[:tracks]
      expect(_response.count).to be 30
    end

    it "should generate tracks for a user" do
      request.headers['Authorization'] =  @user.auth_token
      post :generate_tracks, id: @station.id, format: :json
      _response = json_response[:tracks]
      expect(_response.count).to be 30

      @station.reload

      station_link = @station.user_station_links.where(user: @user).first
      expect(station_link).not_to be nil
      expect(station_link.tracks.count).to be 30
    end
  end

  describe "#get_tracks" do

    it "reponds with the same tracks" do
      @station = FactoryGirl.create :station
      @user = FactoryGirl.create :user
      request.headers['Authorization'] =  @user.auth_token
      post :generate_tracks, id: @station.id, format: :json

      generated_tracks = json_response[:tracks]

      get :get_tracks, id: @station.id, format: :json

      get_tracks = json_response[:tracks]

      expect(generated_tracks).to eq get_tracks
    end

  end

  # #update only makes sense in the context of a users preferences. The actual station is not updated
  describe "#update" do

    it "should update a user_station_link" do
      @station = FactoryGirl.create :station
      @user = FactoryGirl.create :user
      station_link = @station.user_station_links.where(user: @user).first_or_create
      station_link.undergroundness = 2
      station_link.save

      station_params = { id: @station.id, undergroundness: 4 }
      request.headers['Authorization'] =  @user.auth_token
      put :update, id: @station.id, station: station_params, format: :json

      station_link.reload

      expect(station_link.undergroundness).to eq 4
      expect(json_response[:station][:undergroundness]).to eq 4
    end

    it "should 401 if there is no user" do
      @station = FactoryGirl.create :station
      put :update, id: @station.id, format: :json

      expect(response.status).to eq 401
    end

  end

end
