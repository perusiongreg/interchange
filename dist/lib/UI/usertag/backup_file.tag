UserTag backup-file Order file
UserTag backup-file AddAttr
UserTag backup-file Routine <<EOR
sub {
	my ($file, $opt) = @_;
	require File::Copy;
	require File::Path;
	my $bu_file = "backup/$file";
	$bu_file =~ s://+:/:g ;
	$bu_file =~ m:(.*)/: ;
	my $bu_dir = $1;
	eval {
		die ::errmsg("Cannot figure out backup directory from %s", $bu_file)
			if ! $bu_dir;
		if (! -d $bu_dir) {
			File::Path::mkpath($bu_dir)
				or die ::errmsg("Cannot make backup directory %s: %s", $bu_dir, $!);
		}
		if (-f $bu_file) {
			my $fn = $bu_file;
			$fn =~ s:.*/::;
			UI::Primitive::rotate($fn, { Directory => $bu_dir } )
				or die ::errmsg("Cannot make backup of %s: %s", $bu_file, $!);
		}
#::logDebug("ready to copy $file to $bu_file");
		File::Copy::copy($file, $bu_file)
			or die ::errmsg("Copy %s to %s: %s", $file, $bu_file, $!);
	};
	if ($@) {
		$::Scratch->{ui_error} = $@;
		::logError($::Scratch->{ui_error});
		return undef;
	}
	return 1;
}
EOR