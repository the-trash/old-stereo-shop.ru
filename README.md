Stereo-Shop
=====

Getting Started
---------------

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

After seeds you can generate photos. For example run in console: `PhotoSeedsWorker.perform_async('Product')`

It assumes you have a machine equipped with Ruby, Postgres, Redis, etc. If not,
set up your machine with [this script].

#### Locales

You can generate locales for JS. Just run: `rake i18n:js:export`

[this script]: https://github.com/thoughtbot/laptop

Net::SMTPFatalError: 550 5.1.1 <ilya-zykin@stereo-shop.ru>... User unknown