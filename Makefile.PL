# $Id: Makefile.PL,v 1.5 2004/02/21 13:51:52 tvierling Exp $

use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    ABSTRACT_FROM	=> 'lib/Sendmail/PMilter.pm',
    AUTHOR		=> 'Todd Vierling <tv@duh.org>',
    NAME		=> 'Sendmail::PMilter',
    VERSION_FROM	=> 'lib/Sendmail/PMilter.pm',
);
