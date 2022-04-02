use File::Basename;
use Cwd 'abs_path';
if(!defined($INCLUDE_ONCE))
{
    my $INCLUDE_ONCE_FILENAME = abs_path(dirname(__FILE__)) . '/include_once.pl';
    require $INCLUDE_ONCE_FILENAME;
}

package evotranspiler;

sub do_it
{
    my ($input) = @_;
    return $input;
}

1;
