function downloadFile(name)
    if name == nil then
        name = "startup.lua"
    end
    local content = http.get("https://raw.githubusercontent.com/scheMeZa/minecraft-computercraft-miner/master/startup.lua")
    local file = fs.open(name, "w")
    file.write(content.readAll())
    file.close()
end

downloadFile()
