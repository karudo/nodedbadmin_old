
class zxc extends ee.c.Mixin
  #init: -> console.log '++++++++++++++++'
  mixined: -> console.log 'mixined'
  hui: -> console.log '!!!!!!!'

class qwe extends ee.c.Base
  @mixin zxc

q = new qwe
