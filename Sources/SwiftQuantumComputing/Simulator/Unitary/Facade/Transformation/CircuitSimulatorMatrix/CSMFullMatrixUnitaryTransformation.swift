//
//  CSMFullMatrixUnitaryTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 06/06/2021.
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

struct CSMFullMatrixUnitaryTransformation {

    // MARK: - Private properties

    private let expansionConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case expansionConcurrencyHasToBiggerThanZero
    }

    init(expansionConcurrency: Int) throws {
        guard expansionConcurrency > 0 else {
            throw InitError.expansionConcurrencyHasToBiggerThanZero
        }

        self.expansionConcurrency = expansionConcurrency
    }
}

// MARK: - UnitaryTransformation methods

extension CSMFullMatrixUnitaryTransformation: UnitaryTransformation {}

// MARK: - CircuitSimulatorMatrixUnitaryTransformation methods

extension CSMFullMatrixUnitaryTransformation: CircuitSimulatorMatrixUnitaryTransformation {
    func apply(circuitMatrix: CircuitSimulatorMatrix, toUnitary matrix: Matrix) -> Matrix {
        let lhs = try! circuitMatrix.expandedRawMatrix(maxConcurrency: expansionConcurrency).get()

        return try! (lhs * matrix).get()
    }
}
