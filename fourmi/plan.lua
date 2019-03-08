---
-- Plan module
-- @classmod fourmi.plan
-- @author Benoit Giannangeli
-- @license MIT
-- @copyright Benoit Giannangeli 2019

local colors = require "term.colors"

local planMt = {

    ---
    -- Run the plan
    -- @tparam plan self
    -- @tparam table arguments List of arguments
    __call = function(self, arguments)
        local time = os.clock()

        if not arguments.quiet then
            print(
                colors.green("\n🐜 Running plan "
                .. colors.bright(colors.blue(self.__name)))
                .. colors.dim(colors.cyan(
                    (self.__description and "\n" .. self.__description .. ": " or "")
                    .. self.__task.__name
                ))
            )
        end

        if not self.task then
            error("Task is undefined for plan " .. self.__name)
        end

        local results = {self.__task(table.unpack(arguments.arguments or {}))}

        if not arguments.quiet then
            print(
                "\n🐜 Plan " .. colors.bright(colors.blue(self.__name)) .. " completed with "
                .. colors.yellow(#results) .. " result" .. (#results > 1 and "s" or "")
                .. " in " .. colors.yellow(string.format("%.03f", os.clock() - time) .. "s")
            )

            for _, res in ipairs(results) do
                print("\t\t→ " .. colors.dim(colors.cyan(tostring(res))))
            end
        end
    end,

    __index = {

        ---
        -- Set plan's task
        -- @tparam plan self
        -- @tparam task task
        task = function(self, task)
            self.__task = task

            return self
        end,

        ---
        -- Set plan's description
        -- @tparam plan self
        -- @tparam string description
        description = function(self, description)
            self.__description = description

            return self
        end,

        ---
        -- Set plan's name
        -- @tparam plan self
        -- @tparam string name
        name = function(self, name)
            self.__name = name

            return self
        end,

        -- Aliases
        desc = function(self, ...)
            return self:description(...)
        end,

    },

}

local function plan(name)
    return setmetatable({
        __name = name,
    }, planMt)
end

return plan
