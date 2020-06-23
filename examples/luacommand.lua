require('../yarnparse')
function love.load()
    yarn=yarnparse:load("luacommand.json")
    node=yarn:get_node("Start")   

    --get our starting text, store it in the text buffer.
    local script=node.body:traverse() --this allows us to go line by line
    text=script.text --our global text buffer, for showing one line at a time.
    command=false -- this is just so we don't accidently display the command.
end

function love.update(dt)

    if(not node.body:done()) then 
        --we need to go line by line
        --in order to trigger the command.
        --This allows us to do complicated event parsing...
        script, command=node.body:traverse()
    end
end

function love.draw()
    --here is our current text.
    if(not command) then
        love.graphics.print(text, 100, 80)
    end
end