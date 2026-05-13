#!/bin/bash

max_score=${1:-100}
max_student_id=${2:-5}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SUBMISSIONS_DIR="$SCRIPT_DIR/Submissions"
ACCEPTED_OUTPUT="$SCRIPT_DIR/AcceptedOutput.txt"
OUTPUT_CSV="$SCRIPT_DIR/output.csv"

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

student_ids=()
for i in $(seq 1 "$max_student_id"); do
    student_ids+=("180512$i")
done

declare -A initial_score  
declare -A script_path    

for sid in "${student_ids[@]}"; do
    student_dir="$SUBMISSIONS_DIR/$sid"
    student_script="$student_dir/$sid.sh"

    if [ ! -d "$student_dir" ] || [ ! -f "$student_script" ]; then
        initial_score[$sid]=0
        continue
    fi

    out_file="$TEMP_DIR/${sid}_out.txt"
    (cd "$student_dir" && bash "./$sid.sh") > "$out_file" 2>/dev/null

    diff_output=$(diff -w "$ACCEPTED_OUTPUT" "$out_file")

    mismatch=$(printf '%s\n' "$diff_output" | grep -c '^<')

    deduction=$(( mismatch * 5 ))
    score=$(( max_score - deduction ))
    [ "$score" -lt 0 ] && score=0

    initial_score[$sid]=$score
    script_path[$sid]="$student_script"
done

declare -A caught

n=${#student_ids[@]}
for (( i = 0; i < n; i++ )); do
    sid1="${student_ids[$i]}"
    [ -z "${script_path[$sid1]+set}" ] && continue

    for (( j = i + 1; j < n; j++ )); do
        sid2="${student_ids[$j]}"
        [ -z "${script_path[$sid2]+set}" ] && continue

        cp_diff=$(diff -Z -B "${script_path[$sid1]}" "${script_path[$sid2]}" 2>/dev/null)

        if [ -z "$cp_diff" ]; then
            caught[$sid1]=1
            caught[$sid2]=1
        fi
    done
done

printf 'student_id,score\n' > "$OUTPUT_CSV"

for sid in "${student_ids[@]}"; do
    score=${initial_score[$sid]:-0}

    if [ "${caught[$sid]+set}" ]; then
        score=$(( -score ))
    fi

    printf '%s,%s\n' "$sid" "$score" >> "$OUTPUT_CSV"
done

echo "Grading complete. Results written to: $OUTPUT_CSV"
