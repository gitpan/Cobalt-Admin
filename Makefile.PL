# first we need to copy the old Cobalt modules from their existing location
use File::Path;
use File::Find;
$File::Find::prune = 1;

my $BASE_PATH = '/usr/lib/perl5/site_perl/5.005';
my @paths = ( "Cobalt",
			  "i386-linux/Apache",
			  "i386-linux/auto/Apache",
			  "i386-linux/auto/mod_perl",
			);

foreach my $path ( @paths ) {
	mkpath ["lib/$path"];
};

# first get the Cobalt and Apache::* files
find({ wanted => \&steal_file, no_chdir => 1 }, map "$BASE_PATH/$_", @paths );

# now go back and get the mod_perl files
find({ wanted => \&steal_file2, no_chdir => 1 }, "$BASE_PATH/i386-linux" );

# This is an appalling hack, but safe because none of the code is compiled
rename "lib/i386-linux", "lib/i586-linux";

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'			=> 'Cobalt::Admin',
    'VERSION'		=> '0.1', # I can't believe none of the Cobalt modules have versions
	'realclean'		=> { FILES => 'lib' },
);

############################################################################
sub steal_file		#07/18/02 2:57:PM
					# we need to just grab copies of the files in this
					# directory rather than go through the hassle of
					# installing them from scratch
############################################################################

{
	use File::Copy;
	return if /(pkgsave|orig)$/;
	my $file = $File::Find::name;
	$file =~ s($BASE_PATH/)();
	copy $File::Find::name, "lib/$file";
}	##steal_files

############################################################################
sub steal_file2		#07/18/02 4:06:PM
############################################################################

{
	use File::Copy;
	return unless /mod_perl/;
	my $file = $File::Find::name;
	$file =~ s($BASE_PATH/)();
	copy $File::Find::name, "lib/$file";
}	##steal_file2
