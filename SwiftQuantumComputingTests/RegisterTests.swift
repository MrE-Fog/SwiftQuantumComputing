//
//  RegisterTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 10/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

class RegisterTests: XCTestCase {

    // MARK: - Tests

    func testVectorWhichSumOfSquareModulesIsNotOne_init_returnNil() {
        // Given
        let vector = Vector([Complex(real: 1, imag: 1), Complex(real: 2, imag: 2)])!

        // Then
        XCTAssertNil(Register(vector: vector))
    }

    func testVectorWhichSumOfSquareModulesIsOne_init_returnRegister() {
        // Given
        let vector = Vector([Complex(real: sqrt(1 / 2), imag: 0),
                             Complex(real: 0, imag: sqrt(1 / 2))])!

        // Then
        XCTAssertNotNil(Register(vector: vector))
    }

    func testQubitCountEqualToZero_init_returnNil() {
        // Then
        XCTAssertNil(Register(qubitCount:0))
    }

    func testQubitCountBiggerThanZero_init_returnNil() {
        // Then
        XCTAssertNotNil(Register(qubitCount: 1))
    }

    func testRegisterInitializedWithoutAVector_measurements_zeroHasProbabilityOne() {
        // Given
        let register = Register(qubitCount: 2)!

        // Then
        let expectedMeasurements = [Double(1), Double(0), Double(0), Double(0)]
        XCTAssertEqual(register.measurements, expectedMeasurements)
    }

    func testAnyRegisterAndGateWithDifferentSizeThanRegister_applying_returnNil() {
        // Given
        let register = Register(qubitCount: 2)!

        let matrix = Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])!
        let gate = Gate(matrix: matrix)!

        // Then
        XCTAssertNil(register.applying(gate))
    }

    func testAnyRegisterAndGateWithSameSizeThanRegister_applying_returnExpectedRegister() {
        // Given
        let register = Register(qubitCount: 1)!

        let matrix = Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])!
        let gate = Gate(matrix: matrix)!

        // When
        let result = register.applying(gate)

        // Then
        let expectedResult = Register(vector: Vector([Complex(0), Complex(1)])!)
        XCTAssertEqual(result, expectedResult)
    }
}
