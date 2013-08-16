fs = require 'fs'
path = require 'path'

_s = require 'underscore.string'

# Browserify requires
coffeeify = require 'coffeeify'

module.exports = (grunt)->
  BUILD_DIR = 'app/public'
  APP_PATH = './webapp/'
  BUILD_PATH = "./#{BUILD_DIR}/"
  TEMPLATES_SRC = APP_PATH+'templates/'

  ember_templates_files = {}
  ember_templates_files[BUILD_PATH+'templates.js'] = TEMPLATES_SRC + '**/*.handlebars'


  # Project configuration
  grunt.initConfig
    clean:
      all: [ BUILD_PATH ]

    browserify2:
      build:
        entry: APP_PATH+'index.coffee'
        compile: BUILD_PATH+'app.js'
        debug: yes
        beforeHook: (bundle)->
          bundle.transform coffeeify

    copy:
      all:
        files: [
          {cwd: './bower_components/underscore/', src: 'underscore.js', dest: BUILD_PATH, expand: yes}
          {cwd: './bower_components/jquery/', src: 'jquery.js', dest: BUILD_PATH, expand: yes}
          {cwd: './bower_components/handlebars/', src: 'handlebars.runtime.js', dest: BUILD_PATH, expand: yes}
          {cwd: './bower_components/ember/', src: 'ember.js', dest: BUILD_PATH, expand: yes}
        ]

    emberTemplates:
      build:
        options:
          templateName: (fileName)-> path.relative TEMPLATES_SRC, fileName
        files: ember_templates_files

    watch:
      coffee:
        files: [ APP_PATH+'*.coffee', APP_PATH+'**/*.coffee' ]
        tasks: ['browserify2']
      handlebars:
        files: [ APP_PATH+'**/*.handlebars' ]
        tasks: 'emberTemplates'
      style:
        files: [ APP_PATH+'style.css' ]
        tasks: 'copy:style'
      index2:
        files: [ APP_PATH+'index2.html' ]
        tasks: 'copy:all'
      index3:
        files: [ APP_PATH+'index3.html' ]
        tasks: 'copy:all'
      vendor:
        files: [ APP_PATH+'vendor/*' ]
        tasks: 'copy:all'

    createIndex:
      models:
        src: APP_PATH+'models/*'
        dest: APP_PATH+'models/index.coffee'
      routes:
        src: APP_PATH+'routes/*'
        dest: APP_PATH+'routes/index.coffee'
      controllers:
        src: APP_PATH+'controllers/*'
        dest: APP_PATH+'controllers/index.coffee'
      views:
        src: APP_PATH+'views/*'
        dest: APP_PATH+'views/index.coffee'
      mixins:
        src: APP_PATH+'mixins/*'
        dest: APP_PATH+'mixins/index.coffee'



  # Dependencies
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'


  grunt.loadNpmTasks 'grunt-browserify2'

  grunt.loadNpmTasks 'grunt-ember-templates'

  #grunt.loadNpmTasks 'grunt-update-submodules'

  grunt.registerMultiTask 'createIndex', 'Create index task', ->
    done = @async()
    destFileSrc = "module.exports = {\n"
    destFilePath = path.join __dirname, @data.dest
    for filePath in @filesSrc
      fileFullName = path.basename(filePath)
      continue if fileFullName is 'index.coffee'
      continue if _s.strLeft(fileFullName, '_') is ''
      fileName = path.basename(filePath, '.coffee')
      objName = _s.classify(fileName)
      destFileSrc += "  #{objName}: require './#{fileFullName}'\n"
    destFileSrc += "}\n"

    grunt.log.writeln "Write to file: '#{destFilePath}'"
    fs.writeFile destFilePath, destFileSrc, (err)-> done err
    yes


  grunt.registerTask 'build', [
    'clean'
    'copy'
    'emberTemplates:build'
    'createIndex'
    'browserify2:build'
  ]

  grunt.registerTask 'default', [
    'build'
  ]

  grunt.registerTask 'develop', [
    'build'
    'watch'
  ]
