# kanban bot script

module.exports = (robot) ->
  robot.brain.data.kanban = []
  robot.brain.data.todo = []
  robot.brain.data.result = []
  robot.brain.data.completedNumber = [0,0,0,0,0,0,0]
  robot.hear /kanban\s*add (.*)$/i, (res) ->
    if res.match[1] == ''
      res.reply 'Can not add empty task'
    else
      robot.brain.data.kanban.push(res.match[1])
      res.reply 'Added ' + res.match[1] + ' to kanban'

  robot.hear /kanban\s*list/i, (res) ->
    if robot.brain.data.kanban.length == 0
      res.reply 'Nothing task in kanban'
    else
      messages = '\n'
      messages = messages + (i + 1) + '. ' + task + '\n' for task, i in robot.brain.data.kanban
      res.reply messages
  
  robot.hear /kanban\s*del\s*([0-9]*)/i, (res) ->
    index = parseInt(res.match[1], 10) - 1
    task = ""
    if index < robot.brain.data.kanban.length
      task = robot.brain.data.kanban[index]
      robot.brain.data.kanban.splice(index, 1)
    res.reply 'Deleted ' + task
  
  robot.hear /kanban\s*todo\s*(.*)/ig, (res) ->
    indexStrList = res.match[0].split(',')
    for indexStr, i in indexStrList
      if i == 0
        index = parseInt(indexStr.replace(/kanban\s*todo\s*/, ''), 10) - 1
      else
        index = parseInt(indexStr.replace(/\s*/, ''), 10) - 1
      if index < robot.brain.data.kanban.length
        robot.brain.data.todo.push(robot.brain.data.kanban[index])
        robot.brain.data.kanban.splice(index, 1, '')
    newList = []
    for task, n in robot.brain.data.kanban
      if robot.brain.data.kanban[n] != ''
        newList.push(robot.brain.data.kanban[n])
    robot.brain.data.kanban = newList
    messages = 'Today:\n'
    messages = messages + (i + 1) + '. ' + task + '\n' for task, i in robot.brain.data.todo
    res.reply messages

  robot.hear /kanban\s*import\s*([\s\S]*)/i, (res) ->
    messages = ""
    str = res.match[1]
    taskList = str.split('\n')
    for task in taskList
      if task != ''
        robot.brain.data.kanban.push(task)
    messages = '\n'
    messages = messages + (i + 1) + '. ' + task + '\n' for task, i in robot.brain.data.kanban
    res.reply messages

  robot.hear /todo\s*done\s*([0-9]*)/i, (res) ->
    index = parseInt(res.match[1], 10) - 1
    if index < robot.brain.data.todo.length
      task = robot.brain.data.todo[index]
      robot.brain.data.result.push(task)
      robot.brain.data.todo.splice(index, 1, '')
    res.reply 'Done: ' + task

  robot.hear /todo\s*list/i, (res) ->
    if robot.brain.data.todo.length == 0
      res.reply 'Nothing to do !' 
    else
      messages = 'Today:\n'
      for task, i in robot.brain.data.todo
        if task != ''
          messages = messages + (i + 1) + '. ' + task + '\n'
      res.reply messages
  
  robot.hear /todo\s*reset/i, (res) ->
    for task, i in robot.brain.data.todo
      continue if task == ''
      robot.brain.data.kanban.push(task)
    robot.brain.data.todo = []
    res.reply 'All task moved to kanban list'
  
  robot.hear /result\s*show/i, (res) ->
    if robot.brain.data.result.length == 0
      res.reply 'No complated task...'
    else
      currentCompletedNumber = robot.brain.data.result.length
      robot.brain.data.completedNumber.push(currentCompletedNumber * 10)
      if robot.brain.data.completedNumber.length > 7
        robot.brain.data.completedNumber.shift()

      chartUrl = 'http://chart.apis.google.com/chart'
      chs = '?chs=600x150'
      chd = '&chd=t:' + robot.brain.data.completedNumber.join(',')
      cht = '&cht=lc'

      messages = 'Result:\n```\n'
      for task, i in robot.brain.data.result
        if task != ''
          messages = messages + '- ' + task + '\n'
      messages = messages + '```\n' +
        'Completed task number: ' + currentCompletedNumber + '\n' +
        chartUrl + chs + chd + cht + '\n'

      res.reply messages

  robot.hear /result\s*reset/i, (res) ->
    robot.brain.data.result = []
    res.reply 'Result of completed tasks is reset'
