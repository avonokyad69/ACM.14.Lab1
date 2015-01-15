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
	"*add*",
	"*edit*",
	"*show*",
	"*save to file*",
	"*load from file*",
	"*delete*",
	"*exit*",
);

sub st20
{
	print "______It's my lab1_____ :]";
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

my @snowboards = ();

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
	print "Enter the name company:  ";
	chomp(my $namecomp=<STDIN>);
	print "Enter size(from 130 to 190): ";
	chomp(my $size=<STDIN>);
	print "Enter the color: ";
	chomp(my $color=<STDIN>);

	my $snowboard = {
		Name => $namecomp,
		Size => $size,
		Color => $color,
	};

	push(@snowboards,$snowboard);

	print "\nSnowboard ".$namecomp." added\n";
	return 1;
};

sub Edit
{
	if (Show()) 
	{
		print "\nWrite id snowboard to change: \n";
		chomp(my $el=<STDIN>);
		if (@snowboards[$el]) {
			my $hashref = @snowboards[$el];
			foreach my $key(sort keys $hashref){
				print "$key: ";
				chomp(my $hash=<STDIN>);
				$hashref->{$key}=$hash;
			}
			print "\nSnowboard #$el edited\n";
		} else {
			print "\nWrong id\n";
		}
	}
};



sub Show
{
	if (@snowboards) {
		my $i = 0;
		foreach my $f(@snowboards)
		{
			print "\n___________snowboard #$i ___________  \n";
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
	dbmopen(my %hash, "kuzmin_file",0666) || die ("error open");
	%hash = ();
	my $i = 0;
	my @var;
	if (@snowboards) {
		foreach my $f(@snowboards) {
			foreach my $key (sort keys $f) {
				push(@var,$key);
				push(@var,$f->{$key});
			}
			$hash{$i}=join(",",@var);
			$i++;
		}
		print "File saved\n";
	} else {
		print "There is no snowboards \n";
	}
	dbmclose(%hash)
};

sub Delete
{
	if (Show()) {
		print "\n Choose snowboard #id to delete: ";
		chomp (my $el=<STDIN>);
		if (@snowboards[$el]) {
			splice(@snowboards, $el, 1);
			print "\nSnowboard #".$el." deleted\n";
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
	dbmopen(my %hash, "kuzmin_file",0666) || die ("error open");
	while ((my $key, my $value) = each(%hash)) {
		my @snowboard = split(/,/,$hash{$key});
		$snowboards[$key]={@snowboard};
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
