# Third-Party Dependencies

## Scope

This file summarizes third-party license notices for this repository.
The project license for d4 code is `LGPL-2.1-or-later` (see `LICENSE`).
Third-party components keep their own license terms.

## Components

### In-tree dependencies

- **bipe**
  - License: AGPL-3.0-or-later
  - Location: `3rdParty/bipe/`
  - License text: `3rdParty/bipe/LICENSE`

- **flowCutter**
  - License: BSD 2-Clause
  - Location: `3rdParty/flowCutter/`
  - License text: `3rdParty/flowCutter/LICENSE`

- **Glucose 3.0**
  - License: MIT-style notices in source headers
  - Location: `3rdParty/glucose-3.0/`
  - Example notice: `3rdParty/glucose-3.0/utils/Options.h`

- **MiniSat**
  - License: MIT
  - Location: `scripts/minisatSolver/`
  - License text: `scripts/minisatSolver/LICENSE`

- **PaToH 3.2 binaries**
  - License: non-commercial research use (binary distribution)
  - Locations:
    - `3rdParty/patoh/build/Linux-aarch64/README`
    - `3rdParty/patoh/build/Linux-x86_64/README`
    - `3rdParty/patoh_mac/build/Darwin-arm64/README`
    - `3rdParty/patoh_mac/build/Darwin-x86_64/README`
  - Notice excerpt: non-commercial research use is free of charge; commercial use requires a separate license
  - Contact: `umit@gatech.edu`

### System dependencies (resolved by CMake)

- **Boost (program_options)**: Boost Software License
- **GMP / GMPXX**: LGPL-3.0-or-later

## Practical Notes for Academic Use

- Keep `LICENSE` and this file when redistributing source snapshots.
- Keep all third-party license files and README notices listed above.
- If you publish binaries including PaToH artifacts, re-check PaToH redistribution terms with the copyright holder.
- If you modify or redistribute components under AGPL/LGPL, follow their corresponding source-notice obligations.

## Attribution Template

```text
d4v2 fork - model counting library
Project code: LGPL-2.1-or-later

Includes third-party components:
- bipe (AGPL-3.0-or-later)
- flowCutter (BSD 2-Clause)
- Glucose 3.0 (MIT-style source notices)
- MiniSat scripts copy (MIT)
- PaToH binaries (non-commercial research-use notice)
- Boost (Boost Software License)
- GMP/GMPXX (LGPL-3.0-or-later)
```
