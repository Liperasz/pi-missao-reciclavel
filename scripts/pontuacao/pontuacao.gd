extends Node

# Variáveis de controle 
var acertos: int = 0
var erros: int  = 0
var nome_fase: String = "" 

# Calcula a pontuação com base em acertos e erros
func calcular_pontuacao() -> int:
	return max(0, acertos * 10 - erros * 5)

# Calcula o número de estrelas com base nos pontos
# acertos maior que 80 são 3 estrelas
# acertos maior que 50 são 2 estrelas
# acertos maior que 5 são 1 estrela
func calcular_estrelas(pontos: int) -> int:
	if pontos >= 80:
		return 3
	elif pontos >= 50:
		return 2
	elif pontos > 5:
		return 1
	else:
		return 0

# Estas funçães para quando a fase terminar
func finalizar_fase():
	var pontos = calcular_pontuacao()
	var estrelas = calcular_estrelas(pontos)

	# Atualiza os dados no global.gd
	global.atualizar_fase(nome_fase, estrelas)

#exibe a fase, pontos e estrelas
	print("Fase:",nome_fase)
	print("Pontuação:",pontos)
	print("Estrelas:",estrelas)
	
	return estrelas
