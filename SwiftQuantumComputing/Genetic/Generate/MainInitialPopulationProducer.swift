//
//  MainInitialPopulationProducer.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/02/2019.
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
import os.log

// MARK: - Main body

struct MainInitialPopulationProducer {

    // MARK: - Internal types

    typealias Random = (Range<Int>) -> Int

    // MARK: - Private properties

    private let generator: GeneticGatesRandomizer
    private let evaluator: GeneticCircuitEvaluator
    private let score: GeneticCircuitScore
    private let random: Random

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init(generator: GeneticGatesRandomizer,
         evaluator: GeneticCircuitEvaluator,
         score: GeneticCircuitScore,
         random: @escaping Random = { Int.random(in: $0) }) {
        self.generator = generator
        self.evaluator = evaluator
        self.score = score
        self.random = random
    }
}

// MARK: - InitialPopulationProducer methods

extension MainInitialPopulationProducer: InitialPopulationProducer {
    func execute(size: Int, depth: Range<Int>) -> [Fitness.EvalCircuit]? {
        guard size > 0 else {
            os_log("initial population failed: population size has to be bigger than 0",
                   log: MainInitialPopulationProducer.logger,
                   type: .debug)

            return nil
        }

        var population: [Fitness.EvalCircuit] = []

        let queue = DispatchQueue(label: String(reflecting: type(of: self)))
        DispatchQueue.concurrentPerform(iterations: size) { _ in
            guard let circuit = try? generator.make(depth: random(depth)) else {
                return
            }

            guard let evaluation = try? evaluator.evaluateCircuit(circuit) else {
                return
            }

            let circuitScore = score.calculate(evaluation)

            queue.sync {
                population.append((circuitScore, circuit))
            }
        }

        if (population.count != size) {
            os_log("initial population failed: unable to fill initial population",
                   log: MainInitialPopulationProducer.logger,
                   type: .debug)

            return nil
        }

        return population
    }
}
