import * as actionTypes from '../types/actionTypes';

export const onNumClick = (number) => ({
  type: actionTypes.INPUT_NUMBER,
  number,
});
export const onPlusClick = () => ({
  type: actionTypes.PLUS,
});
export const onMinusClick = () => ({
  type: actionTypes.MINUS,
});
export const onClearClick = () => ({
  type: actionTypes.CLEAR,
  resultValue: 0,
});
export const onResultClick = () => ({
  type: actionTypes.RESULT,
});
