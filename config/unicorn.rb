rails_root  = "/srv/www/stereo_shop/#{ ENV['RAILS_ENV'] }/shared"
pid_file    = "#{rails_root}/tmp/pids/unicorn.#{ ENV['RAILS_ENV'] }.pid"
socket_file = "#{rails_root}/tmp/sockets/unicorn.#{ ENV['RAILS_ENV'] }.sock"
log_file    = "#{rails_root}/log/unicorn.#{ ENV['RAILS_ENV'] }.log"
err_log     = "#{rails_root}/log/unicorn.#{ ENV['RAILS_ENV'] }.err"

pid pid_file
preload_app true
stderr_path err_log
stdout_path log_file

listen socket_file, backlog: 1024

timeout 30
worker_processes 3

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

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
