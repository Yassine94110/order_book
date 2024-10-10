// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {OrderBook} from "../src/OrderBook.sol";
import {MockToken} from "../src/MockToken.sol"; // Assurez-vous que le chemin est correct
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract OrderBookScript is Script {
    OrderBook public orderBook;
    MockToken public token1;
    MockToken public token2;

    function setUp() public {
        // Déployer les tokens mock
        token1 = new MockToken("Token1", "TK1");
        token2 = new MockToken("Token2", "TK2");
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("WALLET_PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Déployer le contrat OrderBook avec les adresses des tokens
        orderBook = new OrderBook(address(token1), address(token2));
        console.log("OrderBook contract deployed at:", address(orderBook));

        // Approuver les tokens pour le contrat OrderBook
        approveTokens(address(token1), address(orderBook), 1000 * 10 ** token1.decimals());
        approveTokens(address(token2), address(orderBook), 1000 * 10 ** token2.decimals());

        vm.stopBroadcast();
    }

    function approveTokens(address tokenAddress, address to, uint256 amount) internal {
        IERC20 token = IERC20(tokenAddress);
        token.approve(to, amount);
        console.log("Approved", amount, "tokens for", to);
    }
}