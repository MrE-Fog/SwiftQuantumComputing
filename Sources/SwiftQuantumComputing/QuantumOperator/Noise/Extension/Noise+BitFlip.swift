//
//  Noise+BitFlip.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/09/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

// MARK: - Main body

extension Noise {

    // MARK: - Public class methods

    /// Returns a noise channel that applies a bit flip to `target` with given `probability`
    public static func bitFlip(probability: Double, target: Int) -> Noise {
        return Noise(noise: FixedBitFlipNoise(probability: probability, target: target))
    }
}
