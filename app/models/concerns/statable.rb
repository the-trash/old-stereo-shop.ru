module Statable
  extend ActiveSupport::Concern

  included do
    STATES = %i(draft published removed moderated)

    enum state: STATES

    self.states.each do |st, i|
      scope :"#{ st }", -> { where(state: i) }
    end
  end
end
