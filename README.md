# GroundWork Monitor 7.0.2 Enterprise Release Notes

## System Requirements
GroundWork Monitor 7.0.2 Docker image can be installed on Docker Hub 1.3 or newer.
System Requirements:
- 4GB or more available memory
- 20GB of available disk space. Can be an NFS mount or local directory

## Install instructions
There are two ways to get the GroundWork Monitor docker image into your environment

### Build
- To build the image, simply invoke:
```
sudo docker build -t groundwork_docker github.com/gwos/groundwork-docker-container
```
### Use pre-built docker image
- A prebuilt container is also available in the docker index:
```
sudo docker pull gwos/groundwork-docker-container
```
### Usage

- After the image was created run the container with the following command:
```
docker run -it --name gwos-702 -h HOST-NAME -v LOCAL-STORAGE:/home/groundwork/data -v /etc/localtime:/etc/localtime:ro -p 80:80 groundwork_docker
```

#### Notes:
- HOST-NAME needs to be resolvable because authentication uses intercept/redirect
- LOCAL-STORAGE is the directory were the persistent data is stored between runs
- The container runs on port 80. Make sure that you don't have another Apache on the same host
- Once the container is created it can be started and stopped with the commands:
```
sudo docker start gwos-702 or sudo docker stop gwos-702
```

This release of GroundWork Monitor adds several new features to enhance the monitoring experience with extensions to monitor virtual environments, simplify notifications and escalations, and generally enhance usability.


# Summary of new features in GroundWork Monitor 7.0.2

GroundWork Monitor 7.0.2 is a maintenance release that includes a large number of bugfixes and several significant usability and performance improvements. It is recommended to upgrade to GWME 7.0.2 release to take advantage of these improvements that are described in more details in the following section.

## Event Console

The current release improves the Event Management workflow and make sure that all functionality is consistent across all data types. The consistency across all monitoring data sources (Virtual environments, Devices monitored by Cacti, servers monitored by Nagios, syslog and trap feeds) is becoming more important in today's compute services. The Event Console changes for GWME 7.0.2 were focused on seamlessly integrating all type of event data. The changes can be summarized as following:

