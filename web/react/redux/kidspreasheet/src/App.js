// @flow
// App.js
import './kidspreasheet.css';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Actions } from './store.js';
import type { Symbol, Cell, Spreadsheet } from './types.js';

class SimpleCell extends Component {
  render() {
    const idx = this.props.idx;
    return (<div className="SimpleCell" style={ {  backgroundColor: this.props.obj.color  }  }
      onClick={
        () => Actions.cell(idx)
      } > [{this.props.obj.value}]
        </div>);
  }
}

class FunctionCell extends Component {
  render() {
    const idx = this.props.idx;
    return (
      <div className="FunctionCell" style={{
        backgroundColor: this.props.obj.color,
      }} >
      <div className="topDiv">
        <div className="leftCorner" style={{
            backgroundColor: this.props.obj.lcolor
          }}
          onClick={
            () => Actions.left(this.props.idx)
          } >
        {this.props.obj.left}
        </div>
        <div className="topCenter"> + </div>
        <div className="rightCorner" style={{
            backgroundColor: this.props.obj.rcolor,
          }}
          onClick={
            () => Actions.right(this.props.idx)
          } > {this.props.obj.right}
        </div>
      </div >
      <div className="result" value={idx.toString()}
        onClick={
          () => Actions.cell(this.props.idx)
        }
        >
        <br />
        wartosc wyliczona:
          <br /> <h2> {this.props.obj.value} </h2>
      </div >
    </div>
    );
  }
}

class App extends Component {
  render() {
    var table0 = [];
    for (var i = 0; i < 4; i++) {
      table0.push(<SimpleCell
        key={i}
        idx={i}
        obj={this.props.data.calc[i]}
      />);
    }
    var table1 = [];
    for (i = 4; i < 8; i++) {
      table1.push(<FunctionCell
        key={i}
        idx={i}
        obj={this.props.data.calc[i]}
      />);
    }
    return (<div className="container" >
      <div className="row" > {table0} </div>
      <div className="row" > {table1} </div>
    </div>
    );
  }
}


// connect React-Redux
export default connect(
  (state : Spreadsheet) => ({ data: state }),
)(App);
