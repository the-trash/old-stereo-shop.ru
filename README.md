Stereo-Shop
=====

Getting Started
---------------

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

After seeds you can generate photos. For example run in console:

    PhotoSeedsWorker.perform_async(Product)

It assumes you have a machine equipped with Ruby, Postgres, Redis, etc. If not,
set up your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop
