require './redux_store'

counter_reducer = lambda { |state, action|
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

todos_reducer = lambda { |state, action|
  state ||= []

  case action[:type]
  when 'add'
    state.push(action[:todo])
  when 'remove'
    state.tap { |s| s.delete(action[:todo]) }
  else
    state
  end
}

restaurants_reducer = lambda { |state, action|
  state ||= []

  case action[:type]
  when 'add_restaurant'
    state.tap { state.push(action[:restaurant]) }
  else
    state
  end
}

root_reducer = Redux::ReduxStore.combine_reducers(counter: counter_reducer,
                                                  todos: todos_reducer,
                                                  restaurants: restaurants_reducer)

app_store = Redux::ReduxStore.new(root_reducer)
app_store.dispatch(type: 'increment')
app_store.dispatch(type: 'add', todo: 'buy milk')
app_store.dispatch(type: 'increment')
app_store.dispatch(type: 'add_restaurant', restaurant: { title: 'res' })
p app_store.state
