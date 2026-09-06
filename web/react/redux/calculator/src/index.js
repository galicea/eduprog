import React from 'react';
import { createRoot } from 'react-dom/client'
import { createStore } from 'redux'
import { Provider } from 'react-redux'
import Calculator from './Calculator';
import reducer from './reducers'

const store = createStore(reducer)


createRoot(document.getElementById('root')).render(
  <Provider store={store}>
    <Calculator />
  </Provider>
)