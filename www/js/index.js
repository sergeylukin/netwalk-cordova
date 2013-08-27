(function() {
  var app;

  app = {
    initialize: function() {
      return this.bindEvents();
    },
    bindEvents: function() {
      return document.addEventListener("deviceready", this.onDeviceReady, false);
    },
    onDeviceReady: function() {
      return new App.Netwalk({
        containerSelector: '#netwalk'
      });
    }
  };

  app.initialize();

}).call(this);
