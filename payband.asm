.data
    # Frase que solicita o bit da pulseira
	strBitPul: .asciiz "Informe o bit da pulseira: " 
	
	# Frase que solicita o valor a ser pago
	strGetVal: .asciiz "Informe o valor a ser pago: "
	
	# Frase que informa que a biometria negada
	strBioDenied: .asciiz "Biometria negada."
	
	# Frase que informa que o valor ultrapassou a 1000 reais.
	strValDenied: .asciiz "Valor ultrapassou R$1000."
	
	# Frase que solicita o número do cartão
	strNumCard: .asciiz "Informe o número do cartão: "
	
	# Frase que solicita a senha do cartão
	strPassword: .asciiz "\nInforme a senha do cartão: "
	
	# Frase que informa que a senha é inválida
	strPasswordAgain: .asciiz "\nSenha inválida, tente novamente: "
	
	# Frase que confirma a compra
	strSuccess: .asciiz "\nCompra efetuada com sucesso."
	
	# Frase que exibe o número do cartão
	strSuccessCard: .asciiz "\nNúmero do cartão: "
	
	# Frase que exibe o valor da compra
	strVal: .asciiz "\nValor da compra: "
	
	# Valor máximo permitido
	maxVal: .float 1000
	
	# Número do cartão
	numCard: .space 16

.text
	main:
		# Solicita o bit de biometria da payband
		li $v0, 4
		la $a0, strBitPul
		syscall
		
		li $v0, 5
		syscall
		move $t0, $v0
		
		# Verifica se o bit é igual a 1
		beq $t0, $zero, bioDenied
		j getValor
		
	bioDenied:
		# Bit de biometria é igual a 0
		li $v0, 4
		la $a0, strBioDenied
		syscall
		
		# Encerra o programa
		li $v0, 10
		syscall
		
	getValor:
		# Solicita o valor a ser pago
		li $v0, 4
		la $a0, strGetVal
		syscall
		
		li $v0, 6
		syscall
		
		# Verifica se o valor é menor que 1000
		lwc1 $f2, maxVal
		c.le.s $f0, $f2
		bc1f valDenied # Se o valor é maior que 1000
		bc1t pay # Se o valor é menor ou igual a 1000
	
	valDenied:
		# Valor ultrapassou o valor máximo
		li $v0, 4
		la $a0, strValDenied
		syscall
		
		# Encerra o programa
		li $v0, 10
		syscall
		
	pay:
		# Faz a leitura do cartão
		li $v0, 4
		la $a0, strNumCard
		syscall
		
		li $v0, 8
		la $a0, numCard
		li $a1, 17
		move $t1, $a0
		syscall
		
		# Solicita a senha
		li $v0, 4
		la $a0, strPassword
		syscall
		
		li $v0, 5
		syscall
		move $t2, $v0
		
		# Verifica se a senha é menor ou igual a 9999
		#move $t3, maxPass
		bgt $t2, 9999, getPassword
		
		# Confirma a compra
		j payConfirmed
		
	getPassword:
		# Solicita a senha novamente
		li $v0, 4
		la $a0, strPasswordAgain
		syscall
		
		li $v0, 5
		syscall
		move $t2, $v0
		
		# Verifica se a senha é menor ou igual a 9999
		ble $t2, 9999, payConfirmed
		j getPassword
		
	payConfirmed:
		# Mensagem de conclusão
		li $v0, 4
		la $a0, strSuccess
		syscall 
		
		# Exibe o número do cartão
		li $v0, 4
		la $a0, strSuccessCard
		syscall
		
		li $v0, 4
		la $a0, numCard
		syscall
		
		# Exibe o valor da compra
		li $v0, 4
		la $a0, strVal
		syscall
		
		li $v0, 2 
		mov.s $f12, $f0
		syscall
		
		# Encerra o programa
		li $v0, 10
		syscall
