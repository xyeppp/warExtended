local tabler = {
  [1] = 20,
  [2] = 30,
  [3] = 40,
  [4] = 50,
  [5] = 60,
}

for i=1,#tabler-1 do
  tabler[i] = tabler[i+1]
end

tabler[#tabler]=75

p(tabler)

for i=1,#tabler-1 do
  tabler[i] = tabler[i+1]
end

tabler[#tabler]=90

p(tabler)
--TODO world combat event last 5 hits recap in window