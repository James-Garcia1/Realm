extends Node
var currentRegionID

var gameStart = true

var Dialogue
var dialogueState02 = "000"

var bridgeLength01 = 1
var bridgeMaxLength01 = 9

var playerWood = 0
var playerPositionLoad = Vector2.ZERO

#Region 0 Tree spawn locations
var treeSpawnCoordinates0 = [Vector2(1375,260), Vector2(770,290),
Vector2(155,495), Vector2(1325,915), Vector2(1840,580), Vector2(1895,1135),
Vector2(1325,1530), Vector2(555,1485), Vector2(650,910), Vector2(-25,1080)]


#Controls wheter trees will spawn in scene array index indicates scene
var treeSpawn = { }
var energyFactor = 20

var currentTreeIndex
