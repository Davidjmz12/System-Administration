command="bash ../utils/check_header.sh practica2_"
for i in $(seq 6)
do
    this_command="$command${i}.sh"
    $this_command
done

