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

    let!(:movie) { create(:movie, user: controller.current_user) }
    let(:params) do
      {
        id: movie.id,
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
        put :update, params: params
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
        put :update, params: params
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
        put :update, params: params
        response
      end
      it 'should redirect and show success message!' do
        expect { subject }.not_to change(Movie, :count)
        expect(request.flash[:notice]).to eq('Movies succesfull update')
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

    context 'new like' do
      let(:movie) { create(:movie) }
      subject do
        post :like, params: { id: movie.id }, format: :js
        response
      end

      it 'should increase like count' do
        expect { subject }.to change(movie.reacts.like, :count).by(1)
                          .and change(movie.reacts.dislike, :count).by(0)
        expect(movie.liked_by?(controller.current_user)).to be_truthy
        expect(response.status).to eq 200
      end
    end

    context 'new dislike' do
      let(:movie) { create(:movie) }
      subject do
        post :dislike, params: { id: movie.id }, format: :js
        response
      end

      it 'should increase like count' do
        expect { subject }.to change(movie.reacts.dislike, :count).by(1)
                          .and change(movie.reacts.like, :count).by(0)
        expect(movie.dislike_by?(controller.current_user)).to be_truthy
        expect(response.status).to eq 200
      end
    end

    context 'toggle like to dislike' do
      let(:movie) { create(:movie) }
      let!(:react) { create(:react, movie: movie, react_type: 'like', user: controller.current_user) }
      subject do
        post :dislike, params: { id: movie.id }, format: :js
        response
      end

      it 'should increase dislike count' do
        expect { subject }.to change(movie.reacts.like, :count).by(-1)
                          .and change(movie.reacts.dislike, :count).by(1)
        expect(movie.liked_by?(controller.current_user)).to be_falsey
        expect(movie.dislike_by?(controller.current_user)).to be_truthy
        expect(response.status).to eq 200
      end
    end
  end
end
