Zimki is a text conversion tool which translates files written in [zimki Desktop Wiki][zimki] to
[textile][textile].


## Installation ##

Type in your console

    gem install zimki

and you can use the gem.


## Usage ##

Here is an example how you can use it.

    require 'zimki'

    zimki = Zimki.new
    zimki.textile_conversion("src.txt")

A typical text file in the zimki format can be found in this repository under `spec/source/src.txt`.
The output will be written in the console - so then copy the things you need.


## Current translation status ##

Currently the gem can translate the following constructs. On the left you can see the zimki format
and on the right of the arrow you can see the textile pendant.


### General constructs ###

    //italique// => _italique_
    **bold** => *bold*
    __highlight => @highlight@


### Headings ###

    ==== The 10-day MBA ==== => h1. The 10-day MBA
    === The 10-day MBA === => h2. The 10-day MBA
    == The 10-day MBA == => h3. The 10-day MBA


### Links and Images  ###


    [[http://wikimatze.de|wikimatze]] => "wikimatze":http://wikimatze.de
    {{~/Dropbox/pics/Screenshot.png}} => !http://~/Dropbox/pics/Screenshot.png!


### Bullets ###

    * first bullet
      * second bulltet
        * third bullet
          * fourth

=>

    * first bullet
    ** second bulltet
    *** third bullet
    **** fourth


## Contact ##

Feature request, bugs, questions, etc. can be send to <matthias.guenther@wikimatze.de>.


## License ##

This software is licensed under the [MIT license][mit].

© 2011 Matthias Guenther <matthias.guenther@wikimatze.de>.

[mit]: http://en.wikipedia.org/wiki/MIT_License
[textile]: http://en.wikipedia.org/wiki/Textile_(markup_language)/
[zimki]: http://zim-wiki.org/
