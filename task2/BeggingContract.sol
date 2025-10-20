// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;


/* 
捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。
*/
contract BeggingContract {

  address public _owner;

  // 捐款记录
  mapping (address => uint256) public contributions;

  // 捐赠排行榜，前N名
  address[3] public topDonors;
  uint256[3] public topDonations;

  // 部署时间
  uint256 deploymentTimestamp;

  // 锁定期
  uint256 lockTime;

  // 捐款事件记录
  event LogDonate(address indexed contributor, uint256 amount);
  event LogWithdraw(address indexed contributor, uint256 amount);

  // 自定义error
  error ErrWithdraw(address owner, uint256 amount);

  constructor(uint256 _lockTime) {
    _owner = msg.sender;
    deploymentTimestamp = block.timestamp; // 秒
    lockTime = _lockTime;
  }

  // 自定义error
  error ErrOnlyOwner(address owner, address callUser);

  modifier onlyOwner {
    require(msg.sender == _owner, "Only owner can call this function");
    _;
  } 

  // 超时修饰器
  modifier checkOutTime {
    // 检查是否在锁定期内
    require(block.timestamp <= deploymentTimestamp + lockTime, "Lock period not expired");
    _;
  }


  // 捐款函数
  function donate() public payable onlyOwner checkOutTime returns (uint256) {
    uint256 donation = msg.value;
    require(donation > 0, "Donation amount must be greater than 0");
    contributions[getSender()] += donation;
    // 更新排行榜
    updateTop(getSender(), donation);
    emit LogDonate(getSender(), donation);
    return contributions[getSender()];
  }

  // 捐赠排行榜，前3名，并排序
  function updateTop(address _addr, uint256 _amount) internal returns (bool) {

    bool updated = false;
    
    for (uint256 i = 0; i < topDonors.length; i++) {
        if (_amount > topDonations[i]) {
            // 执行插入和移位
            (_addr, topDonors[i]) = (topDonors[i], _addr);
            (_amount, topDonations[i]) = (topDonations[i], _amount);
            updated = true;
        }
    }
    
    return updated;
  }


  // 提取函数，全部提取
  function withdraw() public onlyOwner returns (uint256) {
    uint256 amount = contributions[getSender()];
    require(amount > 0, "No contributions");
    contributions[getSender()] = 0;
    // payable(getSender()).transfer(amount);
    (bool success, ) = payable(_owner).call{value: amount}("");
    if(!success) {
      revert ErrWithdraw(_owner, amount);
    }
    emit LogWithdraw(getSender(), amount);
    return amount;
  }

  // 获取捐款者地址
  function getSender() public view returns (address) {
    return msg.sender;
  }

  // 获取捐款者捐款金额
  function getDonation(address _addr) public view returns (uint256) {
    return contributions[_addr];
  }

  function getAllDonations() public view returns (address[3] memory , uint256[3] memory) {
    return (topDonors, topDonations);
  }

}