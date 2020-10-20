//
//  Photo.swift
//  CISample
//
//  Created by David on 2020/10/15.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

struct Photo: Decodable {
  let id: Int
  let title: String
  let thumbnailUrl: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case thumbnailUrl
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
    self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
    self.thumbnailUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl) ?? ""
  }
}
