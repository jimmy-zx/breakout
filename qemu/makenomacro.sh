for file in *.s; do
    echo "$file"
    python asmpp.py "$file" > "../nomacro/$file"
done
