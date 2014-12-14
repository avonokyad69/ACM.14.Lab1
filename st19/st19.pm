use strict;

my @ControlPanel = 
(
	"Add",
	"Edit",
	"Delete",
	"Show All",
	"Save to file",
	"Load from file",
	"Exit",
);
  my @FControlPanel=
  (
	  \&add,
	  \&edit,
	  \&delete,
	  \&showall,
	  \&tofile,
	  \&fromfile,
  );
 my @contacts=();
sub menu
{
	my $i = 0;
	print "\n------------------------------\n";
	foreach my $s(@ControlPanel)
	{
		$i++;
		print "$i. $s\n";
	}
	print "\n------------------------------\n";
	my $ch = <STDIN>;
	return ($ch-1);
}

 sub add
 {
	print "Enter the existing information \n"; 
	print "First Name ";
	my $tmp1=<STDIN>;	
	print "Last Name ";
	my $tmp2=<STDIN>;	
	print "Mobile Phone  ";
	my $tmp3=<STDIN>;	
	print "Email ";
	my $tmp4=<STDIN>;	
	my $contact={
	FirstName => $tmp1,
	LastName => $tmp2,
	MobilePhone => $tmp3,
	Email => $tmp4,
	};
	push(@contacts,$contact);
	return 1;
	
 }
 sub edit
 {
	showall();
	print "Enter the existing information \n";
	my $id=<STDIN>;
	print "First Name ";
	my $tmp1=<STDIN>;	
	print "Last Name ";
	my $tmp2=<STDIN>;	
	print "Mobile Phone ";
	my $tmp3=<STDIN>;	
	print "Email ";
	my $tmp4=<STDIN>;	
	my $contact={
	FirstName => $tmp1,
	LastName => $tmp2,
	MobilePhone => $tmp3,
	Email => $tmp4,
	};
	@contacts[$id]=$contact;
	return 1;
 }
 sub delete
 {
	showall();
	print "Enter Deleting Name ?\n";
	my $id=<STDIN>;
	splice( @contacts, $id, 1);
	return 1;
 }
 sub showall
 {
	my $h=0;
	foreach my $i(@contacts)
	{
		print "\n===================$h================\n$i->{FirstName}$i->{LastName}$i->{MobilePhone}$i->{Email}";
		$h++;
	}
	return 1;
 }
 sub tofile
 {
	
	return 1;
 }
 sub fromfile
 {
	
	return 1;

 }
 
 
 
while(1)
{
	my $ch = menu();
	if(defined $FControlPanel[$ch])
	{	
		$FControlPanel[$ch]->();		
	}
	else
	{
		exit();
	}
}
return 1;