'use strict'

module.exports = (grunt) ->
  
  grunt.initConfig
    mochaTest:
      test:
        options: 
          reporter: 'spec'
          globals: []
          ui: 'bdd'
        
        src: ['test/**/*.coffee']
 
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-mocha-test')

  grunt.registerTask('test', ['mochaTest'])
  grunt.registerTask('default', ['test'])
  

