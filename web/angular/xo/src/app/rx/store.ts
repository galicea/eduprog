import { AnyAction, createStore } from 'redux';
import { AkcjeXO } from './actions';

// https://github.com/angular-redux/store/blob/master/articles/intro-tutorial.md

export interface IStanAplikacji { // zamiast export const StanAplikacji = {
  xo: string[], // znak x / o
  kto: string,  // czyj ruch
  stanGry: string// komunikat
}

export const INITIAL_STATE: IStanAplikacji = {
  xo: new Array(9).fill('?'),
  kto: 'x',
  stanGry: '* Kółko i Krzyżyk *'
}

export const reducer = (state: IStanAplikacji = INITIAL_STATE, action: AnyAction): IStanAplikacji => {
  if (action.type === AkcjeXO.ACTION_ZMIANA) {
    const ix = parseInt(action['y'], 10) * 3 + parseInt(action['x'], 10);
    if (state.xo[ix] !== '?') return state;
    const nxo = state.xo.slice(); // PŁYTKA KOPIA state.xo.
    nxo[ix] = state.kto;
    let nkto = 'x';
    let nstan = 'ruch: x';
    if (state.kto === 'x') {
      nkto = 'o';
      nstan = 'ruch: o';
    }
    if (
      (nxo[0] !== '?' && nxo[0] === nxo[1] && nxo[0] === nxo[2]) ||
      (nxo[3] !== '?' && nxo[3] === nxo[4] && nxo[3] === nxo[5]) ||
      (nxo[6] !== '?' && nxo[6] === nxo[7] && nxo[6] === nxo[8]) ||
      (nxo[0] !== '?' && nxo[0] === nxo[3] && nxo[0] === nxo[6]) ||
      (nxo[1] !== '?' && nxo[1] === nxo[4] && nxo[1] === nxo[7]) ||
      (nxo[2] !== '?' && nxo[2] === nxo[5] && nxo[2] === nxo[8]) ||
      (nxo[0] !== '?' && nxo[0] === nxo[4] && nxo[0] === nxo[8]) ||
      (nxo[2] !== '?' && nxo[2] === nxo[4] && nxo[2] === nxo[6])
    ) {
      nstan = 'KONIEC';
    }
    return {
      ...state, // spread operator https://redux.js.org/recipes/using-object-spread-operator
      xo: nxo,
      kto: nkto,
      stanGry: nstan
    };
  } else {
    return state;
  }
}

export const store = createStore(reducer);