module.exports = (grunt) ->

  grunt.initConfig

    coffee:
      app:
        options:
          bare: true
          join: true
        files: 'build/js/app.js': ['src/coffee/*.coffee', 'src/coffee/**/**.coffee']
      server:
        expand: true
        flatten: true
        cwd: 'src/server'
        src: [ '*.coffee' ]
        dest: 'build/server/'
        ext: '.js'
      main:
        expand: true
        cwd: 'src/scripts'
        src: [ '**/*.coffee' ]
        dest: 'build/scripts/'
        ext: '.js'

    # https://www.npmjs.com/package/grunt-angular-templates
    ngtemplates:
      ng:
        cwd: 'src/coffee'
        src: ['**/*.html']
        dest: 'build/js/templates.js'

    # https://www.npmjs.com/package/grunt-ng-annotate
    ngAnnotate:
      build:
        files: 'build/js/app.js': ['build/js/app.js']

    concat:
      js:
        src: [
          'src/vendor/js/**/*.js'
          'src/vendor/js/**'
        ]
        dest: 'build/js/vendor.js'

      css:
        src: [
          'src/vendor/css/**/*.css'
          'src/vendor/css/**'
        ]
        dest: 'build/css/vendor.css'

    stylus:
      build:
        options:
          'resolve url': true
          use: [ 'nib' ]
          compress: false
          paths: [ '/styl' ]

        expand: true
        join: true
        files: 'build/css/app.css': ['src/**/*.styl', 'src/**/**.styl']

    copy:

      main:
        files: [
          { expand: true, cwd: 'src/assets/', src: ['**'], dest: 'build' }
        ]

      node_modules:
        files: [
          { expand: true, cwd: 'node_modules/', src: ['**'], dest: 'build/node_modules' }
        ]

      server:
        src: ['src/server/package.json']
        dest: 'build/server/package.json'

  # load the tasks
  require('load-grunt-tasks') grunt

  grunt.registerTask 'copyDeps', ->
    grunt.task.run 'copy:main'
    grunt.task.run 'copy:server'

  # define the tasks
  grunt.registerTask 'default', (env) ->

    grunt.task.run 'coffee'
    grunt.task.run 'ngtemplates:ng'
    grunt.task.run 'ngAnnotate:build'
    grunt.task.run 'stylus:build'
    grunt.task.run 'concat'
    grunt.task.run 'copyDeps'
