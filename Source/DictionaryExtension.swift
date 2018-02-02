//
//  DictionaryExtension.swift
//  WatchSessionManager
//
//  Created by Carlos Aguiar on 30/01/2018.
//  Copyright © 2018 Bliss Applications. All rights reserved.
//

import Foundation

extension Dictionary {

  mutating func addEntriesFromDictionary(dictionary: Dictionary<Key, Value>) {
    for (key, value) in dictionary {
      self[key] = value
    }
  }
}
