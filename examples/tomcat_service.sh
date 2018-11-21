#/etc/systemd/system
#tomcat_{server_name}
[Unit]
Description=Apache Tomcat for logon
Wants=network.target
After=network.target

[Service]
Type=forking
Environment=JAVA_HOME=/usr/local/java/jdk1.8.0_181
Environment=CATALINA_PID=/opt/slogon_tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/slogon_tomcat

Environment='CATALINA_OPTS=-Xms3G -Xmx3G -XX:PermSize=1G -XX:MaxPermSize=2G  -Djava.net.preferIPv4Stack=true'
Environment='JAVA_OPTS=-Djava.awt.headless=true -server -Dfile.encoding=UTF-8'

ExecStart=/opt/slogon_tomcat/bin/startup.sh
ExecStop=/opt/slogon_tomcat/bin/shutdown.sh
SuccessExitStatus=143

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target