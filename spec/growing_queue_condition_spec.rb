require 'spec_helper'

def setup_test(condition, max_size, ary)
  ary.reverse!

  t = God::Timeline.new(max_size)
  begin
    t.push ary.pop
  end until ary.empty?

  condition.instance_variable_set('@timeline', t)
end


describe God::Conditions::GrowingQueue do

  before :each do
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

    context 'sanity check on setup_test' do

      it 'should return a properly setup object' do
        setup_test(subject, 3, [1,2,3])

        t = subject.instance_variable_get('@timeline')
        t[0].should == 1
        t[1].should == 2
        t[2].should == 3
      end

    end


    context 'when times is 3,5' do

      let(:subject){ God::Conditions::GrowingQueue.new }

      before :each do
        subject.times = [3,5]
      end

      it 'should be false with results 0,0 pushing 0 (not growing)' do
        obj = double
        obj.should_receive(:call).with(:queue_size).and_return 0

        subject.obj = obj
        setup_test(subject, 5, [0,0])

        subject.test.should be_false
      end

      it 'should be false with results 1,2 pushing 3 (not enough info)' do
        obj = double
        obj.should_receive(:call).with(:queue_size).and_return 3

        subject.obj = obj
        setup_test(subject, 5, [1,2])

        subject.test.should be_false
      end

      it 'should be true with results 1,2,3,4 pushing 5 (growing)' do
        obj = double
        obj.should_receive(:call).with(:queue_size).and_return 5

        subject.obj = obj
        setup_test(subject, 5, [1,2,3,4])

        subject.test.should be_true
      end

      it 'should be false with results 1,2,3,4 pushing 3 (not growing)' do
        obj = double
        obj.should_receive(:call).with(:queue_size).and_return 3

        subject.obj = obj
        setup_test(subject, 5, [1,2,3,4])

        subject.test.should be_false
      end

      it 'should be true with results 1,1,1,1 pushing 1 (not shrinking)' do
        obj = double
        obj.should_receive(:call).with(:queue_size).and_return 1

        subject.obj = obj
        setup_test(subject, 5, [1,1,1,1])

        subject.test.should be_true
      end

      it 'should be true with results 1,2,1,2 pushing 2 (3 of 5 fails)' do
        obj = double
        obj.should_receive(:call).with(:queue_size).and_return 2

        subject.obj = obj
        setup_test(subject, 5, [1,2,1,2])

        subject.test.should be_true
      end

      it 'should be false with results 1,2,1,2 pushing 1 (2 of 5 fails)' do
        obj = double
        obj.should_receive(:call).with(:queue_size).and_return 1

        subject.obj = obj
        setup_test(subject, 5, [1,2,1,2])

        subject.test.should be_false
      end

    end

  end


end