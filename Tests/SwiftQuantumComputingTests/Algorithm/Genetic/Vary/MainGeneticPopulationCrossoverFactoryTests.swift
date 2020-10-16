//
//  MainGeneticPopulationCrossoverFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/04/2019.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class MainGeneticPopulationCrossoverFactoryTests: XCTestCase {

    // MARK: - Properties

    let fitness = FitnessTestDouble()
    let crossover = GeneticCircuitCrossoverTestDouble()
    let score = GeneticCircuitScoreTestDouble()
    let evaluator = GeneticCircuitEvaluatorTestDouble()

    // MARK: - Tests

    func testTournamentSizeBiggerThanZero_makeCrossover_returnValue() {
        // Given
        let factory = MainGeneticPopulationCrossoverFactory(fitness: fitness,
                                                            crossover: crossover,
                                                            score: score)

        // Then
        XCTAssertNotNil(factory.makeCrossover(tournamentSize: 1, maxDepth: 0, evaluator: evaluator))
    }

    static var allTests = [
        ("testTournamentSizeBiggerThanZero_makeCrossover_returnValue",
         testTournamentSizeBiggerThanZero_makeCrossover_returnValue)
    ]
}
