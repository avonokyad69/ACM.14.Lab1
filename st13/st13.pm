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
);

my @MENU = 
(
	"add",
	"edit",
	"show",
	"save",
	"load",
	"delete",
);

sub st13
{
	print "Mansurov Alexander Lab1\n";
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
	print "enter the name of the movie: ";
	chomp(my $name=<STDIN>);
	print "enter the name of the director: ";
	chomp(my $director=<STDIN>);
	print "enter the year of the movie: ";
	chomp(my $year=<STDIN>);
	print "enter your score (max = 10) to this movie: ";
	chomp(my $score=<STDIN>);
	
	my $film = {
		Name => $name,
		Director => $director,
		Year => $year,
		Score => $score,
	};
	
	push(@films,$film);
	
	print "\nfilm ".$name." added\n";
	return 1;
};

sub DoEdit
{
	if (DoShow()) {
		print "choose film #id to edit: \n";
		chomp(my $el=<STDIN>);
		if (@films[$el]) {
			print "enter the name of the movie: ";
			chomp(my $name=<STDIN>);
			print "enter the name of the director: ";
			chomp(my $director=<STDIN>);
			print "enter the year of the movie: ";
			chomp(my $year=<STDIN>);
			print "enter your score (max = 10) to this movie: ";
			chomp(my $score=<STDIN>);
	
			my $film = {
				Name => $name,
				Director => $director,
				Year => $year,
				Score => $score,
			};
	
			@films[$el] = $film;
	
			print "\nfilm #".$el." edited\n";
			return 1;
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
			print "\n:::::::::  film #$i  :::::::::  \n".
			"name:     $f->{Name}\n".
			"director: $f->{Director}\n".
			"year:     $f->{Year}\n".
			"score:    $f->{Score}\n";
			$i++;
		}
		print "\n";
		return 1;
	} else {
		print "\nthere is no films in your lib\n";
		return 0;
	}
};

sub DoSave
{
	print "\nsaving...\n";
	my %hash = ();
	dbmopen(%hash, "mansurov_data",0666) || die ("error open");
	my $i = 0;
	my @temp = ();
	if (@films) {
		foreach my $f(@films) {
			@temp = ($f->{Name},$f->{Director},$f->{Year},$f->{Score},"end");
			chomp(@temp);
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
	my %hash=();
	dbmopen(%hash, "mansurov_data",0666) || die ("error open");
	@films=();
	foreach my $key(sort keys %hash) {
		my @temp1 = split(/end/,$hash{$key});
		foreach(@temp1){
			my @temp2 = split(/,/,$_);
			my $film = {
				Name => @temp2[0],
				Director => @temp2[1],
				Year => @temp2[2],
				Score => @temp2[3],
			};
			push(@films, $film);
		}
	}
	print "file loaded\n";
	dbmclose(%hash);
	return 1;
};

sub DoDelete
{
	if (DoShow()) {
		print "choose film #id to delete: ";
		chomp (my $el=<STDIN>);
		if (@films[$el]) {
			splice(@films, $el, 1);
			print "\nfilm #".$el." deleted!\n";
			return 1;
		} else {
			print "\nwrong id\n";
		}	
	}
};

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

return 1;
