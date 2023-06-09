//
//  FixedControlledGate+SimulatorControlledMatrixAdapterFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/04/2021.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class FixedControlledGate_SimulatorControlledMatrixAdapterFactoryTests: XCTestCase {

    // MARK: - Properties

    let nonUnitaryMatrix = try! Matrix([
        [.zero, .one],
        [.one, .one]
    ])

    // MARK: - Tests

    func testEmptyControls_makeControlledMatrixAdapter_throwException() {
        // Given
        let sut = FixedControlledGate(gate: Gate.not(target: 0), controls: [])

        // Then
        var error: GateError?
        if case .failure(let e) = sut.makeControlledMatrixAdapter() {
            error = e
        }
        XCTAssertEqual(error, .gateControlsCanNotBeAnEmptyList)
    }

    func testControlledGateThatThrowsError_makeControlledMatrixAdapter_throwException() {
        // Given
        let sut = FixedControlledGate(gate: Gate.matrix(matrix: nonUnitaryMatrix, inputs: [0]),
                                      controls: [2])

        // Then
        var error: GateError?
        if case .failure(let e) = sut.makeControlledMatrixAdapter() {
            error = e
        }
        XCTAssertEqual(error, .gateMatrixIsNotUnitary)
    }

    func testAnyControlledGate_makeControlledMatrixAdapter_returnExpectedResult() {
        // Given
        let sut = FixedControlledGate(gate: Gate.not(target: 0), controls: [2, 4, 5])

        // When
        let result = try? sut.makeControlledMatrixAdapter().get()

        // Then
        XCTAssertEqual(result?.controlCount, 3)
        XCTAssertEqual(result?.truthTable, [try! TruthTableEntry(repeating: "1", count: 3)])
        XCTAssertEqual(try? result?.controlledMatrix.expandedRawMatrix(maxConcurrency: 1).get(),
                       Matrix.makeNot())
    }

    func testAnyControlledControlledGate_makeControlledMatrixAdapter_returnExpectedResult() {
        // Given
        let sut = FixedControlledGate(gate: Gate.controlled(gate: Gate.not(target: 0),
                                                            controls: [5, 3]),
                                      controls: [2, 4])

        // When
        let result = try? sut.makeControlledMatrixAdapter().get()

        // Then
        XCTAssertEqual(result?.controlCount, 4)
        XCTAssertEqual(result?.truthTable, [try! TruthTableEntry(repeating: "1", count: 4)])
        XCTAssertEqual(try? result?.controlledMatrix.expandedRawMatrix(maxConcurrency: 1).get(),
                       Matrix.makeNot())
    }

    func testControlledOracleGateWithEmptyTruthTable_makeControlledMatrixAdapter_returnExpectedResult() {
        // Given
        let sut = FixedControlledGate(gate: Gate.oracle(truthTable: [],
                                                        controls: [5, 3],
                                                        gate: Gate.not(target: 0)),
                                      controls: [2, 4])

        // When
        let result = try? sut.makeControlledMatrixAdapter().get()

        // Then
        XCTAssertEqual(result?.controlCount, 4)
        XCTAssertEqual(result?.truthTable, [])
        XCTAssertEqual(try? result?.controlledMatrix.expandedRawMatrix(maxConcurrency: 1).get(),
                       Matrix.makeNot())
    }

    static var allTests = [
        ("testEmptyControls_makeControlledMatrixAdapter_throwException",
         testEmptyControls_makeControlledMatrixAdapter_throwException),
        ("testControlledGateThatThrowsError_makeControlledMatrixAdapter_throwException",
         testControlledGateThatThrowsError_makeControlledMatrixAdapter_throwException),
        ("testAnyControlledGate_makeControlledMatrixAdapter_returnExpectedResult",
         testAnyControlledGate_makeControlledMatrixAdapter_returnExpectedResult),
        ("testAnyControlledControlledGate_makeControlledMatrixAdapter_returnExpectedResult",
         testAnyControlledControlledGate_makeControlledMatrixAdapter_returnExpectedResult),
        ("testControlledOracleGateWithEmptyTruthTable_makeControlledMatrixAdapter_returnExpectedResult",
         testControlledOracleGateWithEmptyTruthTable_makeControlledMatrixAdapter_returnExpectedResult)
    ]
}
