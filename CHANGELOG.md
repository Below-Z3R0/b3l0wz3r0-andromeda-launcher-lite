# Changelog

All notable changes to Andromeda Launcher Lite are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-24

### Added

- Category sidebar for the **All Apps** view.
- Option to show or hide application labels in grid mode.
- Independent plugin ID, repository metadata, and fork branding.
- Installation, usage, development, credits, and license documentation.

### Changed

- Migrated supported graphical effects from `Qt5Compat.GraphicalEffects` to `QtQuick.Effects` / `MultiEffect`.
- Improved grid and list performance with reusable delegates and conditional rendering/effect activation.
- Cached the application-category model to avoid repeated binding work.
- Modernized and deduplicated Qt 6 / Plasma 6 imports.
- Standardized source notices with SPDX identifiers while preserving upstream attribution.
- Replaced unresolved TODO markers with explanatory maintenance comments.

### Fixed

- Corrected drag-state assignments in application delegates.
- Corrected click-handler parameters and an icon-size binding loop.
- Fixed category labels, empty-category filtering, and the **All Apps** button behavior.
- Fixed configuration QML syntax and restored required imports.
- Prevented the menu representation from flashing as an empty dialog during creation.
- Restored the stable floating-avatar dialog behavior after reverting an incompatible window experiment.

### Removed

- Experimental rounded application icons because they caused rendering artifacts.

[1.0.0]: https://github.com/Below-Z3R0/b3l0wz3r0-andromeda-launcher-lite/releases/tag/v1.0.0
