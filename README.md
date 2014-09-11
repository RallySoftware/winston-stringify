winston-stringify
=================
Orders winston meta properties alphabetically when stringifying json, with an option to specify 'special' or preferred properties to be stringified first.
Primary use case is to order 'timestamp' first for Splunk performance considerations.

## Usage
```
stringify = require('winston-stringify').ordered(['timestamp'])
winston.add(winston.transports.Console, {
	json: true,
	timestamp: true,
	stringify: stringify
})
```
