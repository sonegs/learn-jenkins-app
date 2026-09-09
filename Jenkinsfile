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
                    echo "Node:"
                    node --version

                    echo "npm:"
                    npm --version

                    rm -rf node_modules

                    if ! npm ci; then
                        echo "===== NPM CI FAILED ====="
                        echo "===== CACHE ====="
                        npm config get cache || true

                        echo "===== LOGS ====="
                        find /home/node/.npm -type f -maxdepth 3 -print -exec cat {} \\; || true

                        exit 1
                    fi

                    npm run build
                '''
            }
        }
    }
}