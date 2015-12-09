#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

namespace :setup do

  desc 'Create a git pullall alias'
  task :submodules do
    submodule_list = `grep path .gitmodules | sed 's/.*= //'`.split(' ')

    if (ARGV.length > 1)
      system("git pull --rebase --recurse-submodules ${1-origin master}")

      # Update submodules according to the parameters
      params = ARGV.drop(1).map{ |arg| arg.split(':')}
      params_hash = Hash[*params.flatten]

      submodule_list.each do |submodule|
        puts "Updating #{submodule} submodule..."
        if params_hash.keys.include?(submodule)
          system("git config -f .git/config submodule.#{submodule}.branch #{params_hash[submodule]}")
          system("git submodule update --init --remote")
          system("git config -f .git/config submodule.#{submodule}.branch master")
        else
          system("git submodule update --init --remote")
        end
      end
    else
      system("git pullall")
    end

  exit # avoid parameters being interpreted as taks
  end
end

Share::Application.load_tasks
