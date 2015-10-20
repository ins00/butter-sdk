shell = require 'shell'
window = require 'browser-window'
ipc      = require 'ipc'

{ EventEmitter } = require 'events'

class AppWindow extends EventEmitter
  constructor: (options, @port) ->
    super()

    defaults =
      title: 'Angular Popcorn Time'
      'min-width': 520
      'min-height': 520
      frame: false
      resizable: true
      show: false
      icon: 'assets/images/icon.png'
      transparent: true
      center: true
      'web-preferences': 
        'webaudio': true,
        'web-security': false,
        'use-content-size': true,
        'subpixel-font-scaling': true,
        'direct-write': true,
        'plugins': true

    @settings = Object.assign defaults, options
    @window = @createBrowserWindow @settings

    if not @window.webContents.isDevToolsOpened() and process.env.NODE_ENV is 'dev'
      @window.webContents.toggleDevTools()

    @bindIpc @window

  createBrowserWindow: (settings) ->
    browserWindow = new window settings

    browserWindow.webContents.on 'new-window', (event, url) ->
      event.preventDefault()
      shell.openExternal(url)

    browserWindow

  bindIpc: ->
    ipc.on 'ready', (event, data) =>
      ready = true

      { size, coords, zoom } = data 

      @window.setSize size[0], size[1]

      @window.show()

      return     

    ipc.on 'get-port', (evt, arg) =>
      evt.returnValue = @port


    ipc.on 'close', =>
      app.quit()
      return

    ipc.on 'open-url-in-external', (event, url) ->
      shell.openExternal url
      return

    ipc.on 'focus', =>
      @window.focus()
      return

    ipc.on 'minimize', =>
      @window.minimize()
      return

    ipc.on 'maximize', =>
      @window.maximize()
      return

    ipc.on 'resize', (e, size) ->
      if @window.isMaximized()
        return
      
      width = @window.getSize()[0]
      height = width / size.ratio | 0
      
      @window.setSize width, height

      return 

    ipc.on 'enter-full-screen', =>
      @window.setFullScreen true
      return

    ipc.on 'exit-full-screen', =>
      @window.setFullScreen false
      @window.show()
      return

    return

  loadUrl: (targetUrl) ->
    @window.loadUrl targetUrl

  show: ->
    @window.show()

  close: ->
    @window.close()
    @window = null

module.exports = AppWindow
