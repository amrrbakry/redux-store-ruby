module Redux
  class ReduxStore
    attr_reader :state

    def initialize(reducer)
      @reducer = reducer
      @listeners = []
      @state = nil
      dispatch({})
    end


    def dispatch(action)
      @state = @reducer.call(@state, action)
      @listeners.each(&:call)
    end

    def subscribe(listener)
      @listeners.push(listener) unless @listeners.include?(listener)
    end

    def unsubscribe(listener)
      @listeners.delete(listener) if @listeners.include?(listener)
    end
  end
end
