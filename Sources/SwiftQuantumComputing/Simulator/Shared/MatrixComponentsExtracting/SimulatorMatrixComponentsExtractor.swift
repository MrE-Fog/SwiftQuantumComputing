//
//  SimulatorMatrixComponentsExtractor.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/02/2021.
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

struct SimulatorMatrixComponentsExtractor {

    // MARK: - Internal types

    typealias InternalExtractor = SimulatorMatrixExtracting & RawInputsExtracting

    // MARK: - Private properties

    private let extractor: InternalExtractor

    // MARK: - Internal init methods

    init(extractor: InternalExtractor) {
        self.extractor = extractor
    }
}

// MARK: - RawInputsExtracting methods

extension SimulatorMatrixComponentsExtractor: RawInputsExtracting {
    func extractRawInputs() -> [Int] {
        return extractor.extractRawInputs()
    }
}

// MARK: - MatrixExtracting methods

extension SimulatorMatrixComponentsExtractor: MatrixComponentsExtracting {
    func extractMatrix() -> Result<AnySimulatorMatrix, GateError> {
        switch extractor.extractSimulatorMatrix() {
        case .success(let matrix):
            return .success(AnySimulatorMatrix(matrix: matrix))
        case .failure(let error):
            return .failure(error)
        }
    }
}
