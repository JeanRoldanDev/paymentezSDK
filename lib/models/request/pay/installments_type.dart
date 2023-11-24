/// https://paymentez.github.io/api-doc/#payment-methods-cards-debit-with-token-base-case-installments-type
enum InstallmentsType {
  type0(
    value: 0,
    description: 'Revolving credit (rotativo)',
  ),
  type1(
    value: 1,
    description: 'Revolving and deferred without interest (The bank will pay '
        'to the commerce the installment, month by month)',
  ),
  type2(
    value: 2,
    description: 'Deferred with interest',
  ),
  type3(
    value: 3,
    description: 'Deferred without interest',
  ),
  type7(
    value: 7,
    description: 'Deferred with interest and months of grace',
  ),
  type6(
    value: 6,
    description: 'Deferred without interest pay month by month. (*)',
  ),
  type9(
    value: 9,
    description: 'Deferred without interest and months of grace',
  ),
  type10(
    value: 10,
    description: 'Deferred without interest promotion bimonthly. (*)',
  ),
  type21(
    value: 21,
    description:
        'For Diners Club exclusive, deferred with and without interest',
  ),
  type22(
    value: 22,
    description:
        'For Diners Club exclusive, deferred with and without interest',
  ),
  type30(
    value: 30,
    description: 'Deferred with interest pay month by month. (*)',
  ),
  type50(
    value: 50,
    description: 'Deferred without interest promotions (Supermaxi). (*)',
  ),
  type51(
    value: 51,
    description: 'Deferred with interest (Cuota fácil). (*)',
  ),
  type52(
    value: 52,
    description: 'Without interest (Rendecion Produmillas). (*)',
  ),
  type53(
    value: 53,
    description: 'Without interest sale with promotions. (*)',
  ),
  type70(
    value: 70,
    description: 'Deferred special without interest. (*)',
  ),
  type72(
    value: 72,
    description: 'Credit without interest (cte smax). (*)',
  ),
  type73(
    value: 73,
    description: 'Special credit without interest (smax). (*)',
  ),
  type74(
    value: 74,
    description: 'Prepay without interest (smax). (*)',
  ),
  type75(
    value: 75,
    description: 'Deffered credit without interest (smax). (*)',
  ),
  type90(
    value: 90,
    description: 'Without interest with months of grace (Supermaxi). (*)',
  );

  const InstallmentsType({
    required this.value,
    required this.description,
  });

  final int value;
  final String description;
}
