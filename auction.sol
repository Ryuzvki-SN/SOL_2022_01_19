//load token from : 0xb4eefd0ed14da9e3a91cf77f8e579d30b6259f87
pragma solidity 0.8.11;

interface IERC721 {

    function transfer(address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract Auction{

    event Start();
    event End(address highestBidder, uint highestBid);
    event Offer(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);

    address payable public seller;

    bool public started;
    bool public ended;
    uint public endAt;

    uint public highestBid;
    address public highestBidder;
    mapping(address=>uint) public Bids;

    IERC721 public token; //nft
    uint256 public tokenId; //nftId


    constructor(){
        seller = payable(msg.sender);
    }

    function start(IERC721 nft, uint256 nftId ,uint startingBid) external{

        require(!started, "Already started!");
        require(seller== msg.sender, "you did\'nt start audition!");

        highestBid = startingBid;
        token = nft;
        tokenId = nftId;
        token.transferFrom(msg.sender, address(this), tokenId);

        started = true;
        endAt = block.timestamp + 1 days;

        emit Start();
    }

    function end() external{

    require(started, "you need to start auction first!");
    require(block.timestamp>= endAt, "Auction is still ongoing!");
    require(!ended, "Auction already ended!");

    if (highestBidder != address(0)){

        token.transfer(highestBidder, tokenId);
        (bool sent, bytes memory data)=seller.call{value:highestBid}("");
        require(sent, "Could\'nt pay seller!");
    }else{

        token.transfer(seller, tokenId);
    }

    ended = true;

    emit End(highestBidder, highestBid);

    }

    function offer() external payable{
        require(started, "Not started.");
        require(block.timestamp<endAt, "Ended");
        require(msg.value>highestBid);

        if(highestBidder!= address(0)){
            Bids[highestBidder]+=highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Offer(highestBidder, highestBid);
    }


    function withdraw() external payable {
    
        uint balance = Bids[msg.sender];
        Bids[msg.sender]= 0;

        (bool sent, bytes memory data)= payable(msg.sender).call{value:balance}("");

        require(sent, "Could\'nt Withdraw");

        emit Withdraw(msg.sender, balance);
    }
}