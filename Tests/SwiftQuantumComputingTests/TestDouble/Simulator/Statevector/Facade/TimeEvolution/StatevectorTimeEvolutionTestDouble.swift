//
//  StatevectorTimeEvolutionTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/12/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

final class StatevectorTimeEvolutionTestDouble {

    // MARK: - Internal properties

    private (set) var stateCount = 0
    var stateResult = try! Vector([.zero, .one])

    private (set) var simulatorApplyingCount = 0
    private (set) var lastSimulatorApplyingGate: Gate?
    var simulatorApplyingResult: StatevectorTimeEvolutionTestDouble?
    var simulatorApplyingError = QuantumOperatorError.circuitQubitCountHasToBeBiggerThanZero
}

extension StatevectorTimeEvolutionTestDouble: StatevectorTimeEvolution {
    var state: Vector {
        stateCount += 1

        return stateResult
    }

    func applying(_ gate: Gate) -> Result<StatevectorTimeEvolution, QuantumOperatorError> {
        simulatorApplyingCount += 1

        lastSimulatorApplyingGate = gate

        if let applyingResult = simulatorApplyingResult {
            return .success(applyingResult)
        }

        return .failure(simulatorApplyingError)
    }
}
