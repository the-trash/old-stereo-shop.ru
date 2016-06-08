Icd /Users/the-teacher/rails/work/stereo-shop.ru/DeployTool
bundle
RVM_HOOK=false cap production rsync:files
RVM_HOOK=false cap production db:dump

cd ..
rake db:drop && rake db:create

pg_restore -h localhost -d stereo_shop_dev -U the-teacher /Users/the-teacher/rails/my_projects/DUMPS/stereo_shop_production.2016_04_26_23_21.pg.sql

time rsync -chavzPr \
  /Users/the-teacher/rails/work/HAKUSHU_2/public/uploads/stereo-shop.ru \
  rails@poweruser.ru:/home/rails/www/stereo-shop.ru/SHARED/public/uploads


/home/rails/www/stereo-shop.ru/current

RAILS_ENV=production rake db:drop
RAILS_ENV=production rake db:create