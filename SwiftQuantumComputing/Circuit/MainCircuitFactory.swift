//
//  MainCircuitFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/01/2019.
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
import os.log

// MARK: - Main body

public struct MainCircuitFactory {

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Public init methods

    public init() {}
}

// MARK: - CircuitFactory methods

extension MainCircuitFactory: CircuitFactory {
    public func makeCircuit(qubitCount: Int, gates: [FixedGate]) -> Circuit? {
        guard let drawer = CircuitViewDrawer(qubitCount: qubitCount) else {
            os_log("makeCircuit failed: unable to build circuit drawer",
                   log: MainCircuitFactory.logger,
                   type: .debug)

            return nil
        }

        let gateFactory = BackendRegisterGateFactoryAdapter(qubitCount: qubitCount)
        let backend = BackendFacade(factory: gateFactory)

        let registerFactory = BackendRegisterFactoryAdapter()

        return CircuitFacade(gates: gates,
                             drawer: drawer,
                             backend: backend,
                             factory: registerFactory)
    }
}
