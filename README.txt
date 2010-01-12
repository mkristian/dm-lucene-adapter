= dm-lucene-adapter

*Homepage*:  [http://dm-lucene-adapter.rubyforge.org]

*Git*:       [http://github.com/mkristian/dm-lucene-adapter]

*Author*:    Kristian Meier  

*Copyright*: 2009

== DESCRIPTION:

adapter to use lucene with datamapper (datamapper.org). you can search in a fuzzy manner with use of :like in the condition without any wildcards.

== FEATURES/PROBLEMS/LIMITATIONS:

* lucene is java library so the whole thing works ONLY with jruby !!!!

* can handle only resources with Serial

* handles all properties internally as Strings, i.e. all GT, GTE, LT, LTE, Range queries do not work

* limit and offset with sorting will retrieving the complete result set, sorts it and apply the limit and offset to it.

* fuzzy search has only default fuzzyness (0.5) and the fuzzy search is always ON when using :like without any wildcards

== SYNOPSIS:

  FIX (code sample of usage)

== REQUIREMENTS:

* lucene-core-3.0.0.jar in classpath or install it as gem with maven

== INSTALL:

* jgem install dm-lucene-adapter

= WORKING WITH THE SOURCES

== the ruby way

 * gem install rake-compiler

 * first install lucene jar (needs maven)  : mvn initialize

 * install lucene library as gem (optional): mvn -P install-lucene-as-gem
   will be used by dm-lucene-adapter when installed

 * building the source: jruby -S rake compile

 * running the specs  : jruby -S rake spec

 * install the gem    : jruby -S rake install

== maven way

 the maven setup allows to use a local setup of gems for the project only. when you add the 'localgems' profile (add -P localgems or comma separate the profiles like -P maven3,localgems) then you will get a rubygems repository in the directory 'target/rubygems'. it is also possible to define a rubygems repository for all uses of maven via the settings.xml (more details under http://github.com/mkristian/jruby-maven-plugins/ )

=== maven2

 * first you need to make sure you have the 'dm-core' gem installed

 * building the source and running the specs    : mvn install

 * building the source without running the specs: mvn install -DskipSpecs=true

=== maven3
 
 * maven will install all the needed gems like dm-core, etc

 * building the source and running the specs    : mvn -P maven3 install

 * building the source without running the specs: mvn -P maven3 install -DskipSpecs=true

=== maven2 + maven3

 * install the gem, after a prior run of install: mvn gem:install

 * install lucene library as gem                : mvn -P install-lucene-as-gem
   will be used by dm-lucene-adapter when installed
 

= LICENSE:

(The MIT License)

Copyright (c) 2009 Kristian Meier

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
