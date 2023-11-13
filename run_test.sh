rm -r coverage
dart run test --coverage=./coverage
dart pub global run coverage:format_coverage --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage --check-ignore
genhtml -o coverage coverage/lcov.info
open coverage/index.html