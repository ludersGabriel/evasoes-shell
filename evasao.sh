#!/bin/bash

tar -zxvf evasao2014-18.tar.gz
sudo apt install gnuplot-nox 

dadosEvasao=$(ls ./evasao | sort) #filtragem dos arquivos a serem trabalhados
cabecalho=$(head -n 1 ./evasao/$(echo $dadosEvasao | cut -d' ' -f1)) #captura do cabeçalho

for i in $dadosEvasao #for para concatenar os dados em um arquivo só
do
	sed '1d' ./evasao/$i >> ./teste1.txt 
done

sort ./teste1.txt -o ./teste1.txt #ordenando o arquivo com os dados concatenados

echo $cabecalho | cat - ./teste1.txt > temp && mv temp ./teste1.txt #adicionando cabeçalho

printf "\n\n\t[ITEM 3]\n\n"
sed '1d' teste1.txt | cut -d, -f1 | tr ' ' '_' | uniq -c | sort -nr | tr -s ' ' | awk '{print $2 " " $1}' | column -t |tr '_' ' ' | sed G #contagem e formatação o item 3 
mapfile -t my_array < <(sed '1d' teste1.txt | cut -d',' -f3 | sort -u) #criação de um vetor que será usado no item 8
rm -rf teste1.txt #remoção do arquivo com todos os dados concatenados


for i in $dadosEvasao #for que faz o item 4
do
	ano=$(echo $i | cut -d'-' -f2 | cut -d'.' -f1) #seleciona o ano da file sendo analisada
	touch ./temp.txt
	sed '1d' ./evasao/$i > ./temp.txt #salva os dados do arquivo selecionado sem o cabeçalho

	while read line
	do
		echo "$(expr $ano - $(echo $line | cut -d',' -f4))" >> ./opa.txt #realiza as subtrações entre o ano de ingresso e o ano da evasao e salva em opa.txt
	done < ./temp.txt
done	

rm -rf ./temp.txt
printf "\n\n\t[ITEM 4]\n\n"
printf "ALUNOS\tANOS\n\n"
sort ./opa.txt | uniq -c | sort -k2 -n | tr -s ' ' | awk '{print $1 "\t" $2}' | sed G #formatação e ordenação pelos anos ao invés a quantidade de pessoas que sairam após x anos
rm -rf opa.txt

printf "\n\n\t[ITEM 5]\n\n"
printf "ANO\tSEMESTRE\n"
for i in $dadosEvasao #for item 5
do
	ano=$(echo $i | cut -d'-' -f2 | cut -d'.' -f1) #seleciona o ano da file sendo analisada
	primeiro=$(sed '1d' ./evasao/$i | cut -d',' -f2 | cut -d'o' -f1 | sort | uniq -c | sort -k2 -n | tr -s ' ' | cut -d' ' -f2 | head -n 1) #pega os dados em relação ao primeiro semestre		
	segundo=$(sed '1d' ./evasao/$i | cut -d',' -f2 | cut -d'o' -f1 | sort | uniq -c | sort -k2 -n | tr -s ' ' | cut -d' ' -f2 | tail -n 1) #pega a quantidade em relação ao segundo semestre
	
	if [ $primeiro  -ge $segundo ] #compara se o primeiro é maior que o segundo
	then
		printf "\n$ano\tsemestre 1 - $((($primeiro * 100)/($primeiro+$segundo)))%%\n" #calcula a porcentagem  do segundo semestre em relação ao total
	else
		printf "\n$ano\tsemestre 2 - $((($segundo * 100)/($primeiro+$segundo)))%%\n" #calcula a porcentagem do segundo semestre em relação ao total
	fi
done
echo


touch femea.txt macho.txt #inicio item 6
for i in $dadosEvasao
do
	femea=$(grep -c 'F' ./evasao/$i) #pega a quantidade de mulheres no arquivo selecionado e salva na variavel femea
	macho=$(grep -c 'M' ./evasao/$i) #pega a quantidade de homens no arquivo selecionado e salva na variável macho
	pctMacho=$((($macho*100)/($macho+$femea))) #calcula a porcentagem de homens em relação ao total de pessoas no arquivo sendo analisado e salva em pctMacho
	pctFemea=$((($femea*100)/($macho+$femea))) #calcula a porcentagem de mulheres em relação ao total de pessoas no arquivo sendo analisado e salva em pctFemea
	echo $pctMacho >> macho.txt #salva a porcentagem de homens do arquivo sendo analisado em macho.txt
	echo $pctFemea >> femea.txt #salva a porcentagem de mulheres do arquivo sendo analisado em femea.txt
