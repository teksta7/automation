node {
   stage('Info_to_check') { 
       echo 'Attempting to trigger X-Ray'
   
    rtServer(
       id: 'pipeline-ART',
       url: 'http://INSERT_URL_HERE/artifactory',
       username: 'INSERT_USERNAME_HERE',
       password: 'INSERT_PASSWORD_HERE',
       bypassProxy: true
    )
    
    echo "checking build ${params.buildName} with build number of ${params.buildNumber}"
    
   };
   stage('Call_X-Ray') {
      xrayScan (
        serverId: 'pipeline-ART',
        buildName: "${params.buildName}",
        buildNumber: "${params.buildNumber}"
    )
    
   }
}
