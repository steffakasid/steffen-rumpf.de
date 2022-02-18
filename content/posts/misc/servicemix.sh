#!/bin/sh
#
# @Copyright Steffen Rumpf <srumpf@brockhaus-gruppe.de
# @Since Fr, 14.03.2008
# @ServiceMix Version 3.2.1
#
# Script for creating working directories and SA/SU- sceletons for servicemix
# This script depends on marven, so 'mvn' runnable must be present
#
#####################################################################################

#### Start Configuration ####
blnUsingJboss=false
jbossDeployDir=deploy
servicemixDeployDir=hotdeploy
#### End Configuration ####



cd $PWD;

clear
echo 
echo "Now working in: $PWD";
echo "";
echo "Note: All commands should be use from root working directory!"
echo "";
if [ "$SERVICEMIX_HOME" == "" ]
then
	echo "SERVICEMIX_HOME is not set! Exiting!"
	exit 1
fi

if [ $1 ]
then
	if [ $1 == "-wd" ]
	then
		echo "#################################"
		echo "# Initalising Working Directory #"
		echo "#################################"
		echo ""
		touch pom.xml
		read -p "GroupID: " groupid
		echo ""
		read -p "Version: " version
		echo ""
		read -p "Name: " name
		echo ""
		read -p "Url: " url
		echo ""
		pom="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<project xmlns=\"http://maven.apache.org/POM/4.0.0\"\n\txmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n\txsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd\">\n\t<modelVersion>4.0.0</modelVersion>\n\t<groupId>$groupid</groupId>\n\t<artifactId>parent</artifactId>\n\t<version>$version</version>\n\t<packaging>pom</packaging>\n\t<name>$name</name>\n\t<url>$url</url>\n</project>"

		echo -e $pom > pom.xml
		exit 0;
	fi
	if [ $1 == "-su" ]
	then
		echo "#########################"
		echo "# Creating Service Unit #"
		echo "#########################"
		echo ""
		read -p "GroupID: " groupid
		echo ""
		read -p "ArtifactID: " artifactid
		echo ""
		read -p "Version: " version
		echo ""
		
		j=0;
		echo "Choose servicemix archetype:"
		echo "----------------------------"
		for i in service-unit http-consumer http-provider jms-consumer jms-provider ftp-poller ftp-sender jsr181-annotated jsr181-wsdl-first saxon-xquery saxon-xslt eip lwcontainer bean ode camel cxf-se cxf-bc
		do 
			echo "$j: $i"
			j=`expr $j + 1`
		done
		read -p "Please enter a id from above: " archetype

		case $archetype in
			0)archetypeArtifactId='servicemix-service-unit';;
			1)archetypeArtifactId='servicemix-http-consumer-service-unit';;
			2)archetypeArtifactId='servicemix-http-provider-service-unit';;
			3)archetypeArtifactId='servicemix-jms-consumer-service-unit';;
			4)archetypeArtifactId='servicemix-jms-provider-service-unit';;
			5)archetypeArtifactId='servicemix-ftp-poller-service-unit';;
			6)archetypeArtifactId='servicemix-ftp-sender-service-unit';;
			7)archetypeArtifactId='servicemix-jsr181-annotated-service-unit';;
			8)archetypeArtifactId='servicemix-jsr181-wsdl-first-service-unit';;
			9)archetypeArtifactId='servicemix-saxon-xquery-service-unit';;
			10)archetypeArtifactId='servicemix-saxon-xslt-service-unit';;
			11)archetypeArtifactId='servicemix-eip-service-unit';;
			12)archetypeArtifactId='servicemix-lwcontainer-service-unit';;
			13)archetypeArtifactId='servicemix-bean-service-unit';;
			14)archetypeArtifactId='servicemix-ode-service-unit';;
			15)archetypeArtifactId='servicemix-camel-service-unit';;
			16)archetypeArtifactId='servicemix-cxf-se-service-unit';;
			17)archetypeArtifactId='servicemix-cxf-bc-service-unit';;
			*)echo 'Unkown ArtifactID please enter archetypeArtifactId by hand.'
			echo "Please enter a ID from above:"
			read archetypeArtifactId;
			echo ""
			;;
		esac

		mvn archetype:create -DarchetypeGroupId=org.apache.servicemix.tooling -DarchetypeArtifactId=$archetypeArtifactId -DgroupId=$groupid -DartifactId=$artifactid -Dversion=$version
		exit 0;
	fi
	if [ $1 == "-sa" ]
	then
		echo "#############################"
		echo "# Creating Service Assembly #"
		echo "#############################"
		echo ""
		read -p "GroupID: " groupid
		echo ""
		read -p "ArtifactID: " artifactid
		echo ""
		read -p "Version: " version
		echo ""
	
		mvn archetype:create -DarchetypeGroupId=org.apache.servicemix.tooling -DarchetypeArtifactId=servicemix-service-assembly -DgroupId=$groupid -DartifactId=$artifactid -Dversion=$version

		exit 0;
	fi
	if [ $1 == "-dp" ]
	then
		echo "#####################################"
		echo "# Deploying Project into ServiceMix #"
		echo "#####################################"
		echo ""
		read -p "Should maven run first (mvn clean install)? [yes/no]: " runmvn
		while [ "$runmvn" != "yes" -a "$runmvn" != "no" ]
		do
			read -p "Plz type yes or no! " runmvn
		done
		if [ $runmvn == "yes" ]
		then
			mvn clean install
			echo "mvn finished with status: $?"
			echo ""
			if [ $? != 0 ] 
			then
				exit 0
			fi
		fi
		echo ""
		echo "Please enter your SA directory"
		read -p "$PWD must not be given: " sadir

		if [ "$blnUsingJboss" == "true" ] 
		then
			cp $PWD/$sadir/target/*.jar $SERVICEMIX_HOME/$jbossDeployDir
		else
			cp $PWD/$sadir/target/*.jar $SERVICEMIX_HOME/$servicemixDeployDir
		fi

		exit 0;
	fi
fi

echo "Usage:"
echo "-wd	creates a new working directory"
echo "-su	creates a new service unit"
echo "-sa	creates a new service assembly"
echo "-dp	deploy the current project"
echo "-h	shows this help"
