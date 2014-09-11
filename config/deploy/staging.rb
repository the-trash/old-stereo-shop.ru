role :app, %w{root@104.131.34.236}
role :web, %w{root@104.131.34.236}
role :db,  %w{root@104.131.34.236}

server '104.131.34.236', user: 'root', password: 'T5jQCbuwBV', roles: %w{web app}

set :rails_env, 'staging'
