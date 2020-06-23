require('../yarnparse')

--really simple menu for displaying choices.
--like dumb simple.
menu={
    --slows down input.
    timer=4.5,
    --select item.
    select=1
}

function love.load()
    --load up the yarn file.
    yarn=yarnparse:load("twochoices.json")

    --let's start with Start
    --some would say it should automatically Start with Start?
    --but I like giving the coder more control.
    node=yarn:get_node("Start") 
    
    --FPS globals--
    min_dt = 1/60 --set to a smooth 60 fps
    next_time = love.timer.getTime()    
end

function love.update(dt)
    --limit FPS
    next_time = next_time + min_dt
    local cur_time = love.timer.getTime()

    --the yarn code--
    --does this node have ahoices for the player to make? if so,
    --update and use the simple as salt menu.
    if(node.has_choices) then
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
            menu.timer=menu.timer-0.2
        end
end
end

function love.draw()
    --print that text!
    love.graphics.print(node.body.text, 100, 80)
    if(node.has_choices) then
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