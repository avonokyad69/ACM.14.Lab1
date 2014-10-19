package ST13;

use strict;

my @MENULINK =
(
	\&DoAdd,
	\&DoEdit,
	\&DoShow,
	\&DoSave,
	\&DoLoad,
	\&DoDelete,
	\&DoExit,
);

my @MENU = 
(
	"add",
	"edit",
	"show",
	"save",
	"load",
	"delete",
	"exit",
);

sub st13
{
	print "Welcome to my own version of IMDB :]";
	while(1)
	{
		my $ch = menu();
		if(defined $MENULINK[$ch])
		{	
			$MENULINK[$ch]->();		
		}
		else
		{
			exit();
		}
	}
};

my @films = ();	

sub menu
{
	my $i = 0;
	print "\n------------------------------\n";
	foreach my $s(@MENU)
	{
		$i++;
		print "$i. $s\n";
	}
	print "------------------------------\n";
	my $ch = <STDIN>;
	return ($ch-1);
};

sub DoAdd
{
	print "\nenter the name of the movie: ";
	chomp(my $name=<STDIN>);
	print "enter the producer of the movie: ";
	chomp(my $producer=<STDIN>);
	print "enter your score (max = 10) to this movie: ";
	chomp(my $score=<STDIN>);
	print "enter the year of the movie: ";
	chomp(my $year=<STDIN>);
	
	my $film = {
		name => $name,
		producer => $producer,
		score => $score,
		year => $year,
	};
	
	push(@films,$film);
	
	print "\nfilm ".$name." added\n";
	return 1;
};

sub DoEdit
{
	if (DoShow()) {
		print "\nchoose film #id to edit: \n";
		chomp(my $el=<STDIN>);
		if (@films[$el]) {
			my $hashref = @films[$el];
			foreach my $key(sort keys $hashref){
				print "$key: ";
				chomp(my $hash=<STDIN>);
				$hashref->{$key}=$hash;
			}
			print "\nfilm #$el edited\n";
		} else {
			print "\nwrong id\n";
		}
	}
};



sub DoShow
{
	#check for objects
	if (@films) {
		my $i = 0;
		foreach my $f(@films)
		{
			print "\n:::::::::  film #$i  :::::::::  \n";
			foreach my $key (sort keys $f) {
				print "$key: $f->{$key}\n";
			}
			$i++;
		}
		return 1;
	} else {
		print "\nthere is no films in your lib\n";
		return 0;
	}
};

sub DoSave
{
	print "\nsaving...\n";
	dbmopen(my %hash, "mansurov_data",0666) || die ("error open");
	%hash = ();
	my $i = 0;
	my @temp;
	if (@films) {
		foreach my $f(@films) {
			foreach my $key (sort keys $f) {
				push(@temp,$key);
				push(@temp,$f->{$key});
			}
			$hash{$i}=join(",",@temp);
			$i++;
		}
		print "file saved\n";
	} else {
		print "there is no films in your lib\n";
	}
	dbmclose(%hash)
};

sub DoLoad
{
	print "\nloading...\n";
	dbmopen(my %hash, "mansurov_data",0666) || die ("error open");
	while ((my $key, my $value) = each(%hash)) {
		my @film = split(/,/,$hash{$key});
		$films[$key]={@film};
	}
	dbmclose(%hash);	
	print "file loaded\n";
};

sub DoDelete
{
	if (DoShow()) {
		print "\nchoose film #id to delete: ";
		chomp (my $el=<STDIN>);
		if (@films[$el]) {
			splice(@films, $el, 1);
			print "\nfilm #".$el." deleted\n";
			return 1;
		} else {
			print "\nwrong id\n";
		}	
	}
};

sub DoExit
{
	print "\nbye bye\n\n";
	exit();
};

return 1;
