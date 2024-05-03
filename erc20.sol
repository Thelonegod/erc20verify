pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT
abstract contract ERC20Interface {
    function totalSupply() public view virtual returns (uint);
    function balanceOf(address tokenOwner) public view virtual returns (uint balance);
    function allowance(address tokenOwner, address spender) public view virtual returns (uint remaining);
    function transfer(address to, uint tokens) public virtual returns (bool success);
    function approve(address spender, uint tokens) public virtual returns (bool success);
    function transferFrom(address from, address to, uint tokens) public virtual returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

library SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a, "SafeMath: addition overflow");
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a, "SafeMath: subtraction overflow");
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b, "SafeMath: multiplication overflow");
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0, "SafeMath: division by zero");
        c = a / b;
    }
}

contract Elzhan is ERC20Interface {
    using SafeMath for uint256;

    string public name = "Elzhan"; 
    string public symbol = "ELZH"; 
    uint8 public decimals = 8; 

    uint256 private _totalSupply;
    address private _owner;

    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowances;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        _owner = msg.sender;
        _totalSupply = 100000000000000000000000000; 
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint balance) {
        return _balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public view override returns (uint remaining) {
        return _allowances[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public override returns (bool success) {
        _allowances[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transfer(address to, uint tokens) public override returns (bool success) {
        _transfer(msg.sender, to, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
        _transfer(from, to, tokens);
        _allowances[from][msg.sender] = _allowances[from][msg.sender].safeSub(tokens);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
        
        _balances[sender] = _balances[sender].safeSub(amount);
        _balances[recipient] = _balances[recipient].safeAdd(amount);
        emit Transfer(sender, recipient, amount);
    }
}
