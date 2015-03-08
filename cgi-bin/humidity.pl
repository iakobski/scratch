#! /usr/bin/perl -w

use strict;
use File::Basename;
use lib dirname (__FILE__);
use CGI;
use JSON::XS;
use DBI;
use DateTime;
use scratch;

my $q = CGI->new;
my $params = $q->Vars;
my $method = $q->request_method();
my $url = $q->url;
my $rest_call = $q->url(-path_info=>1);
$rest_call =~ s/$url\///;
my $service = [split "/", $rest_call];






# getting here means we didn't know what to do...
print $q->header("text/html");
print $q->p("This is the scratch service. Your $method request was not recognised.");
print $q->url;

print $q->br;
print $service->[0];

foreach my $key(keys %$params){
    print $q->li($key . " => " . $params->{$key});
}