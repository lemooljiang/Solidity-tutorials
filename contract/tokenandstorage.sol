pragma solidity >=0.4.22 <0.7.0;

 abstract contract ERC20Interface {
  string public name;
  string public symbol;
  uint8 public  decimals;
  uint public totalSupply;

  function mining(address target, uint amount) public virtual returns (bool success);
  function transfer(address _to, uint256 _value) public virtual returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
  
  function approve(address _spender, uint256 _value) public virtual returns (bool success);
  function allowance(address _owner, address _spender) public virtual view returns (uint256 remaining);

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  event AddSupply(uint amount);
}


contract ERC20 is ERC20Interface {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) allowed;
    
    constructor() public {
       name = "Lemool"; 
       symbol = "LEM";
       decimals = 0;
       totalSupply = 10000000;
       balanceOf[msg.sender] = totalSupply;
    }
    
    function mining(address target, uint amount) public override returns (bool success){
        totalSupply += amount;
        balanceOf[target] += amount;

        emit AddSupply(amount);
        emit Transfer(address(0), target, amount);
        return true;
    }
    
    
  function transfer(address _to, uint256 _value) public override returns (bool success) {
      require(_to != address(0));
      require(balanceOf[msg.sender] >= _value);
      require(balanceOf[ _to] + _value >= balanceOf[ _to]);
      
      
      balanceOf[msg.sender] -= _value;
      balanceOf[_to] += _value;
      
      emit Transfer(msg.sender, _to, _value);
      
      return true;
  }
  
  
  function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
      require(_to != address(0));
      require(allowed[_from][msg.sender] >= _value);
      require(balanceOf[_from] >= _value);
      require(balanceOf[ _to] + _value >= balanceOf[ _to]);
      
      balanceOf[_from] -= _value;
      balanceOf[_to] += _value;
      
      allowed[_from][msg.sender] -= _value;
      
      emit Transfer(msg.sender, _to, _value);
      return true;
  }
  
  function approve(address _spender, uint256 _value) public override returns (bool success) {
      allowed[msg.sender][_spender] = _value;
      
      emit Approval(msg.sender, _spender, _value);
      return true;
  }
  
  function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
      return allowed[_owner][_spender];
  }

}

interface Token {
    function mining(address target, uint amount) external returns (bool success);
}

contract SimpleStorage {
    mapping(uint => string) public contentHash;
    mapping(uint => string) public title;
    mapping(uint => string) public keywords;
    uint public id = 0;
    event SetContent(string t);
    
    Token t = Token(0xB248dEbE95196cED760809159a8B5c49F5c90c64);

    function set(string memory _content, string memory _title, string memory _keywords) public {       
        id += 1;
        contentHash[id] = _content;
        title[id] = _title;
        keywords[id] = _keywords;
        emit SetContent(_content);
        t.mining(msg.sender, 120);
    }

    function get(uint uid) public view returns (string memory, string memory, string memory) {
        return (contentHash[uid], title[id], keywords[id]);
    }

}