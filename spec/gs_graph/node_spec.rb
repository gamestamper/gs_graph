require 'spec_helper'

describe GSGraph::Node do

  describe '.new' do
    it 'should setup endpoint' do
      GSGraph::Node.new('matake').endpoint.should == File.join(GSGraph::ROOT_URL, 'matake')
    end

    it 'should support access_token option' do
      GSGraph::Node.new('matake', :access_token => 'access_token').access_token.should == 'access_token'
    end

    it 'should store raw attributes' do
      attributes = {:key => :value}
      GSGraph::Node.new(12345, attributes).raw_attributes.should == attributes
    end
  end

  describe '#build_params' do
    let(:node) { node = GSGraph::Node.new('identifier') }
    let(:tmpfile) { Tempfile.new('tmp') }

    it 'should make all values to JSON or String' do
      client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
      params = node.send :build_params, {:hash => {:a => :b}, :array => [:a, :b], :integer => 123}
      params[:hash].should == '{"a":"b"}'
      params[:array].should == '["a","b"]'
      params[:integer].should == '123'
    end

    it 'should support Rack::OAuth2::AccessToken::Legacy as self.access_token' do
      client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
      node = GSGraph::Node.new('identifier', :access_token => Rack::OAuth2::AccessToken::Legacy.new(:access_token => 'token'))
      params = node.send :build_params, {}
      params[:access_token].should == 'token'
    end

    it 'should support Rack::OAuth2::AccessToken::Legacy as options[:access_token]' do
      client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
      params = node.send :build_params, {:access_token => Rack::OAuth2::AccessToken::Legacy.new(:access_token => 'token')}
      params[:access_token].should == 'token'
    end

    it 'should support Tempfile' do
      params = node.send :build_params, :upload => tmpfile
      (tmpfile.equal? params[:upload]).should be_true
      # NOTE: For some reason, below fails with RSpec 2.10.0
      # params[:upload].should == tmpfile
    end

    require 'action_dispatch/http/upload'
    it 'should support ActionDispatch::Http::UploadedFile' do
      upload = ActionDispatch::Http::UploadedFile.new(
        :tempfile => tmpfile
      )
      params = node.send :build_params, :upload => upload
      (params[:upload].equal? tmpfile).should be_true
      # NOTE: For some reason, below fails with RSpec 2.10.0
      # params[:upload].should == tmpfile
    end
  end

  describe '#handle_response' do
    it 'should handle null/false response' do
      node = GSGraph::Node.new('identifier')
      null_response = node.send :handle_response do
        HTTP::Message.new_response 'null'
      end
      null_response.should be_nil
      lambda do
        node.send :handle_response do
          HTTP::Message.new_response 'false'
        end
      end.should raise_error(
        GSGraph::NotFound,
        'Graph API returned false, so probably it means your requested object is not found.'
      )
    end

    it 'should raise GSGraph::Exception for invalid JSON response' do
      node = GSGraph::Node.new('identifier')
      expect do
        node.send :handle_response do
          HTTP::Message.new_response 'invalid'
        end
      end.to raise_error GSGraph::Exception
    end
  end

end