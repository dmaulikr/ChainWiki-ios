import React, { Component } from 'react';
import logo from './images/logo.png';
import './App.css';
import * as firebase from 'firebase';

var arcanaRef;

class App extends Component {

  constructor() {
    super();
    this.state = {
      keys: []
    };
  }

  setupCell() {
    console.log("OI");
  }
  
  componentWillMount() {
    this.arcanaRef = firebase.database().ref().child('arcana');

    var keys = [];
    this.arcanaRef.limitToLast(3).on('child_added', snap => {
      
      const arcanaID = snap.key;
      setupCell();
      keys.push(
        <div className='arcana' key={arcanaID}>
          {arcanaID}
        </div>
      );

      this.setState({
        keys: keys
      });

    });

  }

  render() {
    return (
      <div>
        {this.state.keys}
      </div>
      // <div className="App">
      //   <h1>{this.state.keys[1]}</h1>
      // </div>
    );
  }
  

}

export default App;
