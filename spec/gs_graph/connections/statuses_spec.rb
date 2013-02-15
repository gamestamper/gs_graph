require 'spec_helper'

describe GSGraph::Connections::Statuses, '#statuses' do

  context 'when included by GSGraph::User' do
    context 'when no access_token given' do
      it 'should raise GSGraph::Unauthorized' do
        mock_graph :get, 'arjun/statuses', 'users/statuses/arjun_public', :status => [401, 'Unauthorized'] do
          lambda do
            GSGraph::User.new('arjun').statuses
          end.should raise_exception(GSGraph::Unauthorized)
        end
      end
    end

    context 'when access_token is given' do
      it 'should return statuses as GSGraph::Status' do
        mock_graph :get, 'arjun/statuses', 'users/statuses/arjun_private', :access_token => 'access_token' do
          statuses = GSGraph::User.new('arjun', :access_token => 'access_token').statuses
          statuses.first.should == GSGraph::Status.new(
            '113559395341627',
            :access_token => 'access_token',
            :from => {
              :id => '7901103',
              :name => 'Arjun Banker'
            },
            :message => 'http://www.gamestamper.com/photo.php?pid=60538827&l=79b44ffb74&id=7901103',
            :updated_time => '2010-04-21T21:10:16+0000'
          )
          statuses.each do |status|
            status.should be_instance_of(GSGraph::Status)
          end
        end
      end
    end
  end

  context 'when included by GSGraph::Page' do
    context 'when no access_token given' do
      it 'should raise GSGraph::Unauthorized' do
        mock_graph :get, 'platform/statuses', 'pages/statuses/platform_public', :status => [401, 'Unauthorized'] do
          lambda do
            GSGraph::Page.new('platform').statuses
          end.should raise_exception(GSGraph::Unauthorized)
        end
      end
    end

    context 'when access_token is given' do
      it 'should return statuses as GSGraph::Status' do
        mock_graph :get, 'platform/statuses', 'pages/statuses/platform_private', :access_token => 'access_token' do
          statuses = GSGraph::Page.new('platform', :access_token => 'access_token').statuses
          statuses.first.should == GSGraph::Status.new(
            '111081598927600',
            :access_token => 'access_token',
            :from => {
              :id => '19292868552',
              :name => 'Facebook Platform',
              :category => 'Technology'
            },
            :message => 'Here\'s more information on the new social plugins announced at f8 today - http://bit.ly/db8ahS',
            :updated_time => '2010-04-21T20:17:04+0000'
          )
          statuses.each do |status|
            status.should be_instance_of(GSGraph::Status)
          end
        end
      end
    end
  end

end