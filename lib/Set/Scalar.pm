package Set::Scalar;

use strict;
local $^W = 1;

use vars qw($VERSION @ISA);

$VERSION = 0.9;

@ISA = qw(Set::Scalar::Real Set::Scalar::Null Set::Scalar::Base);

use Set::Scalar::Base qw(_make_elements is_equal);
use Set::Scalar::Real;
use Set::Scalar::Null;
use Set::Scalar::Universe;

sub ELEMENT_SEPARATOR { " "    }
sub SET_FORMAT        { "(%s)" }

sub _insert_hook {
    my $self     = shift;

    if (@_) {
	my $elements = shift;

	$self->universe->_extend( $elements );

	$self->_insert_elements( $elements );
    }
}

sub _new_hook {
    my $self     = shift;
    my $elements = shift;

    $self->{ universe } = Set::Scalar::Universe->universe;

    $self->_insert( { _make_elements( @$elements ) } );
}

=head1 NAME

Set::Scalar::Base - base class for Set::Scalar

=head1 SYNOPSIS

    use Set::Scalar;
    $s = Set::Scalar->new;
    $s->insert('a', 'b');
    $s->delete('b');
    $t = Set::Scalar->new('x', 'y', $z);

=head1 DESCRIPTION

=head2 Creating

    $s = Set::Scalar->new;
    $s = Set::Scalar->new(@members); 

    $t = $s->clone;

=head2 Modifying

    $s->insert(@members);
    $s->delete(@members);
    $s->invert(@members); # insert if hasn't, delete if has

=head2 Displaying

    print $s, "\n";

The display format of a set is the members of the set separated by
spaces and enclosed in parentheses ().

You can even display recursive sets.

=head2 Querying

    @members  = $s->members;
    @elements = $s->elements; # alias for members

    $size = $s->size;

    if ($s->member($member)) { ...

    $s->element  # alias for member
    $s->has      # alias for member
    $s->contains # alias for member

    $s->is_null
    $s->is_universal

    $s->null	 # the null set
    $s->universe # the universe of the set

=head2 Deriving

    $u = $s->union($t);
    $i = $s->intersection($t);
    $d = $s->difference($t);
    $e = $s->symmetric_difference($t);
    $v = $s->unique($t);
    $c = $s->complement;

These methods have operator overloads:    

    $u = $s + $t; # union
    $i = $s * $t; # intersection
    $d = $s - $t; # difference
    $e = $s % $t; # symmetric_difference
    $v = $s / $t; # unique
    $c = -$s;     # complement

=head Comparing

    $eq = $s->is_equal($t);
    $dj = $s->is_disjoint($t);
    $pi = $s->is_properly_intersecting($t);
    $ps = $s->is_proper_subset($t);
    $pS = $s->is_proper_superset($t);
    $is = $s->is_subset($t);
    $iS = $s->is_superset($t);

    $cmp = $s->compare($t);

This returns a string from the following list: "equal", "disjoint",
"proper subset", "proper superset", "proper intersect", and "disjoint
universes", if you try to compare sets of different universes, and
"different", if you try to compare sets and non-sets.

    $ueq = $s->have_same_universe($t);

Note: currently it is I<possible> but B<unsupported> to have several
simultaneous universes for the sets.  Do not go there, even if you
read the universe.t and B<think> you understand.  The interface
is not public and going to change.

These methods have operator overloads:    

    $eq = $s == $t; # is_equal
    $dj = $s != $t; # is_disjoint
    # No operator overload for is_properly_intersecting.
    $ps = $s < $t;  # is_proper_subset
    $pS = $s > $t;  # is_proper_superset
    $is = $s <= $t; # is_subset
    $iS = $s >= $t; # is_superset

    $cmp = $s <=> $t;

=head1 AUTHOR

Jarkko Hietaniemi <jhi@iki.fi>

=cut
1;