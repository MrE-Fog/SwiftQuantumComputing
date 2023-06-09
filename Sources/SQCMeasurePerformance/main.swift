//
//  main.swift
//  SQCMeasurePerformance
//
//  Created by Enrique de la Torre on 01/05/2021.
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

import ArgumentParser
import Foundation
import SwiftQuantumComputing

// MARK: - Types

enum Result: String, CaseIterable, ExpressibleByArgument {
    case densityMatrix
    case statevector
    case unitary
}

enum Mode: String, CaseIterable, ExpressibleByArgument {
    case matrix
    case row
    case value
    case direct
}

enum Circuit: String, CaseIterable, ExpressibleByArgument {
    case hadamards
    case halfHadamardsHalfNots
    case controlledHadamards
    case fullyControlledHadamards
    case oracleHadamards
}

typealias Circuits = (circuit: SwiftQuantumComputing.Circuit,
                      noise: SwiftQuantumComputing.NoiseCircuit)

// MARK: - Main body

struct SQCMeasurePerformance: ParsableCommand {

    // MARK: - Properties

    static var configuration = CommandConfiguration(
        abstract: "Calculate how long it takes to produce a statevector, unitary or density matrix",
        discussion: """
            This application provides multiple configuration options, try
            different values to check the performance of this quantum
            circuit simulator in your computer.
            """
    )

    @Option(name: [.customShort("o"), .customLong("option")],
            help: "Result type/option to produce: \(Result.allCases.map({ "\($0)" }).joined(separator: ", ")).")
    var result = Result.statevector

    @Option(name: .shortAndLong,
            help: "Execution mode: \(Mode.allCases.map({ "\($0)" }).joined(separator: ", ")).")
    var mode = Mode.direct

    @Option(name: [.customShort("u"), .customLong("calculations")],
            help: "Maximum number of threads used to make calculations.")
    var calculationConcurrency = 1

    @Option(name: [.customShort("e"), .customLong("expansion")],
            help: "Maximum number of threads used to expand rows & matrices.")
    var expansionConcurrency = 1

    @Option(name: [.short, .customLong("qubits")],
            help: "Number of qubits to be simulated.")
    var qubitCount = 18

    @Option(name: [.customShort("g"), .customLong("gates")],
            help: ArgumentHelp("Set of gates that compose the circuit: " +
                                "\(Circuit.allCases.map({ "\($0)" }).joined(separator: ", "))."))
    var circuit = Circuit.fullyControlledHadamards

    @Option(name: [.short, .customLong("replicate")],
            help: "How many times 'gates' are replicated to compose a longer circuit.")
    var replicateCircuit = 1

    @Option(name: [.customShort("l"), .customLong("loop")],
            help: "How many times the circuit is simulated to get an average execution time.")
    var repeatExecution = 1

    @Flag(name: .shortAndLong, help: "Increase verbosity of informational output")
    var printVerbose = false

    // MARK: - Methods

    mutating func validate() throws {
        guard !(result == .unitary && mode == .direct) &&
                !(result == .densityMatrix && (mode == .value || mode == .direct)) else {
            throw ValidationError("Option \(result) can not be executed in mode \(mode).")
        }

        guard calculationConcurrency >= 1 else {
            throw ValidationError("Please specify a number of 'calculations' of at least 1.")
        }

        guard expansionConcurrency >= 1 else {
            throw ValidationError("Please specify a number of 'expansion' of at least 1.")
        }

        switch mode {
        case .direct, .value:
            if expansionConcurrency > 1 {
                throw ValidationError("Only valid expasion for mode \(mode) is 1.")
            }
        case .matrix:
            if calculationConcurrency > 1 {
                throw ValidationError("Only valid calculations for mode \(mode) is 1.")
            }
        case .row:
            break
        }

        let minQubitCount: Int
        switch circuit {
        case .hadamards, .halfHadamardsHalfNots:
            minQubitCount = 1
        case .controlledHadamards, .fullyControlledHadamards, .oracleHadamards:
            minQubitCount = 2
        }
        guard qubitCount >= minQubitCount else {
            throw ValidationError(
                "For \(circuit) 'gates', please specify at least \(minQubitCount) 'qubits'."
            )
        }

        guard replicateCircuit >= 1 else {
            throw ValidationError("Please specify a 'replicate' of at least 1.")
        }

        guard repeatExecution >= 1 else {
            throw ValidationError("Please specify a 'loop' of at least 1.")
        }
    }

    mutating func run() throws {
        let output = makeCircuits()

        print("""
        Simulating circuit with:
        - \(qubitCount) qubit/s
        - \(output.circuit.gates.count) gates (entangled state + \(circuit))
        - Up to \(calculationConcurrency * expansionConcurrency) thread/s in \(mode) mode to produce \(result)\n
        """)

        let total = (1...repeatExecution).reduce(0.0) { (acc, idx) in
            print("Simulation \(idx) of \(repeatExecution)...")

            let start = DispatchTime.now()
            execute(output)
            let diff = seconds(since: start)

            verbose("Simulation \(idx) of \(repeatExecution): Completed in \(diff) seconds")

            return acc + diff
        }

        print("\nSimulation completed. " +
                "Average execution time: \(total / Double(repeatExecution)) seconds")
    }
}

