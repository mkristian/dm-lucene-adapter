= dm-lucene-adapter

*Homepage*:  [http://dm-lucene-adapter.rubyforge.org]

*Git*:       [http://github.com/mkristian/dm-lucene-adapter]

*Author*:    Kristian Meier  

*Copyright*: 2009

== DESCRIPTION:

FIX (describe your package)

== FEATURES/PROBLEMS/LIMITATIONS:

* can handle only resources with Serial

* handles all properties internally as Strings, i.e. all GT, GTE, LT, LTE, Range queries do not work

* limit and offset with sorting will retrieving the complete result set, sorts it and apply the limit and offset to it.

* the current maven rake-plugin is personal fork, so things are not very usable for others yet

== SYNOPSIS:

  FIX (code sample of usage)

== REQUIREMENTS:

* lucene-core-2.9.0.jar in classpath

== INSTALL:

* jgem install dm-lucene-adapter

== LICENSE:

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
