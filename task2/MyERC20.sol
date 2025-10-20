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
  
  // 代币元数据
    string public constant name = "SimpleToken";      // 代币名称
    string public constant symbol = "STK";           // 代币符号
    uint8 public constant decimals = 18;             // 小数位数（主流为18）

    // 账户余额映射（地址 => 余额）
    mapping(address => uint256) public balanceOf;
    
    // 授权额度映射（owner地址 => spender地址 => 授权额度）
    mapping(address => mapping(address => uint256)) public allowance;
    
    // 代币总供应量
    uint256 public totalSupply;
    
    // 合约所有者地址（用于增发权限控制）
    address public owner;

    // 转账事件（记录代币转移）
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    // 授权事件（记录授权操作）
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev 构造函数：初始化代币，分配初始供应量给合约部署者
     * @param initialSupply 初始供应量（无小数位，如1000表示1000 STK）
     */
    constructor(uint256 initialSupply) {
        owner = msg.sender;                              // 设置部署者为合约所有者
        totalSupply = initialSupply * 10 ** decimals;    // 计算带小数的总供应量（如1000 * 10^18）
        balanceOf[msg.sender] = totalSupply;             // 将初始供应量分配给部署者
        emit Transfer(address(0), msg.sender, totalSupply); // 触发Transfer事件（从0地址到部署者）
    }

    /**
     * @dev 转账函数：从调用者地址向目标地址转移代币
     * @param to 目标地址
     * @param amount 转移金额
     * @return bool 操作是否成功
     */
    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "ERC20: transfer to zero address"); // 禁止向0地址转账
        require(balanceOf[msg.sender] >= amount, "ERC20: insufficient balance"); // 检查余额是否充足
        
        balanceOf[msg.sender] -= amount; // 扣除调用者余额
        balanceOf[to] += amount;         // 增加目标地址余额
        emit Transfer(msg.sender, to, amount); // 触发Transfer事件
        return true;
    }

    /**
     * @dev 授权函数：允许spender地址从调用者地址转移指定数量的代币
     * @param spender 被授权的地址（如去中心化交易所合约）
     * @param amount 授权额度
     * @return bool 操作是否成功
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "ERC20: approve to zero address"); // 禁止授权给0地址
        allowance[msg.sender][spender] = amount; // 记录授权额度
        emit Approval(msg.sender, spender, amount); // 触发Approval事件
        return true;
    }

    /**
     * @dev 代扣转账函数：从from地址向to地址转移amount代币（需from地址授权spender）
     * @param from 转出地址
     * @param to 转入地址
     * @param amount 转移金额
     * @return bool 操作是否成功
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(from != address(0), "ERC20: transfer from zero address"); // 禁止从0地址转出
        require(to != address(0), "ERC20: transfer to zero address");     // 禁止向0地址转账
        require(balanceOf[from] >= amount, "ERC20: insufficient balance"); // 检查转出地址余额
        require(allowance[from][msg.sender] >= amount, "ERC20: insufficient allowance"); // 检查授权额度
        
        allowance[from][msg.sender] -= amount; // 扣除spender的剩余授权额度
        balanceOf[from] -= amount;             // 扣除转出地址余额
        balanceOf[to] += amount;               // 增加转入地址余额
        emit Transfer(from, to, amount);       // 触发Transfer事件
        return true;
    }

    /**
     * @dev 增发函数：合约所有者调用，增加代币总供应量并分配给指定地址
     * @param to 增发目标地址
     * @param amount 增发金额（无小数位）
     */
    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "ERC20: only owner can mint"); // 仅所有者可调用
        totalSupply += amount * 10 ** decimals; // 计算带小数的增发量并更新总供应量
        balanceOf[to] += amount * 10 ** decimals; // 增加目标地址余额
        emit Transfer(address(0), to, amount * 10 ** decimals); // 触发Transfer事件（从0地址到目标地址）
    }

}