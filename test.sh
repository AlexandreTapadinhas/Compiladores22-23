#!/usr/bin/env bash
#
#  Utilização
#    bash test.sh ./path/to/jucompiler
#
#  Funcionalidade
#  Compara todos os casos de teste na pasta meta1
#  Cria o ficheiro *casoteste*.out_temp com resultado de correr cada caso de teste

if [[ -z "$1" ]]; then
    echo "Missing argument executable"
    echo "Usage: $0 executable"
    echo "Example: $0 ./path/to/jucompiler"
    exit 1
fi

exe="$1"

accepted=0
total=0
for inp in meta2/*.java; do 
    echo "$inp"
    out=${inp%.java}.out
    tmp=${inp%.java}.out_temp
    if [[ "$inp" == *_e1.java ]]; then
        $exe -e2 < "$inp" > "$tmp"
    else
        $exe -t < "$inp" > "$tmp"
    fi
    lines=$(diff $out $tmp | wc -l)
    if [[ $lines -gt 0 ]]; then
        echo " Wrong Answer, run 'diff $out $tmp' to see the differences"
    else
        accepted=$(( $accepted + 1 ))
    fi
    total=$(( $total + 1 ))
done

echo "Accepted: $accepted / $total"
