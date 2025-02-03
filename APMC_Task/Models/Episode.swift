//
//  Episode.swift
//  APMC_Task
//
//  Created by Lydia on 2025-02-03.
//

import Foundation

struct Episode: Codable {
    var id: String
    var title: String
    var description: String?
    var videoUrl: String
    var duration: Int
}
