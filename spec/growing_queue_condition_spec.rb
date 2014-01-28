require 'spec_helper'

describe God::Conditions::GrowingQueue do

  before :all do
    # don't care about logging and don't want to see it on STDOUT
    God.log_file = '/dev/null'
  end


  context 'initialize' do

    before :each do
      subject.stub(:obj).and_return double.as_null_object
    end

    it 'should set a default method' do
      subject.meth.should == :queue_size
    end
  end


  context 'valid' do

    it 'should be false if obj is not set' do
      subject.stub(:watch).and_return(double(name: 'foo').as_null_object)
      subject.valid?.should be_false
    end
  end


  context 'test' do

    it 'should be false'
    it 'should be true'

  end


end