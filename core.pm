package Core;

# computation routing dispatcher.
sub compute {
	$id = shift;
	if ($id == 1) {
		555;
	} else {
		666;
	}
}

1;