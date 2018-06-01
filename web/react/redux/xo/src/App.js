import React  from 'react';
import './App.css';
import XO, {Wynik} from './xo.js';
import { connect } from 'react-redux';


class App extends React.Component {

    render() {
        return (
            <table className="plansza">
                <tbody>
                <tr>
                    <XO x={0} y={0} c={this.props.data.xo[0]} />
                    <XO x={1} y={0} c={this.props.data.xo[1]} />
                    <XO x={2} y={0} c={this.props.data.xo[2]} />
                </tr>
                <tr>
                    <XO x={0} y={1} c={this.props.data.xo[3]} />
                    <XO x={1} y={1} c={this.props.data.xo[4]} />
                    <XO x={2} y={1} c={this.props.data.xo[5]} />
                </tr>
                <tr>
                    <XO x={0} y={2} c={this.props.data.xo[6]} />
                    <XO x={1} y={2} c={this.props.data.xo[7]} />
                    <XO x={2} y={2} c={this.props.data.xo[8]} />
                </tr>
                <tr>
                    <td colSpan="3"><Wynik msg={this.props.data.stanGry}/></td>
                </tr>
                </tbody>
            </table> );
    }
}

/*

connect jako argumenty przyjmuje dwie funkcje zwyczajowo nazywane mapStateToProps i mapDispatchToProps

mapStateToProps — jako argument przyjmuje cały stan i musi zwrócić propsy dla danego komponentu
mapDispatchToProps — jako argument przyjmuje funkcję lub obiekt z action creatorami

 */

const mapStateToProps = state => {
    return {
        data: state
    }
};


export default connect(
    mapStateToProps
)(App);
