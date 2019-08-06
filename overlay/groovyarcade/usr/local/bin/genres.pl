#!/usr/bin/perl
use Getopt::Long;
use strict;
use warnings;
use strict "vars";
use strict "refs";
use strict "subs";

my $IS_WIN = 0;
if ($^O eq "MSWin32") {
        $IS_WIN = 1;
}

sub recalc_height($);
sub recalc_width($);

my $MAME_XML = "MAME.xml";
my $MONITOR_TYPE = "generic";
my $MAX_WIDTH = "1024";
my $MAX_HEIGHT = "768";
my $USE_VSYNC = 0;

my $result = 1;
my $HELP = 0;
$result = GetOptions (
        "help|h" => \$HELP,
        "monitor|m=s" => \$MONITOR_TYPE,
        "xml|x=s" => \$MAME_XML,
        "maxwidth|mw=s" => \$MAX_WIDTH,
        "maxheight|mh=s" => \$MAX_HEIGHT,
        "vsync|v" => \$USE_VSYNC,
);
if (!$result || $HELP) {
	print "GenRes modeline generator from MAME XML file\n";
	print "Chris Kennedy (C) 2010\n\n";
	print "Usage: genres.pl\n";
	print " -monitor   -m         Monitor type to pass to switchres\n";
	print " -xml       -x <file>  Mame XML file to use\n";
	print " -maxwidth  -mw <w>    Max width ($MAX_WIDTH)\n";
	print " -maxheight -mh <h>    Max height ($MAX_HEIGHT)\n";
	print " -vsync     -v         Use Vsync differences\n";
	exit 1;
}

my @resolutions = ();
my @lines = `grep "<display" $MAME_XML`;
foreach (@lines) {
	my $line = $_;
	chomp($line);
	$line =~ s/^\s+//g;
	$line =~ s/\s+$//g;
	my @parts = split(/\s+/, $line);
	my ($height, $width, $refresh, $orientation);
	foreach(@parts) {
		my $part = $_;
		chomp($part);
		my ($key, $value);
		$key = ""; 
		$value = "";
		if ($part =~ /=/) {
			($key, $value) = split(/=/, $part);
			$value =~ s/\"//g;
		}
		if ($key eq 'width') {
			$width = $value;
		} elsif ($key eq 'height') {
			$height = $value;
		} elsif ($key eq 'refresh') {
			$refresh = $value;
		} elsif ($key eq 'orientation') {
			if ($value != 0 && $value != 360) {
				$orientation = 1;
			}
		}
	}
	if ($orientation) {
		my $tw = $width;
		my $th = $height;
		$height = $tw;
		$width = $height * (4.0/3.0);
	}
	if ($width) {
		my $ret = recalc_width($width);
		if ($ret > 0) {
			$width = $ret;
		}
	}
	if ($height) {
		my $new_height = recalc_height($height);
		if ($new_height > 0) {
			$height = $new_height;
		} else {
			# greater than 768 pixels high
		}
	}
	if ($height && $width) {
		my $exists = 0;
		#print "$width $height $refresh\n";
		for (my $i = 0; $i < scalar(@resolutions); $i++) {
			if ($resolutions[$i]{'width'} == $width &&
				$resolutions[$i]{'height'} == $height &&
					$resolutions[$i]{'refresh'} == $refresh)
			{
				$exists = 1;
			}
		}
		if (!$exists) {
			my $len = scalar(@resolutions);
			$resolutions[$len]{'width'} = $width;
			$resolutions[$len]{'height'} = $height;
			$resolutions[$len]{'refresh'} = $refresh;
		}
	}
}

my @modelines = ();
for (my $i = 0; $i < scalar(@resolutions); $i++) {
	my ($width, $height, $refresh);
	$width = $resolutions[$i]{'width'};
	$height = $resolutions[$i]{'height'};
	$refresh = $resolutions[$i]{'refresh'};
	#print "$width $height\n";
	my @mline = `switchres $width $height $refresh --monitor $MONITOR_TYPE`;
	foreach (@mline) {
		my $line = $_;
		chomp($line);
		$line =~ s/\s+/ /g;
		$line =~ s/^\s+//g;
		if ($line !~ /^#/ && $line ne '') {
			my $num = scalar(@modelines);
			$modelines[$num]{'modeline'} = $line;
			my ($junk, $label, @rest) = split(/\s+/, $line);
			$label =~ s/\"//g;
			my ($h, $w, $r) = split(/x/, $label);
			$modelines[$num]{'width'} = $w;
			$modelines[$num]{'height'} = $h;
			$modelines[$num]{'refresh'} = $r;
		}
	}
}

my @modelines_2 = ();
for (my $i = 0; $i < scalar(@modelines); $i++) {
	my $exists = 0;
	for (my $j = 0; $j < scalar(@modelines_2); $j++) {
		if ($modelines_2[$j]{'width'} == $modelines[$i]{'width'} &&
			$modelines_2[$j]{'height'} == $modelines[$i]{'height'})
		{
			if ($USE_VSYNC) {
				if ($modelines_2[$j]{'refresh'} == $modelines[$i]{'refresh'}) {
					$exists = 1;
					goto DONE;
				}
			} else {
				$exists = 1;
				goto DONE;
			}
		}
	}
	DONE:
	if (!$exists) {
		my $num = scalar(@modelines_2);
		if (!$USE_VSYNC) {
			my $line = $modelines[$i]{'modeline'};
			my ($junk, $label, @rest) = split(/\s+/, $line);
			$label =~ s/\"//g;
			my ($h, $w, $r) = split(/x/, $label);
			print "$junk \"${h}x${w}\@60\" @rest\n";
		} else {
			print "$modelines[$i]{'modeline'}\n";
		}
		$modelines_2[$num]{'width'} = $modelines[$i]{'width'};
		$modelines_2[$num]{'height'} = $modelines[$i]{'height'};
		$modelines_2[$num]{'refresh'} = $modelines[$i]{'refresh'};
	}
}

exit 0;

sub recalc_width($) {
	my $w = shift(@_);

	if ($w !~ /^\d+$/ || $w <= 0) {
		return -1;
	}

	$w = (($w / 8)+(($w % 8)&0x01)) * 8;

	if ($w < 240) {
		$w = 240;
	} elsif ($w > $MAX_WIDTH) {
		return $MAX_WIDTH;
	}

	return $w;
}

sub recalc_height($) {
	my $h = shift(@_);
	
	if ($h !~ /^\d+$/ || $h <= 0) {
		return -1;
	}

	if ($h < 192) {
		$h = 192;
	} elsif ($h > 192 && $h < 224) {
		$h = 224;
	} elsif ($h > 224 && $h < 240) {
		$h = 240;
	} elsif ($h > 240 && $h < 256) {
		$h = 256;
	} elsif ($h > 264 && $h < 288) {
		$h = 288;
	} elsif ($h > 288 && $h < 384) {
		$h = 384;
	} elsif ($h > $MAX_HEIGHT) {
		return $MAX_HEIGHT;
	}
	$h = (($h / 8)+(($h % 8)&0x01)) * 8;
	return $h;
}
