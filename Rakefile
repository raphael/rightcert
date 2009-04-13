require 'rubygems'
require 'rake/gempackagetask'
require "spec/rake/spectask"
require 'rake/rdoctask'
require 'rake/clean'

GEM = "rightcert"
VER = "0.1.0"
AUTHOR = "Raphael Simon"
EMAIL = "raphael@rightscale.com"
HOMEPAGE = "http://rightcert.rubyforge.org/"
SUMMARY = "Small ruby library for simple X.509 certificate generation and signature. Allows signing and/or encrypting data using PKCS7."

Dir.glob('tasks/*.rake').each { |r| Rake.application.add_import r }

task :default => [ :spec, :gem ]

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = ::VER
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE

  s.require_path = 'lib'
  s.files = %w(README.rdoc Rakefile) + Dir.glob("{lib,bin,specs}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{VER}}
end

desc "Run unit specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = FileList["spec/**/*_spec.rb"]
end

desc 'Generate RDoc documentation'
Rake::RDocTask.new do |rd|
  rd.title = spec.name
  rd.rdoc_dir = 'rdoc'
  rd.main = "README.rdoc"
  rd.rdoc_files.include("lib/**/*.rb", *spec.extra_rdoc_files)
end
CLOBBER.include(:clobber_rdoc)

desc 'Generate and open documentation'
task :docs => :rdoc do
  case RUBY_PLATFORM
  when /darwin/       ; sh 'open rdoc/index.html'
  when /mswin|mingw/  ; sh 'start rdoc\index.html'
  else 
    sh 'firefox rdoc/index.html'
  end
end
