//
//  CircuitDescriptionTestDouble.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 05/09/2018.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class CircuitDescriptionTestDouble {

    // MARK: - Public properties

    private (set) var applyingDescriberCount = 0
    private (set) var lastApplyingDescriberDescriber: CircuitGateDescribable?
    private (set) var lastApplyingDescriberInputs: [Int]?
    var applyingDescriberResult: CircuitDescriptionTestDouble?
}

// MARK: - CustomPlaygroundDisplayConvertible methods

extension CircuitDescriptionTestDouble: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any {
        return ""
    }
}

// MARK: - CircuitDescription methods

extension CircuitDescriptionTestDouble: CircuitDescription {
    func applyingDescriber(_ describer: CircuitGateDescribable,
                           inputs: [Int]) -> CircuitDescriptionTestDouble {
        applyingDescriberCount += 1

        lastApplyingDescriberDescriber = describer
        lastApplyingDescriberInputs = inputs

        return (applyingDescriberResult ?? CircuitDescriptionTestDouble())
    }
}