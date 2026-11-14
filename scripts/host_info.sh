# Pseudo code
# - assign CLI arguments to variables (e.g. `psql_host=$1`) 
# - parse host hardware specifications using bash cmds
# 	- assign the parsed outputs to variables
# - construct the INSERT statement from specification variables
# - execute the INSERT statement through the psql CLI tool

# Setup and validate arguments (again, don't copy comments!)
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check # of args
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

# Save machine statistics and hostname to variables
specs=`lscpu`
hostname=$(hostname -f)

# Retrieve hardware specification variables
# xargs is a trick to trim leading and trailing white spaces
cpu_number=$(echo $specs | awk '{print $20}' | xargs)
cpu_architecture=$(echo $specs | awk '{print $2}' | xargs)
cpu_model=$(echo $specs | awk '{print $30, $31, $32, $33, $34}' | xargs)
cpu_mhz=$(echo $specs | awk '{print $34 * 1000}' | tr -d "GHz" | xargs)

L2_cache=$(lscpu -C | grep L2 | awk '{print $2}' | tail -n1 | tr -d 'K' | xargs) # in kB

cpu_stats=`cat /proc/meminfo`
total_mem=$(echo $cpu_stats | awk '{print $2}' | xargs) # in kB

# Current time in `2019-11-26 14:40:19` UTC format
timestamp=$(vmstat -t | awk '{print $18} {print $19}' | tail -n2 | xargs) #todo

insert_stmt="INSERT INTO host_info(hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem) VALUES('$hostname', $cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$timestamp', '$total_mem');" 

#set up env var for psql cmd
export PGPASSWORD=$psql_password 
#Insert date into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?