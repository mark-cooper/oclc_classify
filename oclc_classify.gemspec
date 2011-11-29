#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

Gem::Specification.new do |s|
  s.name = %q{oclc_classify}
  s.version = "0.0.1"
  s.authors = ["Mark Cooper"]
  s.date = %q{2011-11-22}
  s.homepage = %q{http://www.libcode.net}
  s.email = Base64.decode64("bWFya2NocmlzdG9waGVyY29vcGVyQGdtYWlsLmNvbQ==\n")
  
  s.summary = "Retrieve dewey decimal numbers from OCLC's classify service"
  s.description = "#{s.summary}"
  s.cert_chain = nil
  s.has_rdoc = true

  # files
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files test`.split("\n")
  s.extra_rdoc_files = ["README.txt"]
  s.rdoc_options = ["--main", "README.txt"]

  Dir["bin/*"].map(&File.method(:basename))
  # s.default_executable = "example"
  s.require_paths = ["lib"]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.9")

  # dependencies
  # RubyGems has runtime dependencies (add_dependency) and
  # development dependencies (add_development_dependency)
  # s.add_development_dependency "simple-templater", ">= 0.0.1.2"
  s.add_development_dependency "bundler"

  begin
    require "changelog"
  rescue LoadError
    warn "You have to have changelog gem installed for post install message"
  else
    s.post_install_message = CHANGELOG.new.version_changes
  end

  # RubyForge
  s.rubyforge_project = %q{oclc_classify}
end