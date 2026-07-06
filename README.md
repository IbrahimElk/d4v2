This is a fork of [d4v2](https://github.com/crillab/d4v2).

# D4 Project

D4 is a library designed to compute model counts of logical formulas. It currently supports CNF and circuit-based formats, and can be integrated into custom applications for advanced reasoning and model enumeration tasks.

This README provides an overview of how to use the D4 library, the supported input formats, and example usage.

---

## Supported Methods

D4 supports various methods to analyze and count models of logical formulas. More detailed documentation on the methods used internally (e.g., decision diagrams, SAT solvers, etc.) will be added soon.

---

## How to Use

D4 is implemented as a library and should be linked into a separate executable for use. A demo executable is provided to demonstrate basic functionality.

To run a simple counter example on a CNF file:

```bash
cmake --preset dev
cmake --build --preset dev -j$(nproc)
./build/d4_counter_bin -i assets/cnfs/counting/cnf12.cnf
```

To count models of a circuit-based input, see the example under the `circuit` section below.

---

## Input Formats

### 1. Circuit Format

D4 supports a custom circuit format (BC-S1.2), where formulas are defined in terms of logic gates and evaluation constraints. This format allows complex Boolean functions to be represented more directly than CNF.

#### Format Description

A BC-S1.2 file consists of:

* **Comments**: Prefixed with `c`
* **Weight Information** (optional): `c w <literal> <weight>`
* **Input Variables**: `I <var>`
* **Gate Definitions**: `G <var> := <formula>`
* **Target Literals**: `T <literal>`

#### Formula Syntax

A gate's formula can be one of:

* `A <lit1> <lit2> ...` – AND
* `O <lit1> <lit2> ...` – OR
* `I <lit>` – Identity (can also represent negation using `-<lit>`)

> A literal is either a variable or its negation (e.g., `x`, `-x`).

#### Example 1: Single Negative Literal

```plaintext
c BC-S1.2
I x
T -x
```

#### Example 2: Complex Formula `(a & b) | -(-c & b)`

```plaintext
c BC-S1.2
I a
I b
I c
G g1 := A a b
G g2 := A -c b
G g3 := O g1 -g2
T g3
```

#### Run Example

To run the model counter on a circuit:

```bash
./build/d4_compiler_bin -i assets/circuits/circ1.bc --input-type circuit
```

---

### 2. CNF Format

D4 also supports the standard **DIMACS CNF** format. This is widely used in SAT solving and describes Boolean formulas as a conjunction of clauses, each a disjunction of literals.

To run a model counter on a CNF file:

```bash
./build/d4_counter_bin -i assets/cnfs/counting/cnf5.cnf
```

---

## License

This project combines multiple third-party libraries under different licenses:

- **d4 core**: GNU Lesser General Public License v2.1 (LGPLv2.1)
- **bipe**: GNU Affero General Public License v3 (AGPLv3)
- **flowCutter**: BSD 2-Clause License
- **Glucose SAT Solver**: MIT License
- **GMP/GMPXX**: GNU Lesser General Public License v3+ (LGPLv3+)
- **MiniSat**: MIT License
- **Boost**: Boost Software License
- **PaToH**: Non-commercial research license (see below)


PaToH (Partitioning Tools for Hypergraphs) is available free of charge for
non-commercial, research use by academic/research institutions.
**Commercial use requires a separate commercial license.** 
For commercial license inquiries, contact: Ümit V. Çatalyürek (umit@gatech.edu).
Redistribution of PaToH in any form requires explicit written permission from the copyright holder.
See 3rdParty/patoh/build/Linux-aarch64/README for full details.


bipe is licensed under the GNU Affero General Public License v3 (AGPL-3.0-or-later).
The complete Corresponding Source for the combined libmd4 work is
available at: https://github.com/crillab/d4v2
See 3rdParty/bipe/LICENSE for full details.

By installing or using this package you agree to the terms of all licenses.
