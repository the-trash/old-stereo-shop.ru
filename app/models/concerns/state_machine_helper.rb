module StateMachineHelper
  extend ActiveSupport::Concern

  included do
    def self.state_names
      state_machine.states.map(&:name)
    end
  end
end
