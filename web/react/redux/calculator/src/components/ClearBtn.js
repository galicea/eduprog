import React, { PropTypes } from 'react';

const ClearBtn = ({ onClick }) => (
  <button className="btn" onClick={ onClick }>C</button>
)

ClearBtn.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default ClearBtn
