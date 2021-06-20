//
//  MainCircuitFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/05/2020.
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

// MARK: - Main body

/// Conforms `CircuitFactory`. Use to create new `Circuit` instances
public struct MainCircuitFactory {

    // MARK: - Public types

    /// Define behaviour of `Circuit.unitary(withQubitCount:)`
    public enum UnitaryConfiguration {
        /// Each `Gate` is expanded into a `Matrix` and multiplied between them to get the unitary
        /// that represents the entire circuit.  Expansion can be done in parallel with up to `maxConcurrency`
        /// number of threads. If `maxConcurrency` is set to 1 or less, the whole process will be serial
        case fullMatrix(maxConcurrency: Int = 1)
    }

    /// Define behaviour of `Circuit.statevector(withInitialStatevector:)`
    public enum StatevectorConfiguration {
        /// Each `Gate` is expanded into a `Matrix` and applied to the current statevector
        /// to get the final statevector. Expansion can be done in parallel with up to `maxConcurrency`
        /// number of threads. If `maxConcurrency` is set to 1 or less, the whole process will be serial.
        /// This configuration has the biggest memory footprint
        case fullMatrix(maxConcurrency: Int = 1)
        /// For each position of the next statevector, the corresponding row of the `Gate` is expanded
        /// and applied as needed. Expansion can be done in parallel with up to `maxConcurrency`
        /// number of threads. If `maxConcurrency` is set to 1 or less, the whole process will be serial.
        case rowByRow(maxConcurrency: Int = 1)
        /// For each position of the next statevector, element by element of the corresponding row
        /// in the `Gate` is calculated (on the fly) and applied as needed. This process can be done in
        /// parallel with up to `maxConcurrency` number of threads. If `maxConcurrency` is set to
        /// 1 or less, the whole process will be serial.
        case elementByElement(maxConcurrency: Int = 1)
        /// Similar to `StatevectorConfiguration.elementByElement` but instead of calculating
        /// (on the fly) all positions in a row, only those that are needed (not zero) are generated. If each gate
        /// only uses a few qubits in the circuit, this is the fastest option and it does not consume more memory
        /// than `StatevectorConfiguration.elementByElement`. This process can be done in
        /// parallel with up to `maxConcurrency` number of threads. If `maxConcurrency` is set to 1 or
        /// less, the whole process will be serial.
        case direct(maxConcurrency: Int = 1)
    }

    // MARK: - Private properties

    private let unitaryConfiguration: UnitaryConfiguration
    private let statevectorConfiguration: StatevectorConfiguration

    // MARK: - Public init methods
 
    /**
     Initialize a `MainCircuitFactory` instance.

     - Parameter unitaryConfiguration:Defines how a unitary matrix is calculated. By default is set to
     `UnitaryConfiguration.fullMatrix`, however the performance of each configuration depends on each
     use case. It is recommended to try different configurations so see how long an execution takes and how much
     memory is required.
     - Parameter statevectorConfiguration: Defines how a statevector is calculated. By default is set to
     `StatevectorConfiguration.direct`, however the performance of each configuration depends on each
     use case. It is recommended to try different configurations so see how long an execution takes and how much
     memory is required.

     - Returns: A`MainCircuitFactory` instance.
     */
    public init(unitaryConfiguration: UnitaryConfiguration = .fullMatrix(),
                statevectorConfiguration: StatevectorConfiguration = .direct()) {
        self.unitaryConfiguration = unitaryConfiguration
        self.statevectorConfiguration = statevectorConfiguration
    }
}

// MARK: - CircuitFactory methods

extension MainCircuitFactory: CircuitFactory {

    /// Check `CircuitFactory.makeCircuit(gates:)`
    public func makeCircuit(gates: [Gate]) -> Circuit {
        return CircuitFacade(gates: gates,
                             unitarySimulator: makeUnitarySimulator(),
                             statevectorSimulator: makeStatevectorSimulator())
    }
}

// MARK: - Private body

private extension MainCircuitFactory {

    // MARK: - Private methods

    func makeUnitarySimulator() -> UnitarySimulator {
        return UnitarySimulatorFacade(gateFactory: makeUnitaryGateFactory())
    }

    func makeUnitaryGateFactory() -> UnitaryGateFactory {
        let mc: Int
        let transformation: UnitaryTransformation
        switch unitaryConfiguration {
        case .fullMatrix(let maxConcurrency):
            mc = maxConcurrency > 0 ? maxConcurrency : 1
            transformation = try! CSMFullMatrixUnitaryTransformation(maxConcurrency: mc)
        }

        return try! UnitaryGateFactoryAdapter(maxConcurrency: mc, transformation: transformation)
    }

    func makeStatevectorSimulator() -> StatevectorSimulator {
        let transformation = makeStatevectorTransformation()
        let registerFactory = StatevectorRegisterFactoryAdapter(transformation: transformation)

        let statevectorFactory = MainCircuitStatevectorFactory()

        return StatevectorSimulatorFacade(registerFactory: registerFactory,
                                          statevectorFactory: statevectorFactory)
    }

    func makeStatevectorTransformation() -> StatevectorTransformation {
        let transformation: StatevectorTransformation
        switch statevectorConfiguration {
        case .fullMatrix(let maxConcurrency):
            let mc = maxConcurrency > 0 ? maxConcurrency : 1

            transformation = try! CSMFullMatrixStatevectorTransformation(maxConcurrency: mc)
        case .rowByRow(let maxConcurrency):
            let mc = maxConcurrency > 0 ? maxConcurrency : 1

            transformation = try! CSMRowByRowStatevectorTransformation(maxConcurrency: mc)
        case .elementByElement(let maxConcurrency):
            let mc = maxConcurrency > 0 ? maxConcurrency : 1

            transformation = try! CSMElementByElementStatevectorTransformation(maxConcurrency: mc)
        case .direct(let maxConcurrency):
            let mc = maxConcurrency > 0 ? maxConcurrency : 1

            let filteringFactory = DirectStatevectorFilteringFactoryAdapter()
            let indexingFactory = DirectStatevectorIndexingFactoryAdapter()

            transformation = try! DirectStatevectorTransformation(filteringFactory: filteringFactory,
                                                                  indexingFactory: indexingFactory,
                                                                  maxConcurrency: mc)
        }

        return transformation
    }
}
