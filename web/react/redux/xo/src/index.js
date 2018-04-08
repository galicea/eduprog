import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import { store } from './store.js'
import { Provider } from 'react-redux'
import App from './App';

ReactDOM.render(
<Provider store={store}>
<App klasa="plansza"/>
</Provider>,
document.getElementById('root')
);
