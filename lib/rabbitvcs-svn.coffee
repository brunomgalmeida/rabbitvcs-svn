{CompositeDisposable} = require "atom"
path = require "path"

RabbitCSVSvn = (args, cwd) ->
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
  args = [ "blame", currFile ]
  #args.push("/startrev:1", "/endrev:-1") if atom.config.get("SVN.tortoiseBlameAll")
  #Not Yet Working
  #RabbitCSVSvn(args, path.dirname(currFile))

commit = (currFile)->
  RabbitCSVSvn(["commit", currFile], path.dirname(currFile))

diff = (currFile)->
  RabbitCSVSvn(["diff", currFile], path.dirname(currFile))

log = (currFile)->
  currpath = if currFile then currFile else "."
  RabbitCSVSvn(["log", currpath], path.dirname(currFile))

revert = (currFile)->
  RabbitCSVSvn(["revert", currFile], path.dirname(currFile))

update = (currFile)->
  RabbitCSVSvn(["update", currFile], path.dirname(currFile))

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
    #atom.commands.add "atom-workspace", "SVN:blameFromTreeView": => @blameFromTreeView()
    #atom.commands.add "atom-workspace", "SVN:blameFromEditor": => @blameFromEditor()

    atom.commands.add "atom-workspace", "SVN:commitFromTreeView": => @commitFromTreeView()
    atom.commands.add "atom-workspace", "SVN:commitFromEditor": => @commitFromEditor()

    atom.commands.add "atom-workspace", "SVN:diffFromTreeView": => @diffFromTreeView()
    atom.commands.add "atom-workspace", "SVN:diffFromEditor": => @diffFromEditor()

    atom.commands.add "atom-workspace", "SVN:logFromTreeView": => @logFromTreeView()
    atom.commands.add "atom-workspace", "SVN:logFromEditor": => @logFromEditor()

    atom.commands.add "atom-workspace", "SVN:revertFromTreeView": => @revertFromTreeView()
    atom.commands.add "atom-workspace", "SVN:revertFromEditor": => @revertFromEditor()

    atom.commands.add "atom-workspace", "SVN:updateFromTreeView": => @updateFromTreeView()
    atom.commands.add "atom-workspace", "SVN:updateFromEditor": => @updateFromEditor()

  #blameFromTreeView: ->
  #  currFile = resolveTreeSelection()
  #  blame(currFile) if currFile?

  #blameFromEditor: ->
  #  currFile = resolveEditorFile()
  #  blame(currFile) if currFile?

  commitFromTreeView: ->
    currFile = resolveTreeSelection()
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

  updateFromTreeView: ->
    currFile = resolveTreeSelection()
    update(currFile) if currFile?

  updateFromEditor: ->
    currFile = resolveEditorFile()
    update(currFile) if currFile?
