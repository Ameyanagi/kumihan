# Contributing

Thanks for helping build Kumihan.

## Development setup

1. Install Pixi.
2. Run `pixi install --locked`.
3. Run `pixi run check` before opening a pull request.

Use `pixi run format` to format Mojo sources. Do not edit `pixi.lock` directly;
update dependencies through Pixi and commit the generated lock change.

## Changes

- Keep pull requests focused on one font table, shaping stage, or architectural
  decision.
- Add focused tests before fixing behavioral bugs. Include malformed and
  truncated inputs for parser changes.
- Treat compiler warnings as defects and keep stable Mojo pinned exactly.
- Keep unsafe code and FFI out of 0.1. Do not add runtime dependencies in
  Python, Rust, C, or C++ without an accepted design discussion.
- Treat font bytes as untrusted: use bounded reads, checked arithmetic, explicit
  limits, and validation before constructing semantic values.
- Preserve one scalar/reference implementation when optimizing. Record the
  workload, compiler command, hardware, warmups, samples, checksum, p50, p95,
  and memory behavior for performance claims.
- Update the changelog and compatibility notes for user-visible changes.

## Public API

Root-package exports are compatibility commitments. Keep internal table
records, cursors, scratch storage, and placeholders out of
`src/kumihan/__init__.mojo`. Prefer chainable value modifiers such as
`style.with_size(...).with_language(...)` over boolean combinations or a wide
mutable configuration object.

## Clean-room reference policy

OpenType and Unicode specifications are the implementation authority. External
libraries may be used to discover behaviors, construct differential tests, and
study architecture, but do not copy, transliterate, or mechanically convert
their source. Record the upstream project, revision, license, behavior under
test, and independently derived fixture in the pull request. Do not import test
data whose redistribution terms have not been verified. See
[docs/references.md](docs/references.md).
