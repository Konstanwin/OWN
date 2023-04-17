// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract OWNToken is IERC20 {
    string public constant name = "OWN Token";
    string public constant symbol = "OWN";
    uint8 public constant decimals = 18;
    uint256 private constant _totalSupply = 10 * 10**9 * 10**decimals; // 10 billion total supply
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    
    constructor() {
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    
    function totalSupply() public pure override returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: insufficient balance");
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }
    
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

contract OwnFoundation {
    IERC20 public OWN;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;
    uint256 public constant maxSupply = 10 * 10**9 * 10**18; // maximum supply of OWN tokens
    uint256 public constant reserveRatio = 90; // 90% of OWN tokens reserved for OWN Foundation
    uint256 public constant minContribution = 1000 * 10*18; // minimum contribution to the foundation is 1000 OWN tokens
    uint256 public constant maxContribution = 1000000 * 1018; // maximum contribution to the foundation is 1 million OWN tokens
    uint256 public totalContributions; // total amount of contributions to the foundation
    uint256 public totalRewards; // total amount of OWN tokens rewarded to participants

    event Contribution(address indexed contributor, uint256 amount);
    event Reward(address indexed recipient, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(address ownToken) {
        OWN = IERC20(ownToken);
    }

    function contribute(uint256 amount) public {
       require(amount >= minContribution, "OWN Foundation: contribution amount too low");
       require(amount <= maxContribution, "OWN Foundation: contribution amount too high");
       require(OWN.transferFrom(msg.sender, address(this), amount), "OWN Foundation: transfer failed");
       balances[msg.sender] += amount;
       totalContributions += amount;
       emit Contribution(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
       require(amount > 0, "OWN Foundation: amount must be greater than zero");
       require(balances[msg.sender] >= amount, "OWN Foundation: insufficient balance");
       require(OWN.transfer(msg.sender, amount), "OWN Foundation: transfer failed");
       balances[msg.sender] -= amount;
       totalContributions -= amount;
    }

    function distributeRewards() public {
       uint256 availableBalance = OWN.balanceOf(address(this)) - totalContributions;
       uint256 rewardAmount = (availableBalance * reserveRatio) / 100;
       require(rewardAmount > 0, "OWN Foundation: no rewards available");
       require(OWN.transfer(address(this), rewardAmount), "OWN Foundation: transfer failed");
       totalRewards += rewardAmount;
       emit Reward(address(this), rewardAmount);
    }

    function getReward() public {
       uint256 rewardAmount = balances[msg.sender] * totalRewards / totalContributions;
       require(rewardAmount > 0, "OWN Foundation: no rewards available");
       require(OWN.transfer(msg.sender, rewardAmount), "OWN Foundation: transfer failed");
       balances[msg.sender] = 0;
       emit Reward(msg.sender, rewardAmount);
    }
}