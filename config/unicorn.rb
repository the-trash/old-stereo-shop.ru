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
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
