require 'java'
begin
  include_class "de.saumya.lucene.LuceneService"
rescue
  require 'dm-lucene-adapter_ext'
  retry
end
require 'dm_lucene_adapter/dm_lucene_adapter'
