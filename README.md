# A Hello World [DocPad](http://docpad.org) project ready for Cordova/Phonegap deploy

The application is based on the [Apache Cordova Hello World][cordova-app] app.

## Usage

  - Before you begin any of steps below, you should have
    [Docpad](http://docpad.org) installed
    globally: `npm install -g docpad`

### Run Application in browser emulator

  - `git checkout source` - switch to source branch
  - Compile project with `docpad generate`
  - Start server with `docpad server` and open `http://localhost:9778/www` in
    browser
  - Install [Ripple](http://ripple.incubator.apache.org)
    browser extension and enable it on that page to simulate mobile device
    environment

### Run Application in SDK Emulator/Real Device

- `git checkout source` - switch to source branch
- `npm install -g cordova` - install Cordova CLI
- `docpad generate` - compile project to prepare for cordova/phonegap later
  processing
- `cd out`
- `cordova platform add <PLATFORM>` - prepare platform-specific project files
- `cordova emulate <PLATFORM>` - build platform-specific project files
  within `platforms` sub-directory and launch virtual emulator (requires
  pre-setup)
- `cordova run <PLATFORM>` - build platform-specific project files and install
  on connected device


### Build with PhoneGap remote build service

via Web:

- `git checkout source` - switch to source branch
- `./deploy` to deploy your phonegap-ready app files as well as `source` branch
- create an app on [phonegap web ui](http://build.phonegap.com) by pointing it
  to your public master branch on repository

via CLI:

- `git checkout source` - switch to source branch
- `npm install -g phonegap` - install Phonegap CLI
- `rm -fr ./out` - remove previously generated files (the reason is that you
  may have created platform-specific files there previously and since phonegap
  requires to avoid those files when using their service, we better clean our
  build directory at this point)
- `docpad generate` - compile project
- `cd out` - change directory to compiled files
- `phonegap remote build <PLATFORM>` to build platform-specific package
  (read [Phonegap docs](https://build.phonegap.com/docs) on how to proceed at this point)


## Developing

- `git checkout source` - switch to source branch
- `docpad run` - start webserver with project files watch
- Open "http://localhost:9778/www" in browser and enable
  [Ripple](http://ripple.incubator.apache.org/) extension (find and install an
  extension for your browser first) on that page
- Modify files in `src` directory and watch the result in the browser


## Debugging

- I highly recommend using Phonegap remote Debug server. It works great and
  enables remote debugging on runtime on real device. For more details on setup
  and usage refer to [their
  documentation](https://build.phonegap.com/docs/advanced-debugging)


## References

- [Cordova docs](http://cordova.apache.org/docs/en/edge/)
- [Phonegap Build docs](https://build.phonegap.com/docs)
- [Configure](https://build.phonegap.com/docs/config-xml) your cordova/phonegap app


Copyright &copy; 2013+ All rights reserved.

[cordova-app]: http://github.com/apache/cordova-app-hello-world
