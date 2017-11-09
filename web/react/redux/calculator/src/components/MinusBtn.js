import React, { PropTypes } from 'react';

const MinusBtn = ({ onClick }) => (
  <button className="btn" onClick={ onClick }>-</button>
)

MinusBtn.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default MinusBtn