// MARK: - Private body

private extension SQCMeasurePerformance {

    // MARK: - Private methods

    func seconds(since start: DispatchTime) -> Double {
        let diff = DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds

        return Double(diff) / 1_000_000_000
    }

    func verbose(_ msg: String) {
        guard printVerbose else {
            return
        }

        print(msg)
    }

    func execute(_ circuits: Circuits) {
        switch result {
        case .densityMatrix:
            _ = circuits.noise.densityMatrix()
        case .statevector:
            _ = circuits.circuit.statevector()
        case .unitary:
            _ = circuits.circuit.unitary()
        }
    }

    func entangledStateGates() -> [Gate] {
        verbose("Creating gates to compose initial entangled state...")
        defer {
            verbose("Gates created")
        }

        return [.hadamard(target: 0)] +
            (1..<qubitCount).map { .controlledNot(target: $0, control: 0) }
    }

    func commonGates() -> [Gate] {
        verbose("Creating \(circuit) 'gates'...")
        defer {
            verbose("Gates created")
        }

        let indexes = 0..<qubitCount

        switch circuit {
        case .hadamards:
            return Gate.hadamard(targets: indexes)
        case .halfHadamardsHalfNots:
            let index = qubitCount / 2

            return Gate.hadamard(targets: 0..<index) + Gate.not(targets: index..<qubitCount)
        case .controlledHadamards:
            return indexes.map { idx in
                var control = qubitCount - idx - 1
                if control == idx {
                    control = 0
                }

                return .controlled(gate: .hadamard(target: idx),
                                   controls: [control])
            }
        case .fullyControlledHadamards:
            return indexes.map { idx in
                return .controlled(gate: .hadamard(target: idx),
                                   controls: indexes.filter { $0 != idx })
            }
        case .oracleHadamards:
            let truthtable = [
                String(repeating: "0", count: qubitCount - 1),
                String(repeating: "1", count: qubitCount - 1)
            ]

            return indexes.map { idx in
                return .oracle(truthTable: truthtable,
                               controls: indexes.filter { $0 != idx },
                               gate: .hadamard(target: idx))
            }
        }
    }

    func replicatedGates() -> [Gate] {
        verbose("Replicating 'gates'...")
        defer {
            verbose("Gates replicated")
        }

        return Array(repeating: commonGates(), count: replicateCircuit).flatMap { $0 }
    }

    func makeFactories() -> (CircuitFactory, NoiseCircuitFactory) {
        let unitConfig: MainCircuitFactory.UnitaryConfiguration
        let stateConfig: MainCircuitFactory.StatevectorConfiguration
        let densityConfig: MainNoiseCircuitFactory.DensityMatrixConfiguration
        switch mode {
        case .matrix:
            unitConfig = .matrix(expansionConcurrency: expansionConcurrency)
            stateConfig = .matrix(expansionConcurrency: expansionConcurrency)
            densityConfig = .matrix(expansionConcurrency: expansionConcurrency)
        case .row:
            unitConfig = .row(calculationConcurrency: calculationConcurrency,
                              expansionConcurrency: expansionConcurrency)
            stateConfig = .row(calculationConcurrency: calculationConcurrency,
                               expansionConcurrency: expansionConcurrency)
            densityConfig = .row(calculationConcurrency: calculationConcurrency,
                                 expansionConcurrency: expansionConcurrency)
        case .value:
            unitConfig = .value(calculationConcurrency: calculationConcurrency)
            stateConfig = .value(calculationConcurrency: calculationConcurrency)
            densityConfig = .matrix(expansionConcurrency: expansionConcurrency)
        case .direct:
            unitConfig = .matrix(expansionConcurrency: expansionConcurrency)
            stateConfig = .direct(calculationConcurrency: calculationConcurrency)
            densityConfig = .matrix(expansionConcurrency: expansionConcurrency)
        }

        let circuitFactory = MainCircuitFactory(unitaryConfiguration: unitConfig,
                                                statevectorConfiguration: stateConfig)
        let noiseCircuitFactory = MainNoiseCircuitFactory(densityMatrixConfiguration: densityConfig)

        return (circuitFactory, noiseCircuitFactory)
    }

    func makeCircuits() -> Circuits {
        verbose("Creating circuits...")

        let start = DispatchTime.now()
        defer {
            let diff = seconds(since: start)

            verbose("Circuit created in \(diff) seconds\n")
        }

        let (factory, noiseFactory) = makeFactories()
        let gates = entangledStateGates() + replicatedGates()

        let circuit = factory.makeCircuit(gates: gates)
        let noiseCircuit = noiseFactory.makeNoiseCircuit(quantumOperators: gates)

        return (circuit, noiseCircuit)
    }
}

// MARK: - Launch

SQCMeasurePerformance.main()
