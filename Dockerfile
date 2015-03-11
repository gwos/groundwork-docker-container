FROM ubuntu:14.04
MAINTAINER Bitnami.com

## OS setup
# perform upgrade and install required packages
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y libwrap0 libx11-6 wget && \
  locale-gen en_US.UTF-8

## GroundWork installation
# Install GroundWork, add additional records for cloudhub upgrade and upgrade GroundWork itself
RUN mkdir -p /root/build && \
  wget https://downloads.bitnami.com/files/download/groundwork-docker/groundworkenterprise-7.0.2-br339-gw2112-linux-64-installer-docker.run -O /root/build/installer.run && \
  wget https://downloads.bitnami.com/files/download/groundwork-docker/groundworkpatch-7.0.2-1-03-linux-64-installer.run -O /root/build/patch-installer.run && \
  chmod 0700 /root/build/installer.run /root/build/patch-installer.run && \
  /root/build/installer.run --postgres_password groundwork --minimummemory 128 --groundworkvalidations_minimum_free_disk_space 1 --mode unattended && \
  PGPASSWORD=groundwork /usr/local/groundwork/postgresql/bin/psql -U postgres gwcollagedb --command "INSERT INTO applicationtype (name, description, statetransitioncriteria) VALUES ('DOCK', 'Cloud Hub Docker Monitoring', 'Device;Host;ServiceDescription'), ('ODL', 'Net Hub Open Daylight Monitoring', 'Device;Host;ServiceDescription');" && \
  service groundwork stop && \
  /root/build/patch-installer.run --mode unattended && \
  service groundwork stop && \
  rm -fR /root/build

# Remove JPP history (so it starts up successfully next time)
RUN rm -fR /usr/local/groundwork/jpp/standalone/configuration/standalone_xml_story/current

## Add and unpack additional files
RUN wget https://downloads.bitnami.com/files/download/groundwork-docker/groundworkenterprise-7.0.2-docker-contents.tar.gz -O /root/groundworkenterprise-7.0.2-docker-contents.tar.gz && \
  tar -C /root -xzf /root/groundworkenterprise-7.0.2-docker-contents.tar.gz && \
  rm /root/groundworkenterprise-7.0.2-docker-contents.tar.gz

## Cloudhub upgrade
# Replace existing cloudhub.war
RUN cp /root/cloudhub-upgrade/cloudhub.war /usr/local/groundwork/foundation/container/jpp/standalone/deployments

# Create new profiles folder
RUN mkdir /usr/local/groundwork/config/cloudhub/profile-templates

# Move new profiles into folder
RUN cp /root/cloudhub-upgrade/*monitoring_profile.xml /usr/local/groundwork/config/cloudhub/profile-templates

# Move old profiles into folder
RUN cp /usr/local/groundwork/core/vema/profiles/* /usr/local/groundwork/config/cloudhub/profile-templates

# Change owner
RUN chown -R nagios:nagios /usr/local/groundwork/config/cloudhub

# Clean up
RUN rm -fR /root/cloudhub-upgrade /root/build

# Update performance data config
RUN awk '/# Cloud Hub for Open Stack performance data/{ print "    # Performance Data for Container monitoring" ; print "    <perfdata_source DOCK>" ; print "        perfdata_file = \"/usr/local/groundwork/core/vema/var/dock-perfdata.dat.being_processed\"" ; print "        seek_file     = \"/usr/local/groundwork/core/vema/var/dock-perfdata.dat.seek\"" ; print "    </perfdata_source>\n" }1' /usr/local/groundwork/config/perfdata.properties > perfdata.properties.tmp && \
  mv perfdata.properties.tmp /usr/local/groundwork/config/perfdata.properties

# Disable not needed services
RUN cd /usr/local/groundwork/common/scripts/ && \
  mv ctl-syslog-ng.sh ctl-syslog-ng.sh.disabled && \
  mv ctl-snmptt.sh ctl-snmptt.sh.disabled && \
  mv ctl-snmptrapd.sh ctl-snmptrapd.sh.disabled && \
  mv ctl-nms-ntop.sh ctl-nms-ntop.sh.disabled

# Create backup
RUN service groundwork start postgresql && \
  mkdir -p /root/backup && \
  /root/gw-backup-br0 --password groundwork --filepath /root/backup && \
  service groundwork stop

RUN rm -rf /usr/local/groundwork/jpp/standalone/configuration/standalone_xml_history/current
RUN mkdir -p /home/groundwork/data

RUN \
  GROUNDWORK=/usr/local/groundwork && \
  USER_DATA=/home/groundwork/data && \
  DATA_DIRS="/config /postgresql/data /jpp/standalone/deployments /rrd /cacti/htdocs/rra /nagios/var /nagvis/etc" && \
  (find $GROUNDWORK/config -type l | grep -v 'gatein.properties$' | xargs -I % su -c 'link=`readlink %` && link=${link:3} && rm /usr/local/groundwork/$link && ln -s /home/groundwork/data/etc/$link /usr/local/groundwork/$link') && \
  for i in ${DATA_DIRS} ; do rm -rf $GROUNDWORK$i && ln -s $USER_DATA$i $GROUNDWORK$i ; done

# Set up boot script
CMD /root/boot.sh

