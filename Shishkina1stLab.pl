use strict;
my %myRoomItems;#undef();
mainfunc();


sub addItem
{
	print "add new item\n";
	print "Please write Name, Color, Details for new item\n";
	chomp(my $name = <STDIN>);
	chomp(my $color = <STDIN>);
	chomp(my $details = <STDIN>);
	$myRoomItems{$name} = { color=> $color, details=> $details};
};

sub deleteItem
{
	print "deleteItem\n";
	#запросить имя атрибута
	print "Please write Name of item to delete\n";
	chomp(my $name = <STDIN>);
	if(exists($myRoomItems{$name}))
	{	#удалить элемент
		delete($myRoomItems{$name});
	}
	else
	{
		print "There is no elemet with name = ".$name."\n";
	};
};

sub updateItem
{
	print "updateItem\n";
	print "Please write Name of item to update\n";
	chomp(my $name = <STDIN>);
	if(exists($myRoomItems{$name}))
	{
		print "Please write new Color and Details for item\n";
		chomp(my $color = <STDIN>);
		chomp(my $details = <STDIN>);
		$myRoomItems{$name} = {color=> $color, details=> $details};
	}
	else
	{
		print "There is no elemet with name = ".$name."\n";
	};
		

};

sub showAllItems
{
	print "showAllItems\n";

	while((my $name,my $item) = each %myRoomItems)
	{
		print "Name of item is ".$name."\n";
		while((my $itemKey,my $itemInfo) = each %{$myRoomItems{$name}})
		{
			print "Item info: ".$itemKey." ".$itemInfo."\n";
		};
	};
		
};

sub saveToFile
{
	print "saveToFile\n";
	my %buffHash;
	dbmopen(%buffHash,"ShishkinaDB",0644) || die "Error open to file!";
	%buffHash = undef(); # очищаем фаил перед записью
	my $bufStr = undef();
	while((my $name,my $item) = each %myRoomItems)
	{
		$bufStr = undef();
		foreach my $itemKey (keys %{$myRoomItems{$name}})
		{
			$bufStr = $bufStr.$itemKey.":=".${$myRoomItems{$name}}{$itemKey}.";";
		};		
		#print $bufStr."\n";
		$buffHash{$name} = $bufStr;
	};
	dbmclose(%buffHash);
};

sub loadFromFile
{
	print "loadFromFile\n";
	my %buffHash = undef();
	my $bufStr;
	dbmopen(%buffHash,"ShishkinaDB",0644) || die "Error open to file!";

	while((my $name,my $item) = each %buffHash)#проходим по элементам хэша со строками
	{
		my @buf12 = undef();
		@buf12 = split(/;/, $buffHash{$name}); # разделяем строку на элементы
		foreach my $bufItem (@buf12)
		{
			my @hashArr = split(/:=/, $bufItem); # разделяем элемент на атрибуты
			#print "hashArr: ".@hashArr[0]." ".@hashArr[1].""."\n";
			$myRoomItems{$name} = {color=> @hashArr[0], details=> @hashArr[1]};
		};
	};
	dbmclose(%buffHash);
};


sub mainfunc
{
	my @arr = (\&addItem, \&deleteItem, \&updateItem, \&showAllItems, \&saveToFile, \&loadFromFile);
	my $in;
	while(1)
	{
		print "\nMake your choice:\n 0 - add item\n 1 - delete item\n 2 - update item\n 3 - show all items\n 4 - save to file\n 5 - load from file\n 9 - exit\n";
		chomp($in = <STDIN>);
		last if ($in eq 9);
        $arr[$in]->();
	};

};
