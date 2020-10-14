if not fs.exists('disk/clone/') then return end
for _, file in pairs(fs.list('disk/clone/')) do
    fs.delete(file)
    fs.copy('disk/clone/' .. file, file)
end
