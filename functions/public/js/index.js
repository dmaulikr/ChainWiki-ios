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
var Localization = {
  kr: 'kr',
  jp: 'jp',
};

var ArcanaAttribute = {
  rarity: 'rarity',
  group: 'group',
  weapon: 'weapon',
  affiliation: 'affiliation',
  numberOfViews: 'numberOfViews',
};

var lastArcanaIDKey;
var initialKnownKey;
var arcanaArray = [];
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
    this.insertCell(data, 0);
    arcanaDictionary[data.key] = true;
  }.bind(this);

  var updateArcana = function(data) {
    this.updateCell(data);
  }.bind(this);

  var removeArcana = function(data) {
    delete arcanaDictionary[data.key];
    this.removeCell(data);
  }.bind(this);

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
      this.insertCell(data, pages);
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


ChainWiki.prototype.insertCell = function(data, index) {

  // todo: find the previous <tr> with the previousIDkey? and INSERT at that point.
  console.log('appending cell...');
  const val = data.val();
  const arcanaID = data.key;
  const nameKR = val.nameKR;
  const nicknameKR = val.nicknameKR || val.nickNameKR;
  const nameJP = val.nameJP;
  const nicknameJP = val.nicknameJP || val.nickNameJP;

  console.log('fetching', nameKR, arcanaID);
  // row is a <tr> element
  var row = this.arcanaList.insertRow(index);
  row.style.height = '95px';
  row.setAttribute('onclick', `location.href='/arcana/?arcana=${arcanaID}'`);
  
  var arcanaImageCell = document.createElement('td');
  arcanaImageCell.style.width = '66px';  
  arcanaImageCell.style.height = '66px';

  this.storageRef.child(`/image/arcana/${arcanaID}/icon.jpg`).getDownloadURL().then(function(url) {
    arcanaImageCell.innerHTML = `<img data-original='${url}' class='arcanaImageIcon' id='${arcanaID}_icon'/>`;
    $('img.arcanaImageIcon').lazyload({
      placeholder: 'images/placeholder.png',
      effect : 'fadeIn'
    });
  }).catch(function(error) {
    console.log("Image download error.");
  });

  var nameCell = document.createElement('td');
  nameCell.style.verticalAlign = 'top';

  const nameKRContainerView = setupName(nameKR, nicknameKR, Localization.kr);
  const nameJPContainerView = setupName(nameJP, nicknameJP, Localization.jp);
  const detailContainerView = setupDetail(val.rarity, val.class, val.weapon, val.affiliation, val.numberOfViews);

  nameCell.appendChild(nameKRContainerView);
  nameCell.appendChild(nameJPContainerView);
  nameCell.appendChild(detailContainerView);

  row.appendChild(arcanaImageCell);
  row.appendChild(nameCell);

};

function setupName(name, nickname, localization) {

  const nameContainerView = document.createElement('div');
  const nameLabel = document.createElement('span');
  nameLabel.innerHTML = name;
  if (localization == 'kr') {
    nameLabel.setAttribute('class', 'nameKRLabel');
  }
  else {
    nameLabel.setAttribute('class', 'nameJPLabel');
  }

  nameContainerView.appendChild(nameLabel);

  if (nickname) {

    const nicknameLabel = document.createElement('span');
    nicknameLabel.innerHTML = nickname;
    if (localization == 'kr') {
      nicknameLabel.setAttribute('class', 'nicknameKRLabel');
    }
    else {
      nicknameLabel.setAttribute('class', 'nicknameJPLabel');
    }
    nameContainerView.appendChild(nicknameLabel);
  }

  return nameContainerView;
}

function setupDetail(rarity, group, weapon, affiliation, numberOfViews) {
  console.log("setup detail");
  const detailContainerView = document.createElement('div');

  const rarityLabel = createDetailLabel(rarity, ArcanaAttribute.rarity);
  const groupLabel = createDetailLabel(group, ArcanaAttribute.group);
  const weaponLabel = createDetailLabel(weapon, ArcanaAttribute.weapon);
  const affiliationLabel = createDetailLabel(affiliation, ArcanaAttribute.affiliation);
  const numberOfViewsLabel = createDetailLabel(numberOfViews, ArcanaAttribute.numberOfViews);

  detailContainerView.appendChild(rarityLabel);
  detailContainerView.appendChild(groupLabel);
  detailContainerView.appendChild(weaponLabel);
  detailContainerView.appendChild(affiliationLabel);
  detailContainerView.appendChild(numberOfViewsLabel);

  return detailContainerView;
}

function createDetailLabel(detail, arcanaAttribute) {
  console.log(arcanaAttribute);
  const detailLabel = document.createElement('span');
  detailLabel.setAttribute('class', 'detailLabel');

  if (arcanaAttribute == "rarity") {
    detailLabel.innerHTML = '#' + detail + '성';
  }
  else if (arcanaAttribute == "numberOfViews") {
    detailLabel.innerHTML = '조회 ' + detail;
  }
  else {
    detailLabel.innerHTML = '#' + detail;
  }

  return detailLabel

}

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

function searchArcana() {
  const searchInput = document.getElementById('searchArcanaText').value;
  console.log("Searching for", searchInput);
  if (searchInput) {
      window.location.href = `/search/?nameKR=${searchInput}`
  }
}

function authListener() {
  firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
    console.log('user is signed in');
  } else {
    console.log('user is not signed in');
    firebase.auth().signInAnonymously().catch(function(error) {
      
    });
  }
});
}

window.onload = function() {
  window.ChainWiki = new ChainWiki();
  authListener()
};

$(window).scroll(function() {
    if($(window).scrollTop() == $(document).height() - $(window).height()) {
        console.log("Scrolled to bottom...");
        window.ChainWiki.fetchArcana();
    }
});

$(document).ready(function(){
  console.log("READY");
    $('#searchArcanaText').keypress(function(e){
      console.log("PRESSED");
      if(e.keyCode==13) {
        searchArcana()
        return false;
      }
    });
});