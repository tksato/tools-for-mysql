#!/bin/bash

# script to get row counts from all tables in schema (mysql)

cd `dirname $0`

# login path
MYSQL_LOGIN_PATH=$1

# target database
DATABASE=$2

# current timestamp
DATE_YMD=`date "+%Y%m%d"`
DATE_HMS=`date "+%H%M%S"`

# get table's name in schema
TABLES=(`mysql --login-path=${MYSQL_LOGIN_PATH} -N -e "show tables from ${DATABASE}"`)

# teble's row count
TABLES_COUNT=${#TABLES[*]}
#echo ${TABLES}

# generate sql
CNT=0
for TABLE in ${TABLES[@]};
do
    CNT=$(( CNT + 1 ))
    # execute sql to get row count from table
    SQL="${SQL} SELECT '${TABLE}' AS table_name, COUNT(*) AS table_row_cnt FROM ${DATABASE}.${TABLE}"

    # add 'UNION ALL' except last row
    if [ ${CNT} -ne ${TABLES_COUNT} ]; then
        SQL="${SQL} UNION ALL"
    fi
done

#echo ${SQL}

# execute sql to get table's count
mysql --login-path=${MYSQL_LOGIN_PATH} -e "${SQL}" >> ${DATABASE}_${DATE_YMD}_${DATE_HMS}.log
