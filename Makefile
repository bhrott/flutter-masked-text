publish:
	flutter test && flutter packages pub publish

copy-to-sample:
	cp lib/flutter_masked_text.dart example/masked_text_sample/lib/flutter_masked_text.dart

prepare:
	make copy-to-sample