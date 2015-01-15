package ST20;

use strict;

my @MYMENU =
(
	\&Add,
	\&Edit,
	\&Show,
	\&Save,
	\&Load,
	\&Delete,
#	\&Exit,
);

my @MENU =
(
	"*new*",
	"*edit*",
	"*show*",
	"*save to file*",
	"*load from file*",
	"*delete*",
	"*exit*",
);

sub st20
{
	print "______my lab1_____ ";
	while(1)
	{
		my $ct = menu();
		if(defined $MYMENU[$ct])
		{
			$MYMENU[$ct]->();
		}
		else
		{
			return;
		}
	}
};

my @regions = ();

sub menu
{
	my $i = 0;
	print "\n____________________________\n";
	foreach my $s(@MENU)
	{
		$i++;
		print "$i. $s\n";
	}
	print "_______________________________\n";
	my $ct = <STDIN>;
	return ($ct-1);
};

sub Add
{
	print "Enter region:  ";
	chomp(my $region=<STDIN>);
	print "Enter departments quantity: ";
	chomp(my $department=<STDIN>);
	print "Enter employee quantity: ";
	chomp(my $employee=<STDIN>);

	my $region = {
		Region => $region,
		Department => $department,
		Employee => $employee,
	};

	push(@regions,$region);

	print "\nregion ".$region." added\n";
	return 1;
};

sub Edit
{
	if (Show()) 
	{
		print "\nWrite region to change: \n";
		chomp(my $el=<STDIN>);
		if (@regions[$el]) {
			my $hashref = @regions[$el];
			foreach my $key(sort keys $hashref){
				print "$key: ";
				chomp(my $hash=<STDIN>);
				$hashref->{$key}=$hash;
			}
			print "\nregion #$el edited\n";
		} else {
			print "\nWrong id\n";
		}
	}
};



sub Show
{
	if (@regions) {
		my $i = 0;
		foreach my $f(@regions)
		{
			print "\n___________region #$i ___________  \n";
			foreach my $key (sort keys $f) {
				print "$key: $f->{$key}\n";
			}
			$i++;
		}
		return 1;
	} else {

		return 0;
	}
};

sub Save
{
	print "\nSaving...\n";
	dbmopen(my %hash, "chernyshev_file",0666) || die ("error open");
	%hash = ();
	my $i = 0;
	my @var;
	if (@regions) {
		foreach my $f(@regions) {
			foreach my $key (sort keys $f) {
				push(@var,$key);
				push(@var,$f->{$key});
			}
			$hash{$i}=join(",",@var);
			$i++;
		}
		print "File saved\n";
	} else {
		print "There is no regions \n";
	}
	dbmclose(%hash)
};

sub Delete
{
	if (Show()) {
		print "\n Choose region #id to delete: ";
		chomp (my $el=<STDIN>);
		if (@regions[$el]) {
			splice(@regions, $el, 1);
			print "\nregion #".$el." deleted\n";
			return 1;
		} else
		{
			print "\nWrong id\n";
		}
	}
};

sub Load
{
	print "\nLoading...\n";
	dbmopen(my %hash, "chernyshev_file",0666) || die ("error open");
	while ((my $key, my $value) = each(%hash)) {
		my @region = split(/,/,$hash{$key});
		$regions[$key]={@region};
	}
	dbmclose(%hash);
	print "File loaded\n";
};



sub Exit
{
	print "\nGood bye\n\n";
	exit();
};

return 1;