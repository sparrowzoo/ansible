pipeline {
    agent any
    parameters {
        string defaultValue: 'prod', description: '', name: 'env', trim: false
        string defaultValue: 'sdevice-cloud', description: '', name: '', trim: false
        string defaultValue: 'sdevice-server', description: '', name: 'service_name', trim: false
        string defaultValue: 'feature_eureka_20181016', description: '', name: 'git_branch', trim: false
    }
    stages {
        stage('clean workspace') {
            steps{
                sh 'rm -rf  ${WORKSPACE}/*'
            }
        }
        stage('check out project') {
            steps{
                dir ("${project_name}") {
                    sh ' pwd '
                    //git@gitlab.bitmain.com
                    //git@gitlab.bitmain.com:smartminers/sdevice-cloud.git
                    git branch: '${git_branch}', credentialsId: '75f71fe0-c4e8-4b5d-bb0e-f5f86d5f9d53', url: '${smartminers_git_root}:smartminers/${project_name}.git'
                }

            }
        }

        stage('mvn build'){
            steps{
                sh ' mvn  clean package -Dmaven.test.skip=true -U -f ${WORKSPACE}/${project_name}/pom.xml'
            }
        }
        stage('deploy'){
            steps {
                sh ''' 
				    time=$(date +%Y%m%d%H%M%S)
					backup_dir="$JENKINS_HOME/backup/${project_name}/${env}/$time"
					if [ ! -e $backup_dir ];then mkdir -p $backup_dir ;fi
					cp ${WORKSPACE}/${project_name}/${service_name}/target/${service_name}-1.0-SNAPSHOT.war  $backup_dir/
					
					deploy_ansible_root="/Users/bitmain/it/ansible/examples"

					inventory_host="sdevice"
					app_file="${backup_dir}/${service_name}-1.0-SNAPSHOT.war"


                    if [ ! -e $app_file ];then echo "${app_file} does't exist!" exit -1;fi
                    app_file_dest_path="~/.jenkins/${service_name}.war"

					ansible-playbook ${deploy_ansible_root}/deploy.yml \
					--extra-vars "app_file=$app_file app_file_dest_path=$app_file_dest_path inventory_host=$inventory_host tomcat_service=${service_name}"
				'''
            }
        }
    }
}