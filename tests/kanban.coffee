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
        ['hubot', '@yuki Added task2 to kanban']
        ['yuki', 'kanban list']
        ['hubot', '@yuki \n- 1. task1\n- 2. task2\n']
      ]

  context 'user asks Hubot to show empty kanban list', ->
    beforeEach ->
      room.user.say 'yuki', 'kanban list'

    it 'should return message', ->
      expect(room.messages).to.eql [
        ['yuki', 'kanban list']
        ['hubot', '@yuki Nothing task in kanban']
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
        ['hubot', '@yuki Today:\n- 1. task1\n- 2. task3\n- 3. task5\n']
      ]
  
  #### Features of todo list

  context 'user says to hubot that the task is done', ->
    beforeEach ->
      room.robot.brain.data.todo = ['task1', 'task2', 'task3']
      co =>
        yield room.user.say 'yuki', 'todo done 2'
        yield room.user.say 'yuki', 'todo list'

    it 'should delete a task from todo list', ->
      # todo list keeps index of todo list
      # the completed task is set empty string
      expect(room.robot.brain.data.todo).to.eql ['task1', '', 'task3']
      expect(room.messages).to.eql [
        ['yuki', 'todo done 2']
        ['hubot', '@yuki Done: task2']
        ['yuki', 'todo list']
        ['hubot', '@yuki Today:\n- 1. task1\n- 3. task3\n']
      ]

  context 'user asks Hubot to show todo list', ->
    beforeEach ->
      room.robot.brain.data.todo = ['task1', '', 'task3']
      room.user.say 'yuki', 'todo list'

    it 'should return todo list', ->
      expect(room.messages).to.eql [
        ['yuki', 'todo list']
        ['hubot', '@yuki Today:\n- 1. task1\n- 3. task3\n']
      ]
  
  context 'user asks Hubot to show empty todo list', ->
    beforeEach ->
      room.user.say 'yuki', 'todo list'

    it 'should return message', ->
      expect(room.messages).to.eql [
        ['yuki', 'todo list']
        ['hubot', '@yuki Nothing to do !']
      ]
  
  context 'user asks Hubot to reset todo list', ->
    beforeEach ->
      room.robot.brain.data.kanban = ['task4', 'task5']
      room.robot.brain.data.todo = ['task1', '', 'task3']
      room.user.say 'yuki', 'todo reset'

    it 'should reset todo list', ->
      expect(room.robot.brain.data.kanban).to.eql ['task4', 'task5', 'task1', 'task3']
      expect(room.robot.brain.data.todo).to.eql []
      expect(room.messages).to.eql [
        ['yuki', 'todo reset']
        ['hubot', '@yuki All task moved to kanban list']
      ]

  #### Features of result of completed tasks

  context 'user asks Hubot to show result of completed todo list', ->
    beforeEach ->
      room.robot.brain.data.todo = ['task1', 'task2']
      co =>
        yield room.user.say 'yuki', 'todo done 1'
        yield room.user.say 'yuki', 'todo done 2'
        yield room.user.say 'yuki', 'result show'

    it 'should shows result', ->
      expect(room.robot.brain.data.result).to.eql ['task1', 'task2']
      expect(room.robot.brain.data.todo).to.eql ['', '']
      expect(room.messages).to.eql [
        ['yuki', 'todo done 1']
        ['hubot', '@yuki Done: task1']
        ['yuki', 'todo done 2']
        ['hubot', '@yuki Done: task2']
        ['yuki', 'result show']
        ['hubot', '@yuki Result:\n```\n- task1\n- task2\n```\n']
      ]

  context 'user asks Hubot to reset result of completed result', ->
    beforeEach ->
      room.robot.brain.data.result = ['task1', 'task2']
      co =>
        yield room.user.say 'yuki', 'result reset'

    it 'should reset result', ->
      expect(room.robot.brain.data.result).to.eql []
      expect(room.messages).to.eql [
        ['yuki', 'result reset']
        ['hubot', '@yuki Result of completed tasks is reset']
      ]

  #### Other test

  context 'user asks Hubot with messages that is included multiple space', ->
    beforeEach ->
      co =>
        yield room.user.say 'yuki', 'kanban  list'

    it 'should not ignore message that is included multiple space', ->
      expect(room.messages).to.eql [
        ['yuki', 'kanban  list']
        ['hubot', '@yuki Nothing task in kanban']
      ]
