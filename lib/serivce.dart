import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class FirstCoinService {
  int counterValue = 0;

  final String _rpcUrl =
      Platform.isAndroid ? "YOUR_LINK_HERE" : "YOUR_LINK_HERE";
  final String _wsUrl =
      Platform.isAndroid ? "YOUR_LINK_HERE" : "YOUR_OTHER_LINK_HERE";
  final String _privateKey = "INSERT_YOUR_PRIVATE_KEY_HERE";

  late Web3Client _web3Client;
  late ContractAbi _abiCode;
  late EthPrivateKey _creds;
  late EthereumAddress _contractAddress;

  late DeployedContract _deployedContract;
  late ContractFunction _incrementer;
  late ContractFunction _decrementer;
  late ContractFunction _coinGetter;

  FirstCoinService() {
    init();
  }

  Future<void> init() async {
    _web3Client = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getAbi();
    await getCredentials();
    await getDeployedContracts();
  }

  Future<void> getAbi() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/FirstCoin.json');
    var jsonAbi = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonAbi['abi']), "First");

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContracts() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _incrementer = _deployedContract.function('incrementer');
    _decrementer = _deployedContract.function('decrementer');
    _coinGetter = _deployedContract.function('coinGetter');
  }

  Future<void> coinGetter() async {
    List response = await _web3Client
        .call(contract: _deployedContract, function: _coinGetter, params: []);

    int curVal = response[0].toInt();

    counterValue = curVal;
  }

  Future<void> incrementer() async {
    await _web3Client.sendTransaction(
        _creds,
        Transaction.callContract(
            contract: _deployedContract,
            function: _incrementer,
            parameters: []));

    coinGetter();
  }

  Future<void> decrementer() async {
    await _web3Client.sendTransaction(
        _creds,
        Transaction.callContract(
            contract: _deployedContract,
            function: _decrementer,
            parameters: []));

    coinGetter();
  }
}
