require 'java'
begin
  require 'dm-lucene-adapter_ext'
  include_class "de.saumya.lucene.LuceneService"
  puts "using lucene from classpath"
rescue NameError => e

  begin
    require 'org.apache.lucene.lucene-core'
    puts "using lucene from gem"
  rescue LoadError => ee
    LUCENE_VERSION = '3.0.0'

    require "#{File.expand_path('~/')}/.m2/repository/org/apache/lucene/lucene-core/#{LUCENE_VERSION}/lucene-core-#{LUCENE_VERSION}.jar"
    puts "using lucene from jar"
  end

  puts "load"
  include_class "de.saumya.lucene.LuceneService"
end

require 'dm_lucene_adapter/dm_lucene_adapter'
