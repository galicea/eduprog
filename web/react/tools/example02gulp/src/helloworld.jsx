class HelloWorld extends React.Component {
  render() {
  return  <h1>Hello World</h1>
  }
}

const root = ReactDOM.createRoot(document.getElementById('example2'));
root.render(<HelloWorld />);