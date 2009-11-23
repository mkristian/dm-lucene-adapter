require 'rubygems'

gem 'dm-core', ">0.10.0"
require 'pathname'
$LOAD_PATH << Pathname(__FILE__).dirname.parent.expand_path + 'lib'

require 'dm-core'
require 'dm-lucene-adapter'

class Book

  include DataMapper::Resource

  property :id, Serial

  property :author, String, :length => 128

  property :title, String, :length => 255

  property :published, Boolean, :default => true

end

DataMapper.setup(:default, :adapter => :lucene, :index => "tmp/index")
