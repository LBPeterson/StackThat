-- Set Library Folders
LIBRARYPATH = "libs"
LIBRARYPATH = LIBRARYPATH .. "."

local Gamestate = require( LIBRARYPATH.."hump.gamestate"    )

local function recursiveRequire(folder, tree)
    local tree = tree or {}
    for i,file in ipairs(love.filesystem.getDirectoryItems(folder)) do
        local filename = folder.."/"..file
        if love.filesystem.isDirectory(filename) then
            recursiveRequire(filename)
        elseif file ~= ".DS_Store" then
            require(filename:gsub(".lua",""))
        end
    end
    return tree
end


local function extractFileName(str)
	return string.match(str, "(.-)([^\\/]-%.?([^%.\\/]*))$")
end

function love.load()
  recursiveRequire("src")
  Gamestate.registerEvents()
  Gamestate.switch(Menu)
end

function love.update(dt)

end

function love.keyreleased(key)
   if key == "escape" then
      love.event.quit()
   end

end

function love.draw()

end
