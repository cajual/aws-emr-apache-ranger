#!/bin/bash
set -euo pipefail
set -x
#================================================================
# Creates dummy Hive Tables for testing
#================================================================
#% SYNOPSIS
#+    createHiveTables.sh args ...
#%
#% DESCRIPTION
#%    Uses Hive CLI to setup dummy Hive tables
#%
#% EXAMPLES
#%    createHiveTables.sh args ..
#%
#================================================================
#- IMPLEMENTATION
#-    version         createHiveTables.sh 1.0
#-    author          Varun Bhamidimarri
#-    license         MIT license
#-
#
#================================================================
#================================================================

# Define variables
awsregion=$1
hive_script_data_location=s3://$awsregion.elasticmapreduce.samples/hive-ads/data/
echo "USE default;
CREATE EXTERNAL TABLE IF NOT EXISTS tblanalyst1 (
 request_begin_time STRING,
 ad_id STRING,
 impression_id STRING, 
 page STRING,
 user_agent STRING,
 user_cookie STRING,
 ip_address STRING,
 clicked BOOLEAN )
PARTITIONED BY (
 day STRING,
 hour STRING )
STORED AS SEQUENCEFILE
LOCATION '$hive_script_data_location/joined_impressions/';
MSCK REPAIR TABLE tblanalyst1;
CREATE EXTERNAL TABLE IF NOT EXISTS tblanalyst2 (
 request_begin_time STRING,
 ad_id STRING,
 impression_id STRING, 
 page STRING,
 user_agent STRING,
 user_cookie STRING,
 ip_address STRING,
 clicked BOOLEAN )
PARTITIONED BY (
 day STRING,
 hour STRING )
STORED AS SEQUENCEFILE
LOCATION '$hive_script_data_location/joined_impressions/';
MSCK REPAIR TABLE tblanalyst2;
" >> createTable.hql
sudo -u hive hive -f createTable.hql
