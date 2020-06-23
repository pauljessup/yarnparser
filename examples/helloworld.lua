require('../yarnparse')

function love.load()
    --load up the yarn file.
    yarn=yarnparse:load("helloworld.json")

    --let's start with Start
    --some would say it should automatically Start with Start?
    --but I like giving the coder more control.
    node=yarn:get_node("Start")   
end

function love.update(dt)

end

function love.draw()
    --print that text!
    love.graphics.print(node.body.text, 100, 80)
end