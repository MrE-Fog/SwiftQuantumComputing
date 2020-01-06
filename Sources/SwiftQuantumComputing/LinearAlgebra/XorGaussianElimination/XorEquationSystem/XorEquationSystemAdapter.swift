//
//  XorEquationSystemAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 29/12/2019.
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

// MARK: - Main body

struct XorEquationSystemAdapter {

    // MARK: - Private properties

    private let equations: [XorEquationSystemSolver.Equation]

    // MARK: - Internal init methods

    init(equations: [XorEquationSystemSolver.Equation]) {
        self.equations = equations
    }
}

// MARK: - XorEquationSystem methods

extension XorEquationSystemAdapter: XorEquationSystem {
    func solves(activatingVariables: XorEquationSystemSolver.ActivatedVariables) -> Bool {
        return equations.reduce(true) { (result, equation) in
            let value = XorEquationSystemAdapter.value(of: equation,
                                                       activatedVariables: activatingVariables)

            return result && (value == 0)
        }
    }
}

// MARK: - Private body

private extension XorEquationSystemAdapter {

    // MARK: - Private class methods

    static func value(of equation: XorEquationSystemSolver.Equation,
                      activatedVariables: [Int]) -> Int {
        return equation.reduce(0) { (acc, component) in
            return acc ^ XorEquationSystemAdapter.value(of: component,
                                                        activatedVariables: activatedVariables)
        }
    }

    static func value(of component: XorEquationComponent, activatedVariables: [Int]) -> Int {
        var doActivated = false
        switch component {
        case .constant(let activated):
            doActivated = activated
        case .variable(let id):
            doActivated = activatedVariables.contains(id)
        }

        return (doActivated ? 1 : 0)
    }
}
