// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.30;

// 任务1
contract Voting {

  mapping (address => uint) public votes;

  function vote(address _candidater) public {
    votes[_candidater]++;
  }

  function getVotes() external view returns (uint) {
    return votes[msg.sender];
  }

  function resetVotes() external {
    votes[msg.sender] = 0;
  }

}


contract DataDeal {

    /* 反转字符串 */ 
    function reverseStr(string memory str) public pure returns (string memory) { 
        // 将字符串转换为 bytes 类型
        bytes memory strBytes = bytes(str);
        // 创建一个长度与字节数组相同的 bytes1[] 数组
        bytes memory chars = new bytes(strBytes.length);
        
        // 循环遍历字节数组，将每个字节存入字符数组
        for (uint i = 0; i < strBytes.length ; i++) {
            uint j = strBytes.length - 1- i;
            chars[i] = strBytes[j];
        }
        return string(chars);

    }


    /* 整数转罗马数字 */ 
    uint[] private values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
    string[] private symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
    function int2RomerStr(uint num) public view returns (string memory) {
        string memory resStr = "";
        for(uint i = 0; i < values.length; i++) {
            while (num >= values[i]) {
                num -= values[i];
                resStr = string.concat(resStr, symbols[i]);
            }
        }
        return resStr;
    }


    /* 罗马数字转整数 */
    // 根据罗马字符返回对应的整数值
    function getValue(bytes1 char) internal pure returns (uint256) {
        // 比较字节值
        if (char == 0x49) return 1; // 'I'
        if (char == 0x56) return 5; // 'V'
        if (char == 0x58) return 10; // 'X'
        if (char == 0x4C) return 50; // 'L'
        if (char == 0x43) return 100; // 'C'
        if (char == 0x44) return 500; // 'D'
        if (char == 0x4D) return 1000; // 'M'
        return 0; 
    }

    // 将罗马数字字符串转换为整数
    function romanToInt(string memory s) public pure returns (uint256) {
        // 将字符串转换为 bytes 以便逐个字符处理
        bytes memory romanBytes = bytes(s);
        uint256 length = romanBytes.length;
        uint256 total = 0;

        for (uint256 i = 0; i < length; i++) {
            uint256 currentValue = getValue(romanBytes[i]);

            // 如果还有下一个字符，并且当前值小于下一个字符的值，则减去当前值
            if (i + 1 < length) {
                uint256 nextValue = getValue(romanBytes[i + 1]);
                if (currentValue < nextValue) {
                    total -= currentValue;
                    continue;
                }
            }
            total += currentValue;
        }
        return total;
    }

    /* 合并两个有序数组：将两个有序数组合并为一个有序数组 */
    function mergeSortedArr(uint[] memory arr1, uint[] memory arr2) public pure returns(uint[] memory) {
        uint[] memory resArr = new uint[](arr1.length + arr2.length);
        for(uint i = 0; i < arr1.length; i++) {
            resArr[i] = arr1[i];
        }
        for(uint i = 0; i < arr2.length; i++) {
            resArr[arr1.length + i] = arr2[i];
        }
        for (uint i = 1; i < resArr.length; i++) {
            uint key = resArr[i];  
            uint j = i - 1; 
            while(j >= 0 && resArr[j] > key) {
                resArr[j + 1] = resArr[j]; // 大元素后移一位
                j--;
            }
            resArr[j + 1] = key; 
        }

        return resArr;
    }

    /* 二分查找：在一个有序数组中查找目标值 */
    function bSplitSearch(uint[] memory arr, uint  target) public pure returns (int ) {
        uint left = 0;
        uint right = arr.length - 1;
        int index = -1;
        while (left <= right) {
            uint mid = left + (right- left) / 2;
            if(arr[mid] == target) {
                return int(mid);
            } else if (arr[mid] > target) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return index;
    }
}