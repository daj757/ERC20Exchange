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
    
    // function depositEther() payable public{
        
    // }
    
    // function withdrawEther(uint amountInWei) public {
        
    // }
    
    // function getEthBalanceInWei() constant returns (uint){
        
    // }
    
    //Token Management//
    
    function addToken(string symbolName, address erc20TokenAddress) public {
        require(!hasToken(symbolName));
        symbolNameIndex++;
        tokens[symbolNameIndex].symbolName = symbolName;
        tokens[symbolNameIndex].tokenContract = erc20TokenAddress;
    }
    
    function hasToken(string symbolName) public constant returns (bool)  {
        uint8 index = getSymbolIndexName(symbolName);
        if (index == 0) {
            return false;
        }
        return true;
        
    }
    
    function getSymbolIndexName(string symbolName) view internal returns (uint8) {
        for (uint8 i = 1; i <= symbolNameIndex; i++ ) {
            if (stringsEqual(tokens[i].symbolName, symbolName)) {
                return i;
            }
        }
        return 0;
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