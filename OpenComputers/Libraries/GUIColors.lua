local colors = {
  [0xFFFFFF] = "white",
  [0xFF4D01] = "orange",
  [0xFF0090] = "magenta",
  [0x00CCFF] = "lightblue",
  [0xFEEF00] = "yellow",
  [0x00FF01] = "lime",
  [0xF68EA5] = "pink",
  [0x424242] = "gray",
  [0xD3D3D3] = "silver",
  [0x0069A1] = "cyan",
  [0xA10098] = "purple",
  [0x0000FF] = "blue",
  [0x6B2201] = "brown",
  [0x19A100] = "green",
  [0xFF0000] = "red",
  [0x000000] = "black",
  [0x5B6B1B] = "olive",
  [0x12ACAC] = "teal",
  [0xFF7E00] = "amber",
  [0xC19A6B] = "camel",
  [0x965A3E] = "coconut"
  [0xFF7F50] = "coral"
  [0x555D50] = "ebony"
  [0x4B0082] = "indigo"
  [0xFFA07A] = "salmon"
  [0xE0B0FF] = "mauve"
}

do
  local keys = {}
  for k in pairs(colors) do
    table.insert(keys, k)
  end
  for _, k in pairs(keys) do
    colors[colors[k]] = k
  end
end

return colors
--eof
