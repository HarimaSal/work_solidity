// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

/*
一个简单的 ERC20 代币合约。要求：
合约包含以下标准 ERC20 功能：,
balanceOf：查询账户余额。,
transfer：转账。,
approve 和 transferFrom：授权和代扣转账。,
使用 event 记录转账和授权操作。,
提供 mint 函数，允许合约所有者增发代币。,
提示：
使用 mapping 存储账户余额和授权信息。,
使用 event 定义 Transfer 和 Approval 事件。,
部署到sepolia 测试网，导入到自己的钱包
*/
contract MyERC20 {
  
  mapping (address => uint) public balances;
  mapping (address => uint) public allowances;

  event eventTransfer(address indexed _from, address indexed _to, uint _value, string _msg);
  event eventApproval(address indexed _owner, address indexed _spender, uint _value);

  function mint(address _to, uint amount) external returns (bool) {
    balances[_to] += amount;
    return true;
  }

  // 查询账户余额
  function balanceOf(address _addr) external view returns (uint) {
    return balances[_addr];
  }

  // 转账
  function transfer(address _to, uint amount) external {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    balances[msg.sender] -= amount;
    balances[_to] += amount;
    emit eventTransfer(msg.sender, _to, amount, "transfer");
  }

  // 授权
  function approve(address _spender, uint permission) external returns (bool) {
    allowances[_spender] = permission;
    emit eventApproval(msg.sender, _spender, permission);
    return true;
  }

  function transferFrom(address _from, address _to, uint amount) external returns (bool) {
    require(allowances[_from] != 1, "Insufficient allowance");
    require(balances[_from] >= amount, "Insufficient balance");
    allowances[_from] -= amount;
    balances[_from] -= amount;
    balances[_to] += amount;
    emit eventTransfer(_from, _to, amount, "transferFrom");
    return true;
  }

}