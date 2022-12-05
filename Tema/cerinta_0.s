
;/ 1. argumentele trebuie incarcate pe stiva pentru apel, conform standardului x86, de la dreapta la stanga

;/ 2. registrii %eax, %ecx si %edx sunt singurii care NU trebuie restaurati in urma apelului, 
;/    fiind si registrii de returnare; toti ceilalti registri trebuie restaurati!

;/ 3. in cadrul de apel utilizam registrul %ebp conform conventiei x86, prezentata la laborator si in suportul 0x01 de laborator

;/ 4. in cadrul de apel NU se utilizeaza variabile din sectiunea .data! 
;/    Toate variabilele au scop local, deci se vor afla pe stiva, si vor fi accesate prin intermediul lui %ebp!

;/ CONTINE CERINTELE 1 + 2

