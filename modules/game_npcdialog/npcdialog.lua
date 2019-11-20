local npcDialogWindow = nil

function init()
  connect(g_game, { onGameEnd = onGameEnd })
  npcDialogWindow = g_ui.displayUI('npcDialog')
  npcDialogWindow:hide()
  ProtocolGame.registerExtendedOpcode(80, NpcDialog)  
end

function terminate()
  disconnect(g_game, { onGameEnd = onGameEnd })
  npcDialogWindow:destroy()
  ProtocolGame.unregisterExtendedOpcode(80)
end

function onGameEnd()
  if npcDialogWindow:isVisible() then
    npcDialogWindow:hide()
	end
end

function show()
  npcDialogWindow:show()
  npcDialogWindow:raise()
  addEvent(function() g_effects.fadeIn(npcDialogWindow, 250) end)
end

function hide()
  addEvent(function() g_effects.fadeOut(npcDialogWindow, 250) end)
  scheduleEvent(function() npcDialogWindow:hide() end, 250)
end

local function clickOptionButton(option) 
  g_game.talk(option)
end

function NpcDialog(protocol, opcode, buffer)
  local param = buffer:split('@') 

  show()
  npcDialogWindow:getChildById('labelNpcName'):setText(param[1])
  npcDialogWindow:getChildById('labelTalk'):setText(param[2])
  npcDialogWindow:getChildById('optionButtonOne'):setVisible(false)
  npcDialogWindow:getChildById('optionButtonTwo'):setVisible(false)
  npcDialogWindow:getChildById('optionButtonThree'):setVisible(false)

  if (param[3] ~= nil) then
    local options = param[3]:split('&') 

    if (options[1]) then
      npcDialogWindow:getChildById('optionButtonOne'):setVisible(true)
      npcDialogWindow:getChildById('optionButtonOne'):setText(options[1])
      npcDialogWindow:getChildById('optionButtonOne').onClick = function() clickOptionButton(options[1]) end
    end

    if (options[2]) then
      npcDialogWindow:getChildById('optionButtonTwo'):setVisible(true)
      npcDialogWindow:getChildById('optionButtonTwo'):setText(options[2])
      npcDialogWindow:getChildById('optionButtonTwo').onClick = function() clickOptionButton(options[2]) end
    end

    if (options[3]) then
      npcDialogWindow:getChildById('optionButtonThree'):setVisible(true)
      npcDialogWindow:getChildById('optionButtonThree'):setText(options[3])
      npcDialogWindow:getChildById('optionButtonThree').onClick = function() clickOptionButton(options[3]) end
    end
  end
end
