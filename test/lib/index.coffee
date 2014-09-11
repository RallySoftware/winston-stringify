winstonStringify = require('../../lib/')
stableStringify = require('json-stable-stringify')
sinon = require('sinon')
should = require('should')

describe 'ordered', ->

	beforeEach ->
		@sandbox = sinon.sandbox.create()
		@sandbox.stub(winstonStringify, 'stringifyFactory')

	afterEach ->
		@sandbox.restore()

	it 'should return a stringify function', ->
		winstonStringify.stringifyFactory.returns 'foo'
		winstonStringify.ordered().should.eql('foo')

	it 'should gracefully ignore a lack of special properties', ->
		winstonStringify.ordered()
		winstonStringify.stringifyFactory.calledWith(undefined).should.be.true

	it 'should accept a single string property', ->
		winstonStringify.ordered('foo')
		winstonStringify.stringifyFactory.calledWith(['foo']).should.be.true

	it 'should accept a single string property', ->
		winstonStringify.ordered(['foo', 'bar'])
		winstonStringify.stringifyFactory.calledWith(['foo', 'bar']).should.be.true

describe 'stringify', ->

	beforeEach ->
		@properties = ['b', 'a']
		@stringify = winstonStringify.stringifyFactory @properties

	it 'should pretty print with 2 spaces if configured', ->
		data = {foo: 'bar'}
		result = @stringify.call {prettyPrint: true}, data
		expected = stableStringify data, {space: 2}
		result.should.eql expected

	it 'should not pretty print if not configured', ->
		data = {foo: 'bar'}
		result = @stringify.call {}, data
		expected = stableStringify data
		result.should.eql expected

	it 'should use the keyCompare function to order properties', ->
		@sandbox = sinon.sandbox.create()
		@sandbox.stub(winstonStringify, 'keyCompareFactory')
		comparator = sinon.spy(-> return -1)
		winstonStringify.keyCompareFactory.returns comparator

		data = {foo: 'foo', bar: 'bar'}
		result = @stringify.call {}, data
		
		comparator.called.should.be.true
		@sandbox.restore()

describe 'keyCompare', ->

	beforeEach ->
		@properties = ['z', 'a']
		@compare = winstonStringify.keyCompareFactory @properties

	it 'should place special properties in front', ->
		@compare({key: 'foo'}, {key: 'z'}).should.eql(1)
		@compare({key: 'z'}, {key: 'foo'}).should.eql(-1)

	it 'should order special properties according to their listed order', ->
		@compare({key: 'z'}, {key: 'a'}).should.eql(-1)
		@compare({key: 'a'}, {key: 'z'}).should.eql(1)

	it	it 'should order other properties alphabetically', ->
		@compare({key: 'foo'}, {key: 'bar'}).should.eql(1)
		@compare({key: 'bar'}, {key: 'foo'}).should.eql(-1)
