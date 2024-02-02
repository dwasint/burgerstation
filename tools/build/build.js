#!/usr/bin/env node
/**
 * Build script for /tg/station 13 codebase.
 *
 * This script uses Juke Build, read the docs here:
 * https://github.com/stylemistake/juke-build
 *
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

// Change working directory to project root
process.chdir(require('path').resolve(__dirname, '../../'));

// Validate NodeJS version
const NODE_VERSION = parseInt(process.versions.node.match(/(\d+)/)[1]);
const NODE_VERSION_TARGET = parseInt(require('fs')
  .readFileSync('dependencies.sh', 'utf-8')
  .match(/NODE_VERSION=(\d+)/)[1]);
if (NODE_VERSION < NODE_VERSION_TARGET) {
  console.error('Your current Node.js version is out of date.');
  console.error('You have two options:');
  console.error('  a) Go to https://nodejs.org/ and install the latest LTS release of Node.js');
  console.error('  b) Uninstall Node.js (our build system automatically downloads one)');
  process.exit(1);
}

// Main
// --------------------------------------------------------

const fs = require('fs');
const Juke = require('./juke');
const { yarn } = require('./lib/yarn');
const { dm } = require('./lib/dm');

const DME_NAME = 'burgerstation';

const DefineParameter = Juke.createParameter({
  type: 'string[]',
  name: 'define',
  alias: 'D',
});

const DmTarget = Juke.createTarget({
  name: 'dm',
  inputs: [
    '_maps/map_files/generic/**',
    'code/**',
    'goon/**',
    'html/**',
    'icons/**',
    'interface/**',
    `${DME_NAME}.dme`,
  ],
  outputs: [
    `${DME_NAME}.dmb`,
    `${DME_NAME}.rsc`,
  ],
  parameters: [DefineParameter],
  executes: async ({ get }) => {
    const defines = get(DefineParameter);
    if (defines.length > 0) {
      Juke.logger.info('Using defines:', defines.join(', '));
    }
    await dm(`${DME_NAME}.dme`, {
      defines: ['CBT', ...defines],
    });
  },
});

const DefaultTarget = Juke.createTarget({
  name: 'default',
  dependsOn: [DmTarget], // TguiTarget, TgFontTarget,
});

/**
 * Prepends the defines to the .dme.
 * Does not clean them up, as this is intended for TGS which
 * clones new copies anyway.
 */
const prependDefines = (...defines) => {
  const dmeContents = fs.readFileSync(`${DME_NAME}.dme`);
  const textToWrite = defines.map(define => `#define ${define}\n`);
  fs.writeFileSync(`${DME_NAME}.dme`, `${textToWrite}\n${dmeContents}`);
};

const TgsTarget = Juke.createTarget({
  name: 'tgs',
  executes: async () => {
    Juke.logger.info('Prepending TGS define');
    prependDefines('TGS');
  },
});

const TGS_MODE = process.env.CBT_BUILD_MODE === 'TGS';

Juke
  .setup({
    default: DefaultTarget, // TgsTarget
  })
  .then((code) => {
    process.exit(code);
  });
