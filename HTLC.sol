pragam solidity ^0.7.4;

interface IERC20{
    
        /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    
        /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

contract HTLC {
    uint public startTime;
    uint public lockTime= 10000 seconds;
    
    string public secret; //hocuspocus
    bytes32 public hash = 0x52516b250f7f2ca62094f4fdc55acc4d42001ed196e97dee906449064da494f2;
    
    address public recipient; //to
    address public owner; //from
    
    uint public amount;
    IERC20 public token;
    
    constructor  (address _recipient, address _token, uint _amount){
        recipient = _recipient;
        owner = msg.sender; // the creator of the sc is also the owner
        amount = _amount;
        
        //you need this to retrive the type (from the interface)
        token = IERC20 (_token);
    }
    
    function fund() external {
        startTime = block.timestamp;
        //transfer the amout of token from Bob to this contranct
        token.transferFrom(msg.sender, address(this), amount); 
    }
    
    function withdraw(string memory _secret) external {
        require (keccak256(abi.encodePacked(_secret)== hash, 'wrong secret');
        secret = _secret;
        token.transfer (recipient, amount);
    }
    
    function refund () external {
        require (block.timestamp > startTime + lockTime, ' too early');
        token.transfer(owner,amount);
    }
    
    
}