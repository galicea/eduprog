// @flow

import { applyMiddleware, createStore } from 'redux';
import type { Cell, Spreadsheet } from './types.js';
import logger from 'redux-logger';


// actions:
export const ACTION_CLICK_LEFT = 'ACTION_LEFT'
export const ACTION_CLICK_RIGHT = 'ACTION_RIGHT'
export const ACTION_CLICK_CELL = 'ACTION_CELL'



// actions creator
export const Actions = {
  left(idx : number)  {
/*    console.log(idx);
    console.log('left'); -> logger*/
    store.dispatch({ type: ACTION_CLICK_LEFT, cellidx :idx });
  },
  right(idx : number) {
    store.dispatch({ type: ACTION_CLICK_RIGHT, cellidx : idx });
  },
  cell(idx : number) {
    store.dispatch({ type: ACTION_CLICK_CELL, cellidx : idx });
  },
}

// reducer:
const reducer = (state: Spreadsheet, action: Object)  => {
//  var ncalc = state.calc; !! to nie jest pełna kopia
  let ncalc: Cell[] = state.calc.slice(); // PŁYTKA KOPIA state.calc.
  // Tzn. jest to nowa tablica, ale ncalc[i] to wciąż ten sam obiekt co state.calc[i].
  var sel_value = 0;
  var sel_color = '';
  var i=0;
  switch (action.type) {
    case ACTION_CLICK_LEFT:
      ncalc[action.cellidx] = Object.assign({}, ncalc[action.cellidx]); // KOPIA state.calc[action.cellidx], które będzimy modyfikować
      while ((i<8) && (sel_color==='')) {
        if (ncalc[i].color !== ncalc[i].color0) {
          sel_value=ncalc[i].value;
          sel_color=ncalc[i].color0;
          ncalc[i].color=ncalc[i].color0;
        }
        i=i+1;
      }
      if (sel_color!=='') {
        ncalc[action.cellidx].lcolor=sel_color;
        ncalc[action.cellidx].left=sel_value;
        ncalc[action.cellidx].value=ncalc[action.cellidx].left+ncalc[action.cellidx].right;
      }
      return Object.assign({}, state, {
        calc : ncalc
      });

    case ACTION_CLICK_RIGHT:
      ncalc[action.cellidx] = Object.assign({}, ncalc[action.cellidx]);
      while ((i<8) && (sel_color==='')) {
        if (ncalc[i].color !== ncalc[i].color0) {
          sel_value=ncalc[i].value;
          sel_color=ncalc[i].color0;
          ncalc[i].color=ncalc[i].color0;
        }
        i=i+1;
      }
      if (sel_color!=='') {
        ncalc[action.cellidx].rcolor=sel_color;
        ncalc[action.cellidx].right=sel_value;
        ncalc[action.cellidx].value=ncalc[action.cellidx].left+ncalc[action.cellidx].right;
      }
      return Object.assign({}, state, {
        calc : ncalc
      });

    case ACTION_CLICK_CELL:
      ncalc[action.cellidx] = Object.assign({}, ncalc[action.cellidx]);
      for (i=0; i<8; i++) ncalc[i].color = ncalc[i].color0;
      ncalc[action.cellidx].color='blue';
      return Object.assign({}, state, {
        calc : ncalc
      });

    default:
      return state;
  }
}

// store
function FillSpreadsheet(): Spreadsheet {
  var c=[];
  var x;
  var v=0;
  for (x of ['#006600','#264d73','#262673','#602060']) {
    v=v+1;
    c.push(  {
         color0: x,
         color: x,
         lcolor : 'black',
         rcolor : 'black',
         left: 0,
         right: 0,
//         selected: false, // color = blue
         value: v // docelowo [] - będzie lista ikon
     } );
  }
  for (x of ['#b34700','#00b33c','#006bb3','#b3b300']) {
    c.push(  {
         color0: x,
         color: x,
         lcolor : 'black',
         rcolor : 'black',
         left: 0,
         right: 0,
//         selected: false, // color = blue
         value: 0 // docelowo [] - będzie lista ikon
     } );
  }
  return {
    calc: c,
  };
}

export const store = createStore(
  reducer,
  FillSpreadsheet(),
  applyMiddleware(logger),

);
