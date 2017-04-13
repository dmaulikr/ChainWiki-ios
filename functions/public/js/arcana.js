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

var arcanaID;

window.onload = function() {
  window.ChainWiki = new ChainWiki();
};

// Initializes ChainWiki.
function ChainWiki() {
  // Shortcuts to DOM Elements.
  this.arcanaList = document.getElementById('arcana');
  this.initFirebase();
  arcanaID = getParameterByName('arcana');
  this.loadArcana();
}

// Sets up shortcuts to Firebase features and initiate firebase auth.
ChainWiki.prototype.initFirebase = function() {
  // Shortcuts to Firebase SDK features.
  this.auth = firebase.auth();
  this.database = firebase.database();
  this.storageRef = firebase.storage().ref();
};

ChainWiki.prototype.loadArcana = function() {
  console.log(arcanaID);
  
  this.arcanaRef = this.database.ref(`arcana/${arcanaID}`);
  // Make sure we remove all previous listeners.
  this.arcanaRef.off();

  var setupImage = function(arcanaID) {
    this.loadImage(arcanaID);
  }.bind(this);

  var setupBaseInfo = function(val) {
    this.setupBaseInfo(val);
  }.bind(this);

  this.arcanaRef.on('value', function(snapshot) {

    const val = snapshot.val();
    const arcanaID = snapshot.key;

    setupImage(arcanaID);
    setupBaseInfo(val);
  });
};

ChainWiki.prototype.setupBaseInfo = function(val) {
  
  document.getElementById('nameKR').innerHTML = val.nameKR;
  document.getElementById('rarity').innerHTML = val.rarity;
  document.getElementById('group').innerHTML = val.class;
  document.getElementById('affiliation').innerHTML = val.affiliation;
  document.getElementById('cost').innerHTML = val.cost;
  document.getElementById('weapon').innerHTML = val.weapon;
  document.getElementById('tavern').innerHTML = val.tavern;

  document.getElementById('skillName1').innerHTML = val.skillName1;
  document.getElementById('skillMana1').innerHTML = val.skillMana1;
  document.getElementById('skillDesc1').innerHTML = val.skillDesc1;

  document.getElementById('abilityName1').innerHTML = val.abilityName1;
  document.getElementById('abilityDesc1').innerHTML = val.abilityDesc1;

  if (val.abilityName2) {
    addAbility(val.abilityName2, val.abilityDesc2, 2);
  }

  if (val.partyAbility) {
    addAbility(val.partyAbility, val.partyAbility, 'partyAbility');
  }

  document.getElementById('kizunaName').innerHTML = val.kizunaName;
  document.getElementById('kizunaCost').innerHTML = val.kizunaCost;
  document.getElementById('kizunaDesc').innerHTML = val.kizunaDesc;

};

function insertAfter(referenceNode, newNode) {
  referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
}

function addAbility(abilityName, abilityDesc, type) {

    // create the one row table.
    const table = document.createElement('table');
    table.setAttribute('class', 'arcanaSkillTable');

    const row = table.insertRow(0);

    const headerCell = document.createElement('th');
    headerCell.setAttribute('class', 'headerCell');

    const bodyCell = document.createElement('td');
    bodyCell.setAttribute('class', 'bodyCell');

    row.appendChild(headerCell);
    row.appendChild(bodyCell);

    // setup the abilityDesc below the table
    const abilityDescDiv = document.createElement('div');
    abilityDescDiv.setAttribute('class', 'skillAbilityDescCell');
    abilityDescDiv.setAttribute('id', 'abilityDesc2');
    abilityDescDiv.innerHTML = abilityDesc;

    var previousDiv;
    if (type == 2) {
      console.log('adding ability2');
      bodyCell.innerHTML = abilityName;
      headerCell.innerHTML = '어빌 2';
      previousDiv = document.getElementById('abilityDesc1');
    }
    else {
      console.log('adding partyability');
      headerCell.innerHTML = '파티 어빌';
      previousDiv = document.getElementById('abilityDesc2');
    }
    insertAfter(previousDiv, table);
    insertAfter(table, abilityDescDiv);
}
ChainWiki.prototype.loadImage = function(arcanaID) {

  const arcanaImage = document.getElementById('arcanaImage');
  // arcanaImage.setAttribute("id", "arcanaImageMain");
  this.storageRef.child(`/image/arcana/${arcanaID}/main.jpg`).getDownloadURL().then(function(url) {
    arcanaImage.innerHTML = `<img src =${url} class = "arcanaImageMain"/>`;
  }).catch(function(error) {
    console.log("Image download error.");
  });
};

function getParameterByName(name, url) {
    if (!url) {
      url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}