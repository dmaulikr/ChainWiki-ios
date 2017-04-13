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

var lastArcanaIDKey;
var initialKnownKey;
var arcanaArray = new Array();
var arcanaDictionary = {};
var initialLoad = true;
var pages = 0;
// Initializes ChainWiki.
function ChainWiki() {

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

ChainWiki.prototype.loadArcana = function() {

  this.arcanaRef = this.database.ref('arcana');
  // Make sure we remove all previous listeners.
  this.arcanaRef.off();

  var count = 0;
  var addArcana = function(data) {
    if (count == 0) {
      lastArcanaIDKey = data.key;
    }
    else if (count == 9) {
      initialKnownKey = data.key;
    }
    count++;

    console.log('initialKey is', initialKnownKey);
    if (arcanaDictionary[data.key]) {
      // arcana exists, don't add it.
      console.log("arcana exists, returning.");
      return;
    }
    this.insertNewArcana(data);
    this.setupCell(data);
    arcanaDictionary[data.key] = true;
  }.bind(this);

  var updateArcana = function(data) {
    this.updateCell(data);
  }.bind(this);

  var removeArcana = function(data) {
    delete arcanaDictionary[data.key];
    this.removeCell(data);
  }.bind(this);

  var syncArcana = function(data) {
    this.insertCell(data);
  }.bind(this);
  // this.arcanaRef.on('child_added', syncArcana);
  this.arcanaRef.orderByKey().limitToLast(10).on('child_added', addArcana);
  // this.arcanaRef.orderByKey().limitToLast(10).on('child_changed', updateArcana);
  // this.arcanaRef.orderByKey().limitToLast(10).on('child_removed', removeArcana);
};

ChainWiki.prototype.fetchArcana = function() {
  console.log('fetching 10 more arcana...');
  console.log('starting from ', lastArcanaIDKey);
  this.arcanaRef = this.database.ref('arcana');
  // Make sure we remove all previous listeners.
  this.arcanaRef.off();

  var count = 0;
  var addArcana = function(data) {
    if (count == 0) {
      console.log('this is the oldest arcana, save this ID as ref for next fetch', data.key);
      lastArcanaIDKey = data.key;
    }
    if (count < 10) {
      this.appendCell(data);
      this.insertNewArcana(data);
    }
    else {
      console.log("this is the last arcana that should have been dled already. ", data.val().nameKR);
    }
    count++;

    console.log(data.key);
  }.bind(this);
  pages = arcanaArray.length;
  console.log('pages is ', pages);
  this.arcanaRef.orderByKey().endAt(lastArcanaIDKey).limitToLast(11).on('child_added', addArcana);
};

ChainWiki.prototype.setupCell = function(data) {

  const val = data.val();
  const arcanaID = data.key;
  const nameKR = val.nameKR;
  const nicknameKR = val.nicknameKR;

  // row is a <tr> element
  var rowNumber;
  if (initialLoad) {
    rowNumber = 0;
  }
  else {
    rowNumber = 1;
  }
  var row = this.arcanaList.insertRow(rowNumber);
  row.style.height = '106px';
  row.setAttribute('onclick', `location.href='/arcana/?arcana=${arcanaID}'`);
  row.setAttribute('id', `${arcanaID}_row`);
  
  var arcanaImageCell = document.createElement('td');
  arcanaImageCell.style.width = '75px';  

  this.storageRef.child(`/image/arcana/${arcanaID}/icon.jpg`).getDownloadURL().then(function(url) {
    arcanaImageCell.innerHTML = `<img data-original='${url}' class='arcanaImageIcon' id='${arcanaID}_icon'/>`;
    $('img.arcanaImageIcon').lazyload();

  }).catch(function(error) {
    console.log("Image download error.");
  });

  var nameCell = document.createElement('td');
  const nameKRContainerView = document.createElement('div');

  const nameKRLabel = document.createElement('span');
  nameKRLabel.setAttribute('class', 'nameKRLabel');
  nameKRLabel.setAttribute('id', `${arcanaID}_nameKR`)
  nameKRLabel.innerHTML = nameKR;
  nameKRContainerView.appendChild(nameKRLabel);

  const nicknameKRLabel = document.createElement('span');
  nicknameKRLabel.setAttribute('class', 'nicknameKRLabel');
  nicknameKRLabel.setAttribute('id', `${arcanaID}_nicknameKR`)
  if (nicknameKR) {
      nicknameKRLabel.innerHTML = nicknameKR;
  }
  nameKRContainerView.appendChild(nicknameKRLabel);

  nameCell.appendChild(nameKRContainerView);
  row.appendChild(arcanaImageCell);
  row.appendChild(nameCell);
};

ChainWiki.prototype.updateCell = function(data) {

  const val = data.val();
  const arcanaID = data.key;
  const nameKR = val.nameKR;
  const nicknameKR = val.nicknameKR;

  const nameKRCell = $('#' + `${arcanaID}_nameKR`);
  nameKRCell.html(nameKR);

  if (nicknameKR) {
    const nicknameKRCell = $('#' + `${arcanaID}_nicknameKR`);
    nicknameKRCell.html(nicknameKR);
  }

  // this.storageRef.child(`/image/arcana/${arcanaID}/icon.jpg`).getDownloadURL().then(function(url) {

  //   const arcanaImageCell = $('#' + `${arcanaID}_icon`);
  //   arcanaImageCell.html(`<img data-original='${url}' class='arcanaImageIcon' id='${arcanaID}_icon'/>`);
  //   $('img.arcanaImageIcon').lazyload();

  // }).catch(function(error) {
  //   console.log("Image download error.");
  // });

};

ChainWiki.prototype.insertCell = function(data) {

  const val = data.val();
  const arcanaID = data.key;

  console.log('removing :', val.nameKR);
  const row = $('#' + `${arcanaID}_row`);
  row.remove();

};

ChainWiki.prototype.appendCell = function(data) {

  // todo: find the previous <tr> with the previousIDkey? and INSERT at that point.
  console.log('appending cell...');
  const val = data.val();
  const arcanaID = data.key;
  const nameKR = val.nameKR;
  const nicknameKR = val.nicknameKR;
  console.log('fetching', nameKR, arcanaID);
  // row is a <tr> element
  var row = this.arcanaList.insertRow(pages);
  row.style.height = '106px';
  row.setAttribute('onclick', `location.href='/arcana/?arcana=${arcanaID}'`);
  
  var arcanaImageCell = document.createElement('td');
  arcanaImageCell.style.width = '75px';  

  this.storageRef.child(`/image/arcana/${arcanaID}/icon.jpg`).getDownloadURL().then(function(url) {
    arcanaImageCell.innerHTML = `<img data-original='${url}' class='arcanaImageIcon' id='${arcanaID}icon'/>`;
    $('img.arcanaImageIcon').lazyload();

  }).catch(function(error) {
    console.log("Image download error.");
  });

  var nameCell = document.createElement('td');
  const nameKRContainerView = document.createElement('div');

  const nameKRLabel = document.createElement('span');
  nameKRLabel.setAttribute('class', 'nameKRLabel');
  nameKRLabel.innerHTML = nameKR;
  nameKRContainerView.appendChild(nameKRLabel);

  const nicknameKRLabel = document.createElement('span');
  nicknameKRLabel.setAttribute('class', 'nicknameKRLabel');
  nicknameKRLabel.innerHTML = nicknameKR;
  nameKRContainerView.appendChild(nicknameKRLabel);

  nameCell.appendChild(nameKRContainerView);
  row.appendChild(arcanaImageCell);
  row.appendChild(nameCell);

};

ChainWiki.prototype.insertNewArcana = function(data) {

  const val = data.val();
  // Insert into arcanaArray
  console.log(val.nameKR);
  const arcana = {
    arcanaID: data.key,
    nameKR: val.nameKR,
    nicknameKR: val.nicknameKR,
    nameJP: val.nameJP,
    nicknameJP: val.nicknameJP,
    rarity: val.rarity,
    class: val.class,
    affiliation: val.affiliation,
    cost: val.cost,
    weapon: val.weapon,
    tavern: val.tavern,

    skillName1: val.skillName1,
    skillMana1: val.skillMana1,
    skillDesc1: val.skillDesc1,
    skillName2: val.skillName2,
    skillMana2: val.skillMana2,
    skillDesc2: val.skillDesc2,
    skillName3: val.skillName3,
    skillMana3: val.skillMana3,
    skillDesc3: val.skillDesc3,

    abilityName1: val.abilityName1,
    abilityDesc1: val.abilityDesc1,
    abilityName2: val.abilityName2,
    abilityDesc2: val.abilityDesc2,
    partyAbility: val.partyAbility,
    
    kizunaName: val.kizunaName,
    kizunaCost: val.kizunaCost,
    kizunaDesc: val.kizunaDesc
  };

  arcanaArray.splice(0, 0, arcana);

  // if (initialLoad && arcanaArray.length == 10) {
  //   lastArcanaIDKey = arcanaArray[9].arcanaID;
  //   console.log("Initial lastArcanaIDKey ", lastArcanaIDKey);
  // }
};

window.onload = function() {
  window.ChainWiki = new ChainWiki();
};

$(window).scroll(function() {
    if($(window).scrollTop() == $(document).height() - $(window).height()) {
        console.log("Scrolled to bottom...");
        window.ChainWiki.fetchArcana();
    }
});