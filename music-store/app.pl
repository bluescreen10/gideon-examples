#!/usr/bin/env perl
use strict;
use warnings;
use Gideon::Registry;
use Mojolicious::Lite;
use DBI;
use Try::Tiny;
use Record;
use 5.0014;

setup_app();

get '/record/:id' => sub {
    my $self = shift;
    my $id   = $self->param('id');

    try {
        my $record = Record->find_one( id => $id, -strict => 1 );
        $self->render( json => $record );
    }

    catch {
        say $_;
        if ( ref $_ eq 'Gideon::Exception::NotFound' ) {
            return $self->render_not_found;
        }
        $self->render_exception('Oops');
    };

};

post '/record' => sub {
    my $self = shift;
    my $data = $self->req->json;

    my @date = split '-', $data->{released_at};
    $data->{released_at} = DateTime->new(
        year  => $date[0],
        month => $date[1],
        day   => $date[2]
    );

    try {
        my $record = Record->new(%$data);
        $record->save;
        $self->render( json => { id => $record->id } );
    }

    catch {
        say $_;
        $self->render_exception('Oops');
    };
};

sub setup_app {
    my $dbh = DBI->connect( 'dbi:SQLite:dbname=db/db.sqlite',
        '', '', { RaiseError => 1 } );
    Gideon::Registry->register_store( db => $dbh );
}

app->start;
