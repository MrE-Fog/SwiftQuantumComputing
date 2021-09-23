//
//  FixedPhaseDampingNoise+SimulatorKrausMatrixExtracting.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/09/2021.
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

import ComplexModule
import Foundation

// MARK: - SimulatorKrausMatrixExtracting methods

extension FixedPhaseDampingNoise: SimulatorKrausMatrixExtracting {
    func extractKrausMatrix() -> Result<SimulatorKrausMatrix, QuantumOperatorError> {
        guard (0.0...1.0).contains(probability) else {
            return .failure(.noiseError(error: .noiseProbabilityHasToBeBetweenZeroAndOne))
        }

        return .success(AnySimulatorKrausMatrix(matrices: [
            try! Matrix([[.one, .zero], [.zero, Complex(sqrt(1.0 - probability))]]),
            try! Matrix([[.zero, .zero], [.zero, Complex(sqrt(probability))]]),
        ]))
    }
}
