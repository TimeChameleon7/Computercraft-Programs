module('turtle')
--https://computercraft.info/wiki/Turtle_(API)

--movement
function forward() return true end
function back() return true end
function up() return true end
function down() return true end
function turnLeft() return true end
function turnRight() return true end

--fueling
function refuel(--[[quantity: number]]) return true end
function getFuelLevel() return 1 end
function getFuelLimit() return 1 end

--inventory
function select() return true end
function getSelectedSlot() return 1 end
function getItemCount(--[[slotNum: number]]) return 1 end
function getItemSpace(--[[slotNum: number]]) return 1 end --returns number of items remaining to fill the stack
function getItemDetail(--[[slotNum: number]]) return {} end
function equipLeft() return true end
function equipRight() return true end
function compareTo(slot --[[number]]) end --ompare the current selected slot and the given slot to see if the items are the same.
function transferTo(slot --[[number]] --[[quantitiy: number]]) end

--world interacting
function place(--[[signText: string]]) return true end
function placeUp() return true end
function placeDown() return true end
function drop(--[[count: number]]) return true end --returns false if attempting to drop into a full inventory
function dropUp(--[[count: number]]) return true end
function dropDown(--[[count: number]]) return true end
function suck(--[[amount: number]]) return true end --returns false if turtle cannot pickup the item
function suckUp(--[[amount: number]]) return true end
function suckDown(--[[amount: number]]) return true end

--world reading
function detect() return true end
function detectUp() return true end
function detectDown() return true end
function inspect() return true, {} end
function insepctUp() return true, {} end
function inspectDown() return true, {} end
function compare() return true end --Detects if the block in front is the same as the one in the currently selected slot
function compareUp() return true end
function compareDown() return true end

--crafty turtles
function craft(quantity --[[number]]) return true end

--mining, felling, digging, or farming turtles
function dig(--[[toolSide: string]]) return true end
function digUp(--[[toolSide: string]]) return true end
function digDown(--[[toolSide: string]]) return true end

--any tool turtle
function attack(--[[toolSide: string]]) return true end
function attackUp(--[[toolSide: string]]) return true end
function attackDown(--[[toolSide: string]]) return true end
