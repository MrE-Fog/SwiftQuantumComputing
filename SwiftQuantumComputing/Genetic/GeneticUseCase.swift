//
//  GeneticUseCase.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/01/2019.
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

// MARK: - Main body

public struct GeneticUseCase {

    // MARK: - Types

    public struct TruthTable {

        // MARK: - Public properties

        public let truth: [String]
        public let qubitCount: Int
    }

    public struct Circuit {

        // MARK: - Public properties

        public let output: String
    }

    // MARK: - Public properties

    public let truthTable: TruthTable
    public let circuit: Circuit

    // MARK: - Public init methods

    public init(truthTable: [String], circuitOutput: String) {
        let truthTableQubitCount = truthTable.reduce(0) { $0 > $1.count ? $0 :  $1.count }

        self.init(truthTable: .init(truth: truthTable, qubitCount: truthTableQubitCount),
                  circuit: .init(output: circuitOutput))
    }

    public init(emptyTruthTableQubitCount: Int, circuitOutput: String) {
        self.init(truthTable: .init(truth: [], qubitCount: emptyTruthTableQubitCount),
                  circuit: .init(output: circuitOutput))
    }

    // MARK: - Private init methods

    private init(truthTable: TruthTable, circuit: Circuit) {
        self.truthTable = truthTable
        self.circuit = circuit
    }
}
