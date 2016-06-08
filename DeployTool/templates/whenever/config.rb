set :environment_variable, 'RAILS_ENV'
set :output, { :error => "<%= fetch :log_dir %>/cron.err.log", :standard => "<%= fetch :log_dir %>/cron.log" }

job_type :rake, "cd <%= current_path %> && <%= rvm_do %> bundle exec rake :task :environment_variable=:environment :output"

every 3.hours do
  rake 'ts:rebuild', environment: environment
end

every 1.day, at: '4:30 am' do
  rake 'periodic_tasks:destroy_expired_carts', environment: environment
end


