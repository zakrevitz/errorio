// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import "./bootstrap.min"

$(document).ready(function(){
  $('[data-toggle="popover"]').popover();
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

  var $failure_grid = $('.server_failure_container').isotope({
    itemSelector: '.server_failure_item',
    layoutMode: 'fitRows'
  });

  $('#sorts').on( 'click', 'button', function() {
    var sortByValue = $(this).attr('data-sort-by');
    $project_grid.isotope({ sortBy: sortByValue });
  });
});

$(document).off('click.bs.dropdown.data-api', '.dropdown form');
