import * as actionTypes from '../types/index';
import { store } from '../store.js';

/***********  kreatory akcji ***********/
const Akcje = {

  zmiana(x, y): void {
    store.dispatch({
      type: actionTypes.ACTION_ZMIANA,
      x: x,
      y: y
    });
  },


}

export default Akcje;