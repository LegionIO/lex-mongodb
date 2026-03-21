# frozen_string_literal: true

require_relative 'lib/legion/extensions/mongodb/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-mongodb'
  spec.version       = Legion::Extensions::Mongodb::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX::MongoDB'
  spec.description   = 'Connects LegionIO to MongoDB'
  spec.homepage      = 'https://github.com/LegionIO/lex-mongodb'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/LegionIO/lex-mongodb'
  spec.metadata['documentation_uri'] = 'https://github.com/LegionIO/lex-mongodb'
  spec.metadata['changelog_uri'] = 'https://github.com/LegionIO/lex-mongodb'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/LegionIO/lex-mongodb/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'mongo', '~> 2.19'
end
