-- Usage: github <user> <repo> <filename>
local args = { ... }

if #args < 3 then
    print("Usage: github <user> <repo> <file>")
    return
end

local user = args[1]
local repo = args[2]
local filepath = args[3]
-- Default to 'main' branch, but you can change this or add it as an arg
local branch = "refs/heads/main"

-- Construct the RAW GitHub URL
-- We use raw.githubusercontent.com to get the text, not the HTML page
local url = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/" .. branch .. "/" .. filepath

print("Downloading " .. filepath .. " from " .. user .. "...")

-- Make the HTTP Request
local response = http.get(url)

if response then
    local content = response.readAll()
    response.close()
    
    -- Save to a file locally
    -- We extract just the filename if a path was given (e.g. 'folder/script.lua' -> 'script.lua')
    local localFilename = fs.getName(filepath)
    
    local file = fs.open(localFilename, "w")
    file.write(content)
    file.close()
    
    print("Success! Saved as " .. localFilename)
else
    print("Error: Could not connect or file not found.")
end