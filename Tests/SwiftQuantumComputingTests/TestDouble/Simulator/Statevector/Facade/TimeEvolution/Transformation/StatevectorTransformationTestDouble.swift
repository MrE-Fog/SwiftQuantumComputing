//
//  StatevectorTransformationTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/02/2021.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class StatevectorTransformationTestDouble {

    // MARK: - Internal properties

    private (set) var applyCount = 0
    private (set) var lastApplyGate: Gate?
    private (set) var lastApplyVector: Vector?
    var applyResult: Vector?
    var applyError = QuantumOperatorError.gateError(error: .gateControlsCanNotBeAnEmptyList)
}

// MARK: - StatevectorTransformation methods

extension StatevectorTransformationTestDouble: StatevectorTransformation {
    func apply(gate: Gate, toStatevector vector: Vector) -> Result<Vector, QuantumOperatorError> {
        applyCount += 1

        lastApplyGate = gate
        lastApplyVector = vector

        if let applyResult = applyResult {
            return .success(applyResult)
        }

        return .failure(applyError)
    }
}
