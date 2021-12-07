# Défi - Système de vote 2
### Ajouts des tests unitaires du smart contract
###### Etapes :
1. Création du répertoire : **voting-system**
2. Initialisation du projet Truffle avec la commande ```truffle init``` (création des sous-répertoires : contracts, migrations, test et du fichier truffle-config.js)
3. Configuration du réseau Ganache dans le fichier truffle-config.js
4. Ajout du smart contract "**Voting**" (version corrigée du DEFI #1) dans le sous-répertoire "contracts"
5. Création du fichier de déploiement "2_deploy_contracts.js" dans le sous-répertoire "migrations"
6. Ajout du module "openzeppelin-contracts" en local avec la commande ```npm install @openzeppelin/contracts```
7. Config de l'import dans le smart contract "Voting.sol" :```import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";```
9. Exécution de la commande ```truffle migrate``` (ce qui créé le répertoire "build")
10. Création du test du smart contract "**Voting**" avec la commande ```truffle create test Voting```
11. Test à vide avec la commande ```truffle test test/Voting.sol --network development``` => OK 0 passing (0ms)
12. Création des tests :
    - Création d'une instance pour chaque test avec "beforeEach"
    - Création des tests
        - 1.Vérifier le statut initial
        - 2.Vérifier le changement de statut
        - 3.Vérifier qu'un votant n'a pas déjà voté
        - 4.Vérifier que la description de la proposition est bien enregistrée
        - 5.Vérifier qu'un vote est bien pris en compte
13. Test avec la commande : ```truffle test```
