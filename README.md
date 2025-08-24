<h1 align="center">LibC_SB</h1>



<p align="center">
		<a href=""><img alt="Assembly" src="https://img.shields.io/badge/Language-Assembly-blue.svg" height="20"/></a>
<a href=""><img alt="Architecture" src="https://img.shields.io/badge/Architecture-x86--64-green.svg" height="20"/></a>
<a href=""><img alt="System" src="https://img.shields.io/badge/System-Linux-orange.svg" height="20"/></a>
<a href=""><img alt="Build System" src="https://img.shields.io/badge/Build-Make-red.svg" height="20"/></a>
	</p>



<p align="center">
  <a target="_blank" rel="noopener noreferrer" href="#">
      <img src="gif final.gif" width="650" style="max-width: 100%;">
  </a>
</p>


Trabalho desenvolvido como parte da conclusão da disciplina **Software Básico**, tendo como objetivo a implementação das funções `printf`, `scanf`, `fopen`, `fclose`, `fprintf` e `fscanf` em linguagem **Assembly x86_64**. 

A implementação baseia-se em **chamadas de sistema do kernel Linux**, sem o uso de bibliotecas externas ou de alto nível.



### Entrada e Saída
- `printf`: Saída formatada no terminal
- `fprintf`: Saída formatada em arquivo  
- `scanf`: Leitura formatada da entrada padrão
- `fscanf`: Leitura formatada de arquivo
- `fopen`: Abertura de arquivos com diferentes modos
- `fclose`: Fechamento de arquivos

### Conversão de Dados
- `int_to_string`: Converte inteiros em string
- `string_to_int`: Converte string em inteiro
- `float_to_string`: Converte números de ponto flutuante em string
- `string_to_float`: Converte string em número de ponto flutuante


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)


###  Estrutura do Projeto

```bash
├── constantes
│   └── constantes.s
├── conversao
│   ├── float_to_string.s
│   ├── int_to_string.s
│   ├── string_to_float.s
│   └── string_to_int.s
├── entrada_saida
│   ├── fclose.s
│   ├── fopen.s
│   ├── fprintf.s
│   ├── fscanf.s
│   ├── printar_caractere.s
│   ├── printf.s
│   └── scanf.s
├── leitura-fscanf.txt
├── macros
│   └── macros.s
├── main.s
├── Makefile
├── README.md
├── Trabalho Software Básico - parte III.pdf
└── util
    └── utils.s

```

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)

### Requisitos
  - GNU Assembler (as)
  - GNU Linker (ld)
  - Make

<br>

**Ubuntu/Debian:**
  ```bash
  sudo apt install build-essential
  ```


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)


### Instalação

1. **Clone o repositório:**
   ```sh
   git clone https://github.com/natansantoz/asm-libc.git
   ```

2. **Navegue até o diretório do projeto:**
    ```sh
    cd asm-libc
    ```

### Execução

1. **Compile e execute o projeto:**
   ```sh
   make run
   ```


2. **Limpeza dos arquivos gerados:**
   ```sh
   make clean
   ```


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)


