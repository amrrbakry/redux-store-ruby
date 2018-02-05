# redux-store-ruby

Following this [article](https://medium.com/cloudaper/understanding-redux-store-concepts-by-little-ruby-reimplementation-d08bcc05dee8) by Josef Strzibny, I implemeted Redux's core concepts in `ruby`.

**Example:**

```ruby
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

root_reducer = Redux::ReduxStore.combine_reducers(counter: counter_reducer,
                                                  todos: todos_reducer)

app_store = Redux::ReduxStore.new(root_reducer)
app_store.dispatch(type: 'increment')
app_store.dispatch(type: 'add', todo: 'buy milk')
app_store.dispatch(type: 'increment')
p app_store.state # {:counter=>2, :todos=>["buy milk"]}
```
