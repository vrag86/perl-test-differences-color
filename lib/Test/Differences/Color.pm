package Test::Differences::Color;

use Test::Differences;
use Term::ANSIColor qw(:constants);
use Test::Builder::Formatter;

#$Term::ANSIColor::AUTORESET = 1;

use Exporter 'import';
our @EXPORT = qw(eq_or_diff);

=head1 NAME

Test::Differences::Color - colorize the result of Test::Differences

=head1 VERSION

Version 0.07

=cut

our $VERSION = '0.07';

=head1 SYNOPSIS

    use Test::More tests => 1;
    use Test::Differences::Color;

    eq_or_diff(\%hash1, \@hash2);

=head1 EXPORT

=head2 eq_or_diff

=head1 FUNCTIONS

=head2 eq_or_diff

see L<Test::Differences>

=cut

sub eq_or_diff {
    my (@args) = @_;
    my(undef, $file, $line_num) = caller;

    my $orig_f = \&Test::Builder::Formatter::info_tap;
    *Test::Builder::Formatter::info_tap = sub {
        my ($self, $f) = @_;
        map {$_->{details} = _colorize($_->{details})} @{$f->{info}};
        $orig_f->($self, $f);
    };
    my $return = Test::Differences::eq_or_diff(@args);
    *Test::Bilder::Formatter = $orig_f;
    return $return;
}

sub _colorize {
    my ($str) = @_;
    my @str_arr = split/\n/, $str;
    for my $s (@str_arr) {
        $s =~ s/^(\*.+\*)$/ON_RED . $1 . RESET/em ||
        $s =~ s/^(\*.+)$/ON_BLUE . $1 . RESET/em ||
        $s =~ s/^(.+\*)$/ON_GREEN . $1 . RESET/em;
    }
    return join("\n", @str_arr);
}

=head1 SEE ALSO

L<Test::Differences>

=head1 AUTHOR

Pavel Andryushin <vrag867@gmail.com>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-differences-color at rt.cpan.org>, or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Differences-Color>. I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Differences::Color

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Differences-Color>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Differences-Color>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Differences-Color>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Differences-Color>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2022 Pavel Andryushin, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Test::Differences::Color
