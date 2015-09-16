module WaitForAjax
  def wait_for_ajax
    wait_until { finished_all_ajax_requests? }
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

World(WaitForAjax)
