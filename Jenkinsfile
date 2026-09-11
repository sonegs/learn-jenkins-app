pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = '76808d22-ae2f-4808-9192-c4dbec52d36a'
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
        REACT_APP_VERSION = "1.0.$BUILD_ID"
    }

    stages {

        stage('Docker'){
            steps {
                sh '''
                    docker build -t my-playwright .
                '''
            }
        }

        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    npm run build
                    ls -la
                '''
            }
        }

        stage('Tests') {
            parallel {
                stage('Unit tests') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }

                    steps {
                        sh '''
                            #test -f build/index.html
                            npm test
                        '''
                    }
                    post {
                        always {
                            junit 'jest-results/junit.xml'
                        }
                    }
                }

                stage('E2E') {
                    agent {
                        docker {
                            image 'my-playwright'
                            reuseNode true
                        }
                    }

                    steps {
                        sh '''
                            serve -s build &
                            sleep 10
                            npx playwright test  --reporter=html
                        '''
                    }

                    post {
                        always {
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Local E2E', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }
                }
            }
        }

        stage('Deploy staging') {
            agent {
                docker {
                    image 'my-playwright'
                    reuseNode true
                }
            }

            steps {
                sh '''

                    netlify --version
                    echo "=== Deploying to staging ==="
                    echo "Site ID: $NETLIFY_SITE_ID"
                    netlify status
                    netlify deploy \
                        --dir=build \
                        --json > deploy-output.json

                    export CI_ENVIRONMENT_URL=$(node-jq -r '.deploy_url' deploy-output.json)
                    npx playwright test --reporter=html



                    // set -e

                    // echo "=== Environment ==="
                    // node --version
                    // npm --version
                    // uname -m
                    // node -p "process.arch"

                    // echo "=== Clean dependencies ==="
                    // rm -rf node_modules

                    // echo "=== Install Netlify CLI ==="
                    // npm install netlify-cli@20.1.1 node-jq

                    // echo "=== Netlify version ==="
                    // node_modules/.bin/netlify --version

                    // echo "=== Deploying to staging ==="
                    // echo "Site ID: $NETLIFY_SITE_ID"

                    // node_modules/.bin/netlify status

                    // node_modules/.bin/netlify deploy \
                    //     --dir=build \
                    //     --json > deploy-output.json

                    // echo "=== Staging deploy output ==="
                    // cat deploy-output.json

                    // export CI_ENVIRONMENT_URL=$(node_modules/.bin/node-jq -r '.deploy_url' deploy-output.json)

                    // echo "=== STAGING URL ==="
                    // echo "$CI_ENVIRONMENT_URL"

                    // echo "=== Staging E2E tests ==="
                    // npx playwright test --reporter=html
                '''
            }

            post {
                always {
                    publishHTML([
                        allowMissing: false,
                        alwaysLinkToLastBuild: false,
                        keepAll: false,
                        reportDir: 'playwright-report',
                        reportFiles: 'index.html',
                        reportName: 'Staging E2E',
                        reportTitles: '',
                        useWrapperFileDirectly: true
                    ])
                }
            }
        }

        // stage('Approval') {
        //     steps {
        //         timeout(time: 15, unit: 'MINUTES') {
        //             input message: 'Do you wish to deploy to production?', ok: 'Yes, I am sure!'
        //         }
        //     }
        // }

        stage('Deploy prod') {
            agent {
                docker {
                    image 'my-playwright'
                    reuseNode true
                }
            }

            environment {
                CI_ENVIRONMENT_URL = 'https://super-paprenjak-baff56.netlify.app' 
            }

            steps {
                sh '''
                    netlify --version
                    echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
                    netlify status
                    netlify deploy --dir=build --prod
                    sleep 10
                    npx playwright test  --reporter=html
                '''
            }

            post {
                always {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Prod E2E', reportTitles: '', useWrapperFileDirectly: true])
                }
            }
        }
    }
}
