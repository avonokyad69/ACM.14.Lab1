package ST21;
use 5.010;
use strict;
use warnings;
use Tie::IxHash;

my $choice;

my %list =();
tie %list, "Tie::IxHash";
%list = (
	1 => 'Add',
	2 => 'Edit',
	3 => 'Delete',
	4 => 'Show_all',
	5 => 'Save_to_file',
	6 => 'Load_from_file',
	7 => 'Exit');
	
my %Items =();
tie %Items, "Tie::IxHash";

sub menu
{
	while (my @menu = each %list)
	{
		print "$menu[0] = $menu[1]\n"
	}
	print "==========================\n";
	print "Select the menu item: ";
	
	chomp($choice = <STDIN>);	
	if(exists($list{$choice})){
		system("cls");
		print "The selected function: $list{$choice}\n";
		my $func_call = \&{$list{$choice}};
		&$func_call();		
	} else
	{
		print "==========================\n";
		print "There is no such menu item: $choice\n";
		print "==========================\n\n";
		system("pause");
	}
	
	return($choice);	
}

sub Add
{
	print "Enter the data\n";
	print "Name: "; chomp(my $name = <STDIN>);
	print "Position: "; chomp(my $pos = <STDIN>);
	print "Age: "; chomp(my $age = <STDIN>);
	print "Club: "; chomp(my $club = <STDIN>);
	push(@{$Items{$name}}, $pos, $age, $club);
}
 
sub Edit
{
	Show_all();

	print "Write Name of player to change: ";
	chomp(my $name = <STDIN>);
	if(exists($Items{$name}))
	{
		print "Position: "; chomp(my $pos = <STDIN>);
		print "Age: "; chomp(my $age = <STDIN>);
		print "Club: "; chomp(my $club = <STDIN>);
		@{$Items{$name}}[0] = $pos;
		@{$Items{$name}}[1] = $age;
		@{$Items{$name}}[2] = $club;
	}
	else
	{
		print "\nThere is no such person\n\n";
	};
}
 
sub Delete
{
	Show_all();

	print "Write Name of player to delete: ";
	chomp(my $name = <STDIN>);
	if(exists($Items{$name}))
	{
		delete($Items{$name});
	}
	else
	{
		print "\nThere is no such person:\n\n";
	}
}

sub Show_all
{
	system("cls");
	print "==========================\n";
	foreach my $name (keys %Items)
	{
		print "$name: @{$Items{$name}}\n";
	}
	
	print "==========================\n";
}

sub Save_to_file
{	
	print "Save to file\n";
	my %buff = ();
	dbmopen(%buff,"Shilenkov_dbm",0644) || die "Error open to file!";
	
	my $buffStr;
	foreach my $name (keys %Items)
	{
		$buffStr = undef();		
		$buffStr = @{$Items{$name}}[0].":".@{$Items{$name}}[1].":".@{$Items{$name}}[2].";";
		$buff{$name} = $buffStr;
	};
	
	dbmclose(%buff);
}

sub Load_from_file
{	
	print "Load from file\n";
	my %buff = ();
	dbmopen(%buff,"Shilenkov_dbm",0644) || die "Error open to file!";
	
	print "==========================\n";
	
	foreach my $name (keys %buff)
	{
		my @buffStr = undef();
		@buffStr = split(/;/, $buff{$name}); 
		foreach my $buffElem (@buffStr)
		{
			my @Value = split(/:/, $buffElem);
			push(@{$Items{$name}}, $Value[0], $Value[1], $Value[2]);
		};
	};
	
	Show_all();
	
	dbmclose(%buff);
}

sub Exit
{
	exit;
}

sub st21
{
	while(1)
	{
		$choice = menu();
	}
}
