#!/usr/local/bin/perl
# $Id: protocol-dump.pl,v 1.2 2004/02/20 04:34:48 tvierling Exp $

use strict;
use Carp qw(verbose);
use Sendmail::Milter 0.18 qw(:all);

my $miltername = shift @ARGV || die "usage: $0 miltername\n";

my %cbs;
for my $cb (qw(close connect helo abort envfrom envrcpt header eoh eom)) {
	$cbs{$cb} = sub {
		my $ctx = shift;

		print "$$: $cb: @_\n";
		SMFIS_CONTINUE;
	}
}

Sendmail::Milter::auto_setconn($miltername);
Sendmail::Milter::register($miltername, \%cbs, SMFI_CURR_ACTS);
Sendmail::Milter::main();
