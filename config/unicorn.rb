rails_root = "/srv/www/stereo_shop/#{ ENV['RAILS_ENV'] }"
shared_p   = "#{ rails_root }/shared"

# pid_file   = "#{ shared_p }/tmp/pids/unicorn.#{ ENV['RAILS_ENV'] }.pid"
log_file   = "#{ shared_p }/log/unicorn.#{ ENV['RAILS_ENV'] }.log"
err_log    = "#{ shared_p }/log/unicorn.#{ ENV['RAILS_ENV'] }.err"

preload_app true
stderr_path err_log
stdout_path log_file

# pid pid_file
working_directory shared_p

listen "#{ shared_p }/tmp/sockets/unicorn.#{ ENV['RAILS_ENV'] }.sock", backlog: 1024

timeout 30
worker_processes 3

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{ rails_root }/current/Gemfile"
end

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to
send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
