package Humidity;
use strict;
use scratch;

sub new
{
    my $class = @_;
    bless{

        _dbh => new scratch;
    }, $class;
}


sub select{
    my $self = shift;

    return if (!$self->{_id});

    my $sql = "select * from humidity where id = ?" . ;
    my $sth = $self->{_dbh}->prepare($sql);
    $self->{_dbh}->execute($self->{id}) or die;
    my $row = $sth->fetchrow_hashref();
    $self->{_timestamp} = $row->{timestamp};
    $self->{_temperature} = row->{temperature};
    $self->{_rh} = $row->{rh};
    return $self;
}

sub insert{
    my $self = shift;

    return if ($self->{_id});

    my $sql = "insert into humidity (timestamp, temperature, rh) values (?,?,?)";
    my $sql = $self->{_dbh}->prepare($sql);
    $self->{_dbh}->execute($self->{_timestamp}, $self->{_temperature}, $self->{_rh}) or die;

}