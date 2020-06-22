# yarnparser
A super simple Love2d/Lua code that takes in Yarn Spinner dialogue trees exported to JSON. More to come here later. Right now it just allows you to select dialogue nodes and look at what's inside of them, including any choices, and what nodes those choices link to.

Parsing commands (<< >> in the text) will be up to the individual, since each game engine might want to parse commands differntly.

The Yarn Editor can be found here:
https://github.com/YarnSpinnerTool/YarnEditor

A simple example of how to use:

--this loads the testYarn.json file
local test=yarnparse:load_file("testYarn.json")

--this gets a specific node
local node=yarnparse:get_node("Start")

--and this will print out the body.
print(node.body)

  