- New color codes are added for the 5 default operation status(Orange for open, yellow for notify, black for close,green for accept, purple for acknowledge. First column in the event console shows the operation status color coded.
- Since 7.0.2, the default view of the status viewer is All Events. All open events are moved to the public filter. The above color code helps identifying the operation status for the messages in the all events view.
- Acknowledge is a new OperationStatus but pre-pocessing will not be a allowed for this type. In foundation.properties, customers add preprocessing criteria's for application types. We want to prevent auto acknowledgement of message knowingly or unknowingly.
- Acknowledge Events for all Application types with a comment that will be shown in the default view.
- "Nagios Acknowledge" action applies to Nagios only. "Acknowledge Log Message" action applies to all non-nagios application types.
- All Non-Nagios messages, can be grouped and acknowledged at same time. If Nagios messages are mixed with other messages, then only
- Accept, Open, Close, Notify action be performed. So the new color coded buttons appear/disappear accordingly based on the selected messages.
- Event Console Column Device will be replaced with Host.
- Enable links to SV Host or Host/Service for all application types
- Clicking on Event Tile portlets take to Event console with the Hostgroup or servicegrup filter applied.
- In Event Console, Show Event Tile shows the event tile portlet dialog which can be dragged within the Event console screen
- The Event Tile portlet is now integrated in the Dashboard and in the Event Console. Selecting any Pie chart will link to Event Console and open a filtered view.

#Quick overview of the new elements:

## REST API

Starting with GWME 7.x the REST API was introduced that gives secure access to GroundWork objects including:

- CRUD operation on monitoring elements (Host/HostGroup/Services/ServiceGroup) and Events
- Access to submit alerts to the Notification engine
- Access to create and update performance data
- CRUD operations for Custom Groups

[The REST API documentation is available in GroundWork's bookshelf.](https://kb.groundworkopensource.com/display/DOC70/RESTful+API+Documentation)

To enable developers for rapid development the rest api client libraries are available on the public Nexus repository. Java developers can add the reference to the POM to have all dependencies included in a project.  
More details on how to integrate the REST Clients can be found in the developer section of the bookshelf.

## Performance improvements

The legacy Nagios feeders (status & event) and the newly introduced Cacti feeder have been re-factored to use the REST API to submit data into the GroundWork system. Using the more the more scale-able REST API and replacing the legacy XML feeders resulted in a more robust and better performing data feed into the GroundWork system. The system planning guide has been revised to reflect the improvements.

## Cloud Hub 1.3

- The latest version of Cloud Hub includes support for monitoring Open Stack environments. Cloud Hub can now simultaneously monitor VMware, RHEV and Open Stack virtualization environments through the same instance and setup.  [More information ...](https://kb.groundworkopensource.com/display/DOC70/GroundWork+Cloud+Hub)

## Security and Authentication

The current version of GroundWork Monitor went through a security and penetration assessment by Verizon Security services and received a rating that was above the Technology industry average. Details of the reports can be made available to existing customers upon request.

## Cacti

GroundWork Monitor 7.0.2 includes a Cacti feeder which is enabled by default. With this feeder and devices monitored by Cacti and having a threshold defined will automatically added to the GroundWork Foundation and therefore immediately visible in Status Viewer and event console. The step of importing cacti hosts to Monarch is no longer necessary and this step has been automated.

# Summary of new features in GroundWork Monitor 7.0.0/7.0.1

## Red Hat JBoss Portal

GroundWork Monitor 7.0.0 incorporates a completely new Enterprise Portal Platform that is highly scalable with powerful performance. Jboss Portal Platform 6 is based on the latest JBoss Application server that was re-designed to be highly modular and cloud-ready. Portal management actions such as creating and maintaining users, roles, pages, and layouts are part of the JBoss enterprise framework that significantly improves usability.

Creating Dashboard pages or MyGroundWork views has been simplified. With a few clicks and drag & drop, pages can be created and administered.

All GroundWork applications were integrated into the portal, taking advantage of the new Navigation (drop down menus), and the improved security scheme. The GroundWork applications were re-skinned to improve the look-and-feel. Also note that administrative privileges are now split between the <tt>admin</tt>user used in previous releases, and a new <tt>root</tt> user which can perform certain tasks that the <tt>admin</tt> user cannot.

## GroundWork Cloud Hub 1.2

This release provides enhanced monitoring for VMware vSphere, VMware ESXi, and Red Hat Enterprise Virtualization. Hypervisors and Hypervisor Management data will be seamlessly integrated into the GroundWork UI. In addition Cloud Hub configuration now allows selection of additional views such as Storage or Network Domains and Resource Pools. The views are visible in Event Console and Status Viewer [More information ...](https://kb.groundworkopensource.com/display/DOC70/GroundWork+Cloud+Hub)

## Archive Database

A new log-message archiving facility is supported. This allows long-term operational data to be moved aside for reporting purposes, keeping the active-monitoring database far smaller and more sprightly.

An Archive Server is intended to take over the duty of storing long-term performance and event data. On a regular basis, typically shortly after midnight each day, recent data will be extracted from a GroundWork Monitor runtime database, transferred to a separate machine if necessary, and injected into a separate archive database.

For more information, see the Archive Database subsection below.

## Configuration UI and workflow changes

The visual appearance of the Configuration and Auto-Discovery applications has been overhauled to make them much cleaner.

Management of the Nagios Main Configuration options has been overhauled. They are now logically categorized and ordered within those categories; the categories themselves are grouped into a fairly natural progression of concerns; and the navigational links to reach the options are extended to show the category names, making it much easier to find what you're looking for.

For more information, see the Configuration (Monarch) subsection below.

## Business Service Monitoring (BSM)

The BSM application provides GroundWork customers the capability to represent the condition of Business Groups, Processes, and Applications according to the combined states of individually monitored hosts and services. The method allows the free combining of hosts and/or services and/or groups as components of named groups. The combinations can be assigned numerical values to weight or qualify the member items. In this way we can produce a hierarchical representation of the state of Business Services independently of the methods used to monitor components. Notifications and State changes of BSM groups are integrated into the GroundWork system using the Notification (NoMA) engine and the Event Console for further processing. Creating BSM entities and enabling them does not require Configuration changes and subsequent commits.

## Component Upgrades

With the release of GroundWork Monitor 7.0.0, many components have been upgraded to the latest available versions. The following list shows the new version of the key components that have been updated with GWME 7.0.0 release:

- Nagios 3.5.0
- Java 1.7.0\_25
- Postgres 9.1.9
- RRDtool 1.4.8
- Apache to 2.2.23
- modsecurity to 2.7.2

## CHANGES IN GWME 7.0.X

### Security and Authentication

- Configuration of enabling SSL and integration with LDAP has changed in the 7.0.1 release. See [the SSL instructions](https://kb.groundworkopensource.com/display/DOC70/How+to+enable+SSL+support+for+GWME+7.x) and [the LDAP instructions](https://kb.groundworkopensource.com/display/DOC70/How+to+AD+and+LDAP+configuration) for details.
- OpenLDAP is now supported as an authentication mechanism. GroundWork Monitor supports single sign-on authentication through an external authentication source. Authentication services can be provided by Microsoft Active Directory or through a standards-compliant LDAP server. Most user accounts need not be defined in GroundWork Monitor a priori. User accounts must still be assigned system-specific roles and privileges, and the use of LDAP for authentication changes the way this is done. Configuring the GroundWork JBoss Portal for LDAP allows user passwords and other details such as role membership to be managed by the external directory service. User accounts and roles are synchronized with the GroundWork JBoss Portal when the user logs in, and users are assigned a default role as well as any roles they are members of in LDAP. It is also possible to enable LDAPS, or LDAP over SSL, as well as many other alternate configurations.
- A bug in the 7.0.0 release prevented administrators from resetting passwords properly. This is fixed in the 7.0.1 release.
- Several security holes and permissions problems have been addressed.

### Configuration (Monarch)

- The visual appearance of the Configuration and Auto-Discovery applications has been overhauled to make them much cleaner.
- Management of the Nagios Main Configuration options has been overhauled. They are now logically categorized and ordered within those categories; the categories themselves are grouped into a fairly natural progression of concerns; and the navigational links to reach the options are extended to show the category names, making it much easier to find what you're looking for. In addition, a number of options that were previously not explicitly displayed, and only available via the catch-all Miscellaneous Directives capability, are now first-class citizens in the option screens.
- The "Check service freshness" option in the Nagios Main Configuration is now enabled by default in a fresh-install configuration. This provides the top-level enablement needed for freshness checks to run for GDMA client-machine services. In order not to disturb existing production setups, this value will not be altered during an upgrade; but existing customers may wish to consider their own setting of this option.
- The on-screen organization of Nagios object options that are managed by host and service templates has been revised, to move away from a jumbled, seemingly-random order to a reasonable logical ordering.
- Nagios service stalking options are now supported.
- Organization, display, and behavior of template-inheritance screens has been improved to more intuitively show when template values are in play, as opposed to specific override values.
- Deployment of configurations to child servers has been protected against some potential temporarily-damaging concurrent actions.
- The help messages for Notes, Notes URL, and Action URL fields in host extended info templates and service extended info templates have been revamped to clearly describe the macro substitutions that are performed when these entries are applied to particular hosts and host services.
- (7.0.1) Support for externals is now enabled by default in the fresh-install Monarch seed data, and forced on during an upgrade from a previous release. This is to better support GroundWork Distributed Monitoring Agents (GDMA) deployments in out-of-the-box deployments.
- (7.0.1) GDMA auto-registration is now supported in an out-of-the-box fresh install of GWMEE, by the addition of a hostgroup ("Auto-Registration") and a Monarch Configuration Group ("auto-registration") corresponding to the values in the <tt>config/register_agent.properties configuration</tt> file. Similarly, if auto-registration is enabled in that file during an upgrade from a previous release, the locally configured names for those objects will be added to Monarch if they do not already exist.
- (7.0.1) Similarly, host profiles to support auto-registration from the standard GDMA-supported platforms are now part of the Monarch seed data in a fresh install, and will be added to Monarch during an upgrade if auto-registration is enabled in the <tt>config/register_agent.properties configuration</tt> file.
- (7.0.1) A bunch of new performance-configuration entries are now present in the fresh-install Monarch seed data, and added during an upgrade, to support standard GDMA-monitored services on the various supported GDMA platforms.
- (7.0.1) The mechanism used to graph CloudHub-sensed metrics has been modified to better favor known data over unknown data, so any gaps in monitoring are much less likely to display gaps in the drawn graphs. This change only affects newly created RRD files; it will not reach back and modify already-created RRD files.
- (7.0.1) New sets of profiles are now available to cover monitoring of certain Citrix products, Network security appliances from various vendors, and Hitachi storage platforms. See the Citrix, Network-Security-Appliances, and Storage profile categories, respectively.

### PostgreSQL

- (7.0.1) The location of the PostgreSQL log file has been changed from <tt>/usr/local/groundwork/postgresql/data/postmaster.log</tt> to <tt>/usr/local/groundwork/postgresql/data/pg_log/postmaster.log</tt>, placing it in a subdirectory to avoid intermixing such files with configuration data.
- (7.0.1) The PostgreSQL log file is now rotated on a weekly basis, to prevent it from growing forever. PostgreSQL may continue to log into the renamed file (<tt>postmaster.log.1</tt>) for up to an hour after the weekly file rotation, before it recognizes the situation and opens a new log file under the usual name (<tt>postmaster.log</tt>). There is no loss of information involved in this delayed transition.
- (7.0.1) The <tt>/usr/local/groundwork/logs/postmaster.log</tt>symlink now points to the new location of the log fila, and a companion <tt>/usr/local/groundwork/logs/postmaster.log.1</tt>symlink is also provided to make it easy to access the renamed log file. This may be useful both during the period before PostgreSQL opens a new log file, and in general to look back in time to before the last file-rename action.

### Archive Database

A new log-message archiving facility is supported. This allows long-term operational data to be moved aside for reporting purposes, keeping the active-monitoring database far smaller and more sprightly.

An Archive Server is intended to take over the duty of storing long-term performance and event data. On a regular basis, typically shortly after midnight each day, recent data will be extracted from a GroundWork Monitor runtime database, transferred to a separate machine if necessary, and injected into a separate archive database. Subsequently, long-term reports can be run against the archive database instead of the runtime database. This has two beneficial effects:

- The runtime database is kept small, generally containing only the last few days of data for the main tables of interest here. This keeps it performant during ordinary monitoring operations.
- The potentially significant CPU and disk i/o load of running reports can be offloaded to the separate archive database, which can reside on a different machine. This also contributes to keeping the principle monitoring machine operating smoothly.

Old data is not removed from the runtime database immediately upon being archived; some amount of overlap is allowed, and managed automatically. This provides for such things as ticketing-system references to event messages to remain valid for some time after those messages have been initially copied to the archive database.

In the 7.0.1 release, by popular demand, when log archiving is enabled, the standard retention period for data in the runtime database has been extended to 3 months before deletion. The data should have long since been migrated to the archive database, but it is now kept around long enough for any practical medium-term operational usage instead of being deleted after a week. Sites can locally adjust this period, using the <tt>operationally_useful_days_for_messages</tt> and <tt>operationally_useful_days_for_performance_data</tt> parameters in the <tt>/usr/local/groundwork/config/log-archive-send.conf</tt>config file.

Standard reports which access the Archive Database for long-term reporting are not yet provided in the GWMEE 7.0.1 release. They will be provided at a later date, most likely as a Technical Bulletin patch.

### Nagios

- Nagios has been upgraded to the 3.5.0 release.
- The Bronx Event Broker that GroundWork supplies to work with Nagios has been upgraded to better handle scalability issues (GWMON-10741).
  - A new <tt>max_client_connections</tt> parameter is now present in the <tt>config/bronx.cfg</tt> configuration file. It limits the number of file descriptors used by incoming client connections.
  - A new <tt>reserved_file_descriptor_count</tt> parameter is now present in the <tt>config/bronx.cfg</tt> configuration file. Like the <tt>max_client_connections</tt> parameter, it limits the number of file descriptors used by incoming client connections, both so Nagios itself has enough available for its own work, and so Bronx itself always has a few available for other purposes.
  - A new <tt>idle_connection_timeout</tt> parameter is now present in the <tt>config/bronx.cfg</tt> configuration file. It specifies how long the server should wait to time out client connections which are not actively sending results.

### Cacti

- The Predict plugin ( [http://docs.cacti.net/userplugin:predict](http://docs.cacti.net/userplugin:predict)) is now bundled into the product. To access it, you must first install and enable it from the Plugin Management page in the Cacti Console.
- (7.0.1) Publicly known security vulnerabilities have been addressed by backporting established fixes from later releases.

### GroundWork Distributed Monitoring Agents (GDMA)

The GDMA agent bundles included in GWMEE 7.0.0 and 7.0.1 have been upgraded to the GDMA 2.3.2 release.

The GDMA 2.3.1 release contained these improvements:

- Forcibly setting <tt>Use_Long_Hostname</tt> by default in <tt>gdma_auto.conf</tt>, as we did in the GDMA 2.3.0 release, was a mistake, for most customers. It is now present (for clarity, so people know the option is available) but commented out, which reverts back to the old try-longname, then try-shortname fallback behavior.
- Auto-registration behavior is improved so it operates immediately on the first cycle, when the GDMA poller starts up. Also, if auto-registration is successful, the first fetch of the externals file also happens during that cycle, to shorten the time until monitoring begins.
- Several different backoff algorithms are now available for use should auto-registration fails. GDMA clients are configured by default to use a reasonable backoff algorithm that will not continue to pester the server too often, if auto-registration continues to fail.
- In the GDMA 2.3.0 release, a bug in how the GDMA client handled not finding its own hostname could cause the client poller to die during auto-registration; this is now fixed.
- Bugs in the Windows <tt>diskfree.ps1</tt> script have been fixed.
- The Windows <tt>mountpoint.ps1</tt> plugin script is now deprecated, in favor of the <tt>diskfree.ps1</tt> script.
- Several other PowerShell plugins have had bugs fixed in their handling of warning and critical thresholds.
- Problems in previous releases in how spaces are handled in the value of the <tt>$Plugin_Directory$</tt> macro have now been addressed.
- The sample <tt>multihost_gdma_auto.conf</tt> file provided in the GDMA release now contains the various <tt>Auto_Register_*</tt>directives.
- **NOTICE** : The AIX GDMA build for the GDMA 2.3.1 release contains bad paths in the standard config files. These must be changed from <tt>/opt/groundwork/...</tt> to <tt>/usr/local/groundwork/...</tt> on each AIX client, after installation.

The GDMA 2.3.2 release contains these further improvements:

- GDMA 2.3.2 is the first version to support the use of SSL certificates. This is an important upgrade for security-conscious sites. See [Using GDMA with HTTPS](https://kb.groundworkopensource.com/display/DOC70/Using+GDMA+with+HTTPS) for details.
- Use of companion Certificate Revocation List (CRL) files is optional. They will be used if present on the GDMA client, but their absence will not by itself cause a connection to fail.
- The <tt>Max_Server_Redirects</tt> option is available starting with this release.

### Operating framework

The included version of the Java SDK has been upgraded to the latest version, which is 1.7.0\_45. Java 7 includes many improvements, not only for performance but as well for security.

## OTHER MAJOR CHANGES IN PRIOR RELEASES

### General

- More NMS modules (NeDi, Ntop) are now fully integrated into the base product.
- Custom Groups -- A Custom Group is a collection of host group or service group objects at the user interface level. Custom Groups allow for more freedom to group business functions, locations, or infrastructure setup (e.g. workstations, servers, services), and make them more user-accessible. This is very useful if you have a certain batch of servers attached to an array of servers. Custom groups are more useful from the system manager perspective too, as an administrator does not have to worry about the problem on the segment he doesn't manage. A host group or service group can be a member of multiple custom groups.

### Nagios

- The default value of the <tt>startup_pause_timer</tt> option in the Bronx event broker (and in the <tt>/usr/local/groundwork/config/bronx.cfg</tt> configuration file) has been changed to 0, to avoid loss of data during Nagios startup (GWMON-10412).
- We have dramatically improved the Nagios restart time, down from around 30 seconds to typically 3 to 4 seconds, by recognizing and removing some delays in the way the Bronx event broker was operating (GWMON-10501). This will speed up Commit times considerably.
- The default values, <tt>listener_max_packet_age</tt> and <tt>listener_max_packet_imminence</tt> are now set to <tt>900</tt>in the <tt>/usr/local/groundwork/config/bronx.cfg</tt>configuration file to accomodate the relaxed timing of some environments. This means that an upgrade will not be complete until you manually carry forward any local changes you made to configuration options in the release you are upgrading from.

### Performance Data Handling

- The processing of service performance data has been made more robust and reliable by support for a seek file which is periodically updated as performance data is processed (GWMON-10485). This should prevent the system getting stuck trying to re-read huge amounts of already-processed data under adverse circumstances.
- The processing of service performance data now supports more than one input source (GWMON-10485). This is a complex change requiring separate explanation. See comments in the <tt>/usr/local/groundwork/config/perfdata.properties</tt>file.
- The improvements to performance data handling just noted mean that the content of the <tt>/usr/local/groundwork/config/perfdata.properties</tt>configuration file has changed in this release. This means that an upgrade will not be complete until you manually carry forward any local changes you made to configuration options in the release you are upgrading from.
- Performance data configuration setup has been added to support the Cloud Hub feature, by providing RRD file and graph definitions for the new metrics sensed in that environment (GWMON-10659). In the 7.0.1 release, this setup has been simplified to depend only on a single "Collector Metric" perf-data entry, which matches any "<tt><b>.</b></tt>" type of service name.

### Insight Reports

The reports which are available under <tt>Reports &gt; Alerts,
Reports &gt; Notifications</tt>, and <tt>Reports &gt; Outages</tt>have been updated.

- These reports were broken in the 6.6.X releases, due to an incomplete porting effort and some changes in the behavior of the newer version of Perl that was included in these releases. Those issues are now resolved (GWMON-10453).
- All of the reports now flag an error if the start and end dates are given out of order.
- X-axis and Y-axis labeling has been fixed so the category labels no longer sometimes overlap (GWMON-10094).
- The fonts in the charts have been tuned to keep them readable.
- Some bugs in data collection and calculation for these reports have been fixed.

### GroundWork Distributed Monitoring Agents (GDMA)

- For the GDMA 2.3.0 release, the standard Nagios plugins on the Windows GDMA platform were upgraded from the ancient 1.4.5 release to the then-current 1.4.16 release. This addresses a number of bug reports (GDMA-248, GDMA-328, GWMON-10557). The Perl scripts in the plugins release have been compiled so they will run under Windows without a native Perl interpreter being installed on each GDMA client machine. Since such Perl scripts can generate error messages that refer to line numbers in the Perl source code, we ship the companion Perl source files as well, for reference purposes. For this GDMA release, the Nagios plugins version on UNIX-related platforms (Linux, Solaris, etc.) remains at 1.4.15.
- As part of the upgrade of the Nagios plugins on Windows, we are making available compiled versions of the Perl scripts, and correcting the inappropriate use of Windows shortcuts to emulate symlinks to other plugins, so many more of the standard Nagios plugins are now executable on this platform.
- Many new PowerShell plugins are now available in the Windows GDMA package (GDMA-298, GDMA-309).
- We have standardized on using PowerShell v2 for calling Powershell scripts, because PowerShell v1 just turned out to be too clumsy to use. PowerShell v2 is available for download from Microsoft if it is not already loaded on your Windows machines.
- Support for GDMA on AIX has been brought up to parity with all the other platforms (GDMA-282, GDMA-283, GDMA-284, GDMA-287).
- Starting with the GDMA 2.3.0 release, plugin downloading now works on the AIX platform (GDMA-314).
- The <tt>Use_Long_Hostname</tt> directive is now present in the <tt>gdma_auto.conf</tt> file and enabled there in the standard shipped GDMA configuration (GDMA-334), to highlight the fact that this option exists and to display its current setting. A site which wishes to use unqualified hostnames instead must turn this option off in the GDMA client configuration file.
- A <tt>Forced_Hostname</tt> directive is now available to help in those irritating emergency situations where you just can't get DNS hostname resolution to work properly on a particular GDMA client machine (GDMA-316).
- The <tt>PctTime</tt> metric in the performance data for the configured <tt>Poller_Service</tt> now properly refers to the configured <tt>Warning_Threshold</tt> and <tt>Critical_Threshold</tt> values, if present (defaulting to 60 and 80, respectively, as before) (GDMA-294).
- A major new capability has been added to GDMA in the combined GWMEE 6.7.0 / GDMA 2.3.0 release (GDMA-338). This is support for auto-registration by GDMA clients. A client can send in basic information about itself, and have itself registered on the server side with basic setup for monitoring according to pre-established host and service profiles. This should ease the administrative burden of adding new GDMA clients to the system. Full monitoring of such new machines will not commence until the administrator runs a Commit operation on the server, but the ordinary small tasks are handled automatically.

### Using PostgreSQL as the embedded database

Up to release 6.5, GroundWork Monitor included MySQL as the default database. Starting with release 6.6, PostgreSQL, a more-robust and more-scaleable database for Linux 64-bit systems, is now used. With this new database we have seen performance improvements and a lower load on large systems. PostgreSQL comes with tools and utilities for backup, administration, and libraries for many programming languages. The commands and the SQL language supported by PostgreSQL are similar to MySQL (though with differences), and this reduces the learning curve for becoming familiar with PostgreSQL databases.

### Support of a remote (separate) database server

Starting in GWMEE 6.6.1, GroundWork Monitor Enterprise now supports a separate database install. The same installer is used to set up the database server. The installer also supports upgrades from GWMEE 6.3, 6.4, and 6.5 to an installation with a separated database.

Using a remote database offloads a lot of disk activity away from the GroundWork Monitor server, which reduces the overall system load and improves the system performance in general.

### Operating system support

Starting with release 6.6.1, GroundWork Monitor Enterprise is available for 64-bit Linux. Support for 32-bit Linux has been dropped, as previously announced.

# KNOWN ISSUES AND LIMITATIONS

## Limitations and Work-Arounds

- SUSE 9 installations of GroundWork Monitor may exhibit an issue where certain services such as crond, postfix, ntp, and others will not start properly after GroundWork Monitor is installed. This is due to a dependency on the syslog service, which GroundWork replaces with syslog-ng at installation time. Later versions of SUSE Linux do not exhibit this issue. To work around this in SUSE 9, simply edit the init scripts for these services, removing the dependency on syslog. For example, in <tt>/etc/init.d/cron</tt>, change:
```
# Required-Start: $remote_fs $syslog $time
```
to:
```
# Required-Start: $remote_fs $time
```
- Running on Ubuntu releases before 12.04 is not recommended, because starting and stopping <tt>ntop</tt> on earlier releases is broken.
- Safari and other webkit-based browsers such as Google Chrome may experience an issue whereby the URL will "cycle" in the address bar after login, and never display a portal page. This can sometimes be observed if the user logs in, then closes the browser window, and reconnects later. If this occurs, stop the browser, and retype the url in the form:
```
http(s)://servername/portal
```
Usually it is only necessary to do this once per session.
- The GroundWork backup utility, <tt>/usr/local/groundwork/gw-backup-br204-linux-32</tt> or <tt>/usr/local/groundwork/gw-backup-br204-linux-64</tt>, is included in the 6.6.1 release of GroundWork Monitor. It will be installed on the disk when you start the binary installer, and can be used to make a backup of an existing GroundWork 6.x installation. This utility does not support GroundWork Monitor 5.3, however, and the installer does not differentiate between versions when prompting you to make a backup. If you need to make a backup of your 5.3 installation, please refer to the backup section for older versions in this document. If you attempt to use the backup utility, the backup will hang, and must be killed. It will not harm the GroundWork installation, but neither will it back it up as intended.
- In Auto-Discovery, the OS-match capability of NMAP scan methods is not consistent. It appears there is some significant variation in results based on network traffic conditions, and the OS used to perform the scan. This issue can be worked around by using the port-to-service or service profile matching capability of auto-discovery.

# ANNOUNCEMENTS AS OF VERSION 7.0.2

## Supported Versions of GroundWork

As previously announced, GroundWork Monitor version 6.4 is now end-of-life. Customers using 6.4 or older versions are advised to contact GroundWork Support regarding upgrade options.

Ground Monitor version 6.5 will be end-of-life with the next release. Customers currently using GroundWork 6.5 are advised to plan their migration at this time.

## Linux Supported Versions

SuSE Enterprise Linux (SLES):

- Customers using SUSE SLES 9.x are advised that support for this platform was discontinued with the previous release.
- SLES 10 has reached end-of-life and is no longer supported for installing GWME 7.0.2.
- Recommended version: SLES 11 SP3

Red Hat Enterprise Linux (RHEL):

- Support for Red Hat Enterprise Linux 6.x is available as of this release.
- Recommended version: RHEL 6.5

Ubuntu LTS

- Ubunto 8.04 LTS has reached end-of-life and are no longer supported for installing GroundWork 7.0.2 or newer.
- Ubuntu 10.04 LTS has incompatibilities with the NTOP application and therefore we recommend use the recommended version of Ubuntu.
- Recommended version: Ubuntu 12.04 LTS

## Supported Architectures

As of the previous release, GroundWork supports only 64-bit versions of GroundWork Monitor Enterprise.

## Browser Compatibility

This version of GroundWork has been tested with Firefox 3 & 6, Google Chrome v16, as well as Internet Explorer 7, 8, and 9.

# ADDITIONAL INFORMATION

## Proxy Server Configuration

The Network Service will not be able to receive updates if a non-transparent proxy is used. To configure the proxy settings, complete the following:
- Install the product and enable the Network Service during installation.
- Login using a secure shell on the GroundWork server.
    cd /usr/local/groundwork/network-service/scripts/
    ./network-service-ctl.sh stop
    cd /usr/local/groundwork/network-service/bin/
- Edit the **agent.conf** file and add the following:
    proxy_host=xxx.yyy.zzz.www
    proxy_port=pppp
Save your changes.
- Now restart the network service:
    ./network-service-ctl.sh stop
    ./network-service-ctl.sh start

* * *

Copyright 2004-2015 GroundWork Open Source, Inc. ("GroundWork"). All rights reserved. Use is subject to GroundWork commercial license terms. GroundWork Monitor products are released under the terms of the various public and commercial licenses. For information on licensing and open source elements please see [http://www.gwos.com/products/pro-ipingredients.html](http://www.gwos.com/products/pro-ipingredients.html). GroundWork, GroundWork Open Source, GroundWork Monitor Professional, GroundWork Monitor Open Source, GroundWork Community Edition, GroundWork Monitor Enterprise, GroundWork Foundation, GroundWork Status Viewer, Monarch, and GroundWork Guava are trademarks of GroundWork Open Source, Inc. Other trademarks, logos and service marks (each, a "Mark") used in GroundWork products, including Nagios, which is a registered trademark of Ethan Galstad, are the property of other third parties. These Marks may not be used without the prior ritten consent of GroundWork Open Source or the third party that owns the respective Mark.
