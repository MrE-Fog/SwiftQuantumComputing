//
//  MainGeneticUseCaseEvaluator.swift
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

struct MainGeneticUseCaseEvaluator {

    // MARK: - Private properties

    private let useCase: GeneticUseCase
    private let factory: CircuitFactory
    private let oracleFactory: OracleCircuitFactory
    private let probabilityIndex: Int

    // MARK: - Internal init methods

    init(useCase: GeneticUseCase,
         factory: CircuitFactory,
         oracleFactory: OracleCircuitFactory) {
        self.useCase = useCase
        self.factory = factory
        self.oracleFactory = oracleFactory
        self.probabilityIndex = Int(useCase.circuit.output, radix: 2)!
    }
}

// MARK: - GeneticUseCaseEvaluator methods

extension MainGeneticUseCaseEvaluator: GeneticUseCaseEvaluator {
    func evaluateCircuit(_ geneticCircuit: [GeneticGate]) -> Result<Double, EvolveCircuitError> {
        var gates: [Gate]!
        switch oracleFactory.makeOracleCircuit(geneticCircuit: geneticCircuit, useCase: useCase) {
        case .success((let circuit, _)):
            gates = circuit
        case .failure(let error):
            return .failure(error)
        }

        let circuit = factory.makeCircuit(gates: gates)
        let input = useCase.circuit.input

        var probabilities: [Double]!
        switch circuit.probabilities(withInitialBits: input) {
        case .success(let probs):
            probabilities = probs
        case .failure(let error):
            return .failure(.useCaseMeasurementThrowedError(useCase: useCase, error: error))
        }

        return .success(abs(1 - probabilities[probabilityIndex]))
    }
}
