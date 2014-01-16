socket = io.connect()

socket.on 'connect', ->

module.exports = socket

