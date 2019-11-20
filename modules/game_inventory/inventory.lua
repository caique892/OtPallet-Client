InventorySlotStyles = {
  [InventorySlotHead] = "HeadSlot",
  [InventorySlotNeck] = "NeckSlot",
  [InventorySlotBack] = "BackSlot",
  [InventorySlotBody] = "BodySlot",
  [InventorySlotRight] = "RightSlot",
  [InventorySlotLeft] = "LeftSlot",
  [InventorySlotLeg] = "LegSlot",
  [InventorySlotFeet] = "FeetSlot",
  [InventorySlotFinger] = "FingerSlot",
  [InventorySlotAmmo] = "AmmoSlot"
}

inventoryWindow = nil
inventoryPanel = nil
inventoryButton = nil
purseButton = nil

function init()
  connect(LocalPlayer, { onInventoryChange = onInventoryChange })
  connect(g_game, { onGameStart = refresh })

  g_keyboard.bindKeyDown('Ctrl+I', toggle)

  inventoryButton = modules.client_topmenu.addRightGameToggleButton('inventoryButton', tr('Inventory') .. ' (Ctrl+I)', '/images/topbuttons/inventory', toggle)
  inventoryButton:setOn(true)

  inventoryWindow = g_ui.loadUI('inventory', modules.game_interface.getRightPanel())
  inventoryWindow:disableResize()
  inventoryPanel = inventoryWindow:getChildById('contentsPanel')



  refresh()
  inventoryWindow:setup()
end

function terminate()
  disconnect(LocalPlayer, { onInventoryChange = onInventoryChange })
  disconnect(g_game, { onGameStart = refresh })

  g_keyboard.unbindKeyDown('Ctrl+I')

  inventoryWindow:destroy()
  inventoryButton:destroy()
end

function refresh()
  local player = g_game.getLocalPlayer()
  for i = InventorySlotFirst, InventorySlotPurse-1 do
    if g_game.isOnline() then
      onInventoryChange(player, i, player:getInventoryItem(i))
    else
      onInventoryChange(player, i, nil)
    end
  end

  --purseButton:setVisible(g_game.getFeature(GamePurseSlot))
end

function toggle()
  if inventoryButton:isOn() then
    inventoryWindow:close()
    inventoryButton:setOn(false)
  else
    inventoryWindow:open()
    inventoryButton:setOn(true)
  end
end

function onMiniWindowClose()
  inventoryButton:setOn(false)
end
function useDirect(self)
	g_game.use(self.it)
end
function useDis(self)
	modules.game_interface.startUseWith(self.it)
end
-- hooked events
function onInventoryChange(player, slot, item, oldItem)


  local itemWidget = inventoryPanel:getChildById('slot' .. slot)
  if item then
	itemWidget:setStyle('Item')
	print(item:getId())
	itemWidget.it = item
	if item:getId() == 2580 then
		itemWidget:setImageSource("/images/game/slots/rod.png")
	elseif item:getId() == 2547 then
		itemWidget:setImageSource("/images/game/slots/coins.png")
	elseif item:getId() == 2550 then
		itemWidget:setImageSource("/images/game/slots/order.png")
	elseif item:getId() == 2120 then
		itemWidget:setImageSource("/images/game/slots/rope.png")
	elseif item:getId() == 2382 then
		itemWidget:setImageSource("/images/game/slots/pokedex.png")	
	elseif item:getId() == 1988 then
		itemWidget:setImageSource("/images/game/slots/badge.png")
	elseif item:getId() == 1987 then
		itemWidget:setImageSource("/images/game/slots/pokebag.png")

	else
		itemWidget:setItem(item)
	end

	itemWidget.leitem = item
  else
    itemWidget:setStyle(InventorySlotStyles[slot])
    itemWidget:setItem(nil)
  end


end
