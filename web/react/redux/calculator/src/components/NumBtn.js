import React from 'react';

const NumBtn = ({n, onClick}) => (
  <button className="btn" onClick={onClick}>{n}</button>
)

export default NumBtn