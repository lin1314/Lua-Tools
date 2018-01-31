--- 本模块用于热更新修复bug
local package = package
local require,pairs,type,string,pcall= require,pairs,type,string,pcall
local _G = _G
local function log(nLv, fmt, ...)
	print(string.format(fmt,...))
end

function reload( mname )
	if type(mname) ~= "string" then
		log( 0 , "module name invalid." )
		return
	end
	local oldmodule = _G[ mname ]
	_G[ mname ] = nil
	package.loaded[mname]=nil
	local bSucess,strErr = pcall( require, mname )
	if not bSucess then
		_G[ mname ] = oldmodule
		package.loaded[mname] = oldmodule
		log( 0 , "reload fail: " .. strErr )
		return
	end
	local newmodule = _G[ mname ]
	if oldmodule then
        for k , v in pairs( newmodule ) do
            oldmodule[ k ] = v
        end
		oldmodule._M = oldmodule
		_G[ mname ] = oldmodule
		package.loaded[ mname ] = oldmodule
    end	

	log( 0 , "reload module " .. mname .. " successfull" )
	return true
end
