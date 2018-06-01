import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { XoComponent } from './xo.component';


// redux
import { NgReduxModule, NgRedux } from '@angular-redux/store';
//-
// redux - store
import { IStanAplikacji, store } from './rx/store';
import { xoActions } from './rx/actions';
//-

@NgModule({
  declarations: [
    AppComponent,
    XoComponent
  ],
  imports: [
    BrowserModule,
    NgReduxModule, // redux
  ],
  providers: [xoActions], // <- redux actions types
  bootstrap: [AppComponent, XoComponent]
})
export class AppModule { 

// redux
constructor(ngRedux: NgRedux<IStanAplikacji> ) {
  // zainicjowanie store.
  
/*  ngRedux.configureStore(
    reducer,
    INITIAL_STATE);
*/
  // albo zarejestrowanie istniejącego:
   ngRedux.provideStore(store);
}
//-
}

