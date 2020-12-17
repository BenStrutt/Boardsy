require_relative 'lib/boardsy/version'

Gem::Specification.new do |spec|
  spec.name          = "boardsy"
  spec.version       = Boardsy::VERSION
  spec.authors       = ["Bennett Struttman"]
  spec.email         = ["ben.struttman@gmail.com"]

  spec.summary       = %q{A game board class for CLI games in Ruby.}
  spec.homepage      = "https://github.com/BenStrutt/Boardsy"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
