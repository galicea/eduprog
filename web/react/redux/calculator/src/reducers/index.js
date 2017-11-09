import * as actionTypes from '../types/actionTypes';
import { combineReducers } from 'redux';

const initialAppState = {
  inputValue: 0,
  resultValue: 0,
  lastResult: 0,
  operation: 0, // 0 = nothing, 1 = plus, -1 = minus
  expression: '',
};

const calculator = (state = initialAppState, action) => {

  const newExpression = (result : number, input : number, oper : number) => {
    if ((result !== 0) && (oper !== 0)) {
      return result.toString()+
        (oper>0 ? '+' : '-') +
        input.toString();
    }
    if (result !== 0)
      return result.toString();
    return input.toString();
  }
  const Calculate = (result : number, input : number, oper : number) => {
    if ((result !== 0) && (oper !== 0)) {
      return result+(oper*input);
    }
    return input;
  }

  if (action.type === actionTypes.INPUT_NUMBER) {
    let newInput = state.inputValue * 10 + action.number;
    let newResult = Calculate(state.lastResult,newInput,state.operation);
    return {
      ...state,
      inputValue: newInput,
      resultValue: newResult,
      expression : newExpression(state.lastResult,newInput,state.operation)
    };
  } else if (action.type === actionTypes.PLUS) {
    return {
      ...state,
      expression : newExpression(state.lastResult,state.inputValue,state.operation),
      lastResult: state.resultValue,
      inputValue: 0,
      operation : 1
    };
  } else if (action.type === actionTypes.MINUS) {
    return {
      ...state,
      inputValue: 0,
      operation : -1,
      expression : newExpression(state.lastResult,state.inputValue,state.operation),
      lastResult: state.resultValue,
    };
  } else if (action.type === actionTypes.RESULT) {
    return {
      ...state,
      expression : state.resultValue.toString(),
      inputValue: 0,
      operation : 0,
      lastResult: state.resultValue,
    };
  } else if (action.type === actionTypes.CLEAR) {
    return {
      ...state,
      inputValue: 0,
      operation : 0,
      resultValue: 0,
      lastResult: 0,
      expression : '',
    };
  } else {
    return state;
  }
};

//  index.js - aby katalog byl widoczny jak modul
// gdy wiecej reducerow - w index tylko combine ... ????

const reducer = combineReducers({
  calculator,
});

export default reducer;
