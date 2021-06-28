//
//  Complex+VectorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/06/2021.
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
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Complex_VectorTests: XCTestCase {

    // MARK: - Tests

    func testVectorWithMoreThanOnePosition_init_throwException() {
        // Given
        let vector = try! Vector([.zero, .zero])

        // Then
        XCTAssertThrowsError(try Complex(vector))
    }

    func testVectorWithOnePosition_init_returnExpectedComplexNumber() {
        // Given
        let expectedValue = Complex<Double>(10, 10)
        let vector = try! Vector([expectedValue])

        // Then
        XCTAssertEqual(try? Complex(vector), expectedValue)
    }

    static var allTests = [
        ("testVectorWithMoreThanOnePosition_init_throwException",
         testVectorWithMoreThanOnePosition_init_throwException),
        ("testVectorWithOnePosition_init_returnExpectedComplexNumber",
         testVectorWithOnePosition_init_returnExpectedComplexNumber)
    ]
}
