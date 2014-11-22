NeoJSON [![Build Status](https://travis-ci.org/GsDevKit/NeoJSON.svg?branch=gs_master)](https://travis-ci.org/GsDevKit/NeoJSON)
=======

NeoJSON is an elegant and efficient standalone Smalltalk framework to read and write JSON converting to or from Smalltalk objects.

MIT Licensed.

Go ahead and read the [NeoJSON paper](https://github.com/svenvc/docs/blob/master/neo/neo-json-paper.md).

## GemStone Installation

```Smalltalk
Gofer new
  package: 'GsUpgrader-Core';
  url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
  load.
(Smalltalk at: #GsUpgrader) upgradeGLASS1.

Metacello new
  baseline: 'NeoJSON';
  repository: 'github://GsDevKit/NeoJSON:gs_master/repository';
  load.
```
