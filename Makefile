PROG = main

SRC = main.s \
	entrada_saida/printf.s \
	entrada_saida/fprintf.s \
	entrada_saida/scanf.s \
	entrada_saida/fscanf.s \
	entrada_saida/fopen.s \
	entrada_saida/fclose.s \
	entrada_saida/printar_caractere.s \
	conversao/float_to_string.s \
	conversao/int_to_string.s \
	conversao/string_to_float.s \
	conversao/string_to_int.s \
	util/utils.s \

OBJ = $(SRC:.s=.o)

AS = as
LD = ld

all: $(PROG)

$(PROG): $(OBJ)
	$(LD) -o $@ $(OBJ)

%.o: %.s
	$(AS) -o $@ $<

clean:
	rm -f $(OBJ) $(PROG) arquivo_onde_conteudo_foi_escrito.txt

run: clean all
	@clear
	./$(PROG)
