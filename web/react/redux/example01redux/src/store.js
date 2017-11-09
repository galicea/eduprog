import { createStore, } from 'redux';

export type StanAplikacji = {
  licznik: number,
};

export const ACTION_ZWIEKSZ = 'ACTION_ZWIEKSZ'

const reducer = (state = {    licznik: 0,  }, action) => {
  switch (action.type) {
    case ACTION_ZWIEKSZ:
      return Object.assign({}, state, {
        licznik : state.licznik + 1,
      });
    default: 
      return state;
  }
}

export const store = createStore(
  reducer,
  );

export const Akcje = {
  zwieksz(): void {
    store.dispatch({type: ACTION_ZWIEKSZ});
  }
}

