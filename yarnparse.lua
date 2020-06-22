--super simple yarn parser.
--it's up to you to actually parse commands
--or do something with tags, etc. This just allows you
--to load, etc, nodes from a yarn exported to json.

-- some ideas:
-- add in a line by line return
-- will be easier to get choices etc, by line then
-- will also be easier to hit commands then.


function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

yarnparse={
    json=require("json.json"),
    nodes={},
    file=""
} 

yarnparse.load_file=function(self, filename)
    local parsed, size=love.filesystem.read("string", filename)
    self.nodes=self.json.decode(parsed)
end

yarnparse.get_choices=function(self, text)
--this parses the choices it uses to connect to other nodes
--and returns it as a list.
    local c=text:split("%[%[Answer:")
    local choices={}
    local b=c[1]
    for i,v in ipairs(c) do
        if(i>1) then
            v=v:gsub(']]', '')
            local nxt=v:split("|")
            choices[nxt[1]]=nxt[2]
        end
    end
    return b, choices
end

--returns a list of each line of the body
--which will make it easier to parse commands
yarnparse.parse_body=function(self, node)
    if(type(node)~="number") then
        node=yarnparse:get_node(node)    
    else
        node=self.nodes[node]
    end
    return body:split('\n')
end

yarnparse.get_node=function(self, title)
    if(type(title)=="number") then
        local v=self.nodes[title]
        local body, choices=self:get_choices(v.body)
        return {
            --this just returns a list containing all the info from
            --a node. 
            id=i,
            title=v.title,
            tags=v.tags:split(", "),
            body=body,
            choices=choices,
            colorId=v.colorId
        }
    else
            for i,v in ipairs(self.nodes) do
                if(v.title==title) then
                    local body, choices=self:get_choices(v.body)
                    return {
                        --this just returns a list containing all the info from
                        --a node. 
                        id=i,
                        title=v.title,
                        tags=v.tags:split(", "),
                        body=body,
                        choices=choices,
                        colorId=v.colorId
                    }
                end
            end
    end
end

