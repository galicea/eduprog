import React, { PropTypes } from 'react';

const NumBtn = ({n, onClick}) => (
  <button className="btn" onClick={onClick}>{n}</button>
)

NumBtn.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default NumBtn
