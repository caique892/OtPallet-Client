local config = {
	stones = { -- { Id da Pedra de evolução , nome da imagem }
		[1]  = {11441,"leafStone"},
		[2]  = {11447,"fireStone"},
		[3]  = {11442,"waterStone"},
		[4]  = {11454,"iceStone"},
		[5]  = {11449,"crystalStone"},
		[6]  = {11450,"darknessStone"},
		[7]  = {11452,"enigmaStone"},
		[8]  = {11453,"heartStone"},
		[9]  = {11446,"punchStone"},
		[10] = {11445,"rockStone"},
		[11] = {11444,"thunderStone"},
		[12] = {11443,"venomStone"}
	},
	qtdDollar = 2000 -- = equivale a 20 Hundred Dollar
}

slot1 = nil
slot2 = nil
slot3 = nil

function init()			
	connect(g_game, { onGameEnd = onGameEnd })	
	ProtocolGame.registerExtendedOpcode(12,function(protocol, opcode, buffer) end)
	
	slotMachine = g_ui.displayUI('slot_machine.otui')
	slotMachine:hide()
	
	btnMachine = modules.client_topmenu.addRightButton('Slot Machine', tr('Slot Machine'), '/images/game/machine/icone_machine', toggle)
	
	g_keyboard.bindKeyPress('CTRL+E', toggle)
	
	slot1 = slotMachine:recursiveGetChildById('slot1')
	slot2 = slotMachine:recursiveGetChildById('slot2')
	slot3 = slotMachine:recursiveGetChildById('slot3')
end

function hide()
  addEvent(function() g_effects.fadeOut(slotMachine, 250) end)
  scheduleEvent(function() slotMachine:hide() end, 250)
end

function show()
  slotMachine:show()
  slotMachine:raise()
  slotMachine:focus()
  addEvent(function() g_effects.fadeIn(slotMachine, 250) end)
end

function terminate()
	disconnect(g_game, { onGameEnd = onGameEnd })
	ProtocolGame.unregisterExtendedOpcode(12)
	slotMachine:destroy()
	btnMachine:destroy()
end

function onGameEnd()
  if slotMachine:isVisible() then
    slotMachine:hide()
  end
end

function toggle()
  if slotMachine:isVisible() then
    hide()
  else
    show()
  end
end

function Jogar()
	local idStone = 1
	local qtd = #config.stones
	local slt1, slt2, slt3 = math.random(1, qtd), math.random(1, qtd), math.random(1, qtd)
	
	if getDollar() >= config.qtdDollar then
		slot1:setImageSource('/images/game/machine/Stones/'..config.stones[slt1][2]..'')
		slot2:setImageSource('/images/game/machine/Stones/'..config.stones[slt2][2]..'')
		slot3:setImageSource('/images/game/machine/Stones/'..config.stones[slt3][2]..'')

		if ( (slt1 == slt2 ) and (slt2 == slt3) ) then
		displayInfoBox(tr('Slot Machine'), tr('Voce ganhou uma '..config.stones[slt1][2]))
		idStone = config.stones[slt1][1]
		end
		g_game.getProtocolGame():sendExtendedOpcode(12,idStone)			
	else
	displayInfoBox(tr('Slot Machine'), tr('Voce nao tem Hundred Dollar o suficiente para jogar!'))	
	end	
end

function getDollar() 
	return g_game.getLocalPlayer():getItemsCount(3031) + (g_game.getLocalPlayer():getItemsCount(3035)* 100) + (g_game.getLocalPlayer():getItemsCount(3043) * 10000)
end