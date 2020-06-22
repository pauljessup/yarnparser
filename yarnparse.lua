--super simple yarn parser.
--it's up to you to actually parse commands
--or do something with tags, etc. This just allows you
--to load, etc, nodes from a yarn exported to json.


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

function string:extract(open, close)
    local c=self:split(open)
    local b=c[2]
    b=b:split(close)
    return b[1]
end



yarnparse={
    json=require("json.json")
} 

yarnparse.load=function(self, filename)
    
    local yarn={}
    local parsed, size=love.filesystem.read("string", filename)
    local hashmap={}
    local nodes=self.json.decode(parsed)
    --now to create a loopup table, for faster loading by title
    for i,v in ipairs(nodes) do
        hashmap[v.title]=i
    end

    return {
        file=filename,
        nodes=nodes,
        hashmap=hashmap,

        --get node function--
        get_node=function(self, node)
            --if it's not a node id, use the lookup table
            if(type(node)~="number") then
                --error if title does not exist in lookup table.
                if(self.hashmap[node]==nil) then error("Node " .. node .. " does not exist in " .. self.file  .. ".  Please check spelling.") end
                --if all is kosher, use that lookup table
                node=self.hashmap[node]
            end
        
            --load the node through the ID
            local v=self.nodes[node]
        
            --grab the body, and any choices it has
            local body, choices=self:get_choices(v.body)
            
            return {
                    --this just returns a list containing all the info from
                    --a node. 
                    id=node,
                    title=v.title,
                    tags=v.tags:split(", "),
                    body=yarnparse:parse_body(v.body),
                    choices=choices,
                    colorId=v.colorId
                }
        end,

        --get choice function
        get_choices=function(self, text)
            --this parses the choices it uses to connect to other nodes
            --and returns it as a list.
                local c=text:split("%[%[Answer:")
                local choices={}
                local b=c[1]
                for i,v in ipairs(c) do
                    if(i>1) then
                        v=v:split(']]')
                        v=v[1]
                        local nxt=v:split("|")
                        --splits it so there's the text for the choice, and the node it links to.
                        choices[#choices+1]={text=nxt[1], node=nxt[2]}
                    end
                end
                return b, choices
            end,

            --parse body function

            parse_body=function(self, text)
                local lines=text:split('\n')
                return {
                     text=text,
                     lines=lines,
                     at=0,
                     total=#lines,
                     traverse=function(self)
                        self.at=self.at+1
                        if(self.at>self.total) then return nil end
                        local ret=self.lines[self.at]
                        --check to see if it's a command, if so, do that.
                            if string.match(ret, "<<") then
                                ret=ret:extract("<<", ">>")
                                local f=loadstring(ret)
                                f()
                                --let the main program know we're running a command.
                                return ret, true
                            end
                        return ret, false
                     end,
                     done=function(self)
                        if(self.at>self.total) then return true else return false end
                     end
                }
            end,

            get_node=function(self, node)
                --if it's not a node id, use the lookup table
                if(type(node)~="number") then
                    --error if title does not exist in lookup table.
                    if(self.hashmap[node]==nil) then error("Node " .. node .. " does not exist in " .. self.file  .. ".  Please check spelling.") end
                    --if all is kosher, use that lookup table
                    node=self.hashmap[node]
                end
            
                --load the node through the ID
                local v=self.nodes[node]
            
                --grab the body, and any choices it has
                local body, choices=self:get_choices(v.body)
                
                return {
                        --this just returns a list containing all the info from
                        --a node. 
                        id=node,
                        title=v.title,
                        tags=v.tags:split(", "),
                        body=self:parse_body(v.body),
                        choices=choices,
                        colorId=v.colorId
                    }
            end,
            --make a choice function
            make_choice=function(self, node, choice)
                return self:get_node(node.choices[choice].node)
            end

    }
end
