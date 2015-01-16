package ST06;
use strict;
my %menu_items = (
   1 => ["Show the list", \&showlist],
   2 => ["Add", \&add],
   3 => ["Edit", \&edit],
   4 => ["Delete", \&delete],
   5 => ["Save to a file", \&saveto],
   6 => ["Read from a file", \&readfrom]
);

my @data;

sub menu {
    while (1) {
        print "\n";
        print "select the item number\n";
		print "-----------------------\n";
        foreach my $n (sort keys %menu_items) {
            print "$n. $menu_items{$n}->[0]\n";
        }
        print "-----------------------\n";
        chomp(my $answer = <STDIN>);
        last unless $answer;
        if (exists $menu_items{$answer}) {
            $menu_items{$answer}->[1]->();
        }
        else {
            print "Try again, select the item number correctly\n";
        }
    }    
}

sub showlist {
    print "-List of the students-\n";
    foreach my $i (0..$#data) {
        my $number = $i+1;
        print "$number. $data[$i]->[0] \"$data[$i]->[1]\", $data[$i]->[2]\n";
    }
}

sub add {
    print "---------Add----------\n";
    while (1) {
        print "Enter the student's name: ";
        chomp(my $name = <STDIN>);
        print "Enter the student's surname: ";
        chomp(my $surname = <STDIN>);
        print "Enter the student's age: ";
        chomp(my $age = <STDIN>);
        
        last unless $name . $surname . $age;
        push @data, [$name, $surname, $age];

        print "The student is added\n\n";
    }    
}

sub edit {
    print "---------Edit---------\n";
    while (1) {
        print "Enter the student's number to edit: ";
        chomp(my $number = <STDIN>);
        last unless $number;
        
        if (($number > 0) and ($number <= $#data+1)) {
            my $i = $number - 1; 
            print "$number. $data[$i]->[0] \"$data[$i]->[1]\", $data[$i]->[2]\n";
            print "Enter the student's name: ";
            chomp(my $name = <STDIN>);
            $name = $data[$i]->[0] unless $name;
            print "Enter the student's surname: ";
            chomp(my $surname = <STDIN>);
            $surname = $data[$i]->[1] unless $surname;
            print "Enter the student's age: ";
            chomp(my $age = <STDIN>);
            $age = $data[$i]->[2] unless $age;
            
            $data[$i] = [$name, $surname, $age];

            print "The student is edited\n\n";
        }
        else {
            print "There is not the student\n\n";
        }    
    }    
}

sub delete {
    print "-------Delete-------\n";
    while (1) {
        print "Enter the student's number to delete: ";
        chomp(my $number = <STDIN>);
        last unless $number;
        
        if (($number > 0) and ($number <= $#data+1)) {
            my $i = $number - 1; 
            print "$number. $data[$i]->[0] \"$data[$i]->[1]\", $data[$i]->[2]\n";
            print "Enter 1 to delete: ";
            chomp(my $answer = <STDIN>);
            if ($answer) {
                splice @data, $i, 1;
                print "The student is deleted\n\n";
            }
            else {
                print "no deleted\n\n";
            }    
        }
        else {
            print "There is not the student\n\n";
        }    
    }    
}

sub saveto {
    print "----Save to a file----\n";
    print "Enter the file name to save: ";
    chomp(my $file = <STDIN>);
    if ($file) {
        my %hash;
        if (dbmopen(%hash, $file, 0644)) {
            foreach my $i (0..$#data) {
                $hash{$i} = join("##", @{$data[$i]});
            }
            dbmclose(%hash);
            print "Saved\n\n";
        }
        else {
            print "error\n\n";
        }    
    }
    else {
        print "no saved\n\n";
    }    
}

sub readfrom {
    print "---Read from a file---\n";
    print "Enter the file name to read from: ";
    chomp(my $file = <STDIN>);
    if ($file) {
        my %hash;
        if (dbmopen(%hash, $file, 0644)) {
            @data = ();
            foreach my $i (sort keys %hash) {
                push @data, [split("##", $hash{$i})];
            }
            dbmclose(%hash);
            print "Read\n\n";
        }
        else {
            print "error\n\n";
        }    
    }
    else {
        print "no read\n\n";
    }    
}

sub st06 {
menu();
}
return 1;
