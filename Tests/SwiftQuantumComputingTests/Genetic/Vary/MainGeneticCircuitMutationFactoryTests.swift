//
//  MainGeneticCircuitMutationFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/02/2019.
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

class MainGeneticCircuitMutationFactoryTests: XCTestCase {

    // MARK: - Properties

    let randomizeractory = GeneticGatesRandomizerFactoryTestDouble()
    let randomizer = GeneticGatesRandomizerTestDouble()

    // MARK: - Tests

    func testRandomizerFactoryThatReturnRamdomizer_makeMuration_returnMutation() {
        // Given
        randomizeractory.makeRandomizerResult = randomizer

        let factory = MainGeneticCircuitMutationFactory(factory: randomizeractory)

        // Then
        XCTAssertNotNil(factory.makeMutation(qubitCount: 0, maxDepth: 0, gates: []))
    }

    static var allTests = [
        ("testRandomizerFactoryThatReturnRamdomizer_makeMuration_returnMutation",
         testRandomizerFactoryThatReturnRamdomizer_makeMuration_returnMutation)
    ]
}
