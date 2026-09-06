import { Component } from '@angular/core';
import { XoComponent } from './xo.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [XoComponent],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
}