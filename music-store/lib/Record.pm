package Record;
use Gideon driver => 'DBI';
use DateTime;

has id => (
    is          => 'rw',
    isa         => 'Num',
    serial      => 1,
    primary_key => 1,
    traits      => ['Gideon::DBI::Column']
);

has name => (
    is     => 'rw',
    isa    => 'Str',
    traits => ['Gideon::DBI::Column']
);

has artist => (
    is     => 'rw',
    isa    => 'Str',
    traits => ['Gideon::DBI::Column']
);

has released_at => (
    is      => 'rw',
    isa     => 'DateTime',
    default => sub { DateTime->now },
    traits  => [ 'Gideon::DBI::Column', 'Gideon::DBI::Inflate::DateTime' ]
);

sub TO_JSON {
    my $self = shift;

    {
        id          => $self->id,
        name        => $self->name,
        artist      => $self->artist,
        released_at => $self->released_at->ymd
    }
}

__PACKAGE__->meta->store('db:record');
__PACKAGE__->meta->make_immutable;
1;
