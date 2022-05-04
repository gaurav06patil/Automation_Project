#On execution of the script, it should update the package details
sudo apt update -y

#checks whether the HTTP Apache server is already installed. If not present, then it installs the server
PACKAGE="apache2"
INSTALLED=$(dpkg-query -W --showformat='${Status}\n' $PACKAGE|grep "install ok installed")
echo Checking for $PACKAGE: $INSTALLED
if [ "" = "$INSTALLED" ]
then
	  sudo apt-get --yes install $PACKAGE
  fi

  #Script checks whether the server is running or not. If it is not running, then it starts the server
  Apache2_service=$(service apache2 status)
  if [[ $Apache2_service == *"active (running)"* ]]
  then
	  echo "Apache2 is running"
  else
	  echo "Apache2 Started now..."
	  sudo service apache2 restart
  fi

  #timestamp code
  myname='gaurav'
  timestamp=$(date '+%d%m%Y-%H%M%S')

  #tar file should be present in the correct format in the /tmp/ directory
  tar -zcvf /tmp/${myname}-httpd-logs-$timestamp.tar /var/log/apache2/*.log

  #store data in S3
  s3_bucket='upgrad-gaurav'
  sudo apt update
  sudo apt install awscli
  aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
 echo "File stored into the $s3_bucket bucket."

#End of script.
