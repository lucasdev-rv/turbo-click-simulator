-- EXEMPLO FICTICIO (nao e o codigo do jogo)
-- Uma unica funcao de chances: o SERVIDOR sorteia com ela e a INTERFACE mostra
-- as mesmas porcentagens, entao o que o jogador ve e o que realmente acontece.

local Chances = {}

-- tabela: { {nome, peso}, ... }   sorte >= 1 (so afeta itens raros)
function Chances.calcular(tabela, sorte)
	local pesos, total = {}, 0
	for i, item in ipairs(tabela) do
		local peso = item[2]
		if peso < 10 then peso *= sorte end -- a sorte favorece os raros
		pesos[i] = peso
		total += peso
	end

	local resultado = {}
	for i, item in ipairs(tabela) do
		resultado[i] = {nome = item[1], porcentagem = pesos[i] / total * 100}
	end
	return resultado
end

-- Somente o SERVIDOR chama esta funcao
function Chances.sortear(tabela, sorte)
	local lista = Chances.calcular(tabela, sorte)
	local x = math.random() * 100
	for _, item in ipairs(lista) do
		x -= item.porcentagem
		if x <= 0 then return item.nome end
	end
	return lista[#lista].nome -- seguranca contra arredondamento
end

return Chances
