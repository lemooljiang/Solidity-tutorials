pragma solidity >=0.4.24 <0.7.0;

contract AccessControl {
    address owner;  //界主
    address[] superadmins; //太上
    address[] admins;     //长老
    
    constructor() public {
        owner = msg.sender;
    }
    
    
    //判断是不是太上
    function inSuperAdmins(address a) 
        public 
        view 
        returns(bool)
    {
        for(uint i = 0; i < superadmins.length; i ++){
            if(superadmins[i] == a){
                return true;
            }
        }
        return false;
    }
    
    //判断是不是长老
    function inAdmins(address a) 
        public 
        view 
        returns(bool)
    {
        for(uint i = 0; i < admins.length; i ++){
            if(admins[i] == a){
                return true;
            }
        }
        return false;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function addSuperAdmin(address a) 
        public 
        onlyOwner
    {
        require(!inSuperAdmins(a));
        superadmins.push(a);
    }
    
    function addAdmin(address a) 
        public 
    {
        require(msg.sender == owner || inSuperAdmins(msg.sender));
        require(!inAdmins(a));
        admins.push(a);
    }
    
    function delSuperAdmin(address a)
        public
        onlyOwner
    {
        require(inSuperAdmins(a));
        for(uint i = 0; i < superadmins.length; i ++ )
        {
            if(superadmins[i] == a)
            {
                superadmins[i] = address(0);
            }
        }
    }
    
    function delAdmins(address a)
        public
    {
        require(msg.sender == owner || inSuperAdmins(msg.sender));
        require(inAdmins(a));
        for(uint i = 0; i < admins.length; i ++ )
        {
            if(admins[i] == a)
            {
                admins[i] = address(0);
            }
        }
    }
 
    function getAdmins()
        public
        view
        returns(address[] memory, address[] memory)
    {
        return (superadmins, admins);
    }
    
}