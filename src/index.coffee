_ = require 'lodash'
jade = require 'jade'
stylus = require 'stylus'
fs = require 'fs'

# @map {Object} report object
# @options {Object} Report class options
module.exports = ->

  duplicates = []

  for clone in @map.clones
    do (clone) ->

      duplicates.push

        lines: clone.linesCount
        tokens: clone.tokensCount
        firstFile:
          start: clone.firstFileStart
          end: clone.firstFileStart + clone.linesCount
          name: clone.firstFile
        secondFile:
          start: clone.secondFileStart
          end: clone.secondFileStart + clone.linesCount
          name: clone.secondFile
        fragment: clone.getLines()

  json =
    duplicates: duplicates
    statistics:
      clones: @map.clones.length
      duplications: @map.numberOfDuplication
      files: @map.numberOfFiles
      percentage: @map.getPercentage()
      lines: @map.numberOfLines

  styleStr = fs.readFileSync(__dirname + '/tmpl/index.styl').toString()
  stylus(styleStr).render (err, css) ->

    json.style = css
    htmlStr = jade.compileFile(__dirname + '/tmpl/index.jade')(json)
    fs.writeFileSync('./jscpd-report.html', htmlStr)



  [
    json
    json
    '`jscpd` HTML report being generated.'
  ]
