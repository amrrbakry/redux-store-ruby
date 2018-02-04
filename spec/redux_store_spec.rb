require 'spec_helper'
require './redux_store'

RSpec.describe Redux::ReduxStore do
  let(:counter_reducer) do
    lambda { |state, action|
      state ||= 0

      case action[:type]
      when 'increment'
        state += 1
      when 'decrement'
        state -= 1
      else
        state
      end
    }
  end
  let(:todos_reducer) do
    lambda { |state, action|
      state ||= []

      case action[:type]
      when 'add'
        state.push(action[:todo])
      when 'remove'
        state.remove(action[:todo])
      else
        state
      end
    }
  end
  let(:action) { { type: 'increment' } }
  let(:listener) { -> { puts 'I\'m listening' } }

  subject { Redux::ReduxStore.new(counter_reducer) }

  context '#dispatch' do
    it 'calls reducer with provided action' do
      subject.dispatch(action)
      expect(subject.state).to eq(1)
    end
  end

  context '#subscribe' do
    it 'adds a listener' do
      subject.subscribe(listener)
      expect(subject.listeners.size).to eq(1)
    end
  end

  context '#unsubscribe' do
    it 'removes a listener' do
      subject.subscribe(listener)
      expect(subject.listeners.size).to eq(1)
      subject.unsubscribe(listener)
      expect(subject.listeners.size).to eq(0)
    end
  end

  context '.combine_reducers' do
    it 'combines reducers and returns new state' do
      root_reducer = Redux::ReduxStore.combine_reducers(counter: counter_reducer,
                                                        todos: todos_reducer)
      new_subject = Redux::ReduxStore.new(root_reducer)
      expect(new_subject.state).to eq(counter: 0, todos: [])
    end
  end
end
