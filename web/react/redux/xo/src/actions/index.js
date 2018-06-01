import * as actionTypes from '../types/index';
/***********  kreatory akcji ***********/

export function zmiana(x,y : string) {
  return {
    type: actionTypes.ACTION_ZMIANA,
    x,
    y
  };
}


