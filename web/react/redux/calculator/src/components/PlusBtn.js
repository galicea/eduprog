import React, { PropTypes } from 'react';

const PlusBtn = ({ onClick }) => (
  <button className="btn" onClick={ onClick }>+</button>
)

PlusBtn.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default PlusBtn
