const FirstCoin = artifacts.require('FirstCoin');

module.exports = function (deployer) {
    deployer.deploy(FirstCoin);
}
