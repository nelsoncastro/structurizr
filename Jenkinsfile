pipeline {
    agent any

    stages {
      stage('Build') {
        steps {
          sh 'structurizr-cli push -url http://localhost:8070/api -id 1 -key 3a04942a-234a-4d33-84c0-79259163098c -secret 2772e46c-4902-4d1f-8924-0b70842d2116 -w workspace.json'
        }
      }
    }
}
