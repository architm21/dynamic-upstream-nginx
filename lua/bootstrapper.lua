-- author archi 

local delay =5 -- in seconds
local new_timer = ngx.timer.at
local log = ngx.log
local ERR = ngx.ERR
local shared = ngx.shared
local check
--decode writes the data to the shared memory
function loader(json) 
    local prefixtable = shared.prefix 
    local routes = shared.routes
    local keys = shared.routes
    local prefix = prefixtable:get("prefix")
    if prefix == 1 then
      for key,value in pairs(json) do
        routes:set(prefix.."_"..key,value,1000);
      end
      prefixtable:set("prefix",2,1000)
    else 
      for key,value in pairs(json) do
        routes:set(prefix.."_"..key,value,1000);
      end
      prefixtable:set("prefix",1,1000)
    end    
end
--repeating function reads file 
check = function(premature)
	if not premature then		
		local ok, err = new_timer(delay, check)
		if not ok then
			log(ERR, "failed to create timer: ", err)
			return
		end
    	local cjson = require "cjson"
		local open = io.open
		local function read_file(path)
  	    local file = open(path, "rb") -- r read mode and b binary mode
    	if not file then return nil end
    	local content = file:read "*a" -- *a or *all reads the whole file
    	file:close()
    	return content
		end
		local fileContent = read_file("/usr/local/openresty/sitemap/text.json");
    local json = cjson.decode(fileContent);
    	loader(json);      
	end
	end
if ngx.worker.id() == 0 then
	local ok, err = new_timer(delay, check)
	
	if not ok then
  log(ERR, "failed to create timer: ", err)
		return
	end
end


