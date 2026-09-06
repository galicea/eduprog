import { Component } from '@angular/core';
import { xoActions } from './rx/actions';
import { IStanAplikacji, store } from './rx/store';

@Component({
  selector: 'xo-selector',
  standalone: true,
  templateUrl: './xo.component.html',
  styleUrls: ['./xo.component.css'],
  providers: [xoActions]
})
export class XoComponent {
  public xo: string[];
  public stanGry: string;

  constructor(private actions: xoActions) {
    const state: IStanAplikacji = store.getState();
    this.xo = state.xo;
    this.stanGry = state.stanGry;
    // aktualizacja po każdym dispatchniu
    store.subscribe(() => {
      const s = store.getState();
      this.xo = s.xo;
      this.stanGry = s.stanGry;
    });
  }

  public click(event: Event, n: number) {
    const mapxy: string[][] = [
      ['0', '0'], ['1', '0'], ['2', '0'],
      ['0', '1'], ['1', '1'], ['2', '1'],
      ['0', '2'], ['1', '2'], ['2', '2']
    ];
    store.dispatch(this.actions.zmiana(mapxy[n][0], mapxy[n][1]));
  }
}