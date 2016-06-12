if @current_elco_import.present?
  json.set! :html_content, {
    set_html: {
      ".js--elco-status-block" => render(template: 'yandex_market_lists/elco_status_block.html.slim')
    },
    attrs:{
      remove_value: {
        ".js--elco-status-block" => {
          class: :hidden
        }
      }
    }
  }
else
  json.set! :html_content, {
    set_html: {
      ".js--elco-status-block" => ""
    },
    attrs:{
      append: {
        ".js--elco-status-block" => {
          class: :hidden
        }
      }
    }
  }

  json.set! :js_exec, [
    { "ElcoImport.tracker_stop" => [] }
  ]
end