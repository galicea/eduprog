import { Injectable } from '@angular/core';

export enum AkcjeXO {
  ACTION_ZMIANA = 'ACTION_ZMIANA',
}

@Injectable()
export class xoActions {
  zmiana(x: string, y: string) {
    return {
      type: AkcjeXO.ACTION_ZMIANA,
      x,
      y
    };
  }
}