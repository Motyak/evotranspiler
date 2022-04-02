#!/usr/bin/env perl
use File::Basename;
use Cwd 'abs_path';
if(!defined($INCLUDE_ONCE))
{
    my $INCLUDE_ONCE_FILENAME = abs_path(dirname(__FILE__)) . '/include_once.pl';
    require $INCLUDE_ONCE_FILENAME;
}

my $SRC_FILENAME = abs_path(dirname(__FILE__)) . '/evotranspiler.pl';
require $SRC_FILENAME;

package tests;

sub are_equals
{
    my ($a, $b) = @_;
    if($a ne $b)
    {
        return 0;
    }
    return 1;
}

sub file_to_str
{
    my ($filename) = @_;
    open my $fh, '<:encoding(UTF-8)', $filename or die "Can't open file $!";
    read $fh, my $str, -s $fh;
    return $str;
}

package evotranspiler_tests;

my $EXAMPLES_DIR = './examples/';
my $FUNCTION_TO_TEST = \&evotranspiler::do_it;

sub test
{
    # récupérer tous les noms de fichiers à tester dans le répertoire corpus #
    opendir my $dir, $EXAMPLES_DIR or die "Cannot open directory: $!";
    my @examples = grep{/\.*(?<!_out)\.txt/g} readdir $dir;
    closedir $dir;

    # faire les tests #
    foreach(@examples)
    {
        $_ =~ s/(\.*).in.txt/\1/g;
        
        my $input = tests::file_to_str($EXAMPLES_DIR . $_ . '.in.txt');
        my $expecting = tests::file_to_str($EXAMPLES_DIR . $_ . '.out.txt');
        my $output = '' . $FUNCTION_TO_TEST->($input);

        if(!tests::are_equals($output, $expecting))
        {
            warn "Test '$_' is failing: \n-Expected: '''" . $input 
                    . "'''\n-Had: '''" . $output . "'''\n";
            exit 1;
        }
    }
}

evotranspiler_tests::test();
