import React, {Component} from 'react';
import {Button} from 'react-bootstrap';


class Przycisk extends Component {

   render() {
     return (
        <Button variant="primary" onClick={this.props.akcja}>Kliknij: {this.props.opis} [{this.props.licznik}] </Button>
    );
  }
}



class App extends Component {

   constructor(props) {
    super(props);
    this.state = {
      licznik: 1,
    };
   }


  klikniecie() {
    this.setState(
       (prevState, props) => ({
          licznik: prevState.licznik + 1
       }));
    // lepsza wersja od this.setState({licznik: this.state.licznik+1}); 
  }

  render() {
    return (
      <div className="App">
        <Przycisk opis="licznik" licznik={this.state.licznik} akcja={() => this.klikniecie()} />
      </div>
    );
  }

}

export default App;