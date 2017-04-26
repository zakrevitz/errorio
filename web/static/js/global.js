class Global {
  constructor() {
    this.init()
  }

  init() {
    this.isotopeInit()
    this.popoverInit()
    this.editableInit()
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

  popoverInit() {
    $('[data-toggle="popover"]').popover();
  }

  editableInit() {
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
  }
}

export default Global;
