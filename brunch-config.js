exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js",

      // To use a separate vendor.js bundle, specify two files path
      // http://brunch.io/docs/config#-files-
      // joinTo: {
      //  "js/app.js": /^(web\/static\/js)/,
      //  "js/vendor.js": /^(web\/static\/vendor)|(deps)|(node_modules)/
      // },
      //
      // To change the order of concatenation of files, explicitly mention here
      order: {
        before: [
          "web/static/vendor/js/tether/tether.min.js",
          "web/static/vendor/js/bootstrap/bootstrap.min.js  ",
          "web/static/vendor/js/jquery-mousewheel/jquery.mousewheel.min.js",
          "web/static/vendor/js/jscrollpane/jquery.jscrollpane.min.js",
          "web/static/vendor/js/spin-js/spin.js",
          "web/static/vendor/js/ladda/ladda.min.js",
          "web/static/vendor/js/select2/select2.full.min.js",
          "web/static/vendor/js/html5-form-validation/jquery.validation.min.js",
          "web/static/vendor/js/jquery-typeahead/jquery.typeahead.min.js",
          "web/static/vendor/js/jquery-mask-plugin/jquery.mask.min.js",
          "web/static/vendor/js/autosize/autosize.min.js",
          "web/static/vendor/js/bootstrap/bootstrap-show-password.min.js  ",
          "web/static/vendor/js/moment/moment.min.js",
          "web/static/vendor/js/eonasdan-bootstrap-datetimepicker/bootstrap-datetimepicker.min.js",
          "web/static/vendor/js/bootstrap/sweetalert.min.js",
          "web/static/vendor/js/bootstrap/bootstrap-notify.min.js  ",
          "web/static/vendor/js/summernote/summernote.min.js",
          "web/static/vendor/js/owl.carousel/owl.carousel.min.js",
          "web/static/vendor/js/ionrangeslider/ion.rangeSlider.min.js",
          "web/static/vendor/js/nestable/jquery.nestable.js",
          "web/static/vendor/js/datatables/jquery.dataTables.min.js",
          "web/static/vendor/js/datatables/dataTables.bootstrap4.min.js",
          "web/static/vendor/js/datatables-fixedcolumns/dataTables.fixedColumns.js",
          "web/static/vendor/js/datatables-responsive/dataTables.responsive.js",
          "web/static/vendor/js/editable-table/mindmup-editabletable.js",
          "web/static/vendor/js/d3/d3.min.js",
          "web/static/vendor/js/c3/c3.min.js",
          "web/static/vendor/js/peity/jquery.peity.min.js",
          "web/static/vendor/js/gsap/TweenMax.min.js",
          "web/static/vendor/js/hackertyper/hackertyper.js",
          "web/static/vendor/js/jquery-countTo/jquery.countTo.js",
          "web/static/vendor/js/jquery-steps/jquery.steps.min.js",
          "web/static/vendor/js/nprogress/nprogress.js",
          "web/static/vendor/js/mustache/mustache.min.js",
          "web/static/vendor/js/chartist/chartist.min.js",
          "web/static/vendor/js/chartist-plugin-tooltip/chartist-plugin-tooltip.min.js"
        ]
      }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        after: ["web/static/css/app.scss"] // concat app.css last
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    },
    sass: {
      mode: "native"
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true,
    globals: {
      $: 'jquery',
      jQuery: 'jquery'
    }
  }
};
