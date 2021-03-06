require 'spec_helper'

describe GSGraph::Connections::Scores do
  let(:user) { GSGraph::User.new('matake', :access_token => 'user_access_token') }
  let(:app) { GSGraph::Application.new('GSGraph', :access_token => 'app_access_token') }

  describe '#scores' do
    it 'should return an Array of Score' do
      mock_graph :get, 'matake/scores', 'users/scores/sample', :access_token => 'user_access_token' do
        scores = user.scores
        scores.should be_a Array
        scores.should_not be_blank
        scores.each do |score|
          score.should be_instance_of GSGraph::Score
          score.user.should be_instance_of GSGraph::User
          score.application.should be_instance_of GSGraph::Application
          score.score.should be_a Integer
        end
      end
    end
  end

  describe '#score!' do
    it 'should return true' do
      mock_graph :post, 'matake/scores', 'true', :access_token => 'app_access_token', :params => {
        :score => '10'
      } do
        user.score!(10, :access_token => app.access_token).should be_true
      end
    end
  end

  describe '#unscore!' do
    it 'should return true' do
      mock_graph :delete, 'matake/scores', 'true', :access_token => 'app_access_token' do
        user.unscore!(:access_token => app.access_token).should be_true
      end
    end
  end
end
