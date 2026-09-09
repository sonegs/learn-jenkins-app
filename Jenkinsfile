pipeline {
    agent any

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }

            steps {
                sh '''
                    echo "===== LOGS demostrando que hay cambios ====="
                    node --version

                    echo "npm:"
                    npm --version

                    rm -rf node_modules

                    npm ci    EXIT_CODE=$?

    echo "===== EXIT CODE: $EXIT_CODE ====="
    echo "===== NPM LOG ====="

    cat /home/node/.npm/_logs/*-debug-0.log || true

    exit $EXIT_CODE

                    npm run build
                '''
            }
        }
    }
}