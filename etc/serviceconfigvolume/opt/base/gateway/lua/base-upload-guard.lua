local jwt = require "resty.jwt"

-- allow the token to be passed as argument or cookie named 'auth'
local access_token = ngx.var.cookie_access_token
if not access_token then
    access_token = ngx.var.arg_access_token
end
-- the most important part: verify the token
local auth_obj = jwt:verify(ngx.var.auth_secret, access_token, 0)

if not auth_obj["verified"] then
    ngx.status = ngx.HTTP_UNAUTHORIZED;
    ngx.header["X-CUBBLES-StatusReason"] = auth_obj.reason
    ngx.say(ngx.status, " | reason: ", auth_obj.reason);
    ngx.exit(ngx.status);
end

-- now extract information from the token
-- references
-- * http://docs.couchdb.org/en/1.6.1/api/server/authn.html#proxy-authentication
ngx.var.user = auth_obj.payload.user;
ngx.var.roles = auth_obj.payload.roles;