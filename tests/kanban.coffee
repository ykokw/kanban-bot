Helper = require('hubot-test-helper')
expect = require('chai').expect
helper = new Helper('./../scripts/kanban.coffee')

describe 'kanban', ->
  room = null

  beforeEach ->
    room = helper.createRoom()

  afterEach ->
    room.destroy()

  context 'user asks Hubot to add a task to kanban', ->
    beforeEach ->
      room.user.say 'yuki', 'kanban add task1'

    it 'should add a task to brain', ->
      expect(room.robot.brain.data.kanban).to.eql ['task1']
