module Statable
  extend ActiveSupport::Concern

  STATES = %i(draft published removed moderated).freeze

  included do
    enum state: STATES

    self.states.each do |st, i|
      scope :"#{ st }", -> { where(state: i) }
    end
  end
end
