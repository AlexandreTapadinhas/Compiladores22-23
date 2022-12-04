#!/bin/bash
# Compara o output do programa com o output esperado para cada
#   ficheiro na input/output directory a configurar em baixo
# Os ficheiros de input tem que ter extensao .java ou .juc
#   os de output .out
# Antes de executar o scrip adicionar permissoes com
#   chmod +x ./test.sh
# Usage: ./test.sh
# Args:     -e          imprime os erros (off por default)
#           -t [name]   ficheiro especifico, nao é necessário
#                           adicionar a extensao.
#                           ex: ./test.sh -t EsteEPuxado
#           -a "args"   executa o jucompiler com os args especificos
#                           ex: ./test.sh -a "-e1"
#                           para executar sem argumentos nenhums podem
#                           fazer: ./test.sh -a
#
# Oleksandr Yakovlyev 2020 Universidade de Coimbra

in_dir="./meta2"
out_dir="./meta2"
# in_dir="./localtests"
# out_dir="./localtests"

# Reset
Color_Off='\033[0m'       # Text Reset
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow

show_errors='-'
compile_debug=''
specific_test=''
diff_args=''

prog="jucompiler"
args=""
only_error_files=["InsertionSort"]

run_test(){
    in_file=$1
    out_file="${in_file%.juc}"
    out_file="${out_file%.java}"
    out_file="$out_file.out"

    diff -y $diff_args <( ./$prog $args < "$in_dir/$in_file" ) $out_dir/$out_file &> $outputfile
    error=$?
    if [ $error -eq 0 ]
    then
        let tests_made=$tests_made+1
        let tests_passed=$tests_passed+1
        echo -e ✅ "${Green}PASS${Color_Off}" $(basename $in_file)
    elif [ $error -eq 1 ]
    then
        let tests_made=$tests_made+1
        echo -e ❌ "${Red}FAIL${Color_Off}" $(basename $in_file)
        if [ "$show_errors" = 'true' ]
        then
            cat $outputfile
            echo ""
        fi
    else
        echo -e ⚡ "${Yellow}WARN${Color_Off}" $(basename $in_file) \
        "Something went wrong: $(cat $outputfile)"
    fi
}

while getopts 'edst:a:' flag; do
    case "$flag" in
        e) show_errors='true' ;;
        d) compile_debug='true' ;;
        t) specific_test="$OPTARG" ;;
        s) diff_args='--suppress-common-lines' ;;
        a) args="$OPTARG" ;;
    esac
done

if [ "$compile_debug" = 'true' ]
then
    echo "Recompiling in debug..."
    make debug
else
    echo "Recompiling ..."
    make
fi
error=$?
if [ $error -ne 0 ]
then
    exit
fi
echo "Done."

if [ "$args" != '' ]
then
    echo "Running program with flag : $args"
fi

outputfile="temp.txt" #TODO change to pipe
# mkfifo falha em subdiretorias do windows ( usando WSL )
# por isso fica em ficheiro por enquanto

if [ "$specific_test" != '' ]
then
    specific_test=$(ls $in_dir | grep "$specific_test.[j]")
    run_test $specific_test
    rm temp.txt
    exit
fi

printf "\t Tests:\n"
tests_made=0
tests_passed=0
for in_file in $in_dir/*.java ; do
    in_file=$(basename "$in_file")
    run_test $in_file
done

echo ""
echo "Total $tests_passed/$tests_made ("`echo "$tests_passed*100/$tests_made" | bc`"%)"

rm $outputfile
