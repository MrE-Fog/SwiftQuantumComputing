//
//  Vector.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 01/08/2018.
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

import Foundation

// MARK: - Main body

public struct Vector {

    // MARK: - Public properties

    public var count: Int {
        return matrix.rowCount
    }

    public subscript(index: Int) -> Complex {
        return matrix[index,0]
    }

    // MARK: - Internal properties

    var squaredNorm: Double {
        return try! Vector.innerProduct(self, self).real
    }

    // MARK: - Private properties

    private let matrix: Matrix

    // MARK: - Public init methods

    public enum InitError: Error {
        case doNotPassAnEmptyArray
    }

    public init(_ elements: [Complex]) throws {
        let rows = elements.map { [$0] }

        var matrix: Matrix!
        do {
            matrix = try Matrix(rows)
        } catch Matrix.InitError.doNotPassAnEmptyArray {
            throw InitError.doNotPassAnEmptyArray
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        self.init(matrix: matrix)
    }

    // MARK: - Private init methods

    private init(matrix: Matrix) {
        self.matrix = matrix
    }

    // MARK: - Internal class methods

    enum InnerProductError: Error {
        case vectorsDoNotHaveSameCount
    }

    static func innerProduct(_ lhs: Vector, _ rhs: Vector) throws -> Complex {
        var matrix: Matrix!
        do {
            matrix = try Matrix.Transformation.adjointed(lhs.matrix) * rhs.matrix
        } catch Matrix.ProductError.matricesDoNotHaveValidDimensions {
            throw InnerProductError.vectorsDoNotHaveSameCount
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        return try! Complex(matrix)
    }
}

// MARK: - CustomStringConvertible methods

extension Vector: CustomStringConvertible {
    public var description: String {
        return matrix.description
    }
}

// MARK: - Equatable methods

extension Vector: Equatable {
    public static func ==(lhs: Vector, rhs: Vector) -> Bool {
        return (lhs.matrix == rhs.matrix)
    }
}

// MARK: - Sequence methods

extension Vector: Sequence {
    public typealias Iterator = Array<Complex>.Iterator

    public func makeIterator() -> Vector.Iterator {
        return matrix.makeIterator()
    }
}

// MARK: - Overloaded operators

extension Vector {

    // MARK: - Internal types

    enum ProductError: Error {
        case matrixColumnCountDoesNotMatchVectorCount
    }

    // MARK: - Internal operators

    static func *(lhs: Matrix, rhs: Vector) throws -> Vector {
        var matrix: Matrix!
        do {
            matrix = try lhs * rhs.matrix
        } catch Matrix.ProductError.matricesDoNotHaveValidDimensions {
            throw ProductError.matrixColumnCountDoesNotMatchVectorCount
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        return Vector(matrix: matrix)
    }
}