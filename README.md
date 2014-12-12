winston-stringify
=================
Orders winston meta properties alphabetically when stringifying json, with an option to specify 'special' or preferred properties to be stringified first.
Primary use case is to order 'timestamp' first for Splunk performance considerations.

## Setup
```
var stringify = require('winston-stringify').ordered(['timestamp']);

winston.add(winston.transports.Console, {
	json: true,
	timestamp: true,
	stringify: stringify   // <------- this is what's important
});
```

## Example
```
var winston = new require('winston');
var stringify = require('winston-stringify').ordered(['timestamp']);

// remove the existing logger or you'll get an error
winston.remove(winston.transports.Console);
winston.add(winston.transports.Console, {
	json: true,
	timestamp: true,
	stringify: stringify
});

// example message
winston.info("this log message should be stringified");

```


The output from the example is below -

```
{"timestamp":"2014-12-15T12:47:45.105Z","level":"info","message":"this log message should be stringified"}
```
