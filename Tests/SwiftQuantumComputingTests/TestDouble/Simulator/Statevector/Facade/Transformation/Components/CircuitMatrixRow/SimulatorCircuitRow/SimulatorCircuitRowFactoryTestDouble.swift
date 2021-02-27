//
//  SimulatorCircuitRowFactoryTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 30/12/2020.
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

import Foundation

@testable import SwiftQuantumComputing

// MARK: - Main body

final class SimulatorCircuitRowFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeCircuitMatrixRowCount = 0
    private (set) var lastMakeCircuitMatrixRowQubitCount: Int?
    private (set) var lastMakeCircuitMatrixRowBaseMatrix: SimulatorMatrix?
    private (set) var lastMakeCircuitMatrixRowInputs: [Int]?
    var makeCircuitMatrixRowResult: SimulatorCircuitRow = SimulatorCircuitRowTestDouble()
}

// MARK: - SimulatorCircuitRowFactory methods

extension SimulatorCircuitRowFactoryTestDouble: SimulatorCircuitRowFactory {
    func makeCircuitMatrixRow(qubitCount: Int,
                              baseMatrix: SimulatorMatrix,
                              inputs: [Int]) -> SimulatorCircuitRow {
        makeCircuitMatrixRowCount += 1

        lastMakeCircuitMatrixRowQubitCount = qubitCount
        lastMakeCircuitMatrixRowBaseMatrix = baseMatrix
        lastMakeCircuitMatrixRowInputs = inputs

        return makeCircuitMatrixRowResult
    }
}
