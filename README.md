# A Hello World [DocPad](http://docpad.org) project ready for Cordova deploy

The application is based on the [Apache Cordova Hello World][cordova-app] app.

## Usage

### Run Application

    /www/index.html

### PhoneGap/Build

Create a new app with the following repository:

    https://github.com/sergeylukin/cordova.docpad.git


## Developing

- Install Docpad `sudo npm install -g docpad`
- Execute `docpad run`
- Open "http://localhost:9778/www" in browser and enable
  [Ripple](http://ripple.incubator.apache.org/) extension (find and install an
  extension for your browser first) on that page
- Modify files in `src` directory and watch the result in browser
- Run ./deploy (UNIX shell script) to push ready-to-deploy cordova/phonegap
  project to `master` branch and to update `source` branch


## TODO

- Currently `www` directory contents is part of repository which makes this
  project ready for immediate deploy and try at any time, however it's not the
  best option from Version Control System point of view so it would be nice to
  find a better option - **Done** (abstracted docpad project from
  cordova-specific files. Now docpad is a wrapper which generates
  cordova-ready directory instead of being part of that directory, much cleaner
  structure)

Copyright &copy; 2013+ All rights reserved.

[cordova-app]: http://github.com/apache/cordova-app-hello-world
