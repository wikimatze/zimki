Gem::Specification.new do |s|
  s.name                  = 'zimki'
  s.version               = '0.0.2'
  s.date                  = '2013-02-10'

  s.summary               = 'Converts files written in the zim Desktop format to textile.'
  s.description           = 'Zimki converts file written in the zim Desktop Wiki format and converts them to textile.'

  s.authors               = ["Matthias Guenther"]
  s.email                 = 'matthias.guenther@wikimatze.de'
  s.homepage              = 'https://github.com/matthias-guenther/zimki'

  s.required_ruby_version = '>= 1.8.7'
  s.files                 = `git ls-files`.split("\n")

  s.test_files            = Dir.glob "spec/**/*spec.rb"

  s.extra_rdoc_files      = ["README.md"]

  s.add_development_dependency('rspec', ">= 2.6.0")
end
