import React from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import { store } from './store.js'
import { Provider } from 'react-redux'
import App from './App';

createRoot(document.getElementById('root')).render(
<Provider store={store}>
<App klasa="plansza"/>
</Provider>
);