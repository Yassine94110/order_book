// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Orderbook {
    IERC20 public token1; // Premier token de la paire (ex: ETH)
    IERC20 public token2; // Deuxième token de la paire (ex: USDT)

    constructor(address _token1, address _token2) {
        require(_token1 != address(0) && _token2 != address(0), "Invalid token addresses");
        require(_token1 != _token2, "Tokens must be different");
        
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
    }

    // Structure pour un ordre
    struct Order {
        address trader;  // Adresse du trader qui a placé l'ordre
        uint256 amount;  // Quantité de tokens de l'ordre
        uint256 price;   // Prix unitaire des tokens
        bool isBuyOrder; // True pour un ordre d'achat, False pour un ordre de vente
        bool isActive;   // True si l'ordre est encore valide, False s'il est exécuté
    }

    // Liste des ordres (order book) avec un `mapping` pour un accès rapide
    mapping(uint256 => Order) public orderBook;
    uint256 public orderCounter; // Compteur pour l'identifiant des ordres

    // Placer un ordre d'achat ou de vente
    function placeOrder(uint256 _amount, uint256 _price, bool _isBuyOrder) public {
        require(_amount > 0, "Amount must be greater than 0");
        require(_price > 0, "Price must be greater than 0");

        if (_isBuyOrder) {
            // Si c'est un ordre d'achat, l'utilisateur doit envoyer les tokens token2 (ex: USDT)
            uint256 totalCost = _amount * _price;
            require(token2.transferFrom(msg.sender, address(this), totalCost), "Payment failed");
        } else {
            // Si c'est un ordre de vente, l'utilisateur doit envoyer les tokens token1 (ex: ETH)
            require(token1.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        }

        // Créer et ajouter l'ordre au carnet
        Order memory newOrder = Order({
            trader: msg.sender,
            amount: _amount,
            price: _price,
            isBuyOrder: _isBuyOrder,
            isActive: true
        });

        orderBook[orderCounter] = newOrder;
        orderCounter++;
    }

    // Faire correspondre un ordre (partiellement ou totalement)
    function matchOrder(uint256 _orderId, uint256 _amountToTrade) public {
        Order storage order = orderBook[_orderId];
        require(order.isActive, "Order is not active");
        require(order.trader != msg.sender, "Cannot match your own order");
        require(_amountToTrade <= order.amount, "Amount exceeds order size");
        require(_amountToTrade > 0, "Amount must be greater than 0");

        uint256 totalPrice = _amountToTrade * order.price;

        if (order.isBuyOrder) {
            // Si c'est un ordre d'achat, vérifier que le vendeur envoie les bons tokens (token1)
            require(token1.transferFrom(msg.sender, order.trader, _amountToTrade), "Transfer of token1 failed");
            require(token2.transfer(msg.sender, totalPrice), "Transfer of token2 failed");
        } else {
            // Si c'est un ordre de vente, vérifier que l'acheteur envoie les bons tokens (token2)
            require(token2.transferFrom(msg.sender, order.trader, totalPrice), "Transfer of token2 failed");
            require(token1.transfer(msg.sender, _amountToTrade), "Transfer of token1 failed");
        }

        // Ajuster la quantité restante dans l'ordre
        order.amount -= _amountToTrade;

        // Si l'ordre est entièrement rempli, le marquer comme inactif
        if (order.amount == 0) {
            order.isActive = false;
        }
    }

    // Obtenir les détails d'un ordre spécifique
    function getOrder(uint256 _orderId) public view returns (address, uint256, uint256, bool, bool) {
        Order memory order = orderBook[_orderId];
        return (order.trader, order.amount, order.price, order.isBuyOrder, order.isActive);
    }
}
