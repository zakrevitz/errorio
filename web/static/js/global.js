class Global {
  constructor() {
    this.init()
  }

  init() {
    // this.isotopeInit()
    this.popoverInit()
    this.tooltipInit()
    this.editableInit()
    this.showPasswordInit()
    this.dataTableInit()
    this.datePickerInit()
    this.select2Init()
    this.loading_similar = false
    this.loaded_similar = false
    this.loadSimilarErrors()
  }

  isotopeInit() {
    var $project_grid = $('.projects_container').isotope({
      itemSelector: '.project_item',
      layoutMode: 'vertical',
      sortAscending: {
        name: true,
        template: true,
        error_count: false
      },
      getSortData: {
        template: '.template',
        error_count: '.error_count parseInt',
        name: function( itemElem ) {
          var name = $( itemElem ).find('.name').text();
          return name.toLowerCase();
        }
      }
    });

    $('#sorts btn').click(function(){
      $(this).siblings().find('.btn.active').re
    });

    var $failure_grid = $('.server_failure_container').isotope({
      itemSelector: '.server_failure_item',
      layoutMode: 'fitRows'
    });

    $('#sorts').on( 'click', 'button', function() {
      var sortByValue = $(this).attr('data-sort-by');
      $project_grid.isotope({ sortBy: sortByValue });
      $(this).siblings('.active').removeClass('active');
      $(this).addClass('active')
    });
  }

  dataTableInit() {
    $('#projects_table').DataTable({
      responsive: true
    });
  }

  popoverInit() {
    $('[data-toggle="popover"]').popover();
  }

  tooltipInit() {
    $("[data-toggle=tooltip]").tooltip();
  }

  editableInit() {
    $.fn.editableform.buttons = '<div class="inline-actions"><button type="submit" class="btn btn-icon btn-sm btn-success-outline margin-inline editable-submit"><i class="icmn-checkmark" aria-hidden="true"></i></button><button type="button" class="btn btn-icon btn-sm btn-info-outline margin-inline editable-cancel"><i class="icmn-cross" aria-hidden="true"></i></button></div>';
    var csrf = document.querySelector("meta[name=csrf]").content;

    $('#assignee_id').editable({
      source: '/admin/remote/users',
      params: function(params) {
        var data = {"server_failure_template": {} };
        data['server_failure_template'][params.name] = params.value;
        return data;
      },
      ajaxOptions: {
        headers: {
          "X-CSRF-TOKEN": csrf
        }
      },
      pk: 1
    });

    $('#priority').editable({
      params: function(params) {
        var data = {"server_failure_template": {} };
        data['server_failure_template'][params.name] = params.value;
        return data;
      },
      ajaxOptions: {
        headers: {
          "X-CSRF-TOKEN": csrf
        },
        type: "PUT"
      },
      pk: 1,
      source: [
            {text: "No priority", value: "no_priority"},
            {text: "Trivial", value: "trivial"},
            {text: "Minor", value: "minor"},
            {text: "Major", value: "major"},
            {text: "Critical", value: "critical"},
            {text: "Mega Critical", value: "mega_critical"},
            {text: "КИДАЙ ВСЁ И ЗАЙМИСЬ ЭТИМ!", value: "kiday_vse_i_zaymis_etim"}
       ]
    });
  }
  showPasswordInit() {
    $('.show_password').password({
        eyeClass: '',
        eyeOpenClass: 'icmn-eye',
        eyeCloseClass: 'icmn-eye-blocked'
    });
  }

  datePickerInit() {
    $('#date_from').datetimepicker({
      widgetPositioning: {
        horizontal: 'left'
      },
      icons: {
        time: 'fa fa-clock-o',
        date: 'fa fa-calendar',
        up: 'fa fa-arrow-up',
        down: 'fa fa-arrow-down'
      },
      format: 'DD/MM/Y'
    });

    $('#date_to').datetimepicker({
      widgetPositioning: {
        horizontal: 'left'
      },
      icons: {
        time: 'fa fa-clock-o',
        date: 'fa fa-calendar',
        up: 'fa fa-arrow-up',
        down: 'fa fa-arrow-down'
      },
      format: 'DD/MM/Y',
      useCurrent: false
    });
    $('#date_from').on('dp.change', function(e) {
      $('#date_to').data('DateTimePicker').minDate(e.date);
    });

    $('#date_to').on('dp.change', function(e) {
      $('#date_from').data('DateTimePicker').maxDate(e.date);
    });

  }
  select2Init() {
    $(".select2").select2({
      dropdownAutoWidth : true,
      minimumResultsForSearch: -1
    })
  }

  loadSimilarErrors() {
    var similar_errors = { "errors": []}
    self = this
    $('a#similar_link').on('click', function(e) {
      if (!self.loading_similar && !self.loaded_similar) {
        var id = $('#similar #server_failure_template_id').val()
        self.loading_similar = true
        $.ajax({
          url: "/errors?server_failure_template_id="+ id
        }).done(function(data) {
          self.loading_similar = false
          self.loaded_similar = true
          similar_errors["errors"] = data["data"]
          self.renderTemplate(similar_errors)
        });
      }

    })
  }

  renderTemplate(data) {
    var template = $('#template').html();
    var rendered = Mustache.render(template, data);
    $('#similar_error_table').html(rendered);
    self.tooltipInit()
  }
}

export default Global;
