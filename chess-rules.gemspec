# -*- encoding: utf-8 -*-
# frozen_string_literal: true

$LOAD_PATH.push(File.expand_path("../lib", __FILE__))
require "chess/version"

Gem::Specification.new do |s|
  s.name        = "chess"
  s.version     = Chess::VERSION
  s.authors     = ["Edward Paget"]
  s.email       = ["ed.paget@gmail.com"]
  s.homepage    = "http://github.com/edpaget/chess-rules"
  s.summary     = %{chess rules implemented in ruby}
  s.description = %{chess rules implemented in ruby}

  s.files         = %x(git ls-files).split("\n")
  s.executables   = %x(git ls-files -- bin/*).split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
  s.add_development_dependency("rubocop")
  s.add_development_dependency("rubocop-rspec")
  s.add_development_dependency("rubocop-shopify")
  # s.add_runtime_dependency "rest-client"
end
