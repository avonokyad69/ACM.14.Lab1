package ST18;
use 5.010; # CollapsedSubs: add  edit  del  show  save  load
use strict;
use warnings;

my @student = (
        "NAME",
        "SURNAME",
        "AGE",
        "TEL",
        );

my @elements = ();


# Добавление
sub add()
{
        # Запрашиваем все необходимые данные
        print "name: "; chomp(my $name = <STDIN>);
        print "surname: "; chomp(my $surname = <STDIN>);
        print "age: "; chomp(my $age = <STDIN>);
        print "tel: "; chomp(my $tel = <STDIN>);
        # Добавляем новый хеш в массив
        push @elements,
        {
                $student[0] => $name,
                $student[1] => $surname,
                $student[2] => $age,
                $student[3] => $tel
        };

        return 0;
}

# Редактирование
sub edit()
{
        print "edit elem by index == ";
        chomp(my $index = <STDIN>);
        if ($index =~ /^\d+$/) #число целочисленное
        {
                if($index >= 0 && $index <= $#elements)
                {
                        print "name: "; chomp(my $name = <STDIN>);
                        print "surname: "; chomp(my $surname = <STDIN>);
                        print "age: "; chomp(my $age = <STDIN>);
                        print "tel: "; chomp(my $tel = <STDIN>);

                        $elements[$index]->{NAME} = $name;
                        $elements[$index]->{SURNAME} = $surname;
                        $elements[$index]->{AGE} = $age;
                        $elements[$index]->{TEL} = $tel;
                }
        }
        return 0;
}

# Удалить
sub del()
{
        print "delete elem by index == ";
        chomp(my $index = <STDIN>);
        if ($index =~ /^\d+$/) #число целочисленное
        {
                if($index >= 0 && $index <= $#elements)
                {
                        splice @elements, $index, 1;

                }
        }
        return 0;
}

# Вывод на экран
sub show()
{
        print "\t$_" foreach(@student);
        say "";
        my $i = 0;
        # Выводим все хеши хранящиеся внутри массива
        for my $href ( @elements )
        {
                say "[".$i++."]\t$href->{$student[0]}\t$href->{$student[1]}\t$href->{$student[2]}\t$href->{$student[3]}";
        }
        return 0;
}

# Сохранить в файл
sub save()
{
        # Открыли
        dbmopen(my %recs, "dbmfile", 0644) || die "Cannot open DBM dbmfile: $!";
        # Обнуляем хеш
        %recs = ();
        my $i = 0;
        # Выводим данные в виде строк параметры, внутри строки разделены табуляциями
        for my $elem ( @elements )
        {
                $recs {$i++} = join("\t",
                        $elem->{$student[0]},
                        $elem->{$student[1]},
                        $elem->{$student[2]},
                        $elem->{$student[3]}
                        );
        }
        # Закрыли
        if(dbmclose(%recs))
        {
                say "save complete";
        }
        else
        {
                say "save fail";
        }
        return 0;
}

# Загрузить из файла
sub load()
{
        # Открыли файл
        dbmopen(my %recs, "dbmfile", 0644) || die "Cannot open DBM dbmfile: $!";
        # Очищаем массив
        splice @elements, 0, $#elements + 1;
        # Читаем
        while ((my $key, my $val) = each %recs)
        {
                my @cur_entry = split /\t/, $val;
                push @elements,
                {
                        $student[0] => $cur_entry[0],
                        $student[1] => $cur_entry[1],
                        $student[2] => $cur_entry[2],
                        $student[3] => $cur_entry[3]
                };
        }
        # Закрываем
        if(dbmclose(%recs))
        {
                say "load complete";
        }
        else
        {
                say "load fail";
        }

        return 0;
}
sub st18
{
#############################################################################
my $choice = 0;
# Массив ссылок на подпрограммы
my @commands = (sub {}, \&add, \&edit, \&del, \&show, \&save, \&load, sub {say "good bye !"},);
# Массив надписей меню
my @menu = ("", "[1].add", "[2].edit", "[3].del", "[4].show", "[5].save", "[6].load", "[0].exit");

do
{
        print "-" x 5, "[MENU]", "-" x 5;
        # Выводим меню
        say foreach(@menu);
        print "command: ";
        # Читаем команду
        chomp($choice = <STDIN>);
        if ($choice =~ /^\d+$/) #число целочисленное
        {
                if($choice >= 0 && $choice <= 6)
                {
                        # Выполняем вызов подпрограммы
                        $commands[$choice]->();
                }
        }
        else
        {
                $choice = -1;
                say "error command";
        }

}while($choice != 0);

}return 1;