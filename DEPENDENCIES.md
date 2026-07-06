# Third-Party Dependencies

## Summary

d4v2 is released under LGPLv2.1 and depends on several third-party libraries with
different licenses (all permissive for non-commercial academic use).

## Dependencies by Category

### Core Computation
- **GMP/GMPXX** (v6.3+): LGPLv3+
    - Used for arbitrary-precision arithmetic
    - License: GNU Lesser General Public License v3 or later

### SAT Solving & Logic
- **Glucose** (v3.0): MIT License
    - SAT solver for logical reasoning
    - Authors: Niklas Sorensson (2008-2010)
    - License: Permissive (MIT)

- **MiniSat**: MIT License
    - SAT solver library
    - Authors: Niklas Sorensson
    - License: Permissive (MIT)

### Hypergraph Partitioning
- **PaToH** (v3.2): Non-Commercial Research License
    - Purpose: Multilevel hypergraph partitioning
    - Copyright: (c) 1996- Umit V. Catalyurek
    - **License Terms**: Free for non-commercial research use only
    - **Commercial Use**: Requires separate commercial license
    - **Contact**: umit@gatech.edu
    - **Research Use**: Allowed with attribution

### Tree Decomposition & Heuristics
- **bipe**: GNU Affero General Public License v3 (AGPLv3)
    - Used for constraint-based reasoning
    - Copyright: (c) 2021 Jean-Marie Lagniez
    - License: AGPLv3 (strong copyleft)
    - Academic Use: Compatible

- **flowCutter**: BSD 2-Clause License
    - Tree decomposition algorithm
    - Copyright: (c) 2016 Ben Strasser
    - License: Permissive (BSD 2-Clause)

### Build & Utility
- **Boost** (program_options): Boost Software License
    - Command-line argument parsing
    - License: Permissive
---

## License Implications for Academic Use

### For Research Publication ✅
- You may use this project for research
- You may publish results
- Attribute PaToH and other dependencies as shown below

### For Commercial Use ❌
- PaToH prohibits commercial use without separate license
- AGPLv3 (bipe) imposes additional network-distribution requirements

## Attribution

Please include the following in your documentation:
```
d4v2 - Model Counting Library Copyright (c) 2022 Jean-Marie Lagniez Licensed under LGPLv2.1

Third-party components:
* PaToH (c) 1996- Umit V. Catalyurek - Non-commercial research license
* bipe (c) 2021 Jean-Marie Lagniez - AGPLv3
* flowCutter (c) 2016 Ben Strasser - BSD 2-Clause
* Glucose (c) 2008-2010 Niklas Sorensson - MIT
* MiniSat (c) 2003-2010 Niklas Sorensson - MIT
* GMP/GMPXX - LGPLv3+
* Boost - Boost Software License
```
