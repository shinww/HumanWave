//
//  UpperCase.swift
//  HumanWave
//
//  Created by shinwee on 3/2/17.
//  Copyright © 2017 shinwee. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
  }
}
