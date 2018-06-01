import { Component } from '@angular/core';


// redux
import { NgRedux, select, select$ } from '@angular-redux/store'; // <- New
import { xoActions } from './rx/actions'; // <- New
import { IStanAplikacji, store } from "./rx/store"; // <- New
import { Observable } from 'rxjs';
//-

// debug
function objToString (obj) {
  var str = '';
  for (var p in obj) {
      if (obj.hasOwnProperty(p)) {
          str += p + '::' + obj[p] + '\n';
      }
  }
  return str;
}
//-
@Component({
  selector: 'xo-selector',
  templateUrl: './xo.component.html',
  styleUrls: ['./xo.component.css']
})
export class XoComponent {
  @select() 'stanGry' ;
  public xo : Array<string>;

constructor(                           
  private ngRedux: NgRedux<IStanAplikacji>,
  private actions: xoActions) {
    this.xo = store.getState().xo; 
//    this.xo = this.ngRedux.select( .... );    
}

public click(event, n, item) {
  const mapxy = [{x:'0',y:'0'},{x:'1',y:'0'},{x:'2',y:'0'},
                 {x:'0',y:'1'},{x:'1',y:'1'},{x:'2',y:'1'},
                 {x:'0',y:'2'},{x:'1',y:'2'},{x:'2',y:'2'}];
  this.ngRedux.dispatch(this.actions.zmiana(mapxy[n].x,mapxy[n].y));
  this.xo = store.getState().xo;
}

}
