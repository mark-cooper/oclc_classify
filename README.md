OCLC Classify
=============

https://github.com/mark-cooper/oclc_classify

DESCRIPTION
-----------

Retrieve dewey decimal numbers from OCLC's classify service

FEATURES/PROBLEMS
-----------------

Very much a work in progress ...

SYNOPSIS
--------

Here's some example usage:

    oclc = OCLC::Classify.new 'oclc', '610837844'
    result = oclc.classify

    p result.author
    p result.title

    r = result.recommendations 'ddc', :popular
    s = result.recommendations 'ddc', :recent
    t = result.recommendations 'ddc', :latest
    p r

    p s
    p t

    r.each {|k,v| puts k['nsfa'] }

REQUIREMENTS
------------

- nokogiri
- open-uri

INSTALL
-------

sudo gem install oclc_classify

License & Authors
-----------------
- Author:: Mark Cooper (<mark.cooper@lyrasis.org>)

GPL v3
