-- EXEMPLO FICTICIO (nao e o codigo do jogo)
-- Modulo "Config": fica em ReplicatedStorage e e lido pelo cliente E pelo servidor.
-- Ideia: dados do jogo em um unico lugar, sem duplicar valores entre telas e logica.

local Config = {}

-- Raridades em ordem (o indice serve para comparar e ordenar)
Config.Raridades = {"Comum", "Incomum", "Epico", "Lendario", "Mitico", "Secreto"}

-- Mundos de exemplo: meta de cliques para liberar e bonus crescente
Config.Mundos = {
	{Nome = "Lobby",    MetaCliques = 0,       Bonus = 1.0},
	{Nome = "Floresta", MetaCliques = 1e4,     Bonus = 1.5},
	{Nome = "Deserto",  MetaCliques = 1e6,     Bonus = 2.5},
}

-- Ovos de exemplo: preco e tabela de pets {nome, peso}. Peso menor = mais raro.
Config.Ovos = {
	OvoInicial = {
		Mundo = "Lobby",
		Preco = 100,
		Pets = {
			{"PetA", 70},
			{"PetB", 25},
			{"PetC", 5},
		},
	},
}

-- Formula de custo isolada: facil de ajustar e de testar
function Config.CustoRebirth(rebirthsAtuais)
	return 1000 * (2 ^ rebirthsAtuais)
end

-- Formatacao de numeros grandes (usada so pela interface)
function Config.Formatar(n)
	local sufixos = {"", "K", "M", "B", "T"}
	local i = 1
	while n >= 1000 and i < #sufixos do
		n /= 1000
		i += 1
	end
	return string.format("%.1f%s", n, sufixos[i])
end

return Config
