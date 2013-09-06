#!/usr/bin/env perl
use strict;
use warnings;
use Gideon::Registry;
use Mojolicious::Lite;
use DBI;
use Try::Tiny;
use Record;
use DateTime;
use DateTime::Format::ISO8601;
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

    try {
        my $record = parse_record($self);
        $record->save;

        $self->render( json => { id => $record->id } );
    }

    catch {
        $self->render_exception('Oops');
    };
};

put '/record/:id' => sub {
    my $self = shift;
    my $id   = $self->param('id');

    try {
        my $new = parse_record($self);
        my $old = Record->find_one( id => $id, -strict => 1 );

        $old->name( $new->name )               if $new->name;
        $old->artist( $new->artist )           if $new->artist;
        $old->released_at( $new->released_at ) if $new->released_at;
        $old->save;

        $self->render( json => { id => $old->id } );
    }

    catch {
        if ( ref $_ eq 'Gideon::Exception::NotFound' ) {
            return $self->render_not_found;
        }

        $self->render_exception('Oops');
    };
};

del '/record/:id' => sub {
    my $self = shift;
    my $id   = $self->param('id');

    try {
        my $record = Record->find_one( id => $id, -strict => 1 );
        $record->remove;

        $self->render( json => { id => $record->id } );
    }

    catch {
        if ( ref $_ eq 'Gideon::Exception::NotFound' ) {
            return $self->render_not_found;
        }

        $self->render_exception('Oops');
    };
};

sub parse_record {
    my $c    = shift;
    my $data = $c->req->json;
    $data->{released_at} =
      DateTime::Format::ISO8601->parse_datetime( $data->{released_at} );
    Record->new(%$data);
}

sub setup_app {
    my $dbh = DBI->connect( 'dbi:SQLite:dbname=db/db.sqlite',
        '', '', { RaiseError => 1, PrintError => 1 } );
    Gideon::Registry->register_store( db => $dbh );
}

app->start;
