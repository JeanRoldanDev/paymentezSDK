enum Installments {
  month_0(value: 0),
  month_1(value: 1),
  month_2(value: 2),
  month_3(value: 3),
  month_6(value: 6),
  month_9(value: 9),
  month_12(value: 12),
  month_15(value: 15),
  month_18(value: 18),
  month_24(value: 24),
  month_30(value: 30),
  month_36(value: 36);

  const Installments({
    required this.value,
  });

  final int value;
}
