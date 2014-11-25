package ST14;
use strict;

my %barcaPlayers;

sub addI
{
	print "\n add new item";
	print "\n Please write player number: \t";
	chomp(my $PlNum = <STDIN>);
	print "\n Please write player name: \t";
	chomp(my $PlName = <STDIN>);
	print "\n Please write player position: \t";
	chomp(my $PlPosition = <STDIN>);
	print "\n Please write is player a capitan: \t";
	chomp(my $isCaptain = <STDIN>);
	
	#my $isCaptain = "No";

	#if (!defined $isCaptain || ($isCaptain != 'no' && $isCaptain != 'yes'))
	#{
#		print "You should chose between yes and no. \n";
#		$isCaptain = "no";
#	};

 	#my $dbh = DBI->connect('DBI:mysql:mydb:localhost:3306', 'root', '', { RaiseError => 1, AutoCommit => 1});
	#$dbh->do("insert into mydb.barca_players (PlNum, PlName, PlPosition, isCaptain) values (?,?,?,?)",
	#		 undef,($PlNum, $PlName, $PlPosition,$isCaptain));
	
	#$dbh->disconnect();
	
	if (exists($barcaPlayers{$PlNum}))
	{
		print "There is already player with number ".$PlNum."\n";
		return 1;
	};

	$barcaPlayers{$PlNum} = { Name => $PlName, Position => $PlPosition, isCaptain => $isCaptain};

};



sub delI
{
	print "\ndelete item";
	print "\n Please write number of player to delete: \t";
	chomp(my $PlNum = <STDIN>);

	#my $dbh = DBI->connect('DBI:mysql:mydb:localhost:3306', 'root', '', { RaiseError => 1, AutoCommit => 1});
	#$dbh->do("delete from mydb.barca_players where PlNum = ?",
	#		 undef, ($PlNum));
	#$dbh->disconnect();
	if (!exists($barcaPlayers{$PlNum}))
	{
		print "There is no player with number ".$PlNum."\n";
		return 1;
	}

	delete($barcaPlayers{$PlNum});

};


sub updI
{
	print "\n update player info";
	print "\n Please write number of player to update: \t";
	chomp(my $PlNum = <STDIN>);

	if (!exists($barcaPlayers{$PlNum}))
	{
		print "Can't find player with number ".$PlNum."\n";
		return 1;
	}

	print "\n Please write player new name: \t";
	chomp(my $PlName = <STDIN>);
	print "\n Please write player new position: \t";
	chomp(my $PlPosition = <STDIN>);
	print "\n Please write is player a capitan: \t";
	chomp(my $isCaptain = <STDIN>);

	#if (!defined $isCaptain || ($isCaptain != 'no' && $isCaptain != 'yes'))
	#{
#		print "You should chose between yes and no. \n";
#		$isCaptain = "no";
#	};

	#my $dbh = DBI->connect('DBI:mysql:mydb:localhost:3306', 'root', '', { RaiseError => 1, AutoCommit => 1});
	#$dbh->do( "update mydb.barca_players set PlName = ?, PlPosition = ?, isCaptain=?  where PlNum=?", 
	#			undef, ($PlName, $PlPosition,$isCaptain, $PlNum) );

	#$dbh->disconnect();

	$barcaPlayers{$PlNum} = { Name => $PlName, Position => $PlPosition, isCaptain => $isCaptain};

};

sub showI
{
	print "\nList of players:\n";

	foreach my $PlNum(sort keys  %barcaPlayers)
	{
		print "Player number: ".$PlNum."\n";
		foreach my $info(sort keys %{$barcaPlayers{$PlNum}})
		{
			print "\t".$info.": ".${$barcaPlayers{$PlNum}}{$info}."\n";
		};
	};
		
};

sub saveData
{
	my %buffHash = ();
	dbmopen(%buffHash,'barcaplayersDB',0644) || die "Error to open file!";
	my $InfoStr = undef();
	

	foreach my $num (keys %barcaPlayers)
	{
		$InfoStr = undef();
		foreach my $info (sort keys %{$barcaPlayers{$num}})
		{
			$InfoStr = $InfoStr.${$barcaPlayers{$num}}{$info}.";";
		};		
		$buffHash{$num} = $InfoStr;
	};
	my @bufArr = %buffHash;
	dbmclose(%buffHash);	
};

sub getData
{
	my %buffHash = ();
	dbmopen(%buffHash,'barcaplayersDB',0644) || die "Error to open file!";

	foreach my $num (keys %buffHash)
	{;
		my @InfoArr =  split(/;/, $buffHash{$num}); 
		$barcaPlayers{$num} = { Name => @InfoArr[0], Position => @InfoArr[1], isCaptain => @InfoArr[2] };
	};
	dbmclose(%buffHash);
};


sub st14
{
	my %methodsRef = 
	(
		'add' => \&addI,
		'upd' => \&updI,
		'del' => \&delI,
		'show' => \&showI,
		'sv' => \&saveData,
		'ld' => \&getData
	);
	my $in;
	while(1)
	{
		print "\n FORDO:\n 'add' - add item\n 'del' - delete item\n 'upd' - update item\n 'show' - show all items\n 'sv' - save to file\n 'ld' - load from file\n 'exit' - exit\n";
		chomp($in = <STDIN>);
		last if ($in eq 'exit');
		if (exists($methodsRef{$in}))
		{
			$methodsRef{$in}->();
		}
	};

};


1;
