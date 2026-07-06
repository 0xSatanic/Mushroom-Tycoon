local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatNumber = require(ReplicatedStorage.Packages.robloxformatnumber).Main
local Helper = {}

local SUFFIX = FormatNumber.Notation.compactWithSuffixThousands({"K", "M", "B", "T"})
local formatter = FormatNumber.NumberFormatter.with():Notation(SUFFIX):Precision(FormatNumber.Precision.integer():WithMinDigits(3))

function Helper.FormatNumber(amount: number) : string

    return formatter:Format(amount)
end

return Helper