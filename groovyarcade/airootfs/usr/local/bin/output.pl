#!/usr/bin/perl

my $mc = "";
my $cmdline = `cat /proc/cmdline`;
chomp($cmdline);
my @cmdparts = split(/\s+/, $cmdline);
foreach (@cmdparts) {
	my $line = $_;
	chomp($line);
	if ($line =~ /^video=/) {
		$line =~ s/video=//g;
		my ($c, $res) = split(/:/, $line);
		if ($res ne '') {
			if ($c =~ /DVI/) {
				$mc = "DVI-0";
			} elsif ($c =~ /VGA/) {
				$mc = "VGA-0";
			} elsif ($c =~ /TV/) {
				$mc = "TV-0";
			}
		}
	}	
}

print "Connector bootup: $mc\n";

my @outputs;
my @xrandr_info = `xrandr --current`;
foreach (@xrandr_info) {
	my $line = $_;
	chomp($line);

	if ($line =~ /connected/) {
		my ($output, $status, $resolution, @pos) =
			split(/\s+/, $line);
		my $num = scalar(@outputs);
		$outputs[$num]{'name'} = $output;
		$outputs[$num]{'status'} = $status;
		$outputs[$num]{'resolution'} = $resolution;
		$outputs[$num]{'position'} = "@pos";
	}
}

my $i;
for ($i = 1; $i < scalar(@outputs); $i++) {
	if ($outputs[$i]{'status'} eq 'connected' && $outputs[$i]{'status'} !~ /$mc/i) {
		print "Disable $outputs[$i]{'name'}\n";
		system("xrandr --output $outputs[$i]{'name'} --off");
	} else {
		print "Already Disabled $outputs[$i]{'name'}\n";
	}	
}
