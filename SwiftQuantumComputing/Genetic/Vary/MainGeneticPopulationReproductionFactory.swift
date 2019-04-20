//
//  MainGeneticPopulationReproductionFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/02/2019.
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

struct MainGeneticPopulationReproductionFactory {

    // MARK: - Private properties

    private let evaluatorFactory: GeneticCircuitEvaluatorFactory
    private let crossoverFactory: GeneticPopulationCrossoverFactory
    private let mutationFactory: GeneticPopulationMutationFactory

    // MARK: - Internal init methods

    init(evaluatorFactory: GeneticCircuitEvaluatorFactory,
         crossoverFactory: GeneticPopulationCrossoverFactory,
         mutationFactory: GeneticPopulationMutationFactory) {
        self.evaluatorFactory = evaluatorFactory
        self.crossoverFactory = crossoverFactory
        self.mutationFactory = mutationFactory
    }
}

// MARK: - GeneticPopulationReproductionFactory methods

extension MainGeneticPopulationReproductionFactory: GeneticPopulationReproductionFactory {
    func makeReproduction(qubitCount: Int,
                          tournamentSize: Int,
                          mutationProbability: Double,
                          threshold: Double,
                          maxDepth: Int,
                          useCases: [GeneticUseCase],
                          gates: [Gate]) throws -> GeneticPopulationReproduction {
        var evaluator: GeneticCircuitEvaluator!
        do {
            evaluator = try evaluatorFactory.makeEvaluator(qubitCount: qubitCount,
                                                           threshold: threshold,
                                                           useCases: useCases)
        } catch GeneticCircuitEvaluatorFactoryMakeEvaluatorError.qubitCountHasToBeBiggerThanZero {
            throw GeneticPopulationReproductionFactoryMakeReproductionError.qubitCountHasToBeBiggerThanZero
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        var mutation: GeneticPopulationMutation!
        do {
            mutation = try mutationFactory.makeMutation(qubitCount: qubitCount,
                                                        tournamentSize: tournamentSize,
                                                        maxDepth: maxDepth,
                                                        evaluator: evaluator,
                                                        gates: gates)
        } catch GeneticPopulationMutationFactoryMakeMutationError.qubitCountHasToBeBiggerThanZero {
            throw GeneticPopulationReproductionFactoryMakeReproductionError.qubitCountHasToBeBiggerThanZero
        } catch GeneticPopulationMutationFactoryMakeMutationError.tournamentSizeHasToBeBiggerThanZero {
            throw GeneticPopulationReproductionFactoryMakeReproductionError.tournamentSizeHasToBeBiggerThanZero
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        var crossover: GeneticPopulationCrossover!
        do {
            crossover = try crossoverFactory.makeCrossover(tournamentSize: tournamentSize,
                                                           maxDepth: maxDepth,
                                                           evaluator: evaluator)
        } catch GeneticPopulationCrossoverFactoryMakeCrossoverError.tournamentSizeHasToBeBiggerThanZero {
            throw GeneticPopulationReproductionFactoryMakeReproductionError.tournamentSizeHasToBeBiggerThanZero
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        return MainGeneticPopulationReproduction(mutationProbability: mutationProbability,
                                                 mutation: mutation,
                                                 crossover: crossover)
    }
}
