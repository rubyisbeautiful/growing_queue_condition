# GrowingQueueCondition

This is a God::Condition for god [http://godrb.com/] to alert on a queue that is growing.  The principal use case is
for a background processors, such as DelayedJob, Resque, ActiveMQ, etc...
but could be for any growing queue/table/data store.

## Installation

Add this line to your application's Gemfile:

    gem 'growing_queue_condition'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install growing_queue_condition

## Usage

The gem requires a class that responds to an instance method queue_size.  The class must be accessible to god.

### Example

``my_class.rb``
{code}
class MyClass

def <<*self

  def queue_size
    # code returning an int or int-able value
  end

end
{code}

``god_config.rb``
{code}
require 'growing_queue_condition'

restart.condition(:growing_queue) do |c|
    c.times     = [3,5]
    c.interval  = 30.seconds
    c.obj       = MyClass.new
end

{code}

The example will call the instantiated MyClass instance method queue_size at least 4 times.  If the size is larger or
the same each time, the condition will fail.  See 'Examples' for possible usages.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
