# A Hello World [DocPad](http://docpad.org) project ready for Cordova deploy

The application is based on the [Apache Cordova Hello World][cordova-app] app.

## Usage

### Run Application in browser emulator

  - Compile project with `docpad generate`
  - Start server with `docpad server` and open `http://localhost:9778/www` in
    browser
  - Install [Ripple](http://ripple.incubator.apache.org)
    browser extension and enable it on that page to simulate mobile device
    environment

### Run Application in SDK Emulator/Real Device

- `npm install -g cordova` - install Cordova CLI
- `docpad generate` - compile project to prepare for cordova/phonegap later
  processing
- `cd out`
- `cordova emulate <PLATFORM>` - build platform-specific project files
  within `platforms` sub-directory (some of platforms are: `android`,
  `ios`, `blackberry10`, `wp8`) and launch virtual emulator (requires
  pre-setup)
- `cordova run <PLATFORM>` - build platform-specific project files and install
  on connected device


### Build with PhoneGap remote build service

- `npm install -g phonegap` - install Phonegap CLI
- `rm -fr ./out` - remove previously generated files (the reason is that you
  may have created platform-specific files there previously and since phonegap
  requires to avoid those files when using their service, we better clean our
  build directory at this point)
- `docpad generate` - compile project
- `cd out` - change directory to compiled files
- `phonegap remote build <PLATFORM>` to build platform-specific project files
  within `platforms` sub-directory (some of platforms are: `android`,
  `ios`, `blackberry10`, `wp8`)


## Developing

- Install Docpad `sudo npm install -g docpad`
- Execute `docpad run`
- Open "http://localhost:9778/www" in browser and enable
  [Ripple](http://ripple.incubator.apache.org/) extension (find and install an
  extension for your browser first) on that page
- Modify files in `src` directory and watch the result in browser


## References

- [Configure](https://build.phonegap.com/docs/config-xml) your cordova/phonegap app


Copyright &copy; 2013+ All rights reserved.

[cordova-app]: http://github.com/apache/cordova-app-hello-world
