lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'solargraph/rails/version'


solargraph_force_ci_version = (ENV['CI'] && ENV['MATRIX_SOLARGRAPH_VERSION'])
solargraph_version =
  if solargraph_force_ci_version
    [solargraph_force_ci_version]
  else
    # below this isn't tested in CI
    '>= 0.48.0',
    # did not have support for global conventions
    '!=0.53.0', '!=0.53.1', '!=0.53.2', '!=0.53.3', '!=0.53.4',
    # did not have support for global conventions
    '!=0.54.0', '!=0.54.1', '!=0.54.2', '!=0.54.3', '!=0.54.4', '!=0.54.5',
    # did not have support for global conventions
    '!=0.55.0', '!=0.55.1', '!=0.55.2', '!=0.55.3', '!=0.55.4', '!=0.55.5', '!=0.55.6', '!=0.55.7',
    # above this hasn't been tested
    '< 0.57'
  ]

Gem::Specification.new do |spec|
  spec.name = 'solargraph-rails'
  spec.version = Solargraph::Rails::VERSION
  spec.authors = ['Fritz Meissner']
  spec.email = ['fritz.meissner@gmail.com']

  spec.summary =
    'Solargraph plugin that adds Rails-specific code through a Convention'
  spec.description =
    'Add reflection on ActiveModel dynamic attributes that will be created at runtime'
  spec.homepage = 'https://github.com/iftheshoefritz/solargraph-rails'
  spec.license = 'MIT'

  spec.files =
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(assets|test|spec|features)/})
    end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.76'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8.0'

  spec.add_runtime_dependency 'solargraph', *solargraph_version

  spec.add_runtime_dependency 'activesupport'
end
