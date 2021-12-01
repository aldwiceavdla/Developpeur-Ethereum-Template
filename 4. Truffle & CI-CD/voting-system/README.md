1. Création du répertoire : voting-system
2. Initialisation du projet Truffle avec la commande "truffle init" (création des sous-répertoires : contracts, migrations, test et du fichier truffle-config.js)
3. Configuration du réseau Ganache dans le fichier truffle-config.js
4. Ajout du smart contract "Voting" (version corrigée du DEFI #1) dans le sous-répertoire "contracts"
5. Création du fichier de déploiement "2_deploy_contracts.js" dans le sous-répertoire "migrations"
6. Ajout du module "openzeppelin-contracts" en local avec la commande "npm install @openzeppelin/contracts"
7. Configuration de l'import dans le smart contract "Voting.sol" : import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
8. Exécution de la commande "truffle migrate" (ce qui créé le répertoire "build")
9. Création du test du smart contract "Voting" avec la commande "truffle create test Voting"
10. Test à vide avec la commande "truffle test test/Voting.sol --network development" => OK 0 passing (0ms)
11. Création des tests :
    1. Création d'une instance pour chaque test avec "beforeEach"
    2. Création des tests
12. Test avec la commande : "truffle test"