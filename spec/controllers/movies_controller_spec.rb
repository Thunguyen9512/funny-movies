# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  before do
    user = create(:user)
    sign_in(user)
  end

  describe "GET /index" do
    it "renders the :index view" do
      get :index
      expect(response.status).to eq 200
    end
  end

  describe 'POST /movies' do

    let(:params) do
      {
        movie: {
          movie_url: movie_url,
          title: title
        }
      }
    end

    context 'when invalid url' do
      let(:movie_url) { nil }
      let(:title) { Faker::Movie.title }
      subject do
        post :create, params: params
        response
      end
      it 'should redirect and show error message!' do
        expect { subject }.not_to change(Movie, :count)
        expect(request.flash[:error]).to eq('Something wrong, please try again')
        expect(response.status).to eq 302
      end
    end

    context 'when invalid title' do
      let(:movie_url) { 'https://www.youtube.com/watch?v=K_tE-ZBze0M&list=RDKXy_q2vOzjg&index=14&ab_channel=TaynguyenSoundOfficial' }
      let(:title) { nil }
      subject do
        post :create, params: params
        response
      end
      it 'should redirect and show error message!' do
        expect { subject }.not_to change(Movie, :count)
        expect(request.flash[:error]).to eq('Something wrong, please try again')
        expect(response.status).to eq 302
      end
    end

    context 'when valid url and title' do
      let(:movie_url) { 'https://www.youtube.com/watch?v=K_tE-ZBze0M&list=RDKXy_q2vOzjg&index=14&ab_channel=TaynguyenSoundOfficial' }
      let(:title) { Faker::Movie.title }
      subject do
        post :create, params: params
        response
      end
      it 'should redirect and show success message!' do
        expect { subject }.to change(Movie, :count).by(1)
        expect(request.flash[:notice]).to eq('Movies succesfull shared')
        expect(response.status).to eq 302
      end
    end
  end

  describe 'PUT /movies' do

    let(:params) do
      {
        movie: {
          movie_url: movie_url,
          title: title
        }
      }
    end

    context 'when invalid url' do
      let(:movie_url) { nil }
      let(:title) { Faker::Movie.title }
      subject do
        post :create, params: params
        response
      end
      it 'should redirect and show error message!' do
        expect { subject }.not_to change(Movie, :count)
        expect(request.flash[:error]).to eq('Something wrong, please try again')
        expect(response.status).to eq 302
      end
    end

    context 'when invalid title' do
      let(:movie_url) { 'https://www.youtube.com/watch?v=K_tE-ZBze0M&list=RDKXy_q2vOzjg&index=14&ab_channel=TaynguyenSoundOfficial' }
      let(:title) { nil }
      subject do
        post :create, params: params
        response
      end
      it 'should redirect and show error message!' do
        expect { subject }.not_to change(Movie, :count)
        expect(request.flash[:error]).to eq('Something wrong, please try again')
        expect(response.status).to eq 302
      end
    end

    context 'when valid url and title' do
      let(:movie_url) { 'https://www.youtube.com/watch?v=K_tE-ZBze0M&list=RDKXy_q2vOzjg&index=14&ab_channel=TaynguyenSoundOfficial' }
      let(:title) { Faker::Movie.title }
      subject do
        post :create, params: params
        response
      end
      it 'should redirect and show success message!' do
        expect { subject }.to change(Movie, :count).by(1)
        expect(request.flash[:notice]).to eq('Movies succesfull shared')
        expect(response.status).to eq 302
      end
    end
  end

  describe 'POST /movies/like' do

    let(:params) do
      {
        movie: {
          movie_url: movie_url,
          title: title
        }
      }
    end

    context 'user like for first time' do
      let(:movie) { create(:movie) }
      subject do
        post :like, params: { id: movie.id }, format: :js
      end
      
      it 'should increase like count' do
        expect { subject }.to change(React, :count).by(1)
      end
    end
  end
end
