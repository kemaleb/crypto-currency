import 'package:crypto_currency/crypto/domain/crypto_currency_rate.dart';
import 'package:crypto_currency/crypto/domain/crypto_currency_trend.dart';
import 'package:crypto_currency/crypto/ui/money_format.dart';
import 'package:crypto_currency/crypto/ui/trend_icon_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CryptoCurrencyDetailScreen extends StatelessWidget {
  final CryptoCurrencyRate cryptoCurrencyRate;
  final NumberFormat numberFormat = NumberFormat.decimalPattern();
  final MoneyFormat moneyFormat = MoneyFormat();

  CryptoCurrencyDetailScreen(
    this.cryptoCurrencyRate, {
    Key key,
  })  : assert(cryptoCurrencyRate != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
      );

  Widget _buildAppBar() => AppBar(
        title: Text(cryptoCurrencyRate.cryptoCurrency.name),
      );

  Widget _buildBody(BuildContext context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _buildContent(context),
          ),
        ),
      );

  List<Widget> _buildContent(BuildContext context) {
    return <Widget>[
      _buildLabeledTextField(
          'Price', moneyFormat.format(cryptoCurrencyRate.price)),
      _buildLabeledTextField(
          'Market Cap', numberFormat.format(cryptoCurrencyRate.marketCap)),
      Divider(),
      _buildLabeledTextField('Circulating Supply',
          '${numberFormat.format(cryptoCurrencyRate.supply.circulating)} ${cryptoCurrencyRate.cryptoCurrency.symbol}'),
      _buildMaxSupply(),
      Divider(),
      _buildTrendLabeledTextField(
          context, 'Change (1h)', cryptoCurrencyRate.trendHistory.hour),
      _buildTrendLabeledTextField(
          context, 'Change (1d)', cryptoCurrencyRate.trendHistory.day),
      _buildTrendLabeledTextField(
          context, 'Change (1w)', cryptoCurrencyRate.trendHistory.week),
    ];
  }

  Widget _buildMaxSupply() {
    return cryptoCurrencyRate.supply.max != null
        ? _buildLabeledTextField(
            'Max Supply',
            '${numberFormat.format(cryptoCurrencyRate.supply.max)} ${cryptoCurrencyRate.cryptoCurrency.symbol}',
          )
        : SizedBox();
  }

  Widget _buildLabeledTextField(String label, String text) => TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          enabled: false,
        ),
        controller: TextEditingController(text: text),
      );

  Widget _buildTrendLabeledTextField(
    BuildContext context,
    String label,
    TrendValue trendValue,
  ) =>
      TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          enabled: false,
          suffixIcon: buildTrendIcon(context, trendValue.trend),
        ),
        controller: TextEditingController(
            text: '${trendValue.value.toStringAsFixed(2)} %'),
      );
}
