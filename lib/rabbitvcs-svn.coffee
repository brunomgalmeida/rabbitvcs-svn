{CompositeDisposable} = require "atom"
path = require "path"

RabbitVCSSvn = (args, cwd) ->
  spawn = require("child_process").spawn
  #command = atom.config.get("SVN.rabbitvcsPath") + "/rabbitvcs"
  command = "/usr/bin/rabbitvcs"
  options =
    cwd: cwd

  tProc = spawn(command, args, options)

  tProc.stdout.on "data", (data) ->
    console.log "stdout: " + data

  tProc.stderr.on "data", (data) ->
    console.log "stderr: " + data

  tProc.on "close", (code) ->
    console.log "child process exited with code " + code

resolveTreeSelection = ->
  if atom.packages.isPackageLoaded("tree-view")
    treeView = atom.packages.getLoadedPackage("tree-view")
    treeView = require(treeView.mainModulePath)
    serialView = treeView.serialize()
    serialView.selectedPath

resolveEditorFile = ->
  editor = atom.workspace.getActivePaneItem()
  file = editor?.buffer.file
  file?.path

blame = (currFile)->
  RabbitVCSSvn(["annotate", currFile], path.dirname(currFile))

commit = (currFile)->
  RabbitVCSSvn(["commit", currFile], path.dirname(currFile))

diff = (currFile)->
  RabbitVCSSvn(["diff", currFile], path.dirname(currFile))

log = (currFile)->
  currpath = if currFile then currFile else "."
  RabbitVCSSvn(["log", currpath], path.dirname(currFile))

revert = (currFile)->
  RabbitVCSSvn(["revert", currFile], path.dirname(currFile))

update = (currFile)->
  RabbitVCSSvn(["update", currFile], path.dirname(currFile))

add = (currFile)->
  RabbitVCSSvn(["add", currFile], path.dirname(currFile))

rename = (currFile)->
  RabbitVCSSvn(["rename", currFile], path.dirname(currFile))

module.exports = SVN =
  config:
    rabbitvcsPath:
      title: "SVN bin path"
      description: "The folder containing rabbitvcs"
      type: "string"
      default: "/usr/bin"
    rabbitvcsBlameAll:
      title: "Blame all versions"
      description: "Default to looking at all versions in the file's history. Uncheck to allow version selection."
      type: "boolean"
      default: true

  activate: (state) ->
    atom.commands.add "atom-workspace", "SVN:blameFromTreeView": => @blameFromTreeView()
    atom.commands.add "atom-workspace", "SVN:blameFromEditor": => @blameFromEditor()

    atom.commands.add "atom-workspace", "SVN:commitFromTreeView": => @commitFromTreeView()
    atom.commands.add "atom-workspace", "SVN:commitFromEditor": => @commitFromEditor()
    atom.commands.add "atom-workspace", "SVN:commitProject": => @commitProject()

    atom.commands.add "atom-workspace", "SVN:diffFromTreeView": => @diffFromTreeView()
    atom.commands.add "atom-workspace", "SVN:diffFromEditor": => @diffFromEditor()

    atom.commands.add "atom-workspace", "SVN:logFromTreeView": => @logFromTreeView()
    atom.commands.add "atom-workspace", "SVN:logFromEditor": => @logFromEditor()

    atom.commands.add "atom-workspace", "SVN:revertFromTreeView": => @revertFromTreeView()
    atom.commands.add "atom-workspace", "SVN:revertFromEditor": => @revertFromEditor()

    atom.commands.add "atom-workspace", "SVN:addFromTreeView": => @addFromTreeView()
    atom.commands.add "atom-workspace", "SVN:addFromEditor": => @addFromEditor()

    atom.commands.add "atom-workspace", "SVN:updateFromTreeView": => @updateFromTreeView()
    atom.commands.add "atom-workspace", "SVN:updateFromEditor": => @updateFromEditor()
    atom.commands.add "atom-workspace", "SVN:updateProject": => @updateProject()

    atom.commands.add "atom-workspace", "SVN:renameFromTreeView": => @renameFromTreeView()
    atom.commands.add "atom-workspace", "SVN:renameFromEditor": => @renameFromEditor()
  blameFromTreeView: ->
    currFile = resolveTreeSelection()
    blame(currFile) if currFile?

  blameFromEditor: ->
    currFile = resolveEditorFile()
    blame(currFile) if currFile?

  commitFromTreeView: ->
    currFile = resolveTreeSelection()
    commit(currFile) if currFile?

  commitProject: ->
    currFile = atom.project.getPaths()[0]
    commit(currFile) if currFile?

  commitFromEditor: ->
    currFile = resolveEditorFile()
    commit(currFile) if currFile?

  diffFromTreeView: ->
    currFile = resolveTreeSelection()
    diff(currFile) if currFile?

  diffFromEditor: ->
    currFile = resolveEditorFile()
    diff(currFile) if currFile?

  logFromTreeView: ->
    currFile = resolveTreeSelection()
    log(currFile) if currFile?

  logFromEditor: ->
    currFile = resolveEditorFile()
    log(currFile) if currFile?

  revertFromTreeView: ->
    currFile = resolveTreeSelection()
    revert(currFile) if currFile?

  revertFromEditor: ->
    currFile = resolveEditorFile()
    revert(currFile) if currFile?

  addFromTreeView: ->
    currFile = resolveTreeSelection()
    add(currFile) if currFile?

  addFromEditor: ->
    currFile = resolveEditorFile()
    add(currFile) if currFile?

  renameFromTreeView: ->
    currFile = resolveTreeSelection()
    rename(currFile) if currFile?

  renameFromEditor: ->
    currFile = resolveEditorFile()
    rename(currFile) if currFile?

  updateFromTreeView: ->
    currFile = resolveTreeSelection()
    update(currFile) if currFile?

  updateFromEditor: ->
    currFile = resolveEditorFile()
    update(currFile) if currFile?

  updateProject: ->
    currFile = atom.project.getPaths()[0]
    update(currFile) if currFile?
