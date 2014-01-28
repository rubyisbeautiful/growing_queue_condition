class DjExample

  attr_accessor :user
  attr_accessor :pass
  attr_accessor :host
  attr_accessor :db
  attr_accessor :table


  def initialize(opts={})
    @user = opts[:user]
    @pass = opts[:pass]
    @host = opts[:host]
    @db = opts[:db]
    @table = opts[:table]
  end


  # this is a pretty lame example that uses command line mysql client instead of mysql2
  def queue_size
    `mysql -u #{user} -p'#{pass}' -h #{host} --silent --skip-column-names #{db} --execute 'select count(*) from #{table}'`
  end

end