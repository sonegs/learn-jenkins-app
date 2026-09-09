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
    echo "===== DNS ====="
    cat /etc/resolv.conf

    echo "===== REGISTRY DNS ====="
    getent hosts registry.npmjs.org || true

    echo "===== NPM PING ====="
    npm ping || true

    echo "===== CURL ====="
    curl -I --max-time 10 https://registry.npmjs.org/ || true

    npm ci
                    npm run build
                '''
            }
        }
    }
}