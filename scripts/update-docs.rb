#!/usr/local/env ruby
# encoding : utf-8

tag = ENV["TRAVIS_TAG"] || ""
token = ENV["GH_PAGES_GITHUB_API_TOKEN"] || ""

if tag.empty? or token.empty?
  puts "Skip gh-pages updates for the commit:"
  puts "\n    #{ENV['TRAVIS_COMMIT_MESSAGE']}\n"
  return
end

Dir.chdir("docs") do
  puts "Updating gh-pages..."
  %x(git remote add upstream "https://#{token}@github.com/carousell/pickle.git")
  %x(git push --quiet upstream HEAD:gh-pages)
  %x(git remote remove upstream)
end
