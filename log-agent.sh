sudo curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh

sudo apt-get update
sudo apt-get install -y zip

sudo apt-get install -y google-fluentd
sudo apt-get install -y google-fluentd-catch-all-config
sudo service google-fluentd start
sudo tee /etc/google-fluentd/config.d/purchase-log.conf <<EOF
<source>
@type tail
    # Format 'none' indicates the log is unstructured (text).
format none
    # The path of the log file.
path /var/log/cadabra/*.log
    # The path of the position file that records where in the log file
    # we have processed already. This is useful when the agent
    # restarts.
pos_file /var/lib/google-fluentd/pos/test-unstructured-log.pos
read_from_head true
    # The log tag for this log input.
tag purchase-log
</source>
EOF

sudo service google-fluentd restart
wget http://media.sundog-soft.com/AWSBigData/LogGenerator.zip
unzip LogGenerator.zip
chmod a+x LogGenerator.py
sudo mkdir /var/log/cadabra
sudo ./LogGenerator.py 50000
