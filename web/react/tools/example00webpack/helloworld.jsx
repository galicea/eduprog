import React from 'react';
import { createRoot } from 'react-dom/client';

class HelloWorld extends React.Component {
  render() {
    return <h1>Hello World</h1>
  }
}

const root = createRoot(document.getElementById('example02'));
root.render(<HelloWorld />);