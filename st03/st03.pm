package ST03;
use strict;
my %menu_items = (
   1 => ["Вывод списка книг", \&list],
   2 => ["Добавить книги", \&add],
   3 => ["Редактирование книг", \&edit],
   4 => ["Удаление книг", \&remove],
   5 => ["Сохранение в файл", \&backup],
   6 => ["Чтение из файла", \&restore]
);

my @data;

sub menu {
    while (1) {
        print "\n";
        print "---------------------------------------\n";
        foreach my $n (sort keys %menu_items) {
            print "$n. $menu_items{$n}->[0]\n";
        }
        print "---------------------------------------\n";
        print "Выберите номер пункта, или 0 для выхода: ";
        chomp(my $answer = <STDIN>);
        last unless $answer;
        if (exists $menu_items{$answer}) {
            $menu_items{$answer}->[1]->();
        }
        else {
            print "Ошибка! Повторите еще раз: \n";
        }
    }    
}

sub list {
    print "Список книг.\n";
    foreach my $i (0..$#data) {
        my $number = $i+1;
        print "$number. $data[$i]->[0] \"$data[$i]->[1]\", $data[$i]->[2]\n";
    }
}

sub add {
    print "Добавление книг.\n";
    while (1) {
        print "Для завершения вводите пустые ответы\n";
        print "Введите автора: ";
        chomp(my $autor = <STDIN>);
        print "Введите название: ";
        chomp(my $title = <STDIN>);
        print "Введите год издания: ";
        chomp(my $year = <STDIN>);
        
        last unless $autor . $title . $year;
        push @data, [$autor, $title, $year];

        print "Книга добавлена\n\n";
    }    
}

sub edit {
    print "Редактирование книг\n";
    while (1) {
        print "Укажите номер книги для редактирования (ВВОД для завершения):";
        chomp(my $number = <STDIN>);
        last unless $number;
        
        if (($number > 0) and ($number <= $#data+1)) {
            my $i = $number - 1; 
            print "$number. $data[$i]->[0] \"$data[$i]->[1]\", $data[$i]->[2]\n";
            print "Пустой ответ оставит поле без внимания\n";
            print "Введите автора: ";
            chomp(my $autor = <STDIN>);
            $autor = $data[$i]->[0] unless $autor;
            print "Введите название: ";
            chomp(my $title = <STDIN>);
            $title = $data[$i]->[1] unless $title;
            print "Введите год издания: ";
            chomp(my $year = <STDIN>);
            $year = $data[$i]->[2] unless $year;
            
            $data[$i] = [$autor, $title, $year];

            print "Книга изменена\n\n";
        }
        else {
            print "Неверный номер книги\n\n";
        }    
    }    
}

sub remove {
    print "Удаление книг\n";
    while (1) {
        print "Укажите номер книги для удаления (ВВОД для завершения):";
        chomp(my $number = <STDIN>);
        last unless $number;
        
        if (($number > 0) and ($number <= $#data+1)) {
            my $i = $number - 1; 
            print "$number. $data[$i]->[0] \"$data[$i]->[1]\", $data[$i]->[2]\n";
            print "Пустой ответ оставит поле без внимания\n";
            print "Чтобы подтвердить удаление, введите 1 ";
            chomp(my $answer = <STDIN>);
            if ($answer) {
                splice @data, $i, 1;
                print "Книга удалена\n\n";
            }
            else {
                print "Удаление отменено\n\n";
            }    
        }
        else {
            print "═Неверный номер книги, повторите запрос\n\n";
        }    
    }    
}

sub backup {
    print "Сохранение списка книг в файл.\n";
    print "Укажите имя файла для сохранения (ВВОД для отмены):";
    chomp(my $file = <STDIN>);
    if ($file) {
        my %hash;
        if (dbmopen(%hash, $file, 0644)) {
            foreach my $i (0..$#data) {
                $hash{$i} = join("##", @{$data[$i]});
            }
            dbmclose(%hash);
            print "Сохранение выполнено\n\n";
        }
        else {
            print "Ошибка при работе с файлом\n\n";
        }    
    }
    else {
        print "Операция отменена\n\n";
    }    
}

sub restore {
    print "Чтение списка книг из файла.\n";
    print "Укажите имя файла для чтения (ВВОД для отмены):";
    chomp(my $file = <STDIN>);
    if ($file) {
        my %hash;
        if (dbmopen(%hash, $file, 0644)) {
            @data = ();
            foreach my $i (sort keys %hash) {
                push @data, [split("##", $hash{$i})];
            }
            dbmclose(%hash);
            print "Чтение выполнено\n\n";
        }
        else {
            print "Ошибка при работе с файлом\n\n";
        }    
    }
    else {
        print "Операция отменена\n\n";
    }    
}
sub st03 {
menu();
}
return 1;
