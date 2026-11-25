#!/usr/bin/env bash


if [ "$#" -ne 1 ]; then
    echo "введите $0 <путь_к_файлу.gff3>"
    exit 1
fi

INPUT_GFF="$1"
OUT_DIR="terminal_task/results"
OUT_FILE="$OUT_DIR/result.tsv"

# 1. Создаём директорию terminal_task/results
mkdir -p "$OUT_DIR"

# 2-3. Фильтруем строки, извлекаем поля и пересчитываем координаты
awk -F'\t' 'BEGIN { OFS="\t" }
/^#/ { next }
$3 == "gene" && $9 ~ /(^|;)gene_type=unprocessed_pseudogene(;|$)/ {
    gene_name = "NA"
    n = split($9, attrs, ";")
    for (i = 1; i <= n; i++) {
        if (attrs[i] ~ /^gene_name=/) {
            gene_name = substr(attrs[i], 11)
            break
        }
    }

    if ($7 == "+") {
        start = $4
        end = $4 + 1
    } else if ($7 == "-") {
        start = $5
        end = $5 + 1
    } else {
        next
    }

    print $1, start, end, $7, gene_name
}' "$INPUT_GFF" > "$OUT_FILE"

echo "Готово! Результат сохранён в: $OUT_FILE"



