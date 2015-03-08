#!/usr/bin/perl
use warnings; use strict;
use File::Basename;
use lib dirname (__FILE__);
use CGI;
use JSON::XS;
use DBI;
use DateTime;
use r2015;

my $dbh = db_connect();
if (!$dbh){ die "dbh undefined";}

my $q = CGI->new;
print $q->header('application/json');

my $uri = $ENV{REQUEST_URI};
my $action;
my $id;
if ($uri =~ /action/){
    $action = $q->param('action');
}
else{
    $uri =~ /(\d+)\Z/xms;
    $id = $1;
}

if ($action eq "get"){
    my $sql = "SELECT * from resolutions";
    print get_sql_results_as_json($dbh, $sql);
    exit;
}

if ($action eq "add"){
    my $text = $q->param('text');
    my $sql = "insert resolutions (resolution) values (?)";
    my $sth = $dbh->prepare($sql) or die "can't prepare $sql: $DBI::errstr\n";
    $sth->execute($text) or die "failed running $sql with id=$id: $DBI::errstr\n";
    my $id = $dbh->{'mysql_insertid'};
    print encode_json({id => $id});
    exit;
}

if ($action eq "toggle"){
    my $id = $q->param('id');
    my $sql = "update resolutions set completed_datetime =
        case when completed_datetime is null then now() else null end
        where id = ?";
    my $sth = $dbh->prepare($sql) or die "can't prepare $sql: $DBI::errstr\n";
    $sth->execute($id) or die "failed running $sql with id=$id: $DBI::errstr\n";

    exit;
}

if ($action eq "delete"){
    my $id = $q->param('id') + 0;
    my $sql = "delete from resolutions where id = $id";
    my $sth = $dbh->prepare($sql) or die "can't prepare $sql: $DBI::errstr\n";
    $sth->execute() or die "failed running $sql with id=$id: $DBI::errstr\n";


    exit;
}