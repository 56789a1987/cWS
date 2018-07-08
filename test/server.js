'use strict';

const port = 3001;
const addon = require(`../dist/uws_${process.platform}_${process.versions.modules}.node`);

console.log(`Broker is running on ${port} port`);
addon.runGlobalBroker(port);