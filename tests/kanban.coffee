Helper = require('hubot-test-helper')
expect = require('chai').expect
co     = require('co')
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
  
  context 'user asks Hubot to show kanban list', ->
    beforeEach ->
      room.robot.brain.data.kanban = ['task1']
      co =>
        yield room.user.say 'yuki', 'kanban add task2'
        yield room.user.say 'yuki', 'kanban list'

    it 'should return task list', ->
      expect(room.robot.brain.data.kanban).to.eql ['task1', 'task2']
      expect(room.messages).to.eql [
        ['yuki', 'kanban add task2']
        ['hubot', '@yuki Added kanban to task2']
        ['yuki', 'kanban list']
        ['hubot', '@yuki \n1. task1\n2. task2\n']
      ]
  
  context 'user asks Hubot to delete task from kanban', ->
    beforeEach ->
      room.user.say 'yuki', 'kanban add task1'
      room.user.say 'yuki', 'kanban del 1'

    it 'should delete a task from brain', ->
      expect(room.robot.brain.data.kanban).to.eql []
