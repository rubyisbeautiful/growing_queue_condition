module God
  module Conditions
    # Condition Symbol :growing_queue
    # Type: Poll
    #
    # Trigger when a queue is growing
    #
    # Parameters
    # Required
    #   +obj+ is an instance of a queue interface class
    # Optional
    #   +method+ is the method to call, it defaults to queue_size
    #
    # Examples
    #
    # Trigger if the queue has grown 3 out of the last 5 checks
    #
    # restart.condition(:growing_queue) do |c|
    #   c.times     = [3,5]
    #   c.interval  = 30.seconds
    #   c.obj       = MyClass.new
    # end
    class GrowingQueue < PollCondition
      attr_accessor :times, :obj, :meth


      def initialize
        super
        self.times ||= [2, 3]
        self.meth ||= :queue_size
      end


      def prepare
        if self.times.kind_of? Integer
          self.times = [self.times, self.times]
        end

        @timeline = Timeline.new(self.times[1])
      end


      def reset
        @timeline.clear
      end


      def valid?
        valid = true
        valid &= complain("Attribute 'obj' must be specified", self) if self.obj.nil?
        valid
      end


      def test
        failing = false
        count = obj.call(meth)
        num_of_fails = times[0]
        num_of_tests = times[1]

        @timeline.push count.to_i

        history = "[#{@timeline.join(', ')}]"

        if @timeline.length < num_of_tests
          self.info = 'not enough info'
          return false
        end

        ary = @timeline.dup.flatten
        fails = []

        (num_of_fails == num_of_tests ? num_of_fails-1 : num_of_fails).times do
          if ary[-1] == 0
            fails << false
          else
            fails << (ary[-1] >= ary[-2])
          end
          ary.shift
        end

        bad, good = fails.partition { |f| TrueClass === f }
        failing = bad.length >= num_of_fails

        if failing
          self.info = "count increasing: (#{bad.length} fails #{history}"
          return true
        else
          self.info = "count ok: #{history}"
          return false
        end
      end
    end
  end
end
