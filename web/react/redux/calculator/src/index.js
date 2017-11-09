import React from 'react';
import { render } from 'react-dom'
import { createStore } from 'redux'
import { Provider } from 'react-redux'
import Calculator from './Calculator';
import reducer from './reducers'
//import { calculator } from './reducers'

const store = createStore(reducer)


render(
  <Provider store={store}>
    <Calculator />
  </Provider>,
  document.getElementById('root')
)
