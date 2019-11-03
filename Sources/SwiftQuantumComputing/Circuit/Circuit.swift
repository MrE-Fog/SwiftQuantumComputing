//
//  Circuit.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/08/2018.
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

// MARK: - Errors

public enum GateError: Error {
    case additionOfSquareModulusIsNotEqualToOneAfterApplyingGateToStatevector
    case resultingMatrixIsNotUnitaryAfterApplyingGateToUnitary
    case gateInputCountDoesNotMatchGateMatrixQubitCount
    case gateInputsAreNotInBound
    case gateInputsAreNotUnique
    case gateMatrixIsNotSquare
    case gateMatrixIsNotUnitary
    case gateMatrixRowCountHasToBeAPowerOfTwo
    case gateMatrixHandlesMoreQubitsThatGateActuallyHas
    case gateOracleControlsCanNotBeAnEmptyList
    case gateQubitCountDoesNotMatchCircuitQubitCount
    case gateQubitCountHasToBeBiggerThanZero
}

public enum StatevectorError: Error {
    case initialStatevectorCountHasToBeAPowerOfTwo
    case initialStatevectorAdditionOfSquareModulusIsNotEqualToOne
    case gateThrowedError(gate: FixedGate, error: GateError)
}

public enum UnitaryError: Error {
    case circuitCanNotBeAnEmptyList
    case gateThrowedError(gate: FixedGate, error: GateError)
}

// MARK: - Protocol definition

public protocol Circuit {
    var gates: [FixedGate] { get }

    func unitary(withQubitCount qubitCount: Int) throws -> Matrix
    func statevector(withInitialStatevector initialStatevector: Vector) throws -> Vector
}