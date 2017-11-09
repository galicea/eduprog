import React, { Component } from 'react';
import { connect } from 'react-redux';
import type { StanAplikacji } from './store.js';
import { Akcje } from './store.js'

class App extends Component {

  render() {
    return ( <button
      onClick = { () => Akcje.zwieksz() } > Kliknij  {this.props.dane.licznik.toString()}  </button>
    );
  }
}

export default connect(
  (state: StanAplikacji) => ({ dane: state }),
)(App);
