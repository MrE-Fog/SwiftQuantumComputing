//
//  UnitaryGateFactoryTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/10/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

final class UnitaryGateFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeGateCount = 0
    private (set) var lastMakeUnitaryGateQubitCount: Int?
    private (set) var lastMakeUnitaryGateGate: Gate?
    var applyingResult: UnitaryGateTestDouble?
    var applyingError = QuantumOperatorError.operatorHandlesMoreQubitsThanCircuitActuallyHas
}

// MARK: - UnitaryGateFactory methods

extension UnitaryGateFactoryTestDouble: UnitaryGateFactory {
    func makeUnitaryGate(qubitCount: Int, gate: Gate) -> Result<UnitaryGate, QuantumOperatorError> {
        makeGateCount += 1

        lastMakeUnitaryGateQubitCount = qubitCount
        lastMakeUnitaryGateGate = gate

        if let applyingResult = applyingResult {
            return .success(applyingResult)
        }

        return .failure(applyingError)
    }
}
