# $Id: Milter.pm,v 1.4 2004/02/25 20:58:01 tvierling Exp $
#
# Copyright (c) 2002-2004 Todd Vierling <tv@pobox.com> <tv@duh.org>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 
# 3. Neither the name of the author nor the names of contributors may be used
# to endorse or promote products derived from this software without specific
# prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

package Sendmail::Milter;

use base Exporter;

use strict;
use warnings;

use Sendmail::PMilter qw(:all %DEFAULT_CALLBACKS);

##### Symbols exported to the caller

our @EXPORT = qw(
	SMFIS_CONTINUE
	SMFIS_REJECT
	SMFIS_DISCARD
	SMFIS_ACCEPT
	SMFIS_TEMPFAIL

	SMFIF_ADDHDRS
	SMFIF_CHGBODY
	SMFIF_ADDRCPT
	SMFIF_DELRCPT
	SMFIF_CHGHDRS
	SMFIF_MODBODY

	SMFI_V1_ACTS
	SMFI_V2_ACTS
	SMFI_CURR_ACTS
);
our @EXPORT_OK = ( @EXPORT );
our %EXPORT_TAGS = ( 'all' => [ @EXPORT_OK ] );

##### Version of "official" Sendmail::Milter emulated here

our $VERSION = '0.18';

##### Global instance of PMilter engine

my $milter = new Sendmail::PMilter;

##### Function subroutines

sub auto_getconn ($;$) {
	unshift(@_, $milter);
	goto &Sendmail::PMilter::auto_getconn;
}

sub auto_setconn ($;$) {
	unshift(@_, $milter);
	goto &Sendmail::PMilter::auto_setconn;
}

sub get_milter () {
	$milter;
}

sub main (;$$) {
	unshift(@_, $milter);
	goto &Sendmail::PMilter::main;
}

sub register ($$;$) {
	unshift(@_, $milter);
	goto &Sendmail::PMilter::register;
}

sub setconn ($) {
	unshift(@_, $milter);
	goto &Sendmail::PMilter::setconn;
}

sub setdbg ($) {
	# no-op
}

sub settimeout ($) {
	# no-op
}

1;
__END__

=pod

=head1 SYNOPSIS
 
    use Sendmail::Milter;

    Sendmail::Milter::auto_setconn(NAME);
    Sendmail::Milter::register(NAME, { CALLBACKS }, FLAGS);
    Sendmail::Milter::main();

=head1 DESCRIPTION

This is a compatibility interface which emulates the "standard"
Sendmail::Milter API.

=head1 FUNCTIONS

The following functions are available in this module.  Unlike
C<Sendmail::PMilter>, this interface involves a single, global instance of
milter data, so these functions are called without an object reference.

For each function, see the description of its object-based counterpart in
L<Sendmail::PMilter>.

=over 4

=item Sendmail::Milter::auto_getconn(NAME[, CONFIG])

=item Sendmail::Milter::auto_setconn(NAME[, CONFIG])

=item Sendmail::Milter::main([MAXCHILDREN[, MAXREQ]])

=item Sendmail::Milter::register(NAME, CALLBACKS[, FLAGS])

=item Sendmail::Milter::setconn(DESC)

=back

One extension function is provided by this implementation.

=over 4

=item Sendmail::Milter::get_milter()

Returns the C<Sendmail::PMilter> instance underlying this emulation layer.
This allows mostly-unmodified milter scripts to set PMilter extensions
(such as dispatcher and sendmail.cf values).  It is recommended, however,
that new code use the object instance methods described in
L<Sendmail::PMilter>.

=back

=head1 EXPORTS

In order to preserve compatibility with the standard C<Sendmail::Milter>
interface, all SMFI* constants described in L<Sendmail::PMilter> are
exported into the caller's namespace by default.

(Note that C<Sendmail::PMilter> itself does not export these symbols
by default.)

=cut
