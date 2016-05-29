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

  #### Features of kanban

  context 'user asks Hubot to add a task to kanban', ->
    beforeEach ->
      room.user.say 'yuki', 'kanban add task1'

    it 'should add a task to brain', ->
      expect(room.robot.brain.data.kanban).to.eql ['task1']
  
  context 'user asks Hubot to add a empty task to kanban', ->
    beforeEach ->
      room.user.say 'yuki', 'kanban add '

    it 'should add a task to brain', ->
      expect(room.robot.brain.data.kanban).to.eql []
      expect(room.messages).to.eql [
        ['yuki', 'kanban add ']
        ['hubot', '@yuki Can not add empty task']
      ]
  
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
  
  context 'user asks Hubot to create todo list from kanban', ->
    beforeEach ->
      room.robot.brain.data.kanban = ['task1', 'task2', 'task3', 'task4', 'task5']
      room.user.say 'yuki', 'kanban todo 1, 3, 5'

    it 'should create todo list from brain', ->
      expect(room.robot.brain.data.kanban).to.eql ['task2', 'task4']
      expect(room.robot.brain.data.todo).to.eql ['task1', 'task3', 'task5']
      expect(room.messages).to.eql [
        ['yuki', 'kanban todo 1, 3, 5']
        ['hubot', '@yuki Today:\n1. task1\n2. task3\n3. task5\n']
      ]
  
  #### Features of todo list
