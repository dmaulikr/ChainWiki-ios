/**
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
'use strict';

// Initializes ChainWiki.
function ChainWiki() {

  // Shortcuts to DOM Elements.
  this.arcanaList = document.getElementById('arcana');
  this.initFirebase();
  this.loadArcana();
}

// Sets up shortcuts to Firebase features and initiate firebase auth.
ChainWiki.prototype.initFirebase = function() {
  // Shortcuts to Firebase SDK features.
  this.auth = firebase.auth();
  this.database = firebase.database();
  this.storageRef = firebase.storage().ref();
};

// Loads chat messages history and listens for upcoming ones.
ChainWiki.prototype.loadArcana = function() {

  this.arcanaRef = this.database.ref('arcana');
  // Make sure we remove all previous listeners.
  this.arcanaRef.off();

  var setArcana = function(data) {
    this.setupCell(data);
  }.bind(this);

  var nameArray = new Array();

  this.arcanaRef.limitToLast(3).on('child_added', setArcana);
  this.arcanaRef.limitToLast(3).on('child_changed', setArcana);
};

ChainWiki.prototype.setupCell = function(data) {

  const val = data.val();
  const arcanaID = data.key;
  const nameKR = val.nameKR;
  const nicknameKR = val.nicknameKR;

  // row is a <tr> element
  var row = this.arcanaList.insertRow(0);
  row.style.height = '106px';
  // row.setAttribute("onclick", "location.href='arcana.html'");
  
  
  var arcanaImageCell = document.createElement('td');
  arcanaImageCell.style.width = '75px';

  this.storageRef.child(`/image/arcana/${arcanaID}/icon.jpg`).getDownloadURL().then(function(url) {
    arcanaImageCell.innerHTML = `<img src =${url} style = "padding: 0px;", vertical-align: "middle;"/>`;

  }).catch(function(error) {
    console.log("Image download error.");
  });

  var nameCell = document.createElement('td');
  // nameCell.style.width = '85%';
  const nameKRContainerView = document.createElement('div');

  const nameKRLabel = document.createElement('span');
  nameKRLabel.className = "nameKRLabel";
  nameKRLabel.innerHTML = nameKR;
  nameKRContainerView.appendChild(nameKRLabel);

  const nicknameKRLabel = document.createElement('span');
  nicknameKRLabel.innerHTML = nicknameKR;
  nameKRContainerView.appendChild(nicknameKRLabel);

  nameCell.appendChild(nameKRContainerView);
  row.appendChild(arcanaImageCell);
  row.appendChild(nameCell);
};

window.onload = function() {
  window.ChainWiki = new ChainWiki();
};
