module Redux
  class ReduxStore
    attr_reader :state, :listeners

    def initialize(reducer, initial_state = nil)
      @reducer = reducer
      @listeners = []
      @state = initial_state
      dispatch({})
    end

    def self.combine_reducers(reducers)
      lambda do |state, action|
        state ||= {}

        reducers.each_with_object({}) do |(key, reducer), next_state|
          next_state[key] = reducer.call(state[key], action)
          next_state
        end
      end
    end

    def dispatch(action)
      @state = @reducer.call(@state, action)
      @listeners.each(&:call)
    end

    def subscribe(listener)
      @listeners.push(listener) unless @listeners.include?(listener)
      -> { @listeners.delete(listener) } if @listeners.include?(listener)
    end
  end
end
