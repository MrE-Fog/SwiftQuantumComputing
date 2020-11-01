//
//  SimulatorCircuitMatrixAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/05/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

import ComplexModule
import Foundation

// MARK: - Main body

struct SimulatorCircuitMatrixAdapter {

    // MARK: - SimulatorMatrix properties

    let count: Int

    // MARK: - Private properties

    private let derives: [(base: Int, remaining: Int)]
    private let baseMatrix: SimulatorMatrix

    // MARK: - Internal init methods

    init(qubitCount: Int, baseMatrix: SimulatorMatrix, inputs: [Int]) {
        let count = Int.pow(2, qubitCount)
        let remainingInputs = (0..<qubitCount).reversed().filter { !inputs.contains($0) }

        let derives = (0..<count).lazy.map { value in
            return (value.derived(takingBitsAt: inputs),
                    value.derived(takingBitsAt: remainingInputs))
        }

        self.count = count
        self.derives = Array(derives)
        self.baseMatrix = baseMatrix
    }
}

// MARK: - SimulatorCircuitMatrix methods

extension SimulatorCircuitMatrixAdapter: SimulatorCircuitMatrix {
    var rawMatrix: Matrix {
        return try! Matrix.makeMatrix(rowCount: count,
                                      columnCount: count,
                                      value: { self[$0, $1] }).get()
    }
}

// MARK: - SimulatorCircuitMatrixRow methods

extension SimulatorCircuitMatrixAdapter: SimulatorCircuitMatrixRow {
    subscript(row: Int) -> Vector {
        return try! Vector.makeVector(count: count, value: { self[row, $0] }).get()
    }
}

// MARK: - SimulatorMatrix methods

extension SimulatorCircuitMatrixAdapter: SimulatorMatrix {
    subscript(row: Int, column: Int) -> Complex<Double> {
        let (baseRow, remainingRow) = derives[row]
        let (baseColumn, remainingColumn) = derives[column]

        return (remainingRow == remainingColumn ? baseMatrix[baseRow, baseColumn] : Complex.zero)
    }
}