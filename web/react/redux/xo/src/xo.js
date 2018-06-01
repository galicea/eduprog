import React  from 'react';
import {connect} from "react-redux";
import {bindActionCreators} from "redux";
import * as Akcje from './actions';

class Wynik extends React.Component {
    render() {
        return <span>{this.props.msg}</span>
    }
}

export {Wynik};

class XO extends React.Component {
    render() {
      return <td onClick={ () =>  this.props.zmiana(this.props.x,this.props.y) }>{this.props.c}</td>
    }
}

// https://github.com/reactjs/redux/blob/master/docs/api/bindActionCreators.md
// https://stackoverflow.com/questions/39419237/what-is-mapdispatchtoprops
// https://blog.benestudio.co/5-ways-to-connect-redux-actions-3f56af4009c8

const mapDispatchToProps = dispatch => bindActionCreators(
    Akcje,
    dispatch,
)

export default connect(
    null,
    mapDispatchToProps
)(XO);
