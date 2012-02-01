==================
Ceph Nagios Plugin
==================

Description
-----------

This plugin checks the health of a ceph cluster.


Usage
----

The plugin usage is given in the source code as the following::

    Usage: check_ceph [-m|--mon] [-k|--key]
     -m, --mon=ADDRESS[,ADDRESS,ADDRESS]
       IP address(es) of ceph monitors
     -k, --key=string
      secret key to access the ceph cluster
     -h, --help
       Print detailed help screen


Nagios Plugins
--------------

You can read about Nagios plugin development here:
  http://nagiosplug.sourceforge.net/developer-guidelines.html

In particular, you will likely be interested in learning about `plugin output <http://nagiosplug.sourceforge.net/developer-guidelines.html#PLUGOUTPUT>`_.
