//
//  UserDefaults.swift
//  Chain
//
//  Created by Jitae Kim on 10/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import FirebaseAnalytics

extension UserDefaults {
    
    func setLogin(value: Bool) {
        set(value, forKey: "loggedIn")
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: "loggedIn")
    }
    
    func setUID(value: String) {
        set(value, forKey: "uid")
    }
    
    func getUID() -> String? {
        return string(forKey: "uid")
    }
    
    func setName(value: String) {
        set(value, forKey: "name")
    }
    
    func getName() -> String? {
        return string(forKey: "name")
    }
    
    func setEditPermissions(value: Bool) {
        set(value, forKey: "edit")
    }
    
    func canEdit() -> Bool {
        return bool(forKey: "edit")
    }
    
    func setAbilityIndex(value: Int) {
        set(value, forKey: "abilityIndex")
    }
    
    func abilityIndex() -> Int {
        return integer(forKey: "abilityIndex")
    }
    
    func setRecent(value: [String]) {
        set(value, forKey: "recent")
    }
    
    func getRecent() -> [String] {
        return object(forKey: "recent") as? [String] ?? [String]()
    }
    
    func setLikes(value: [String]) {
        set(value, forKey: "likes")
    }
    
    func getLikes() -> [String] {
        return object(forKey: "likes") as? [String] ?? [String]()
    }
    
    func setFavorites(value: [String]) {
        set(value, forKey: "favorites")
    }
    
    func getFavorites() -> [String] {
        return object(forKey: "favorites") as? [String] ?? [String]()
    }
    
    func setImagePermissions(value: Bool) {
        set(value, forKey: "image")
    }
    
    func getImagePermissions() -> Bool {
        return bool(forKey: "image")
    }
    
    func updateVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            set(version, forKey: "version")
        }
    }
    
    func getStoredVersion() -> String? {
        return object(forKey: "version") as? String
    }
    
    func getCurrentVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? nil
    }
    
    func setPreviewAbility(value: Bool) {
        set(value, forKey: "previewAbility")
    }
    
    func getPreviewAbility() -> Bool {
        return bool(forKey: "previewAbility")
    }
    
    // MARK: Visual preference for viewing Arcana
    
    func setShowedArcanaViewSelection(value: Bool) {
        set(value, forKey: "showedArcanaViewSelection")
    }
    
    func getShowedArcanaViewSelection() -> Bool {
        return bool(forKey: "showedArcanaViewSelection")
    }
    
    func setAllArcanaView(value: String) {
        setSearchView(value: value)
        setTavernView(value: value)
        setFavoritesView(value: value)
    }
    
    func setSearchView(value: String) {
        set(value, forKey: "searchView")
        // analytics
        FIRAnalytics.logEvent(withName: "SearchView", parameters: [
            "type" : value as NSObject
            ])
    }
    
    func getSearchView() -> String? {
        return string(forKey: "searchView")
    }
    
    func setTavernView(value: String) {
        set(value, forKey: "tavernView")
        FIRAnalytics.logEvent(withName: "TavernView", parameters: [
            "type" : value as NSObject
            ])
    }
    
    func getTavernView() -> String? {
        return string(forKey: "tavernView")
    }
    
    func setFavoritesView(value: String) {
        set(value, forKey: "favoritesView")
        FIRAnalytics.logEvent(withName: "FavoritesView", parameters: [
            "type" : value as NSObject
            ])
    }
    
    func getFavoritesView() -> String? {
        return string(forKey: "favoritesView")
    }
    
    // End preferred viewing preference
    
    func setMainImage(value: Bool) {
        set(value, forKey: "imageType")
    }
    
    func getMainImage() -> Bool {
        return bool(forKey: "imageType")
    }
    

    
    // MARK - App Rating
    func getAppLaunchCount() -> Int {
        return integer(forKey: "numberOfLaunches")
    }
    
    func setAppLaunches(value: Int) {
        set(value, forKey: "numberOfLaunches")
    }
    
    func hasShownRating() -> Bool {
        return bool(forKey: "hasShownRating")
    }
    
    func setShownRating(value: Bool) {
        set(value, forKey: "hasShownRating")
    }
    
    
}
