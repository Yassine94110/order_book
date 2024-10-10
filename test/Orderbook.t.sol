// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/Orderbook.sol"; // Assurez-vous que le chemin est correct

contract MockToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 10000 * 10 ** decimals()); // Mint initial tokens to deployer
    }
}

contract orderbookTest is Test {
    Orderbook public orderbook;
    MockToken public token1;
    MockToken public token2;

    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        token1 = new MockToken("Token1", "TK1");
        token2 = new MockToken("Token2", "TK2");
        orderbook = new Orderbook(address(token1), address(token2));

        // Mint tokens to users for testing
        token1.transfer(user1, 1000 * 10 ** token1.decimals());
        token2.transfer(user2, 1000 * 10 ** token2.decimals());
    }

    function test_placeBuyOrder() public {
        // User2 places a buy order for 100 Token1 at price 5 Token2
        vm.startPrank(user2);
        token2.approve(address(orderbook), 500 * 10 ** token2.decimals());
        orderbook.placeOrder(100 * 10 ** token1.decimals(), 5, true);

        // Get the order details
        (address trader, uint256 amount, uint256 price, bool isBuyOrder, bool isActive) = orderbook.getOrder(0);

        assertEq(trader, user2);
        assertEq(amount, 100 * 10 ** token1.decimals());
        assertEq(price, 5);
        assertTrue(isBuyOrder);
        assertTrue(isActive);
        vm.stopPrank();
    }

    function test_placeSellOrder() public {
        // User1 places a sell order for 100 Token1 at price 5 Token2
        vm.startPrank(user1);
        token1.approve(address(orderbook), 100 * 10 ** token1.decimals());
        orderbook.placeOrder(100 * 10 ** token1.decimals(), 5, false);

        // Get the order details
        (address trader, uint256 amount, uint256 price, bool isBuyOrder, bool isActive) = orderbook.getOrder(0);

        assertEq(trader, user1);
        assertEq(amount, 100 * 10 ** token1.decimals());
        assertEq(price, 5);
        assertFalse(isBuyOrder);
        assertTrue(isActive);
        vm.stopPrank();
    }

    function test_matchBuyOrder() public {
        // User2 places a buy order
        vm.startPrank(user2);
        token2.approve(address(orderbook), 500 * 10 ** token2.decimals());
        orderbook.placeOrder(100 * 10 ** token1.decimals(), 5, true);
        vm.stopPrank();

        // User1 places a sell order
        vm.startPrank(user1);
        token1.approve(address(orderbook), 100 * 10 ** token1.decimals());
        orderbook.placeOrder(100 * 10 ** token1.decimals(), 5, false);
        vm.stopPrank();

        // User2 matches the order
        vm.startPrank(user1);
        token1.approve(address(orderbook), 100 * 10 ** token1.decimals());
        orderbook.matchOrder(0, 100 * 10 ** token1.decimals()); // Match the buy order
        vm.stopPrank();

        // Verify the order has been matched
        (address trader, uint256 amount, uint256 price, bool isBuyOrder, bool isActive) = orderbook.getOrder(0);
        assertEq(amount, 0); // The order should be filled
        assertFalse(isActive); // The order should not be active anymore
    }



    function test_cancelOrder() public {
        // User1 places a sell order
        vm.startPrank(user1);
        token1.approve(address(orderbook), 100 * 10 ** token1.decimals());
        orderbook.placeOrder(100 * 10 ** token1.decimals(), 5, false);
        uint256 orderId = 0; // The ID of the placed order
        vm.stopPrank();

        // Cancel the order (Note: You'll need to implement a cancel function in orderbook)
        // vm.startPrank(user1);
        // orderbook.cancelOrder(orderId);
        // vm.stopPrank();

        // Verify order status
        // (address trader, uint256 amount, uint256 price, bool isBuyOrder, bool isActive) = orderbook.getOrder(orderId);
        // assertFalse(isActive);
    }
}
