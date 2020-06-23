require('../yarnparse')

--a stupid simple menu for our test purposes.

menu={
    --slows down input.
    timer=4.5,
    --select item.
    select=1
}


function love.load()
    yarn=yarnparse:load("NITWstyle.json")
    node=yarn:get_node("Start")   

    --get our starting text, store it in the text buffer.
    local script=node.body:traverse() --this allows us to go line by line
    text=script.who .. ": " .. script.text --our global text buffer, for showing one line at a time.


    --FPS globals--
    min_dt = 1/60 --set to a smooth 60 fps
    next_time = love.timer.getTime()      
end

function love.update(dt)
    --limit FPS
    next_time = next_time + min_dt
    local cur_time = love.timer.getTime()

    --code you should actually care about, lol
    
    --slow down space bar
    if(not node.body:done()) then --are we at the bottom? If not, keep traversing.
            if(menu.timer<01) then
                menu.timer=4.5
                --move to the next line on the body of the node. If it's done, do nothing.
                
                    --if not, check to see if space it prssed. 
                    --if it is, move to the next line in the body
                    if(love.keyboard.isDown("space")) then
                        --the text is the text, and the command is whether or not
                        --the text is actually a lua command and should be skipped.
                        local script=node.body:traverse()
                        text=script.who .. ": " .. script.text
                    end
                else
                    menu.timer=menu.timer-0.5
                end
    end

    --In case there arechoices,
    --display our simple menu
    if(node.has_choices) and node.body:done() then

        if(menu.timer<0.1) then
            menu.timer=4.5
            if(love.keyboard.isDown("up")) then
                menu.select=menu.select+1
                if(menu.select>=#node.choices) then 
                    menu.select=1
                end
            end

            if(love.keyboard.isDown("down")) then
                menu.select=menu.select-1
                if(menu.select<=0) then 
                    menu.select=#node.choices
                end  
            end

            if love.keyboard.isDown("space")  then
                --if the player pressed space, they made a selection
                --so now we move to the chosen node.
                node=yarn:make_choice(node, menu.select)
            end
        else
            menu.timer=menu.timer-0.5
        end
    end


end

function love.draw()
    --here is our current text.
    love.graphics.print(text, 100, 80)
    love.graphics.print("-Press Spacebar to Cycle Through Text-", 0, 0)

    --display the menu
    if(node.has_choices and node.body:done()) then
        for i,v in ipairs(node.choices) do
            --our menu selection. The selected text is a diff color
            if(i==menu.select) then love.graphics.setColor(0.9, 0.4, 0.3) end
            --and this is the actual text itself.
            love.graphics.print(v.text, 100, 200+(i*20))
            --------------------------------------
            if(i==menu.select) then love.graphics.setColor(1, 1, 1) end
        end
    end
    
end