//import { Injectable } from '@angular/core';
//import { Action } from 'redux';

//@Injectable()
export class xoActions {
  static ACTION_ZMIANA = 'ACTION_ZMIANA';

  zmiana(x,y : string) {
//    alert('zmiana['+x+', '+y+']')
    return {
      type: xoActions.ACTION_ZMIANA,
      x,
      y
    };
  }
}
