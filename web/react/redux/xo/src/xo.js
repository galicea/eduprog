import React  from 'react';
import Akcje from './actions/index.js';

class XO extends React.Component {

    render() {
      return <td onClick={ () => Akcje.zmiana(this.props.x,this.props.y) }>{this.props.c}</td>
    }

}

class Wynik extends React.Component {
 render() {
   return <span>{this.props.msg}</span>
 }
}

export {Wynik};
export default XO;
