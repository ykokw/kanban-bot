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
