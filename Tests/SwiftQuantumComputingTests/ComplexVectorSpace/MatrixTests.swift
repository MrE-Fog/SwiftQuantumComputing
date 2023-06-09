//
//  MatrixTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 29/07/2018.
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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class MatrixTests: XCTestCase {

    // MARK: - Tests

    func testEmptyArray_init_throwException() {
        // Then
        XCTAssertThrowsError(try Matrix([]))
    }

    func testEmptyRow_init_throwException() {
        // Then
        XCTAssertThrowsError(try Matrix([[]]))
    }

    func testRowsWithDifferentColumnCount_init_throwException() {
        // Given
        let complex = Complex<Double>.zero
        let elements: [[Complex<Double>]] = [[complex], [complex, complex]]

        // Then
        XCTAssertThrowsError(try Matrix(elements))
    }

    func testRowsWithSameColumnCount_init_returnMatrixWithExpectedNumberOfRowsAndColumns() {
        // Given
        let complex = Complex<Double>.zero
        let elements: [[Complex<Double>]] = [[complex], [complex]]

        // When
        let matrix = try? Matrix(elements)

        // Then
        XCTAssertEqual(matrix?.rowCount, 2)
        XCTAssertEqual(matrix?.columnCount, 1)
    }

    func testAnyMatrix_first_returnExpectedValue() {
        // Given
        let expectedValue = Complex<Double>(10, 10)
        let elements: [[Complex<Double>]] = [
            [expectedValue, .zero, .zero],
            [.zero, .zero, .zero],
            [.zero, .zero, .zero]
        ]
        let matrix = try! Matrix(elements)

        // Then
        XCTAssertEqual(matrix.first, expectedValue)
    }

    func testAnyMatrix_subscript_returnExpectedValue() {
        // Given
        let expectedValue = Complex<Double>(10, 10)
        let elements: [[Complex<Double>]] = [
            [.zero, .zero],
            [.zero, expectedValue],
            [.zero, .zero],
            [.zero, .zero]
        ]
        let matrix = try! Matrix(elements)

        // Then
        XCTAssertEqual(matrix[1,1], expectedValue)
    }

    func testAnySlice_subscript_returnExpectedValue() {
        // Given
        let expectedValue = Complex<Double>(10, 10)
        let elements: [[Complex<Double>]] = [
            [.zero, .zero, .zero, .zero],
            [.zero, .zero, expectedValue, .zero],
            [.zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero]
        ]
        let matrix = try! Matrix(elements)
        let slice = try! matrix.makeSlice(startColumn: 1, columnCount: 2).get()

        // Then
        XCTAssertEqual(slice[1,1], expectedValue)
    }

    func testAnyMatrix_loop_returnExpectedSequence() {
        // Given
        let elements: [[Complex<Double>]] = [
            [.one, .zero, Complex(2)],
            [.one, .zero, Complex(2)],
            [.one, .zero, Complex(2)]
        ]
        let matrix = try! Matrix(elements)

        // When
        let sequence = matrix.map { $0 }

        // Then
        let expectedSequence: [Complex<Double>] = [
            .one, .one, .one, .zero, .zero, .zero, Complex(2), Complex(2), Complex(2)
        ]
        XCTAssertEqual(sequence, expectedSequence)
    }

    func testMatricesWithDifferentNumberOfRows_isApproximatelyEqual_returnFalse() {
        // Given
        let m1 = try! Matrix([[.one], [.one]])
        let m2 = try! Matrix([[.one], [.one], [.one]])

        // Then
        XCTAssertFalse(m1.isApproximatelyEqual(to: m2,
                                               absoluteTolerance: SharedConstants.tolerance))
    }

    func testMatricesWithDifferentNumberOfColumns_isApproximatelyEqual_returnFalse() {
        // Given
        let m1 = try! Matrix([[.one, .one]])
        let m2 = try! Matrix([[.one, .one, .one]])

        // Then
        XCTAssertFalse(m1.isApproximatelyEqual(to: m2,
                                               absoluteTolerance: SharedConstants.tolerance))
    }

    func testAnyMatrixAndAccuracyZero_isApproximatelyEqual_returnTrue() {
        // Given
        let matrix = try! Matrix([[.one], [.one]])

        // Then
        XCTAssertTrue(matrix.isApproximatelyEqual(to: matrix, absoluteTolerance: 0))
    }

    func testMatricesWithValusAroundAccuracy_isApproximatelyEqual_returnTrue() {
        let accuracy = 0.0001
        let m1 = try! Matrix([
            [Complex(1 + accuracy), Complex(accuracy, -1)]
        ])
        let m2 = try! Matrix([[Complex(1, accuracy), Complex(2 * accuracy, -1 - accuracy)]])

        // Then
        XCTAssertTrue(m1.isApproximatelyEqual(to: m2, absoluteTolerance: accuracy))
    }

    func testMatricesWithOneValueFartherThanAccuracy_isApproximatelyEqual_returnFalse() {
        let accuracy = SharedConstants.tolerance
        let m1 = try! Matrix([[.one, Complex(accuracy, -accuracy)]])
        let m2 = try! Matrix([[.one, Complex(accuracy, accuracy)]])

        // Then
        XCTAssertFalse(m1.isApproximatelyEqual(to: m2, absoluteTolerance: accuracy))
    }

    func testNonSquareMatrix_isApproximatelyUnitary_returnFalse() {
        // Given
        let matrix = try! Matrix([[.one], [.one]])

        // Then
        XCTAssertFalse(matrix.isApproximatelyUnitary(absoluteTolerance: SharedConstants.tolerance))
    }

    func testSquareNonUnitaryMatrix_isApproximatelyUnitary_returnFalse() {
        // Given
        let matrix = try! Matrix([[.one, .one, .one],
                                  [.one, .one, .one],
                                  [.one, .one, .one]])

        // Then
        XCTAssertFalse(matrix.isApproximatelyUnitary(absoluteTolerance: SharedConstants.tolerance))
    }

    func testUnitaryMatrix_isApproximatelyUnitary_returnTrue() {
        // Given
        let elements: [[Complex<Double>]] = [
            [Complex(1.0 / 2.0, 1.0 / 2.0),
             Complex(imaginary: 1.0 / sqrt(3)),
             Complex(3.0 / (2.0 * sqrt(15)), 1.0 / (2.0 * sqrt(15)))],
            [Complex(-1.0 / 2.0),
             Complex(1.0 / sqrt(3)),
             Complex(4.0 / (2.0 * sqrt(15)), 3.0 / (2.0 * sqrt(15)))],
            [Complex(1.0 / 2.0),
             Complex(imaginary: -1.0 / sqrt(3)),
             Complex(imaginary: 5.0 / (2.0 * sqrt(15)))]
        ]
        let matrix = try! Matrix(elements)

        // Then
        XCTAssertTrue(matrix.isApproximatelyUnitary(absoluteTolerance: SharedConstants.tolerance))
    }

    func testNegativeStartColumn_makeSlice_throwException() {
        // Then
        var error: Matrix.MakeSliceError?
        if case .failure(let e) = Matrix.makeNot().makeSlice(startColumn: -1, columnCount: 1) {
            error = e
        }
        XCTAssertEqual(error, .startColumnOutOfRange)
    }

    func testStartColumEqualToColumnCount_makeSlice_throwException() {
        // Then
        var error: Matrix.MakeSliceError?
        if case .failure(let e) = Matrix.makeNot().makeSlice(startColumn: 10, columnCount: 1) {
            error = e
        }
        XCTAssertEqual(error, .startColumnOutOfRange)
    }

    func testZeroColumnCount_makeSlice_throwException() {
        // Then
        var error: Matrix.MakeSliceError?
        if case .failure(let e) = Matrix.makeNot().makeSlice(startColumn: 0, columnCount: 0) {
            error = e
        }
        XCTAssertEqual(error, .columnCountOutOfRange)
    }

    func testColumnCountOutOfRange_makeSlice_throwException() {
        // Then
        var error: Matrix.MakeSliceError?
        if case .failure(let e) = Matrix.makeNot().makeSlice(startColumn: 1, columnCount: 2) {
            error = e
        }
        XCTAssertEqual(error, .columnCountOutOfRange)
    }

    func testAllColumnsInAMatrix_makeSlice_returnSameMatrix() {
        // Given
        let matrix = Matrix.makeControlledNot()

        // When
        let otherMatrix = try! matrix.makeSlice(startColumn: 0,
                                                columnCount: matrix.columnCount).get()

        // Then
        XCTAssertTrue(matrix.isApproximatelyEqual(to: otherMatrix,
                                                  absoluteTolerance: SharedConstants.tolerance))
    }

    func testTwoColumnsInAMatrix_makeSlice_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]])

        // When
        let otherMatrix = try! matrix.makeSlice(startColumn: 1, columnCount: 2).get()

        // Then
        let expectedMatrix = try! Matrix([[2, 3], [6, 7], [10, 11]])

        XCTAssertTrue(otherMatrix.isApproximatelyEqual(to: expectedMatrix,
                                                       absoluteTolerance: SharedConstants.tolerance))
    }

    func testMatrixAlreadySliced_makeSlice_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([[1, 2, 3, 4, 5], [6, 7, 8, 9, 10],  [11, 12, 13, 14, 15]])
        let firstSlice = try! matrix.makeSlice(startColumn: 1, columnCount: 3).get()

        // When
        let otherMatrix = try! firstSlice.makeSlice(startColumn: 1, columnCount: 1).get()

        // Then
        let expectedMatrix = try! Matrix([[3], [8], [13]])

        XCTAssertTrue(otherMatrix.isApproximatelyEqual(to: expectedMatrix,
                                                       absoluteTolerance: SharedConstants.tolerance))
    }

    func testNonHermitianMatrix_eigenvalues_throwException() {
        // Given
        let matrix = try! Matrix([
            [.one, .zero, .zero],
            [.one, Complex(2), .zero],
            [Complex(2), Complex(3), Complex(3)]
        ])

        // Then
        var error: Matrix.EigenvaluesError?
        if case .failure(let e) = matrix.eigenvalues() {
            error = e
        }
        XCTAssertEqual(error, .matrixIsNotHermitian)
    }

    func testAnyHermitianMatrices_eigenvalues_returnExpectedValues() {
        // Given
        let matrices: [(Matrix, [Double])] = [
            (try! Matrix([[Complex(2), .one],
                          [.one, Complex(2)]]),
             [1.0, 3.0]),
            (try! Matrix([[Complex(2), -.one],
                          [-.one, Complex(2)]]),
             [1.0, 3.0]),
            (try! Complex(1.0 / 3.0) * Matrix([[Complex(2), -.one],
                                               [-.one, .one]]),
             [0.5 - sqrt(5) / 6.0, 0.5 + sqrt(5) / 6.0]),
            (try! Matrix([[Complex(1), .zero, .zero],
                          [.zero, Complex(2), .zero],
                          [.zero, .zero, Complex(3)]]),
             [1.0, 2.0, 3.0]),
            (try! Matrix([[Complex(2), .zero, .zero],
                          [.zero, Complex(3), Complex(4)],
                          [.zero, Complex(4), Complex(9)]]),
             [1.0, 2.0, 11.0]),
            (try! Matrix([[Complex(2), .i, .zero],
                          [-.i, Complex(2), .zero],
                          [.zero, .zero, Complex(3)]]),
             [1.0, 3.0, 3.0]),
            (try! Matrix([[-.one, .zero, -2 * .i],
                          [.zero, Complex(2), .zero],
                          [2 * .i, .zero, -.one]]),
             [-3.0, 1.0, 2.0])
        ]

        for (matrix, expectedValues) in matrices {
            // When
            let values = try? matrix.eigenvalues().get()

            // Then
            XCTAssertEqual(values, expectedValues)
        }
    }

    func testAnyHermitianMatrices_eigenvalues_returnAlmostExpectedValues() {
        // Given
        let matrices: [(Matrix, [Double])] = [
            (try! Matrix([[.one, -.one, .zero],
                          [-.one, Complex(2), -.one],
                          [.zero, -.one, .one]]),
             [0.0, 1.0, 3.0])
        ]

        for (matrix, expectedValues) in matrices {
            // When
            let values = try! matrix.eigenvalues().get()

            // Then
            for (val, expectedVal) in zip(values, expectedValues) {
                XCTAssertEqual(val, expectedVal, accuracy: SharedConstants.tolerance)
            }
        }
    }

    func testHermitianSlice_eigenvalues_returnExpectedValues() {
        // Given
        let matrix = try! Matrix([[.i, -.one, .zero, -2 * .i, .i],
                                  [.i, .zero, Complex(2), .zero, .i],
                                  [.i, 2 * .i, .zero, -.one, .i]])
        let slice = try! matrix.makeSlice(startColumn: 1, columnCount: 3).get()

        // When
        let values = try? slice.eigenvalues().get()

        // Then
        let expectedValues = [-3.0, 1.0, 2.0]
        XCTAssertEqual(values, expectedValues)
    }

    func testZeroRowCount_makeMatrix_throwException() {
        // Then
        var error: Matrix.MakeMatrixError?
        if case .failure(let e) = Matrix.makeMatrix(rowCount: 0,
                                                    columnCount: 1,
                                                    value: { _,_ in .zero }) {
            error = e
        }
        XCTAssertEqual(error, .passRowCountBiggerThanZero)
    }

    func testZeroColumnCount_makeMatrix_throwException() {
        // Then
        var error: Matrix.MakeMatrixError?
        if case .failure(let e) = Matrix.makeMatrix(rowCount: 1,
                                                    columnCount: 0,
                                                    value: { _,_ in .zero }) {
            error = e
        }
        XCTAssertEqual(error, .passColumnCountBiggerThanZero)
    }

    func testZeroMaxConcurrency_makeMatrix_throwException() {
        // Then
        var error: Matrix.MakeMatrixError?
        if case .failure(let e) = Matrix.makeMatrix(rowCount: 1,
                                                    columnCount: 1,
                                                    maxConcurrency: 0,
                                                    value: { _,_ in .zero }) {
            error = e
        }
        XCTAssertEqual(error, .passMaxConcurrencyBiggerThanZero)
    }

    func testOneRowOneColumn_makeMatrix_returnExpectedMatrix() {
        // When
        let matrix = try? Matrix.makeMatrix(rowCount: 1,
                                            columnCount: 1,
                                            value: { _,_ in .one }).get()

        // Then
        let expectedMatrix = try? Matrix([[.one]])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testAnyRowsAndColumns_makeMatrix_returnExpectedMatrix() {
        // When
        let matrix = try? Matrix.makeMatrix(rowCount: 2, columnCount: 3, value: { r, c -> Complex<Double> in
            return Complex(Double(r), Double(c))
        }).get()

        // Then
        let expectedMatrix = try? Matrix([
            [.zero, .i, Complex(imaginary: 2)],
            [.one, Complex(1, 1), Complex(1, 2)]
        ])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testEvenNumberOfElementsAndEvenMaxConcurrency_makeMatrix_returnExpectedMatrix() {
        // When
        let matrix = try? Matrix.makeMatrix(rowCount: 2,
                                            columnCount: 3,
                                            maxConcurrency: 2,
                                            value: { r, c -> Complex<Double> in
                                                return Complex(Double(r), Double(c))
        }).get()

        // Then
        let expectedMatrix = try? Matrix([
            [.zero, .i, Complex(imaginary: 2)],
            [.one, Complex(1, 1), Complex(1, 2)]
        ])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testEvenNumberOfElementsAndOddMaxConcurrency_makeMatrix_returnExpectedMatrix() {
        // When
        let matrix = try? Matrix.makeMatrix(rowCount: 2,
                                            columnCount: 3,
                                            maxConcurrency: 3,
                                            value: { r, c -> Complex<Double> in
                                                return Complex(Double(r), Double(c))
        }).get()

        // Then
        let expectedMatrix = try? Matrix([
            [.zero, .i, Complex(imaginary: 2)],
            [.one, Complex(1, 1), Complex(1, 2)]
        ])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testAnyRowsAndColumnsAndMaxConcurrencyBiggerThanNumberOfElements_makeMatrix_returnExpectedMatrix() {
        // When
        let matrix = try? Matrix.makeMatrix(rowCount: 2,
                                            columnCount: 3,
                                            maxConcurrency: 100,
                                            value: { r, c -> Complex<Double> in
                                                return Complex(Double(r), Double(c))
        }).get()

        // Then
        let expectedMatrix = try? Matrix([
            [.zero, .i, Complex(imaginary: 2)],
            [.one, Complex(1, 1), Complex(1, 2)]
        ])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testZeroRowCount_makeMatrixByRow_throwException() {
        // Then
        var error: Matrix.MakeMatrixError?
        if case .failure(let e) = Matrix.makeMatrix(rowCount: 0,
                                                    columnCount: 1,
                                                    rowValues: { _ in try! Vector([.zero])},
                                                    customValue: { _, _, _ in .zero}) {
            error = e
        }
        XCTAssertEqual(error, .passRowCountBiggerThanZero)
    }

    func testZeroColumnCount_makeMatrixByRow_throwException() {
        // Then
        var error: Matrix.MakeMatrixError?
        if case .failure(let e) = Matrix.makeMatrix(rowCount: 1,
                                                    columnCount: 0,
                                                    rowValues: { _ in try! Vector([.zero])},
                                                    customValue: { _, _, _ in .zero}) {
            error = e
        }
        XCTAssertEqual(error, .passColumnCountBiggerThanZero)
    }

    func testZeroMaxConcurrency_makeMatrixByRow_throwException() {
        // Then
        var error: Matrix.MakeMatrixError?
        if case .failure(let e) = Matrix.makeMatrix(rowCount: 1,
                                                    columnCount: 1,
                                                    maxConcurrency: 0,
                                                    rowValues: { _ in try! Vector([.zero])},
                                                    customValue: { _, _, _ in .zero}) {
            error = e
        }
        XCTAssertEqual(error, .passMaxConcurrencyBiggerThanZero)
    }

    func testOneRowOneColumn_makeMatrixByRow_returnExpectedMatrix() {
        // When
        let matrix = try? Matrix.makeMatrix(rowCount: 1,
                                            columnCount: 1,
                                            rowValues: { _ in try! Vector([.one])},
                                            customValue: { _, _, _ in .one}).get()

        // Then
        let expectedMatrix = try? Matrix([[.one]])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testAnyRowsAndColumns_makeMatrixByRow_returnExpectedMatrix() {
        // When
        let columnCount = 3
        let matrix = try? Matrix.makeMatrix(rowCount: 2,
                                            columnCount: columnCount,
                                            rowValues: { r -> Vector in
                                                let row = Array(repeating: Complex(Double(r)),
                                                                count: columnCount)
                                                return try! Vector(row)
                                            },
                                            customValue: { _, c, row -> Complex<Double> in
                                                return row[c] + Complex(imaginary: Double(c))
                                            }).get()

        // Then
        let expectedMatrix = try? Matrix([
            [.zero, .i, Complex(imaginary: 2)],
            [.one, Complex(1, 1), Complex(1, 2)]
        ])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testEvenNumberOfElementsAndEvenMaxConcurrency_makeMatrixByRow_returnExpectedMatrix() {
        // When
        let columnCount = 3
        let matrix = try? Matrix.makeMatrix(rowCount: 2,
                                            columnCount: columnCount,
                                            maxConcurrency: 2,
                                            rowValues: { r -> Vector in
                                                let row = Array(repeating: Complex(Double(r)),
                                                                count: columnCount)
                                                return try! Vector(row)
                                            },
                                            customValue: { _, c, row -> Complex<Double> in
                                                return row[c] + Complex(imaginary: Double(c))
                                            }).get()

        // Then
        let expectedMatrix = try? Matrix([
            [.zero, .i, Complex(imaginary: 2)],
            [.one, Complex(1, 1), Complex(1, 2)]
        ])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testEvenNumberOfElementsAndOddMaxConcurrency_makeMatrixByRow_returnExpectedMatrix() {
        // When
        let columnCount = 3
        let matrix = try? Matrix.makeMatrix(rowCount: 2,
                                            columnCount: columnCount,
                                            maxConcurrency: 3,
                                            rowValues: { r -> Vector in
                                                let row = Array(repeating: Complex(Double(r)),
                                                                count: columnCount)
                                                return try! Vector(row)
                                            },
                                            customValue: { _, c, row -> Complex<Double> in
                                                return row[c] + Complex(imaginary: Double(c))
                                            }).get()

        // Then
        let expectedMatrix = try? Matrix([
            [.zero, .i, Complex(imaginary: 2)],
            [.one, Complex(1, 1), Complex(1, 2)]
        ])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testAnyRowsAndColumnsAndMaxConcurrencyBiggerThanNumberOfElements_makeMatrixByRow_returnExpectedMatrix() {
        // When
        let columnCount = 3
        let matrix = try? Matrix.makeMatrix(rowCount: 2,
                                            columnCount: columnCount,
                                            maxConcurrency: 100,
                                            rowValues: { r -> Vector in
                                                let row = Array(repeating: Complex(Double(r)),
                                                                count: columnCount)
                                                return try! Vector(row)
                                            },
                                            customValue: { _, c, row -> Complex<Double> in
                                                return row[c] + Complex(imaginary: Double(c))
                                            }).get()

        // Then
        let expectedMatrix = try? Matrix([
            [.zero, .i, Complex(imaginary: 2)],
            [.one, Complex(1, 1), Complex(1, 2)]
        ])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testMatricesWithDifferentRowCount_add_throwException() {
        // Given
        let lhs = try! Matrix([[.zero, .zero]])
        let rhs = try! Matrix([[.zero, .zero], [.zero, .zero]])

        // Then
        var error: Matrix.AddError?
        if case .failure(let e) = lhs + rhs {
            error = e
        }
        XCTAssertEqual(error, .matricesDoNotHaveSameRowCount)
    }

    func testMatricesWithDifferentColumnCount_add_throwException() {
        // Given
        let lhs = try! Matrix([[.zero], [.zero]])
        let rhs = try! Matrix([[.zero, .zero], [.zero, .zero]])

        // Then
        var error: Matrix.AddError?
        if case .failure(let e) = lhs + rhs {
            error = e
        }
        XCTAssertEqual(error, .matricesDoNotHaveSameColumnCount)
    }

    func testMatricesWithSameSize_add_returnExpectedMatrix() {
        // Given
        let lhs = try! Matrix([[.zero, .one, .zero],
                               [.one, .zero, .one],
                               [.one, .one, .one]])
        let rhs = try! Matrix([[.one, .zero, .one],
                               [.zero, .one, .zero],
                               [.one, .one, .one]])

        // When
        let result = try? (lhs + rhs).get()

        // Then
        let expectedResult = try! Matrix([[.one, .one, .one],
                                          [.one, .one, .one],
                                          [Complex(2), Complex(2), Complex(2)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testOneComplexNumberAndOneMatrix_multiply_returnExpectedMatrix() {
        // Given
        let complex = Complex<Double>(3, 2)
        let row: [Complex<Double>] = [Complex(6, 3), .zero, Complex(5, 1), Complex(4)]
        let matrix = try! Matrix([row, row])

        // When
        let result = (complex * matrix)

        // Then
        let expectedRow: [Complex<Double>] = [
            Complex(12, 21), .zero, Complex(13, 13), Complex(12, 8)
        ]
        let expectedResult = try? Matrix([expectedRow, expectedRow])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithColumnCountDifferentThanRowCountInSecondMatrix_multiply_throwException() {
        // Given
        let complex = Complex<Double>.zero
        let lhs = try! Matrix([[complex, complex]])
        let rhs = try! Matrix([[complex], [complex], [complex]])

        // Then
        var error: Matrix.ProductError?
        if case .failure(let e) = lhs * rhs {
            error = e
        }
        XCTAssertEqual(error, .matricesDoNotHaveValidDimensions)
    }

    func testMatrixWithColumnCountEqualToRowCountInSecondMatrix_multiply_returnExpectedMatrix() {
        // Given
        let lhsElements: [[Complex<Double>]] = [
            [Complex(3, 2), .zero, Complex(5, -6)],
            [.one, Complex(4, 2), .i]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhs = try! Matrix([[Complex(5), Complex(2, -1)],
                               [.zero, Complex(4, 5)],
                               [Complex(7, -4), Complex(2, 7)]])

        // When
        let result = try? (lhs * rhs).get()

        // Then
        let expectedResult = try? Matrix([[Complex(26, -52), Complex(60, 24)],
                                          [Complex(9, 7), Complex(1, 29)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithRowCountDifferentThanRowCountInSecondMatrix_adjointedMultiply_throwException() {
        // Given
        let complex = Complex<Double>.zero
        let lhs = try! Matrix([[complex, complex, complex]])
        let rhs = try! Matrix([[complex], [complex], [complex]])

        // Then
        var error: Matrix.ProductError?
        if case .failure(let e) = Matrix.Transformation.adjointed(lhs) * rhs {
            error = e
        }
        XCTAssertEqual(error, .matricesDoNotHaveValidDimensions)
    }

    func testMatrixWithRowCountEqualToRowCountInSecondMatrix_adjointedMultiply_returnExpectedMatrix() {
        // Given
        let lhsElements: [[Complex<Double>]] = [
            [Complex(3, -2), .one],
            [.zero, Complex(4, -2)],
            [Complex(5,  6), Complex(imaginary: -1)]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhs = try! Matrix([[Complex(5), Complex(2, -1)],
                               [.zero, Complex(4, 5)],
                               [Complex(7, -4), Complex(2, 7)]])

        // When
        let result = try? (Matrix.Transformation.adjointed(lhs) * rhs).get()

        // Then
        let expectedResult = try? Matrix([[Complex(26, -52), Complex(60, 24)],
                                          [Complex(9, 7), Complex(1, 29)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithRowCountDifferentThanRowCountInSecondMatrix_transposedMultiply_throwException() {
        // Given
        let complex = Complex<Double>.zero
        let lhs = try! Matrix([[complex, complex, complex]])
        let rhs = try! Matrix([[complex], [complex], [complex]])

        // Then
        var error: Matrix.ProductError?
        if case .failure(let e) = Matrix.Transformation.transposed(lhs) * rhs {
            error = e
        }
        XCTAssertEqual(error, .matricesDoNotHaveValidDimensions)
    }

    func testMatrixWithRowCountEqualToRowCountInSecondMatrix_transposedMultiply_returnExpectedMatrix() {
        // Given
        let lhsElements: [[Complex<Double>]] = [
            [Complex(3, 2),  .one],
            [.zero, Complex(4, 2)],
            [Complex(5, -6), .i]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhs = try! Matrix([[Complex(5), Complex(2, -1)],
                               [.zero, Complex(4, 5)],
                               [Complex(7, -4), Complex(2, 7)]])

        // When
        let result = try? (Matrix.Transformation.transposed(lhs) * rhs).get()

        // Then
        let expectedResult = try? Matrix([[Complex(26, -52), Complex(60, 24)],
                                          [Complex(9, 7), Complex(1, 29)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithRowCountDifferentThanRowCountInFirstMatrix_adjointedMultiply_throwException() {
        // Given
        let complex = Complex<Double>.zero
        let lhs = try! Matrix([[complex], [complex], [complex]])
        let rhs = try! Matrix([[complex, complex, complex]])

        // Then
        var error: Matrix.ProductError?
        if case .failure(let e) = lhs * Matrix.Transformation.adjointed(rhs) {
            error = e
        }
        XCTAssertEqual(error, .matricesDoNotHaveValidDimensions)
    }

    func testMatrixWithRowCountEqualToRowCountInFirstMatrix_adjointedMultiply_returnExpectedMatrix() {
        // Given
        let lhsElements: [[Complex<Double>]] = [
            [Complex(3, 2), .zero, Complex(5, -6)],
            [.one, Complex(4, 2), .i]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhsElements: [[Complex<Double>]] = [
            [Complex(5), .zero, Complex(7, 4)],
            [Complex(2, 1), Complex(4, -5), Complex(2, -7)]
        ]
        let rhs = try! Matrix(rhsElements)

        // When
        let result = try? (lhs * Matrix.Transformation.adjointed(rhs)).get()

        // Then
        let expectedResult = try? Matrix([[Complex(26, -52), Complex(60, 24)],
                                          [Complex(9, 7), Complex(1, 29)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithRowCountDifferentThanRowCountInFirstMatrix_transposedMultiply_throwException() {
        // Given
        let complex = Complex<Double>.zero
        let lhs = try! Matrix([[complex], [complex], [complex]])
        let rhs = try! Matrix([[complex, complex, complex]])

        // Then
        var error: Matrix.ProductError?
        if case .failure(let e) = lhs * Matrix.Transformation.transposed(rhs) {
            error = e
        }
        XCTAssertEqual(error, .matricesDoNotHaveValidDimensions)
    }

    func testMatrixWithRowCountEqualToRowCountInFirstMatrix_transposedMultiply_returnExpectedMatrix() {
        // Given
        let lhsElements: [[Complex<Double>]] = [
            [Complex(3, 2), .zero, Complex(5, -6)],
            [.one, Complex(4, 2), .i]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhsElements: [[Complex<Double>]] = [
            [Complex(5), .zero, Complex(7, -4)],
            [Complex(2, -1), Complex(4, 5), Complex(2, 7)]
        ]
        let rhs = try! Matrix(rhsElements)

        // When
        let result = try? (lhs * Matrix.Transformation.transposed(rhs)).get()

        // Then
        let expectedResult = try? Matrix([[Complex(26, -52), Complex(60, 24)],
                                          [Complex(9, 7), Complex(1, 29)]])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testEmptyArray_init_throwException",
         testEmptyArray_init_throwException),
        ("testEmptyRow_init_throwException",
         testEmptyRow_init_throwException),
        ("testRowsWithDifferentColumnCount_init_throwException",
         testRowsWithDifferentColumnCount_init_throwException),
        ("testRowsWithSameColumnCount_init_returnMatrixWithExpectedNumberOfRowsAndColumns",
         testRowsWithSameColumnCount_init_returnMatrixWithExpectedNumberOfRowsAndColumns),
        ("testAnyMatrix_first_returnExpectedValue",
         testAnyMatrix_first_returnExpectedValue),
        ("testAnyMatrix_subscript_returnExpectedValue",
         testAnyMatrix_subscript_returnExpectedValue),
        ("testAnySlice_subscript_returnExpectedValue",
         testAnySlice_subscript_returnExpectedValue),
        ("testMatricesWithDifferentNumberOfRows_isApproximatelyEqual_returnFalse",
         testMatricesWithDifferentNumberOfRows_isApproximatelyEqual_returnFalse),
        ("testMatricesWithDifferentNumberOfColumns_isApproximatelyEqual_returnFalse",
         testMatricesWithDifferentNumberOfColumns_isApproximatelyEqual_returnFalse),
        ("testAnyMatrixAndAccuracyZero_isApproximatelyEqual_returnTrue",
         testAnyMatrixAndAccuracyZero_isApproximatelyEqual_returnTrue),
        ("testMatricesWithValusAroundAccuracy_isApproximatelyEqual_returnTrue",
         testMatricesWithValusAroundAccuracy_isApproximatelyEqual_returnTrue),
        ("testMatricesWithOneValueFartherThanAccuracy_isApproximatelyEqual_returnFalse",
         testMatricesWithOneValueFartherThanAccuracy_isApproximatelyEqual_returnFalse),
        ("testNonSquareMatrix_isApproximatelyUnitary_returnFalse",
         testNonSquareMatrix_isApproximatelyUnitary_returnFalse),
        ("testSquareNonUnitaryMatrix_isApproximatelyUnitary_returnFalse",
         testSquareNonUnitaryMatrix_isApproximatelyUnitary_returnFalse),
        ("testUnitaryMatrix_isApproximatelyUnitary_returnTrue",
         testUnitaryMatrix_isApproximatelyUnitary_returnTrue),
        ("testNegativeStartColumn_makeSlice_throwException",
         testNegativeStartColumn_makeSlice_throwException),
        ("testStartColumEqualToColumnCount_makeSlice_throwException",
         testStartColumEqualToColumnCount_makeSlice_throwException),
        ("testZeroColumnCount_makeSlice_throwException",
         testZeroColumnCount_makeSlice_throwException),
        ("testColumnCountOutOfRange_makeSlice_throwException",
         testColumnCountOutOfRange_makeSlice_throwException),
        ("testAllColumnsInAMatrix_makeSlice_returnSameMatrix",
         testAllColumnsInAMatrix_makeSlice_returnSameMatrix),
        ("testTwoColumnsInAMatrix_makeSlice_returnExpectedMatrix",
         testTwoColumnsInAMatrix_makeSlice_returnExpectedMatrix),
        ("testMatrixAlreadySliced_makeSlice_returnExpectedMatrix",
         testMatrixAlreadySliced_makeSlice_returnExpectedMatrix),
        ("testNonHermitianMatrix_eigenvalues_throwException",
         testNonHermitianMatrix_eigenvalues_throwException),
        ("testAnyHermitianMatrices_eigenvalues_returnExpectedValues",
         testAnyHermitianMatrices_eigenvalues_returnExpectedValues),
        ("testAnyHermitianMatrices_eigenvalues_returnAlmostExpectedValues",
         testAnyHermitianMatrices_eigenvalues_returnAlmostExpectedValues),
        ("testHermitianSlice_eigenvalues_returnExpectedValues",
         testHermitianSlice_eigenvalues_returnExpectedValues),
        ("testZeroRowCount_makeMatrix_throwException",
         testZeroRowCount_makeMatrix_throwException),
        ("testZeroColumnCount_makeMatrix_throwException",
         testZeroColumnCount_makeMatrix_throwException),
        ("testZeroMaxConcurrency_makeMatrix_throwException",
         testZeroMaxConcurrency_makeMatrix_throwException),
        ("testOneRowOneColumn_makeMatrix_returnExpectedMatrix",
         testOneRowOneColumn_makeMatrix_returnExpectedMatrix),
        ("testAnyRowsAndColumns_makeMatrix_returnExpectedMatrix",
         testAnyRowsAndColumns_makeMatrix_returnExpectedMatrix),
        ("testEvenNumberOfElementsAndEvenMaxConcurrency_makeMatrix_returnExpectedMatrix",
         testEvenNumberOfElementsAndEvenMaxConcurrency_makeMatrix_returnExpectedMatrix),
        ("testEvenNumberOfElementsAndOddMaxConcurrency_makeMatrix_returnExpectedMatrix",
         testEvenNumberOfElementsAndOddMaxConcurrency_makeMatrix_returnExpectedMatrix),
        ("testAnyRowsAndColumnsAndMaxConcurrencyBiggerThanNumberOfElements_makeMatrix_returnExpectedMatrix",
         testAnyRowsAndColumnsAndMaxConcurrencyBiggerThanNumberOfElements_makeMatrix_returnExpectedMatrix),
        ("testZeroRowCount_makeMatrixByRow_throwException",
         testZeroRowCount_makeMatrixByRow_throwException),
        ("testZeroColumnCount_makeMatrixByRow_throwException",
         testZeroColumnCount_makeMatrixByRow_throwException),
        ("testZeroMaxConcurrency_makeMatrixByRow_throwException",
         testZeroMaxConcurrency_makeMatrixByRow_throwException),
        ("testOneRowOneColumn_makeMatrixByRow_returnExpectedMatrix",
         testOneRowOneColumn_makeMatrixByRow_returnExpectedMatrix),
        ("testAnyRowsAndColumns_makeMatrixByRow_returnExpectedMatrix",
         testAnyRowsAndColumns_makeMatrixByRow_returnExpectedMatrix),
        ("testEvenNumberOfElementsAndEvenMaxConcurrency_makeMatrixByRow_returnExpectedMatrix",
         testEvenNumberOfElementsAndEvenMaxConcurrency_makeMatrixByRow_returnExpectedMatrix),
        ("testEvenNumberOfElementsAndOddMaxConcurrency_makeMatrixByRow_returnExpectedMatrix",
         testEvenNumberOfElementsAndOddMaxConcurrency_makeMatrixByRow_returnExpectedMatrix),
        ("testAnyRowsAndColumnsAndMaxConcurrencyBiggerThanNumberOfElements_makeMatrixByRow_returnExpectedMatrix",
         testAnyRowsAndColumnsAndMaxConcurrencyBiggerThanNumberOfElements_makeMatrixByRow_returnExpectedMatrix),
        ("testMatricesWithDifferentRowCount_add_throwException",
         testMatricesWithDifferentRowCount_add_throwException),
        ("testMatricesWithDifferentColumnCount_add_throwException",
         testMatricesWithDifferentColumnCount_add_throwException),
        ("testMatricesWithSameSize_add_returnExpectedMatrix",
         testMatricesWithSameSize_add_returnExpectedMatrix),
        ("testOneComplexNumberAndOneMatrix_multiply_returnExpectedMatrix",
         testOneComplexNumberAndOneMatrix_multiply_returnExpectedMatrix),
        ("testMatrixWithColumnCountDifferentThanRowCountInSecondMatrix_multiply_throwException",
         testMatrixWithColumnCountDifferentThanRowCountInSecondMatrix_multiply_throwException),
        ("testMatrixWithColumnCountEqualToRowCountInSecondMatrix_multiply_returnExpectedMatrix",
         testMatrixWithColumnCountEqualToRowCountInSecondMatrix_multiply_returnExpectedMatrix),
        ("testMatrixWithRowCountDifferentThanRowCountInSecondMatrix_adjointedMultiply_throwException",
         testMatrixWithRowCountDifferentThanRowCountInSecondMatrix_adjointedMultiply_throwException),
        ("testMatrixWithRowCountEqualToRowCountInSecondMatrix_adjointedMultiply_returnExpectedMatrix",
         testMatrixWithRowCountEqualToRowCountInSecondMatrix_adjointedMultiply_returnExpectedMatrix),
        ("testMatrixWithRowCountDifferentThanRowCountInSecondMatrix_transposedMultiply_throwException",
         testMatrixWithRowCountDifferentThanRowCountInSecondMatrix_transposedMultiply_throwException),
        ("testMatrixWithRowCountEqualToRowCountInSecondMatrix_transposedMultiply_returnExpectedMatrix",
         testMatrixWithRowCountEqualToRowCountInSecondMatrix_transposedMultiply_returnExpectedMatrix),
        ("testMatrixWithRowCountDifferentThanRowCountInFirstMatrix_adjointedMultiply_throwException",
         testMatrixWithRowCountDifferentThanRowCountInFirstMatrix_adjointedMultiply_throwException),
        ("testMatrixWithRowCountEqualToRowCountInFirstMatrix_adjointedMultiply_returnExpectedMatrix",
         testMatrixWithRowCountEqualToRowCountInFirstMatrix_adjointedMultiply_returnExpectedMatrix),
        ("testMatrixWithRowCountDifferentThanRowCountInFirstMatrix_transposedMultiply_throwException",
         testMatrixWithRowCountDifferentThanRowCountInFirstMatrix_transposedMultiply_throwException),
        ("testMatrixWithRowCountEqualToRowCountInFirstMatrix_transposedMultiply_returnExpectedMatrix",
         testMatrixWithRowCountEqualToRowCountInFirstMatrix_transposedMultiply_returnExpectedMatrix)
    ]
}
