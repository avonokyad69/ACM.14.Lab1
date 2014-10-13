package ST13;

dbmopen(%A, "data", 0666);

sub st13
{
	print "Mansurov Alexander Lab1\n";
	my $ch = menu();
	$MENULINK[$ch]->();
};

my @MENULINK
{
	\&DoAdd,
	\&DoEdit,
	\&DoShow,
	\&DoSave,
	\&DoLoad,
	\&DoDelete,
};

my @MENU = 
(
	"Add",
	"Edit",
	"Show",
	"Save to file",
	"Load from file",
	"Delete",
);
	
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
	print "add";
};

sub DoEdit
{
	print "edit";
};

sub DoShow
{
	print "show";
};

sub DoSave
{
	print "save";
};

sub DoLoad
{
	print "load";
};

sub DoDelete
{
	print "delete";
};

dbmclose(%A);

return 1;
