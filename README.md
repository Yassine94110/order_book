📈 OrderBook DApp
Bienvenue dans le projet OrderBook ! Ce projet consiste en une application décentralisée (DApp) qui permet aux utilisateurs de passer et de gérer des ordres d'achat et de vente de tokens ERC20 sur la blockchain.

🚀 Fonctionnalités
Gestion des Ordres : Placez des ordres d'achat et de vente pour échanger des tokens.
Matching d'Ordres : Alignez automatiquement les ordres d'achat et de vente pour faciliter les échanges.
Annulation d'Ordres : Annulez des ordres actifs à tout moment.
Tokens ERC20 : Utilisez des tokens ERC20 comme actifs sous-jacents pour les échanges.
🛠️ Technologies Utilisées
Solidity : Langage de programmation pour développer des smart contracts.
Foundry : Cadre de développement pour écrire, tester et déployer des smart contracts.
OpenZeppelin : Bibliothèque pour les contrats intelligents sécurisés, y compris les tokens ERC20.
⚙️ Installation
Clonez le dépôt :

bash
Copier le code
git clone https://github.com/Yassine94110/order_book.git
cd orderbook
Installez les dépendances :

bash
Copier le code
forge install
Configurez votre fichier .env avec vos clés privées et les URL RPC :

plaintext
Copier le code
WALLET_PRIVATE_KEY=your_private_key
SEPOLIA_RPC_URL=https://your_rpc_url
📝 Utilisation
Déployez le contrat OrderBook :

Pour déployer le contrat sur le réseau de test Sepolia, exécutez :

bash
Copier le code
forge script script/OrderBookScript.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $WALLET_PRIVATE_KEY --broadcast
Interagissez avec le contrat :

Utilisez l'interface utilisateur ou un outil comme Remix ou Hardhat pour interagir avec les fonctionnalités de votre OrderBook.

🧪 Tests
Pour exécuter les tests, utilisez la commande suivante :

bash
Copier le code
forge test
📄 Contribuer
Les contributions sont les bienvenues ! Si vous souhaitez améliorer ce projet, veuillez suivre ces étapes :

Forkez le projet.
Créez votre branche (git checkout -b feature/nouvelle-fonctionnalité).
Commitez vos modifications (git commit -m 'Ajout d\'une nouvelle fonctionnalité').
Poussez votre branche (git push origin feature/nouvelle-fonctionnalité).
Ouvrez une Pull Request.


🎉 Remerciements
Merci d'avoir consulté le projet OrderBook ! Votre soutien est grandement apprécié. 🚀