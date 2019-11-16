extends Node

signal create
signal player_change_dir
signal store_block
signal put_block
signal seed_pickup
signal seed_plant
signal fork_block_destroy

var current_level : int = 1
var levels : Array = [
    "Level1",
    "Level2",
    "Level3",
    "Level4",
    "Level5",
    "Level6"
]
