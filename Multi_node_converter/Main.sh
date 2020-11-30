#!/bin/bash 
tittle="------Executing multi process on Linux------"
echo ""
echo $tittle
echo ""
echo "-->> Starting process..."
username="ariosky"
password="AngelE12A"
function_workspace="/home/ariosky/Actual_Process/BC-V_data_converter"

if test -d "$function_workspace"; then
    declare -a nodes=("gpu01" "gpu01" "gpu01" "gpu01" "gpu01" "gpu02" "gpu02" "gpu02" "node01" "node01" "node02" "node02" "node03" "node04" "node05" "node06" "node07" "node08" "node09" "node10")
    N=${#nodes[@]}
    echo "Total of instances: "$N

    script_path="`pwd`"
    function_name="Main"
    idnode=1
 if test -f "$script_path/move_to_node.sh"; then
    for node in "${nodes[@]}"; do
      (   
        echo "Moving to node: "$node" in instance :"$idnode
        gnome-terminal --tab --title="Process in node: "$node --command="bash -c '$script_path/move_to_node.sh $script_path $function_workspace $function_name $node $idnode $N $password'"
        #xterm -e "/home/$username/Actual_Process/move_to_node.sh" $workspace_path $function_name $node $idnode $N $password
      ) &
      ((idnode=idnode+1))
      echo ""
     # allow to execute up to $N jobs in parallel
      if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
          # now there are $N jobs already running, so wait here for any job
          # to be finished so there is a place to start next one.
          wait
      fi
    done
else
    echo "The file: 'move_to_node.sh' cannot be found in the current folder"
fi

    # no more jobs to be started but wait for pending jobs
    # (all need to be finished)
    wait
else
  echo "The address: function_workspace='$function_workspace' is not a directory"
fi

echo "Process finished!!!"