//
//  StatevectorRegisterTestDouble.swift
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

final class StatevectorRegisterTestDouble {

    // MARK: - Internal properties

    private (set) var applyingCount = 0
    private (set) var lastApplyingGate: RegisterGate?
    var applyingResult: StatevectorRegisterTestDouble?
    var applyingError = GateError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGate

    private (set) var measureCount = 0
    private (set) var lastMeasureQubits: [Int]?
    var measureResult: [Double]?
    var measureError = MeasureError.qubitsAreNotSorted
}

// MARK: - StatevectorRegister methods

extension StatevectorRegisterTestDouble: StatevectorRegister {
    func applying(_ gate: RegisterGate) throws -> StatevectorRegisterTestDouble {
        applyingCount += 1

        lastApplyingGate = gate

        if let applyingResult = applyingResult {
            return applyingResult
        }

        throw applyingError
    }

    func measure(qubits: [Int]) throws -> [Double] {
        measureCount += 1

        lastMeasureQubits = qubits

        if let measureResult = measureResult {
            return measureResult
        }

        throw measureError
    }
}
