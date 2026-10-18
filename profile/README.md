`dgcalc` is a modular development system/utility for C, C++, and Fortran. 
Its source code is hosted [here](https://github.com/DGCALC/dgcalc). 

DGCALC consists of several projects that can be thought of as a basic set of 
examples of [dgcalc](https://github.com/DGCALC/dgcalc)  organization, although they can do useful things. 

- Base is a small basket of all-encompassing (mainly) compile-time resources. 
- Kyte is for industrial strength bit-fiddling. 
- Types is like Base, but for more development of the type system (again, compile-time resources). 
- Types allows dependency on Kyte, and can be thought of as a continuation of Base. 
- Scalar is the master project for scalar classes. 
- Kabbage is a basket of basic algorithms that (1) don't use scalars (2) are needed later, as well as problems that don't require special data structures to describe, e.g., sorting. 
- Tennsix is a project serving linear algebra based on Scalar types. 

The dependencies among DGCALC projects, where each line represents a project
that depends on at least one project in the previous line,
but no projects in the same line or any projects in lower lines is:
```
{Base}
{Kyte}
{Types}
{Scalar, Kabbage}
{Tennsix}
```
These projects were created in 2021-2022 and have been largely inactive since 2023, 
while the `dgcalc` utility is currently under active development. 

## License and Maintainers

Distributed under the [MIT License](_F/LICENSE).

* Maintainer Contact: Lucius Schoenbaum ([email](mailto:lts0016@uah.edu))

## Acknowledgements

This project is supported by the National Science Foundation:

| Award Number                                                                  | Principal Investigator                 |
|:------------------------------------------------------------------------------|:---------------------------------------|
| **[NSF-2514037](https://www.nsf.gov/awardsearch/show-award/?AWD_ID=2514037)** | Dr. Vladimir Florinski (UAH)           |
| **[NSF-2514038](https://www.nsf.gov/awardsearch/show-award/?AWD_ID=2514038)** | Dr. Dinshaw Balsara (Univ. Notre Dame) |

*Disclaimer: Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.*
