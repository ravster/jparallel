Gem::Specification.new do |s|
  s.name = "Jparallel"
  s.version = "0.1.0"
  s.license = "LGPL-3.0"
  s.summary = "Easy parallel processing for jruby"
  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.platform = Gem::Platform::CURRENT
  s.authors = ["Ravi Desai"]

  s.homepage = "https://github.com/ravster/jparallel"
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
end
