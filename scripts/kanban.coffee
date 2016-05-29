# kanban bot script

module.exports = (robot) ->
  robot.brain.data.kanban = []
  robot.hear /kanban add (.*)$/i, (res) ->
    robot.brain.data.kanban.push(res.match[1])
    res.reply 'Added kanban to ' + res.match[1]

  robot.hear /kanban list/i, (res) ->
    messages = '\n'
    messages = messages + (i + 1) + '. ' + task + '\n' for task, i in robot.brain.data.kanban
    res.reply messages;
  
  robot.hear /kanban del ([0-9]*)/i, (res) ->
    index = parseInt(res.match[1], 10) - 1
    task = ""
    if index < robot.brain.data.kanban.length
      task = robot.brain.data.kanban[index]
      robot.brain.data.kanban.splice(index, 1)
    res.reply 'Deleted ' + task
