validate:
	flutter test

publish:
	make validate && flutter packages pub publish