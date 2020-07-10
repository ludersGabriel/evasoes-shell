# SOBRE

Trabalho feito para matéria de "Programação I" cujo intuito era analisar uma base de dados fornecida e extrair informações utilizando Shell, confome os critérios:

Tema: Taxas e formas de evasão

Os dados de evasão de estudantes do curso de Bacharelado em Ciência da Computação da UFPR estão disponíveis em arquivos-texto por ano.

O objetivo deste trabalho é fazer um script chamado evasao.sh que:

  - Leia todos os arquivos do diretório descompactado da extração do arquivo evasao2014-18.tar.gz

  - Concatene as informações de cada arquivo em um único arquivo

  - Faça um ranking (ordenado de modo decrescente) de cada "forma de evasão", considerando o total de evasões no período disponível (2014-2018).

  - Com base no ano de evasão (este dado faz parte do nome de cada arquivo .csv), faça um ranking que mostre a quantidade de anos que os alunos ficam na universidade antes de ocorrer a evasão, isto é, quantos alunos ficam 1 ano, quantos ficam 2 e por aí vai...

  - Mostre para cada ano, qual foi o semestre (1o ou 2o) que teve mais casos de evasão e a porcentagem correspondente

  - Mostre a porcentagem da média de evasões do sexo masculino e feminino ao longo do período (2014 a 2018).

  - Produza um gráfico (de linha) com os anos de evasão no eixo x e o número de evasões no eixo y (use o Gnuplot)

  - Produza um gráfico (de barras) mostrando, para cada ano, o número de evasões por forma de ingresso
 
 
# COMO RODAR
   - executar ./evasao.sh. O script instalará gnuplot e extrairá os arquivos necessários para análise. Após o fim da execução, os arquivos de apoio são excluídos e       dois arquivos png são criados conforme os dois últimos itens.
