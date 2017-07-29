//
//  Migration.swift
//  DuckDuckGo
//
//  Created by Christopher Brind on 27/07/2017.
//  Copyright © 2017 DuckDuckGo. All rights reserved.
//

import Foundation
import CoreData
import Core

class Migration {
    
    public static let oldBookmarksKey = "bookmarks"
    
    private var container: PersistenceContainer
    
    init(container: PersistenceContainer = PersistenceContainer(name: "Stories")) {
        self.container = container
    }
    
    func start(queue: DispatchQueue = DispatchQueue.global(qos: .background), completion: @escaping (_ stories: Int, _ bookmarks: Int) -> ()) {
        queue.async {
            let bookmarks = BookmarksManager()
            let bookmarksMigrated = self.migrateBookmarks(into: bookmarks)
            let storiesMigrated = self.migrateStories(into: bookmarks)
            completion(storiesMigrated, bookmarksMigrated)
        }
    }
    
    private func migrateBookmarks(into bookmarks: BookmarksManager) -> Int {
        
        let defaults = UserDefaults.standard
        guard let oldBookmarks = defaults.array(forKey: Migration.oldBookmarksKey) else {
            return 0
        }
        
        var bookmarkCount = 0
        for bookmarkDict in oldBookmarks {
            
            guard let bookmark = bookmarkDict as? [ String: String? ] else { continue }
            guard let title = bookmark["title"] else { continue }
            guard let urlString = bookmark["url"] else { continue }
            guard let url = URL(string: urlString!) else { continue }
            
            bookmarks.save(bookmark: Link(title: title, url: url, favicon: nil))
            bookmarkCount += 1
        }
        
        return bookmarkCount
    }
    
    private func migrateStories(into bookmarks: BookmarksManager) -> Int {
        let savedStories = self.container.savedStories()
        
        var storyCount = 0
        for story in savedStories {
            
            guard let urlString = story.urlString else { continue }
            guard let url = URL(string: urlString) else { continue }
            
            bookmarks.save(bookmark: Link(title: story.title, url: url, favicon: nil))
            storyCount += 1
        }
        
        self.container.clear()
        return storyCount;
    }
    
}
