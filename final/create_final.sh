## ======================================================================
##  Name:    create_final.sh
##  Author:  Michael McLaughlin
##  Date:    02-Apr-2020
## ------------------------------------------------------------------
##  Purpose: Provide an example with proper error checking.
## ======================================================================

#!/usr/bin/bash

# Assign user and password
username="student"
password="student"
directory="/home/student/Data/cit325/final"

echo "User name:" ${username}
echo "Password: " ${password}
echo "Directory:" ${directory}

# Define an array.
declare -a cmd
echo "after define--------"

# Assign elements to an array.
cmd[0]="base_t.sql"
cmd[1]="create_tolkien.sql"
cmd[2]="dwarf_t.sql"
cmd[3]="elf_t.sql"
cmd[4]="goblin_t.sql"
cmd[5]="hobbit_t.sql"
cmd[6]="maia_t.sql"
cmd[7]="man_t.sql"
cmd[8]="orc_t.sql"
cmd[9]="noldor_t.sql"
cmd[10]="silvan_t.sql"
cmd[11]="sindar_t.sql"
cmd[12]="teleri_t.sql"
cmd[13]="type_validation.sql"
cmd[14]="insert_instances.sql"
cmd[15]="query_instances.sql"
echo "------after assignment--------"

# Call the array elements.
echo "before loop"
for i in ${cmd[*]}; do
  echo "------ in loop #${i}-------"
  sqlplus -s ${username}/${password} @${directory}/${i} > /dev/null
done

echo "----------after loop---------------"

# Print query log files.
cat type_validation.txt
cat query_instances.txt
