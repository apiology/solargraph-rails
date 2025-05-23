source 'https://rubygems.org'

group :development, :test do
  gem 'bundler-audit'
  gem 'debug'
  gem 'byebug'
end

# Specify your gem's dependencies in solargraph_rails.gemspec
gemspec

gem 'solargraph',
    github: 'apiology/solargraph',
    branch: '2025-04-28'

# Local gemfile for development tools, etc.
local_gemfile = File.expand_path(".Gemfile", __dir__)
instance_eval File.read local_gemfile if File.exist? local_gemfile
