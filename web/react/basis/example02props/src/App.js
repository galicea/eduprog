import React, {Component} from 'react';

class Tekst extends Component {
 render() {
  return ( <span>{this.props.normal} <i>{this.props.italic}</i></span>);
 }
}

class Przycisk extends Component {
render() {
  return (
   <button onClick={this.props.akcja}>Kliknij {this.props.opis} </button>
  );
 }
}

class App extends Component {
  klikniecie() { // funkcja JavaScript
   console.log('Klik'); alert('Klik');
}

render() {
 return (
  <div>
   <Tekst italic='kursywa' normal='test' /><br />
   <Przycisk akcja={ () => { alert('Klik1'); } }  opis='klik1/alert'  />
   <Przycisk akcja={ function() { alert('klik2'); } }
                                             opis='klik2/function()'  />
   <Przycisk akcja={ function() { this.klikniecie(); }.bind(this) }
                                        opis='klik3/this/bind'  />
   <Przycisk akcja={ () => this.klikniecie() } opis='klik4/this'  />
 </div>
 );
}

}

export default App;
