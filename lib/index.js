stringify = require('json-stable-stringify')
winston = require('winston')
_ = require('lodash')

/**
Order properties before all others, in the order they are specifeid. All other properties
will be ordered alphabetically.
*/
exports.keyCompareFactory = function(properties){
	return function(a, b){
		if(_.size(properties)){
			var intersection = _.intersection([a.key, b.key], properties)		
			if(intersection.length === 1){ 
				// sort by whichever key has the match
				return (a.key === intersection[0] ) ? -1 : 1;
			} else if(intersection.length === 2){
				// sort by order in properties collection
				var indexes = _.map([a.key, b.key], function(key){
					return _.indexOf(properties, key);
				});
				
				return (indexes[0] < indexes[1]) ? -1 : 1;
			}
		}	
		return (a.key < b.key) ? -1 : 1;
	};
};

/**
Orders timestamp first using the above keyCompare function and the json-stable-stringify lib
*/
exports.stringifyFactory = function(properties){
	return function(obj){
		var options = {
			cmp: exports.keyCompareFactory(properties)
		};
		if(this.prettyPrint){
			options.space = 2;
		}
		return stringify(obj, options);
	};
};

/**
Returns a stringify function that orders properties.
*/
exports.ordered = function(properties){
	if(_.isString(properties)){
		properties = [properties]
	}
	return exports.stringifyFactory(properties);
};
