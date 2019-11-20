local barPoke = nil
local icons = {}

-- Public functions
function init()
   barPoke = g_ui.displayUI('barpoke', modules.game_interface.getRootPanel())
   barPoke:setVisible(false)  
   barPoke:move(250,50)
   
   connect(g_game, 'onTextMessage', getParams)
   connect(g_game, { onGameEnd = hide } )
   connect(g_game, { onGameStart = show } )

   createIcons()
end

function terminate()
   disconnect(g_game, { onGameEnd = hide })
   disconnect(g_game, 'onTextMessage', getParams)

   destroyIcons()
   barPoke:destroy()
end


function getParams(mode, text)
if not g_game.isOnline() then return end
   if mode == MessageModes.Failure then 
      if string.sub(text, 1, 9) == "BarClosed" then
      hide()
      elseif string.sub(text, 1, 7) == "Pokebar" then
         atualizarBar(text)
   end
end
end

function atualizarBar(text)
if not g_game.isOnline() then return end
local talk = "/poke"
show()
cleanAllPokes()
local t = string.explode(text, "/")
for i=2, #t do
x= i-1
local poke = t[i]
local progress = icons['Icon'..x].progress
changeIconPoke(x, poke)
progress.onClick = function() g_game.talk(talk.." "..poke.."")
end 
end
end



function changeIconPoke(i, poke)
if not g_game.isOnline() then return end
   local icon = icons['Icon'..i].icon
local image = "pokes/"..poke..".png"
   icon:setImageSource(image)
end

function createIcons()
   local d = 45
   local image = "pokes/portait.png"
   for i = 1, 6 do
      local icon = g_ui.createWidget('IconPoke', barPoke)
      local progress = g_ui.createWidget('Poke', barPoke) 
      icon:setId('Icon'..i)  
      progress:setId('Progress'..i)  
      icons['Icon'..i] = {icon = icon, progress = progress, dist = (i == 1 and 5 or i == 2 and 45 or d + ((i-2)*34)), event = nil}
      icon:setMarginLeft(icons['Icon'..i].dist)
      icon:setImageSource(image)
      icon:setMarginTop(4)
      progress:fill(icon:getId())
   end
end

function cleanAllPokes()
   local image = "pokes/portait.png"
   for i = 1, 6 do
       local icon = icons['Icon'..i].icon
       icon.onClick = function() end
      icon:setImageSource(image)
     local progress = icons['Icon'..i].progress
     progress.onClick = function() g_game.talk("") end  
end               
end

function hide()
   barPoke:setVisible(false)
end

function show()
   barPoke:setVisible(true)
end
-- End public functions