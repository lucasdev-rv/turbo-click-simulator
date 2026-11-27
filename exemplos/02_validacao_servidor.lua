-- EXEMPLO FICTICIO (nao e o codigo do jogo)
-- Servidor autoritativo: o cliente so PEDE; o servidor valida, executa e responde.

local Players = game:GetService("Players")
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("Config"))

local sessoes = {} -- dados de cada jogador, em memoria (preenchido ao entrar)

Remotes.AbrirOvo.OnServerInvoke = function(jogador, idOvo, quantidade)
	local sessao = sessoes[jogador]
	if not sessao or sessao.ocupado then return false, "Aguarde..." end

	-- 1) valida TIPO e INTERVALO do que veio do cliente (nunca confie nele)
	local ovo = type(idOvo) == "string" and Config.Ovos[idOvo]
	if not ovo then return false, "Ovo invalido" end
	if type(quantidade) ~= "number" or quantidade % 1 ~= 0 or quantidade < 1 or quantidade > 3 then
		return false, "Quantidade invalida"
	end

	-- 2) valida as regras do jogo: mundo liberado e saldo
	if not sessao.mundosLiberados[ovo.Mundo] then return false, "Desbloqueie este mundo primeiro!" end
	local custo = ovo.Preco * quantidade
	if sessao.cliques < custo then return false, "Cliques insuficientes!" end

	-- 3) executa dentro de pcall: um erro nunca deixa o estado "ocupado" preso
	sessao.ocupado = true
	local ok, resultado = pcall(function()
		sessao.cliques -= custo
		jogador:SetAttribute("Cliques", sessao.cliques) -- a interface so le este atributo
		-- (aqui entraria o sorteio; veja 03_sorteio_ponderado.lua)
		return {"PetA"}
	end)
	sessao.ocupado = false

	if not ok then
		warn("[AbrirOvo] erro:", resultado)
		return false, "Erro, tente de novo"
	end
	return true, resultado
end

Players.PlayerRemoving:Connect(function(jogador)
	sessoes[jogador] = nil
end)
