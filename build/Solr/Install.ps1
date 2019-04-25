Param(
    [parameter(Position=0,Mandatory=$false,HelpMessage="Remove the container if existing")][switch]$Remove
)

# Define variables
$containername="habitat-solr"

#Functions
function Write-Status {
    Param(
        [parameter(Position=0,Mandatory=$true)][string]$Message
    )
    Write-Host $Message -ForegroundColor DarkYellow
}

# Check for removal
if ($Remove -and (docker ps -q -f name=$containername)) {
    Write-Status "Removing existing container '$containername'"
    docker stop $containername
    docker rm $containername
    docker volume rm $(docker volume ls -f dangling=true -q)
}

Write-Status "Start container '$containername'"
docker-compose up -d

Write-Status "Set up needed cores"
Start-Sleep -Seconds 10

docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_xdb -d /opt/solr/server/solr/configsets/_default
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_xdb_rebuild -d /opt/solr/server/solr/configsets/_default
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_core_index -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_core_index_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_master_index -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_master_index_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_web_index -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_web_index_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_marketingdefinitions_master -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_marketingdefinitions_master_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_marketingdefinitions_web -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_marketingdefinitions_web_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_marketing_asset_index_master -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_marketing_asset_index_master_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_marketing_asset_index_web -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_marketing_asset_index_web_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_testing_index -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_testing_index_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_suggested_test_index -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_suggested_test_index_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_fxm_master_index -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_fxm_master_index_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_fxm_web_index -d /opt/solr/server/solr/configsets/sitecore_configs
docker exec -it --user=solr habitat-solr bin/solr create_core -c habitat_fxm_web_index_rebuild -d /opt/solr/server/solr/configsets/sitecore_configs

docker cp ./certificates/. habitat-solr:/opt/solr/server/etc
docker cp ./solr/. habitat-solr:/opt/solr/bin

Write-Status "Restart container '$containername'"
docker restart $containername

Write-Status "Finished Installation of container '$containername'"