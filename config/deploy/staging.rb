role :app, %w{root@stereo-shop.ru}
role :web, %w{root@stereo-shop.ru}
role :db,  %w{root@stereo-shop.ru}

server 'stereo-shop.ru', user: 'root', password: 'T5jQCbuwBV', roles: %w{web app}

set :rails_env, 'staging'
set :branch,    'staging'
