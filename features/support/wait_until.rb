require 'timeout'

module WaitUntil
  def wait_until timeout = 10
    Timeout.timeout timeout do
      sleep 0.5 until value = yield
      value
    end
  end

  def set_element_value element, value
    while element.value != value.to_s
      sleep 0.5
      element.set value
    end
  end
end

World(WaitUntil)
