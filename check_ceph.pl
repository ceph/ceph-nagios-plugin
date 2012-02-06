#!/usr/bin/perl
# Author: Dallas Kashuba

# Copyright (c) 2012, New Dream Network, LLC (DreamHost)
# All rights reserved.
#
# Licenced available at ./LICENSE in the ceph-nagios-plugin source.

use strict;
use Getopt::Long qw(:config no_ignore_case);

my ($mon_ips, $key);
my $CEPH = '/usr/bin/ceph';
my $HELP = 0;

my %STATUSCODE = (
	'OK'       => '0',
	'WARNING'  => '1',
	'CRITICAL' => '2',
	'UNKNOWN'  => '3',
);

my $usage = <<EOF;

This plugin checks the health of a ceph cluster.

Usage: check_ceph [-m|--mon] [-k|--key]
 -m, --mon=ADDRESS[,ADDRESS,ADDRESS]
   IP address(es) of ceph monitors
 -k, --key=string
  secret key to access the ceph cluster
 -h, --help
   Print detailed help screen

EOF

my $result = GetOptions(
	"m|mon=s" => \$mon_ips,
	"k|key=s" => \$key,
	"h|help"  => \$HELP,
);

if ( $HELP || !$result ) {
	print $usage;
	exit ($STATUSCODE{'UNKNOWN'});
}

if (! -x $CEPH) {
	print "Where is the ceph binary?  Not here: $CEPH\n";
	exit ($STATUSCODE{'UNKNOWN'});

}

# run ceph command and grab output
my $cephcmd = "ceph ";
$cephcmd .= "-m $mon_ips " if $mon_ips;
$cephcmd .= "--key $key " if $key;
$cephcmd .= "health";

open(CEPHOUT, "$cephcmd |") or exit ($STATUSCODE{'UNKNOWN'});
while (defined( my $line = <CEPHOUT> )) {
	chomp $line;

	my $health_status = '';
	# matching on the expected second line of output with the arrow pointing to the right (->)
	if (($health_status) = ($line =~ /.+\ ->\ \'(HEALTH_(OK|WARN|ERR).*)\'.*/)) {
		print "status: '$health_status'\n";
		if ($health_status =~ /^HEALTH_OK/) {
			exit ($STATUSCODE{'OK'});
		}
		elsif ($health_status =~ /^HEALTH_WARN/) {
			exit ($STATUSCODE{'WARNING'});
		}
		elsif ($health_status =~ /^HEALTH_ERR/) {
			exit ($STATUSCODE{'CRITICAL'});
		}
		else {
			exit ($STATUSCODE{'UNKNOWN'});
		}
	}
}
close (CEPHOUT);

# if we got to here, something didn't work right...
exit ($STATUSCODE{'UNKNOWN'});
