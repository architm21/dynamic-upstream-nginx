--setting prefix to the key 
local default = 1 
local prefix = ngx.shared.prefix 
prefix:set("prefix",default)