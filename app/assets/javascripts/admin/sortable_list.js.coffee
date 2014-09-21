(($) ->
  $(document).ready ->
    $(".handle").closest("tbody").activeAdminSortable()

  $.fn.activeAdminSortable = ->
    @sortable
      handle: '.handle'
      axis: 'y'
      update: (event, ui) ->
        current_span = ui.item.find('[data-sort-url]')
        prev_span    = ui.item.prev().find('[data-sort-url]')

        current_position = current_span.data('position')
        prev_position    = prev_span.data('position')

        url = current_span.data('sort-url')

        if current_position < prev_position
          position = prev_position
        else
          position = ui.item.next().find('[data-sort-url]').data('position')

        $.ajax
          url: url
          type: "post"
          data:
            position: position

          success: (data) ->
            window.location.reload()

    @disableSelection()
) jQuery
