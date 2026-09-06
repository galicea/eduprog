import React, {Component} from 'react';
import {Button} from 'react-bootstrap';

class App extends Component {

  constructor(props) { // konieczne ustawienie stanu początkowego
    super(props);
    this.state = {
      licznik: 0,
    };
   }
 
  klikniecie() {
    console.log('zwieksza');
    // źle:
    //  this.setState({licznik: this.state.licznik+1}); 
    // Dobrze:
    this.setState( // spowoduje ponowny render()
       (prevState, props) => ({
          licznik: prevState.licznik + 1
       }));
  }



  render() {
    return (
      <div>
        <p>Licznik={this.state.licznik.toString()}</p>
        <Button variant="primary" onClick={ this.klikniecie.bind(this) } >Kliknij {this.state.licznik.toString()}</Button><br />
        inny zapis:
        <Button variant="primary" onClick={ ()=>this.klikniecie() } >Kliknij {this.state.licznik.toString()}</Button>
      </div>
    );
  }
}

export default App;