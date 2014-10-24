use strict;

main ();

sub main
{
       
        print "Choose menu item\n";
        print "1. Add student at the list\n";
        print "2. Edit student\n";
        print "3. Delete student\n";
        print "4. Output list\n";
        print "5. Load the list from file\n";
        print "6. Save the list to the file\n";
        

        my @List;
        my %command =  (1 => \&AddStudent,
                        2 => \&EditList,
                        3 => \&DeleteStudent,
                        4 => \&OutputList,
                        5 => \&LoadFromFile,
                        6 => \&SaveToFile);

        print " \nEnter number of operation :   ";
        while (<STDIN>)
        {
                chomp;
                $command{$_}->(\@List);
                print "\nEnter number of operation :   ";
        }
}

sub AddStudent
{
        my($param1) = @_;

        print "Enter Student Surname:     ";
        chomp (my $Surname = <STDIN>);

        print "Enter Student Name:     ";
        chomp (my $Name= <STDIN>);

        print "Enter Student Age:     ";
        chomp (my $Age= <STDIN>);

        push @$param1, [$Surname, $Name, $Age];

        print "The student   $Surname $Name, $Age   has been added to the list \n";
}

sub EditList
{
        my($param1) = @_;

        print "Enter number of student :     ";
        chomp (my $Numb = <STDIN>);

        if (($Numb > 0) && ($param1->[--$Numb]))
        {
                print "\nCurrent Student     $param1->[$Numb][0]  $param1->[$Numb][1], $param1->[$Numb][2]   \n";

                print "Enter Student Surname:     ";
                chomp ($param1->[$Numb][0] = <STDIN>);

                print "Enter Student Name:     ";
                chomp ($param1->[$Numb][1] = <STDIN>);

                print "Enter Student Age :     ";
                chomp ($param1->[$Numb][2] = <STDIN>);

                print "Student   $param1->[$Numb][0]  $param1->[$Numb][1]  $param1->[$Numb][2] \n";
        }
        else
        {
                print "There is no Student with number like this!";
        }
}

sub DeleteStudent
{
        my($param1) = @_;

        print "Enter number of Student you want to delete:     ";
        chomp (my $Numb = <STDIN>);

        if (($Numb > 0) && ($param1->[--$Numb]))
        {
                $param1->[$Numb] = undef;
                while ($param1->[$Numb + 1])
                {
                        $param1->[$Numb] = $param1->[$Numb + 1];
                        $Numb++;
                }
                pop @$param1;
        }
        else
        {
                print "There is no Student with number like this!";
        }
}
sub OutputList
{
        my($param1) = @_;

        my $n = 0;
        while ($param1->[$n])
        {
                print $n+1 . ". $param1->[$n][0] $param1->[$n][1], $param1->[$n++][2] \n";
        }
        print "\nList is empty! \n" if $n == 0;
}

sub LoadFromFile
{
        my($param1) = @_;
        my @tmpmass;
        my %tmphash;
        my $n = 0;

        print "Enter name of file     ";
        chomp (my $FileName = <STDIN>);

        if (dbmopen (%tmphash, $FileName, undef))
        {
                foreach $n(keys %tmphash)
                {
                        @tmpmass = split(/::/, $tmphash{$n});

                        push @$param1, [$tmpmass[0], $tmpmass[1], $tmpmass[2]];
                }
                dbmclose (%tmphash);
                print "\nSuccessfully loaded!\n";
        }
        else
        {
                print "\nThe file can not be loaded\n";
        }
}
sub SaveToFile
{
        my($param1) = @_;
        my %tmphash;
        my $n = 0;

        print "Enter name of file     ";
        chomp (my $FileName = <STDIN>);

        if (dbmopen (%tmphash, $FileName, 0664))
        {
                %tmphash = ();
                while ($param1->[$n])
                {
                        $tmphash{$n} = join ("::", ($param1->[$n][0], $param1->[$n][1], $param1->[$n][2]));
                        $n++;
                }
                dbmclose (%tmphash);
                print "\nSuccessfully saved!\n";
        }
        else
        {
                print "\nThe list can not be saved!\n";
        }
}