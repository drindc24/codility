require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#create' do
    let(:response_body){ JSON.parse(response.body) }

    context 'the parameter "user[name]" is not blank' do
      it 'creates a new user' do
        expect {
          post '/users', params: { user: { name: 'sample' } }
        }.to change{ User.count }.by(1)
      end

      before do
        post '/users', params: { user: { name: 'sample' } }
      end

      it 'renders an empty response' do
        expect(response.body).to be_empty
      end

      it 'renders a response with status 200' do
        expect(response.code).to eq "200"
      end
    end

    context 'the parameter "user[name]" is blank' do
      it 'does not create a new user' do
        expect {
          post '/users', params: { user: { name: '' } }
        }.to change{ User.count }.by(0)
      end

      before do
        post '/users', params: { user: { name: '' } }
      end

      it 'renders an empty response' do
        expect(response.body).to_not be_empty
      end

      it 'renders a response with status 200' do
        expect(response.code).to eq "422"
      end

      it 'renders a json object {"errors": {"name": ["can\'t be blank"]}}' do
        expect(response_body).to eq({"errors"=>{"name"=>["can't be blank"]}})
      end
    end
  end
end