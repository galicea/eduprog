import React, { PropTypes } from 'react';

const ResultBtn = ({ onClick }) => (
  <button className="btn" onClick={ onClick }>=</button>
)

ResultBtn.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default ResultBtn
