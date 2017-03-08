//
//  DataLink.swift
//  Chain
//
//  Created by Jitae Kim on 3/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

class DataLink {
    
    private let url: String
    private let title: String
    
    init(url: String, title: String) {
        self.url = url
        self.title = title
    }
    
    func getURL() -> String {
        return url
    }
    
    func getTitle() -> String {
        return title
    }
}
