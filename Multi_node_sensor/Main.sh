#!/bin/bash 
tittle="------Executing multi process on Linux------"
echo ""
echo $tittle
echo ""
echo "-->> Starting process..."
username="ariosky"
password="AngelE12A"

declare -a nodes=("gpu01" "gpu01" "gpu01" "gpu01" "gpu01" "gpu02" "gpu02" "gpu02" "node01" "node01" "node02" "node02" "node03" "node04" "node05" "node06" "node07" "node08" "node09" "node10")

N=${#nodes[@]}
echo "Total of instances: "$N

function_workspace="/home/ariosky/Actual_Process/BC-VARETA_Toolbox/"
script_path="/home/ariosky/Actual_Process/Multi_node_sensor"
function_name="Main"
idnode=1
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

# no more jobs to be started but wait for pending jobs
# (all need to be finished)
wait

echo "Process finished!!!"