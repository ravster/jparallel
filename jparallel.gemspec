Gem::Specification.new do |s|
  s.name = "jparallel"
  s.version = "0.1.1"
  s.license = "LGPL-3.0"
  s.summary = "Easy parallel processing for ruby"
  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.platform = Gem::Platform::RUBY
  s.authors = ["Ravi Desai"]

  s.homepage = "https://github.com/ravster/jparallel"
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
end
