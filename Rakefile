# -*- ruby -*-

require 'rubygems'
require 'hoe'

LUCENE_VERSION = '3.0.0'
HOE = Hoe.spec 'dm-lucene-adapter' do |p|
  p.developer('mkristian', 'm.kristian@web.de')
  p.extra_deps = [['dm-core', '~>0.10.1']]
  p.url = "http://github.com/mkristian/dm-lucene-adapter"
end

begin
  gem 'rake-compiler', '~>0.7'
  require 'rake/javaextensiontask'

  # still must run mvn compile first-time
  Rake::JavaExtensionTask.new('dm-lucene-adapter_ext', HOE.spec) do |ext|
    ext.ext_dir   = 'src/main/java'
    ext.classpath = "#{File.expand_path('~/')}/.m2/repository/org/apache/lucene/lucene-core/#{LUCENE_VERSION}/lucene-core-#{LUCENE_VERSION}.jar"
  end

  task 'compile:dm-lucene-adapter_ext' => ['compile:dm-lucene-adapter_ext:java']
  task 'compile' => ['compile:java']

rescue LoadError
  warn 'To compile, install rake-compiler (gem install rake-compiler) or use Maven (mvn)'
end

# vim: syntax=ruby
