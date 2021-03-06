require 'spec_helper'

describe GSGraph::Status, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :from => {
        :id => '23456',
        :name => 'nov matake'
      },
      :message => 'hello, how are you?',
      :updated_time => '2010-01-02T15:37:41+0000'
    }
    status = GSGraph::Status.new(attributes.delete(:id), attributes)
    status.identifier.should   == '12345'
    status.from.should         == GSGraph::User.new('23456', :name => 'nov matake')
    status.message.should      == 'hello, how are you?'
    status.updated_time.should == Time.parse('2010-01-02T15:37:41+0000')
  end

  it 'should support page as from' do
    page_status = GSGraph::Status.new('12345', :from => {
      :id => '23456',
      :name => 'Smart.fm',
      :category => 'Web Site'
    })
    page_status.from.should == GSGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
  end

end