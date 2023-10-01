//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 04/09/23.
//

import Foundation

/// Manages in memory session scoped API caches
final class RMAPICacheManager {
  private var cache = NSCache<NSString, NSData>()
  private var cacheDictionary: [RMEndpoint: NSCache<NSString, NSData>] = [:]

  init() {
    setUpCache()
  }

  private func setUpCache() {
    RMEndpoint.allCases.forEach {
      cacheDictionary[$0] = NSCache<NSString, NSData>()
    }
  }

  /// Get object in cache
  /// - Parameters:
  ///   - endpoint: endpoint where cache is located
  ///   - url: key where to find object
  /// - Returns: data if exists, nil otherwise
  public func cachedResponse(for endpoint: RMEndpoint, url: URL?) -> Data? {
    guard let targetCache = cacheDictionary[endpoint], let url = url else {
      return nil
    }

    let key = url.absoluteString as NSString
    return targetCache.object(forKey: key) as? Data
  }

  /// Save object into the cache
  /// - Parameters:
  ///   - endpoint: endpoint where cache is located
  ///   - url: key where to save object
  ///   - data: object to save into the cache
  public func setCache(endpoint: RMEndpoint, url: URL?, data: Data) {
    guard let targetCache = cacheDictionary[endpoint], let url = url else {
      return
    }

    let key = url.absoluteString as NSString
    targetCache.setObject(data as NSData, forKey: key)
  }
}
