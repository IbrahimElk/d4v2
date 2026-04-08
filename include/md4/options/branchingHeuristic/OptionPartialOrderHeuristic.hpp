/*
 * d4
 * Copyright (C) 2020  Univ. Artois & CNRS
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA
 */
#pragma once

#include <string>

#include "md4/exceptions/FactoryException.hpp"
#include "md4/heuristics/partialOrder/PartialOrderHeuristic.hpp"
#include "md4/partitioner/PartitionerManager.hpp"
#include "md4/representation/graph/GraphExtractor.hpp"
#include "md4/representation/hypergraph/HyperGraphExtractor.hpp"
#include "md4/treeDecomposition/TreeDecomposition.hpp"
#include "md4/treeDecompositioner/TreeDecompositioner.hpp"

namespace d4 {

class ConfigurationPartialOrderHeuristic;
enum PartialOrderHeuristicMethod : char;

class OptionPartialOrderHeuristic {
 public:
  PartialOrderHeuristicMethod partialOrderMethod;
  PartitionerName partitionerName;
  HyperGraphExtractorMethod hyperGraphExtractorMethod;
  TreeDecompositionMethod treeDecompositionMethod;
  TreeDecompositionerMethod treeDecompositionerMethod;
  GraphExtractorMethod graphExtractorMethod;
  bool useSimpGraphExtractor;

  /**
   * @brief Construct a new Option Partitioning Heuristic object with the
   * default configuration.
   *
   */
  OptionPartialOrderHeuristic();

  /**
   * @brief Construct a new Option Partitioning Heuristic object with the given
   * configuration.
   *
   * @param config is the configuration we want to use.
   */
  OptionPartialOrderHeuristic(const ConfigurationPartialOrderHeuristic& config);

  friend std::ostream& operator<<(std::ostream& out,
                                  const OptionPartialOrderHeuristic& dt);
};
}  // namespace d4
