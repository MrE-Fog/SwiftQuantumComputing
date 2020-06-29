//
//  Drawable+DrawCircuitTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/11/2019.
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

class Drawable_DrawCircuitTests: XCTestCase {

    // MARK: - Tests

    func testEmptyCircuit_drawCircuit_execMethodWithQubitCountSetToOne() {
        // Given
        let drawer = DrawableTestDouble()
        let circuit: [Gate] = []

        // When
        _ = drawer.drawCircuit(circuit)

        // Then
        XCTAssertEqual(drawer.drawCircuitCount, 1)
        XCTAssertEqual(drawer.lastDrawCircuitCircuit, circuit)
        XCTAssertEqual(drawer.lastDrawCircuitQubitCount, 1)
    }
}
