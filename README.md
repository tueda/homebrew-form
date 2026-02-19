homebrew-form
=============

Homebrew formulae for [FORM](https://www.nikhef.nl/~form/) and related software.

Quick start
-----------

1. Install [Homebrew](https://brew.sh/) (macOS) or
   [Linuxbrew](http://linuxbrew.sh/) (Linux).
2. Run `brew install tueda/form/<formula>`. Or tap this repository
   `brew tap tueda/form` and then `brew install <formula>`.

Installing FORM
---------------

### Stable version

To install FORM, run the following command:
```bash
brew install tueda/form/form
```
You can upgrade the installed FORM by
```bash
brew upgrade tueda/form/form
```

### Development version

Sometimes you may want to use the development version on
the [FORM repository](https://github.com/form-dev/form), because it may have
more functionalities or more well-debugged than the \`stable\' version.
To install the development version, you can use `--HEAD` option.
```bash
brew install --HEAD tueda/form/form
```
More install options can be found by `brew info tueda/form/form`.
For packages installed with the `--HEAD` option, `brew upgrade` is known
[not to work](https://github.com/Homebrew/legacy-homebrew/issues/13197).
Instead, you can reinstall it:
```bash
brew reinstall --HEAD tueda/form/form
```

Setting $FORMPATH
-----------------

Formulae for FORM packages in this repository (e.g., `form-forcer`) will
install package files into the directory shown by
```bash
echo "$(brew --prefix)/share/form"
```
Therefore it is convenient to append this directory to
[`FORMPATH`](https://www.nikhef.nl/~form/maindir/documentation/reference/online/online.html#145).
Add the following line to your `.bashrc` or `.zshrc`:
```bash
export FORMPATH="$(brew --prefix)/share/form:$FORMPATH"
```

Contributing
------------
Any contribution is welcome, but for a pull request making a new formula (e.g.,
for your FORM package), there are some conventions you should be aware of.
Probably, it is best to start by copying an existing formula.

- A formulae for FORM package must have a name `form-<package>.rb`.
- Please follow the Homebrew coding style.
  You can check your formula by `brew audit --strict <formula>.rb`.
- `test` is required, which typically runs examples. Probably proprietary
  software cannot work on our continuous integration setup.
  Packages depending on them are ruled out from this tap.
- FORM library files should be installed into the shared `FORMPATH`.
  Putting many `.prc` files should be avoided because they tend to have common
  names and may cause conflict with another package in future.
  The recommended way is, like [Forcer](https://github.com/benruijl/forcer),
  putting one header file and one directory with the help of the
  [`#AppendPath`](https://www.nikhef.nl/~form/maindir/documentation/reference/online/online.html#preappendpath)
  or
  [`#PrependPath`](https://www.nikhef.nl/~form/maindir/documentation/reference/online/online.html#preprependpath)
  preprocessor instruction (available since FORM version 4.2) to minimize
  possible conflict, but for this old packages may need to be modified.
