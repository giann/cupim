local colors = require "term.colors"
local function sh(program, ...)
    local arguments = {...}
    for i, arg in ipairs(arguments) do
        local sarg = tostring(arg)

        arguments[i] = sarg:match "[^%s]%s+[^%s]"
            and string.format("%q", sarg)
            or sarg
    end

    local command =
        "/usr/bin/env "
        .. program
        .. " " .. table.concat(arguments, " ")

    local stderr = os.tmpname()

    print(colors.magenta("🐢 " .. command))

    -- spawn program and yield when waitpid returns
    local ok, _, status = os.execute(
        command .. " 2> " .. stderr,
        "r"
    )

    if ok then
        return true
    else
        local err = io.open(stderr, "r")
        local failure = err:read "*a"

        err:close()
        os.remove(stderr)

        return false,
            "Command `" .. command .. "` failed with status code, " .. status .. ": " .. failure
    end
end

return {
    task   = require "fourmi.task",
    plan   = require "fourmi.plan",
    sh     = sh,
}
