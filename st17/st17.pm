package ST17;
use strict;

sub st17
{
	my %commands=(
		"1"=>\&add_elem,
		"2"=>\&edit_elem,
		"3"=>\&del_elem,
		"4"=>\&view_list,
		"5"=>\&save_data,
		"6"=>\&load_list,
		"0"=>sub{exit()}
               );
	while(1)
	{
		print "\n\t\tАвтопарк вашей мечты. Введите номер действия:\n
		1.Добавить авто\n
		2.Изменить существующее\n
		3.Удалить авто\n
		4.Вывести весь автопарк на экран\n
		5.Сохранить список в файл\n
		6.Загрузить список из файла\n
		0.Выход\n";
		chomp(my $string=<>);
		last if $string eq "0";
		redo if $string eq "";
		if ($commands{$string}) {$commands{$string}->();}
		else {print "Нет действия под таким номером (\"".$string."\"). Попробуйте снова\n";} 
	}

};

my %Car=();

my $model_car;
my $power;
my $body_type;
my $price_car;


sub input_values
{
	print "Введите тип кузова автомобиля: ";
	chomp($body_type=<>);
	print "Введите мощность двигателя авто (в л.с.): ";
	chomp($power=<>);
	print "Введите цену в условных единицах: ";
	chomp($price_car=<>);
};

sub add_elem
{
	print "Введите название модели авто: ";
	chomp($model_car=<>);
	input_values();
	push(@{$Car{$model_car}}, $body_type,$power, $price_car);
	
	print "\nВаш автопарк пополнился автомобилем ".$model_car."!\n";
	return 1;
};

sub del_elem
{
	if (%Car)
	{
		print "Введите название модели авто в вашем списке:\n";
		chomp(my $model_car = <STDIN>);
		if(exists($Car{$model_car}))
		{
			delete($Car{$model_car});
			print "Автомобиль успешно удалён!\n";
		}
		else
		{
			print "\nВ Вашем автопарке нет такой модели!\n\n";
		}
	}
	else
	{
		print "\nСписок пуст! Добавьте ваши авто\n";
	}
	
 return 1;
};

sub edit_elem
{
	if(%Car)
	{
		print "Введите название модели авто, которое хотите изменить: \n";
		chomp(my $model_car = <STDIN>);
		if(exists($Car{$model_car}))
		{
			input_values();
			@{$Car{$model_car}}[0] = $body_type;
			@{$Car{$model_car}}[1] = $power;
			@{$Car{$model_car}}[2] = $price_car;
			
			print "Автомобиль успешно изменён!\n";
		}
		else
		{
			print "\nВ Вашем автопарке нет такой модели!\n\n";
		};
	}
	else
	{
		print "\nСписок пуст! Добавьте ваши авто\n";
	}
return 1;
};

sub view_list
{
    if (%Car) 
    {
	print "\tВаш автопарк мечты:\n\n";
	for my $model_car (sort keys %Car ) 
	{
		print "\nАвто $model_car:\n 
	Тип кузова:         @{$Car{$model_car}}[0];\n
	Мощность двигателя: @{$Car{$model_car}}[1];\n
	Цена авто (в у.е.): @{$Car{$model_car}}[2];\n";
	}
    }
    else 
    {
	print "\nСписок пуст! Добавьте ваши авто\n";

    }
return 1;
};

sub save_data
{	
	
	my %hash_data = ();
	dbmopen(%hash_data,"My_Autopark",0644) || die "Ошибка при сохранении!";
	
	my $tmp;
	foreach my $model_car (keys %Car)
	{
		$tmp = undef();		
		$tmp = @{$Car{$model_car}}[0].",".@{$Car{$model_car}}[1].",".@{$Car{$model_car}}[2].";";
		$hash_data{$model_car} = $tmp;
	};
	
	dbmclose(%hash_data);
	print "Успешно сохранено!\n";
return 1;
}

sub load_list
{	
	my %hash_data = ();
	dbmopen(%hash_data,"My_Autopark",0644) || die "Ошибка при загрузки!";
	
	foreach my $model_car (keys %hash_data)
	{
		my @tmp = undef();
		@tmp = split(/,/, $hash_data{$model_car}); 
		foreach my $tmp_item (@tmp)
		{
			my @param = split(/,/, $tmp_item);
			push(@{$Car{$model_car}}, $param[0], $param[1], $param[2]);
		};
	};
	
	dbmclose( %hash_data);
	print "Успешно загружено!\n";
return 1;
}
1;
