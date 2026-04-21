/*
 * d4
 * Copyright (C) 2024  Univ. Artois & CNRS & KU Leuven
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
#include <unordered_map>
#include "md4/problem/ProblemTypes.hpp"

namespace d4 {

class LitNameMap {
 private:
  std::unordered_map<std::string, Lit> name_map;

 public:
  Var nextVar = 1;

  Lit get_lit(std::string &name) {
    if (!name_map.contains(name)) name_map[name] = Lit::makeLitTrue(nextVar++);
    return name_map[name];
  }

  Lit add_new(std::string &name) {
    if (name_map.contains(name))
      throw std::invalid_argument("Key " + name + " already defined.");
    name_map[name] = Lit::makeLitTrue(nextVar++);
    return name_map[name];
  }
};

}  // namespace d4