done

somaF=0 
somaM=0 
while read line
do
	somaF=$(($somaF + $line)) #calcula a soma das porcentagens das mulheres 
done < femea.txt

while read line
do
	somaM=$(($somaM + $line)) #calcula a soma das porcentagens dos homens
done < macho.txt

printf "\n\n\t[ITEM 6]\n\n"
printf "SEXO\tMEDIA EVASÕES\n"
printf "\nF\t$(($somaF/5))%%\n" #calcula a media das porcentagens das mulheres
printf "\nM\t$(($somaM/5))%%\n\n" #calcula a media das porcentagens dos homens
printf "obs: erro de 2 p.p. devido aos arredondamentos feitos pela shell\n\n"
rm -f macho.txt femea.txt

touch item7.dat #inicio item 7
echo "Ano Quantidade" >> ./item7.dat
for i in $dadosEvasao
do
	ano=$(echo $i | cut -d'-' -f2 | cut -d'.' -f1) #seleciona o ano do arquivo sendo analisado
	quantidade=$(sed '1d' ./evasao/$i | wc -l) #calcula a quantidade de pessoas daquele arquivo
	echo "$ano $quantidade" >> ./item7.dat   	
done

#plota o gráfico do item7
gnuplot <<-EOFMarker 
	set term pngcairo
	set output "evasoes-ano.png"
	set title "EVASOES VS ANOS"
	plot "item7.dat" using 1:2 with lines lt rgb "red" title "Evasoes"
EOFMarker
rm -f item7.dat

touch file13.dat #inicio item 8
echo "ANO" | tr '\n' ' ' >> file13.dat
for((i=0; i<${#my_array[@]}; i++)); do echo ${my_array[i]} | tr ' ' '_' | tr "\n" "  ">> file13.dat ; done #varre o array declarado no item 1 e cria um cabeçalho com as formas de ingresso
echo >> file13.dat

for i in $dadosEvasao
do
        ano=$(echo $i | cut -d'-' -f2 | cut -d'.' -f1) #seleciona o ano do arquivo sendo analisado
	echo $ano | tr '\n' ' ' >> file13.dat
	for ((j=0; j<${#my_array[@]}; j++)) #calcula as formas de ingresso no arquivo sendo analisado
	do
		temp=$(sed '1d' ./evasao/$i | cut -d',' -f3 | grep -c "${my_array[j]}")
		echo $temp | tr '\n' ' ' >> file13.dat
	done
	echo >> file13.dat
done

#plota o gráfico do item 8
gnuplot <<-EOFMarker
	set terminal pngcairo size 1800,900  enhanced font "Helvetica,20"
set output 'evasoes-forma.png'

red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB"; purple = "#664B81";
yellow = "#E4DA50"; black = "#000000"; lightPurp = "#9A90F5"; green2 = "#53B253"; red2 = "#FC9090";
grey = "#808080";


set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9
set xtics format ""
set grid ytics

set title "EVASÕES VS FORMA DE INGRESSO"
plot "file13.dat" using 2:xtic(1) title "Aluno interc" linecolor rgb red, \
            '' using 3 title "Aprov. C. Sup." linecolor rgb blue, \
            '' using 4 title "Convênio AUGM" linecolor rgb green, \
            '' using 5 title "Convênio PEC-G" linecolor rgb skyblue, \
            '' using 6 title "Mobi. Acadêmica" linecolor rgb purple, \
            '' using 7 title "Proc. Sele. ENEM" linecolor rgb yellow, \
            '' using 8 title "Reopção" linecolor rgb black, \
            '' using 9 title "Transf. Ex-Ofício" linecolor rgb lightPurp, \
            '' using 10 title "Transf. Provar" linecolor rgb green2, \
            '' using 11 title "Vestibular" linecolor rgb red2

EOFMarker
rm -f file13.dat
rm -rf ./evasao



