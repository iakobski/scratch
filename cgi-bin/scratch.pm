package r2015;
use strict;
use DBI;
use JSON::XS;
use DateTime;

use Exporter qw(import);

our @EXPORT = qw(db_connect get_sql_results_as_json year_start_end);

sub db_connect{
    my $user = "cl42-2015";
    my $db = $user;
    my $pass = "sp1der";
    my $host = "localhost";
    my $dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass);
    return $dbh;
}

sub get_sql_results_as_json{
    my $dbh = shift;
    my $sql = shift;
    my @args = @_;
        my $sth = $dbh->prepare($sql);
        my $result = $sth->execute(@args);
        my @arr;
        while(my $row = $sth->fetchrow_hashref){
            push @arr, $row;
        }
        my $json_text = encode_json(\@arr);
}

sub year_start_end{
    my $year = shift;
    if (!$year){
        $year = DateTime->today()->add(months=> -3)->year;
    }
    my $start = DateTime->new( year=>$year, month=>4, day=>1);
    my $end = DateTime->last_day_of_month( year=>$year+1, month=>3);
    return ($start, $end);
}

1;