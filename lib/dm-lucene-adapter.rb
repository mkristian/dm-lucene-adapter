require 'java'
begin
  LUCENE_VERSION = '3.0.0'

  require "#{File.expand_path('~/')}/.m2/repository/org/apache/lucene/lucene-core/#{LUCENE_VERSION}/lucene-core-#{LUCENE_VERSION}.jar"
  require 'dm-lucene-adapter_ext'

  include_class "de.saumya.lucene.LuceneService"
rescue => e
  STDERR.puts e.message
end

require 'dm_lucene_adapter/dm_lucene_adapter'
