package ST04;

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

my @MYMENU = 
(
	"Dobavit'",
	"Izmenit'",
	"Pokazat'",
	"Sohranit'",
	"Zagryzit'",
	"Udalit'",
	"Vihod",
);

sub st04
{
	print "Spisok chlenov garajnogo kooperativa";
	while(1)
	{
		my $ch = menu();
		if(defined $MENULINK[$ch])
		{	
			$MENULINK[$ch]->();
		}
		else
		{
			print "\nwrong choice\n";
		}
	}
};

my @lists = ();	

sub menu
{
	my $i = 0;
	print "\n------------------------------\n";
	foreach my $s(@MYMENU)
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
	print "Vvedite imya vladelcya garaja: ";
	chomp(my $name=<STDIN>);
	print "Vvedite marky avtomobilya: ";
	chomp(my $marka=<STDIN>);
	print "Vvedite nomer garaja: ";
	chomp(my $number=<STDIN>);
	print "Vvedite nomer licevogo scheta: ";
	chomp(my $schet=<STDIN>);
	
	my $list = {
		name => $name,
		marka => $marka,
		number => $number,
		schet => $schet,
	};
	
	push(@lists,$list);
	
	print "\nVladelec ".$name." dobavlen v bazy\n";
	return 1;
};

sub DoEdit
{
	if (DoShow()) {
		print "\nViberite #id vladelcya dlya redaktirovaniya: \n";
		chomp(my $el=<STDIN>);
		if (@lists[$el]) {
			my $hashref = @lists[$el];
			foreach my $k(sort keys $hashref){
				print "$k: ";
				chomp(my $hash=<STDIN>);
				$hashref->{$k}=$hash;
			}
			print "\nVladelec #$el izmenen\n";
		} else {
			print "\nwrong id\n";
		}
	}
};



sub DoShow
{
	#check for objects
	if (@lists) {
		my $i = 0;
		foreach my $f(@lists)
		{
			print "\n:::::::::  Vladelec #$i  :::::::::  \n";
			foreach my $k (sort keys $f) {
				print "$k: $f->{$k}\n";
			}
			$i++;
		}
		return 1;
	} else {
		print "\nV baze net lydei :( \n";
		return 0;
	}
};

sub DoSave
{
	print "\nsaving...\n";
	dbmopen(my %hash, "vorobev_baze",0666) || die ("error open");
	%hash = ();
	my $i = 0;
	my @temp;
	if (@lists) {
		foreach my $f(@lists) {
			foreach my $k (sort keys $f) {
				push(@temp,$k);
				push(@temp,$f->{$k});
			}
			$hash{$i}=join(",",@temp);
			$i++;
		}
		print "file saved\n";
	} else {
		print "V baze net lydei :( \n";
	}
	dbmclose(%hash)
};

sub DoLoad
{
	print "\nloading...\n";
	dbmopen(my %hash, "vorobev_baze",0666) || die ("error open");
	while ((my $k, my $value) = each(%hash)) {
		my @list = split(/,/,$hash{$k});
		$lists[$k]={@list};
	}
	dbmclose(%hash);	
	print "file loaded\n";
};

sub DoDelete
{
	if (DoShow()) {
		print "\nViberite #id vladelcya dlya ydaleniya: ";
		chomp (my $el=<STDIN>);
		if (@lists[$el]) {
			splice(@lists, $el, 1);
			print "\nVladelec #".$el." ydalen\n";
			return 1;
		} else {
			print "\nwrong id\n";
		}	
	}
};

sub DoExit
{
	print "\nDo novih vstrech\n\n";
	last;
};

return 1;
