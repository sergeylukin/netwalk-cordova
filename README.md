# A Hello World [DocPad](http://docpad.org) project ready for Cordova deploy

The application is based on the [Apache Cordova Hello World][cordova-app] app.

## Usage

### Run Application

  - Compile project with `docpad generate`
  - Start server with `docpad server` and open `http://localhost:9778/www` in
    browser (consider installing [Ripple](http://ripple.incubator.apache.org)
    browser extension to simulate mobile device environment in browser)


### PhoneGap/Build

- Install NPM `phonegap` package
- `cd ./out && phonegap deploy`


## Developing

- Install Docpad `sudo npm install -g docpad`
- Execute `docpad run`
- Open "http://localhost:9778/www" in browser and enable
  [Ripple](http://ripple.incubator.apache.org/) extension (find and install an
  extension for your browser first) on that page
- Modify files in `src` directory and watch the result in browser


Copyright &copy; 2013+ All rights reserved.

[cordova-app]: http://github.com/apache/cordova-app-hello-world
