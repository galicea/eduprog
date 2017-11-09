// @flow
// Calculator.js
import './calculator.css';
import React, {  Component } from 'react';
import { connect } from 'react-redux';

////////////////???????????
import {  bindActionCreators } from 'redux';
import * as actions from './actions';
////////////////

import NumBtn from './components/NumBtn';
import PlusBtn from './components/PlusBtn';
import MinusBtn from './components/MinusBtn';
import ClearBtn from './components/ClearBtn';
import ResultBtn from './components/ResultBtn';
import Input from './components/Input';
import Expression from './components/Expression';
import Result from './components/Result';

class Calculator extends Component {
  render() {
    const {
      calculator, actions
    } = this.props; /* to samo co: const calculator = this.props.calculator;
    const actions = this.props.actions;*/
    return (
    <div className="container" >
     <div className="row" >
      <NumBtn n={1} onClick={  () => actions.onNumClick(1) } />
      <NumBtn n={2} onClick={  () => actions.onNumClick(2) } />
      <NumBtn n={3} onClick={  () => actions.onNumClick(3) } />
     </div>
     <div className="row" >
      <NumBtn n={4} onClick={  () => actions.onNumClick(4) } />
      <NumBtn n={5} onClick={  () => actions.onNumClick(5) } />
      <NumBtn n={6} onClick={  () => actions.onNumClick(6) } />
     </div>
     <div className="row" >
      <NumBtn n={7} onClick={  () => actions.onNumClick(7) } />
      <NumBtn n={8} onClick={  () => actions.onNumClick(8) } />
      <NumBtn n={9} onClick={  () => actions.onNumClick(9) } />
     </div>
     <div className="row" >
      <NumBtn n={0} onClick={  () => actions.onNumClick(0) } />
      <PlusBtn onClick={ actions.onPlusClick }/>
      <MinusBtn onClick={ actions.onMinusClick } />
     </div>
     <div className="row" >
      <ClearBtn onClick={ actions.onClearClick } />
      <ResultBtn onClick={ actions.onResultClick } />
     </div>
     <div className="row" >
     <Input input={ calculator.inputValue }/>
     <Expression expression={  calculator.expression }/>
     <Result result={  calculator.resultValue }/>
     </div>
    </div>
   );
}
}

// alternatywa do bezpośredniego wywołania ??
function mapDispatch(dispatch) {
  return {  actions: bindActionCreators(actions, dispatch),  }
}

const mapState = (state, ownProps) => ({
  calculator: state.calculator,
});

export default connect(mapState, mapDispatch)(Calculator);
