pipeline {
    agent any

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    set -e

                    rm -rf node_modules

                    ls -la
                    node --version
                    npm --version

                    npm ci || {
                        echo "===== NPM DEBUG LOG ====="
                        ls -la /home/node/.npm/_logs || true
                        cat /home/node/.npm/_logs/* || true
                        exit 1
                    }

                    npm run build

                    ls -la
                '''
            }
        }
    }
}