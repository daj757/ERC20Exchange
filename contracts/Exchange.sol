pragma solidity ^0.4.0;

import "./FixedSupplyToken.sol";

contract Exchange is Owned {
    
    struct Offer {
        uint amount;
        address who;
        
    }
    
    struct OrderBook {
        uint higherPrice;
        uint lowerPrice;
        
        mapping(uint => Offer) offers;
        
        uint offers_key;
        uint offers_length;
        
    }
    
    struct Token {
        address tokenContract;
        string symbolName;
        
        mapping(uint => OrderBook) buyBook;
        uint curBuyPrice;
        uint lowestBuyPrice;
        uint amountBuyPrices;
        
        mapping(uint => OrderBook) sellBook;
        uint curSellPrice;
        uint lowestSellPrice;
        uint amountSellPrices;
        
    }
    
    mapping (uint8 => Token) tokens;
    
    uint8 symbolNameIndex;
    
    //Balances//
    
    mapping(address => mapping(uint8 => uint)) tokenBalanceForAddress;
    
    mapping(address => uint) balanceEthForAddresses;
    
    //Events//
    
    
    //Withdraw/deposit Ether//
    
    function depositEther() payable public {
        require(balanceEthForAddresses[msg.sender] + msg.value >= balanceEthForAddresses[msg.sender]);
        balanceEthForAddresses[msg.sender] += msg.value;
    }
    
    function withdrawEther(uint amountInWei) public {
        require(balanceEthForAddresses[msg.sender] - amountInWei >= 0);
        require(balanceEthForAddresses[msg.sender] - amountInWei <= balanceEthForAddresses[msg.sender]);
        balanceEthForAddresses[msg.sender] -= amountInWei;
        msg.sender.transfer(amountInWei);
        
    }
    
    function getEthBalanceInWei() public constant returns (uint) {
        return balanceEthForAddresses[msg.sender];
    }
    
    //Token Management//
    
    function addToken(string symbolName, address erc20TokenAddress) public {
        require(!hasToken(symbolName));
        symbolNameIndex++;
        tokens[symbolNameIndex].symbolName = symbolName;
        tokens[symbolNameIndex].tokenContract = erc20TokenAddress;
    }
    
    function hasToken(string symbolName) public constant returns (bool) {
        uint8 index = getSymbolIndex(symbolName);
        if (index == 0) {
            return false;
        }
        return true;
        
    }
    
    function getSymbolIndex(string symbolName) view internal returns (uint8) {
        for (uint8 i = 1; i <= symbolNameIndex; i++ ) {
            if (stringsEqual(tokens[i].symbolName, symbolName)) {
                return i;
            }
        }
        return 0;
    }

    function getSymbolIndexOrThrow(string symbolName) view internal returns (uint8) {
        uint8 index = getSymbolIndex(symbolName);
        require(index >= 0);
        return index;
    }
    
    //imported String comparison function//
    
    function stringsEqual(string storage _a, string memory _b) view internal returns(bool) {
        bytes storage a = bytes(_a);
        bytes memory b = bytes(_b);
        if (a.length != b.length)
            return false;
            
        for (uint i = 0; i < a.length; i++)
            if (a[i] != b[i])
                return false;
        return true;       
    }

    //Deposit tokens//
    function depositToken (string symbolName, uint amount) public {
        uint8 index = getSymbolIndexOrThrow(symbolName);
        require(tokens[index].tokenContract != address(0));
        ERC20Interface token = ERC20Interface(tokens[index].tokenContract);
        require(token.transferFrom(msg.sender, address(this), amount) == true);
        require(tokenBalanceForAddress[msg.sender][index] + amount >= tokenBalanceForAddress[msg.sender][index]);
        tokenBalanceForAddress[msg.sender][index] += amount;

    }

    function withdrawToken (string symbolName, uint amount) public {
        uint8 index = getSymbolIndexOrThrow(symbolName);
        require(tokens[index].tokenContract != address(0));
        ERC20Interface token = ERC20Interface(tokens[index].tokenContract);
        require(token.transferFrom(msg.sender, address(this), amount) == true);
        require(tokenBalanceForAddress[msg.sender][index] - amount <= tokenBalanceForAddress[msg.sender][index]);
        tokenBalanceForAddress[msg.sender][index] -= amount;
        require(token.transfer(msg.sender, amount) == true);
    }

    function getBalance (string symbolName) public constant returns (uint){
        uint8 index = getSymbolIndexOrThrow(symbolName);
        return tokenBalanceForAddress[msg.sender][index];
    }
    
    //get order books//
    
    // function getBuyOrderBook(string symbolName) constant returns (uint[], uint[]) {
        
    // }
    
    // function getSellOrderBook(string symbolName) constant returns (uint[], uint[]){
        
    // }
    
    // //Bid order//
    
    // function buyToken(string symbolName, uint priceInWei, uint amount){
        
    // }
    
    // //Ask Order//
    
    // function sellToken(string symbolName, uint priceInWei, uint amount){
        
    // }
    
    // //Cancel Order//
    
    // function cancelOrder(string symbolName, bool isSellOrder, uint priceInWei, uint offerKey){
        
    // }
    
}