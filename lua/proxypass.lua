local shared = ngx.shared
local fulluri 
local house 
local prefixtable 
local routes 
local prefix
local route 
function gethouse(str)
    -- Eliminate bad cases...
    if string.find(str, "/") == nil then
        return str
    else 
      local c,d = string.gsub(str,"/","",1,1)
      local a,b = string.find(c,"/")
      local n  = string.sub(c,1,b-1 )
      return n
    end
end

-- fetching the house name from uri 
house = gethouse(ngx.var.uri)
-- loading shared routes 
routes = shared.routes
-- loading the prefix shsred memory 
prefixtable = shared.prefix
-- getting prefix from prefix shared memory
prefix = prefixtable:get("prefix")
  local randomone = math.random(1,10)
-- selection of aproproriate house and number of routes associated with it from routes based on random number   
  local takeone = prefix.."_"..house.."_score_"..randomone
  local housevalue = routes:get(takeone)
  local taketwo
  if tonumber(housevalue) == 1 then 
    taketwo = prefix.."_"..house.."_score_"..randomone.."_"..housevalue
  else
    local randomtwo = math.random(1,tonumber(housevalue))
    taketwo = prefix.."_"..house.."_score_"..randomone.."_"..randomtwo
  end
--getting actual access point based on random value 
route = routes:get(taketwo)
ngx.var.container_url = route