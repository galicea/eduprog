class HelloWorld extends React.Component {
  render() {
    return /*#__PURE__*/React.createElement("h1", null, "Hello World");
  }
}
const root = ReactDOM.createRoot(document.getElementById('example2'));
root.render(/*#__PURE__*/React.createElement(HelloWorld, null));