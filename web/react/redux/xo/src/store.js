import { createStore, } from 'redux';
import * as actionTypes from './types/index';

const StanAplikacji = {
  xo : [], // znak x / o
  kto : '',  // czyj ruch
  stanGry: ''// komunikat
};

function inicjujStanAplikacji() {
  return {
    xo: new Array(9).fill('?'),
    kto: 'x',
    stanGry: '* Kółko i Krzyżyk *'
  };
}

const reducer = (state, action) => {
    if (action.type === actionTypes.ACTION_ZMIANA) {
    let ix = parseInt(action.y,10)*3 + parseInt(action.x,10);
    if (state.xo[ix] !== '?') return state;
    let nxo  = state.xo.slice(); // PŁYTKA KOPIA state.xo.
    nxo[ix] = state.kto;
    let nkto='x';
    let nstan = 'ruch: x';
    if (state.kto==='x') {
      nkto='o';
      nstan = 'ruch: o';
    }
    if (    ((nxo[0] !== '?') && (nxo[0]===nxo[1]) && (nxo[0]===nxo[2]))
         || ((nxo[3] !== '?') && (nxo[3]===nxo[4]) && (nxo[3]===nxo[5]))
         || ((nxo[6] !== '?') && (nxo[6]===nxo[7]) && (nxo[6]===nxo[8]))
         || ((nxo[0] !== '?') && (nxo[0]===nxo[3]) && (nxo[0]===nxo[6]))
         || ((nxo[1] !== '?') && (nxo[1]===nxo[4]) && (nxo[1]===nxo[7]))
         || ((nxo[2] !== '?') && (nxo[2]===nxo[5]) && (nxo[2]===nxo[8]))
         || ((nxo[0] !== '?') && (nxo[0]===nxo[4]) && (nxo[0]===nxo[8]))
         || ((nxo[2] !== '?') && (nxo[2]===nxo[4]) && (nxo[2]===nxo[6]))  ) { 
           nstan = 'KONIEC';
    }
    return {
     ...state, // spread operator https://redux.js.org/recipes/using-object-spread-operator
      xo : nxo,
      kto : nkto,
      stanGry : nstan
    };

  } else {
     return state;
  }
}

export {StanAplikacji};
export const store = createStore(
  reducer,
  inicjujStanAplikacji(),
  // dla debuggera window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);
