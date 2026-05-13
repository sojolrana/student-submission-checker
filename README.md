# Linux Submission Evaluator

A Bash-based automated grading and plagiarism detection system for Linux shell scripting assignments.

This project evaluates student `.sh` submissions by executing scripts, comparing outputs against an accepted solution, deducting marks for mismatches, detecting copied submissions, and generating a final CSV report.

---

## Features

- Automated Bash script evaluation
- Output comparison using `diff`
- Whitespace-insensitive output checking
- Automatic score deduction system
- Plagiarism detection between student scripts
- CSV report generation
- Temporary file cleanup using `trap`
- Configurable maximum score and student range

---

## Project Structure

```text
.
├── marking.sh
├── AcceptedOutput.txt
├── output.csv
├── Submissions/
│   ├── 1805121/
│   │   └── 1805121.sh
│   ├── 1805122/
│   │   └── 1805122.sh
│   └── ...
```

---

## Requirements

- Linux Operating System
- Bash Shell
- GNU `diff` utility

---

## How It Works

### 1. Submission Validation

The script checks whether:

- The student directory exists
- The required `.sh` file exists

Missing submissions automatically receive a score of `0`.

---

### 2. Script Execution

Each student script is executed inside its own directory:

```bash id="8e2nd9"
(cd "$student_dir" && bash "./$sid.sh")
```

The generated output is stored temporarily for evaluation.

---

### 3. Output Comparison

The output is compared with the expected output using:

```bash id="okvys1"
diff -w
```

The `-w` flag ignores whitespace differences.

---

### 4. Mark Deduction

Each mismatched line deducts:

```text id="9by7bc"
5 marks
```

Final score calculation:

```text id="r6r0u8"
score = max_score - (mismatch × 5)
```

Scores never go below `0`.

---

### 5. Plagiarism Detection

Student scripts are compared using:

```bash id="9hy7we"
diff -Z -B
```

Flags used:

- `-Z` → ignore trailing whitespace
- `-B` → ignore blank lines

If two scripts are identical:

- Both students receive negative scores
- Negative values indicate copied submissions

---

## Usage

Make the script executable:

```bash id="a47hzg"
chmod +x marking.sh
```

Run with default settings:

```bash id="7l3x0d"
./marking.sh
```

Default values:

| Parameter | Default |
|---|---|
| Maximum Score | 100 |
| Maximum Student ID | 5 |

This evaluates:

```text id="4d9tsm"
1805121 → 1805125
```

---

## Custom Execution

Run with custom parameters:

```bash id="m2v9p6"
./marking.sh <max_score> <max_student_id>
```

Example:

```bash id="2p5ww4"
./marking.sh 50 10
```

This evaluates:

- Students: `1805121 → 18051210`
- Maximum score: `50`

---

## Output

The script generates:

```text id="s4h2mw"
output.csv
```

Example:

```csv id="72ht6h"
student_id,score
1805121,95
1805122,-80
1805123,0
```

### Score Interpretation

| Score Type | Meaning |
|---|---|
| Positive | Normal evaluated score |
| Zero | Missing submission or very poor output |
| Negative | Copied submission detected |

---

## Key Bash Concepts Used

- Arrays
- Associative Arrays
- Command Substitution
- Process Subshells
- File Redirection
- Temporary Directories
- Signal Trapping
- String Processing
- Nested Loops
- Conditional Statements

---

## Technologies Used

- Bash
- Linux Shell Utilities
- GNU diff
- CSV File Handling

---

## Example Workflow

1. Place student submissions inside:

```text id="t2lqjo"
Submissions/
```

2. Add the expected output file:

```text id="9z6b1d"
AcceptedOutput.txt
```

3. Run the evaluator:

```bash id="jjr2jp"
./marking.sh
```

4. View generated results:

```text id="83khx8"
output.csv
```

---

## Academic Project

This project was developed as part of a Linux shell scripting assignment focused on automation, file processing, and plagiarism detection.

---

## License

This project is licensed under the MIT License.
