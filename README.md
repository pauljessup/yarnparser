# yarnparser
A super simple Love2d/Lua code that takes in Yarn Spinner dialogue trees exported to JSON. More to come here later. Right now it just allows you to select dialogue nodes and look at what's inside of them, including any choices, and what nodes those choices link to.

Parsing commands (<< >> in the text) will be up to the individual, since each game engine might want to parse commands differntly.

The Yarn Editor can be found here:
https://github.com/YarnSpinnerTool/YarnEditor

A simple example of how to use in a love2d project:

--require the library


require('yarnparse')


function love.load()

--load the file. Though love.load isn't the best for this in an actual game

    yarn=yarnparse:load("testYarn.json")  
    
end

function love.update(dt)

    --this is a simple example. Something more complex and we would put
    
    --loading the node and traversing it here.
    
end

function love.draw()

--load up the Start node.

    local node=yarn:get_node("Start")

--traverse through the body text. This goes line by line

--each time you call it, it moves to the next line.

--it returns two variables- text and command.

--text is the text of the line. Command is if it's executing a command

--and should not be displayed.

    local text, command=node.body:traverse()
    
--if it's not a command, print the text. If it is a lua command, it just

--runs it in the body:traverse function.

    if(not command) then love.graphics.print(text, 100, 80) end
    
end
  

another example-
some dialogue nodes will have choices the player needs to make, and are linked to other
nodes. Using this is somewhat simple.

node.choices

is a lua list that stores all the choices. Each choise has a node that it points to and text to display
for that choice. For example, this will list the choices for the player-

function love.draw()

    for i,v in ipairs(node.choices) do
    
        love.graphics.print(v.text, 100, 120+i*12)
    
    end

end

Now let's say you have two choices, and the player selects the second choice. To move to the selected dialogue node, just use-


node=yarn:make_choice(node.choices[choice])


where choice is a variable that stores whatever choice the user made (stored in a number corresponding
to the list that was printed above). 

For example, let's say you have three choices inside that dialogue node. If the player choose #3 just do


node=yarn:make_choice(node.choices[3])


And this will make the current node the next node in that dialogue tree. It's a fairly simple way
to traverse the dialogue tree setup. More examples will come later, using an actual example .json file
built in Yarn.
