# Blockchain Integration Guide

## Overview

This guide provides comprehensive instructions for integrating blockchain functionality into the REChain DAO platform, including smart contracts, wallet connections, and token operations.

## Table of Contents

1. [Blockchain Architecture](#blockchain-architecture)
2. [Smart Contract Development](#smart-contract-development)
3. [Wallet Integration](#wallet-integration)
4. [Token Operations](#token-operations)
5. [DeFi Integration](#defi-integration)
6. [Security Considerations](#security-considerations)

## Blockchain Architecture

### Supported Networks
- **Ethereum Mainnet**: Primary network for production
- **Polygon**: Layer 2 scaling solution
- **Binance Smart Chain**: Alternative network
- **Testnets**: Goerli, Mumbai, BSC Testnet

### Smart Contract Structure
```solidity
// contracts/REChainDAO.sol
pragma solidity ^0.8.0;

contract REChainDAO {
    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 deadline;
        bool executed;
    }
    
    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public balances;
    uint256 public proposalCount;
    
    event ProposalCreated(uint256 indexed proposalId, string title);
    event VoteCast(address indexed voter, uint256 indexed proposalId, bool support);
    
    function createProposal(string memory _title, string memory _description) external {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            title: _title,
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            deadline: block.timestamp + 7 days,
            executed: false
        });
        
        emit ProposalCreated(proposalCount, _title);
    }
    
    function vote(uint256 _proposalId, bool _support) external {
        require(block.timestamp <= proposals[_proposalId].deadline, "Voting period ended");
        
        if (_support) {
            proposals[_proposalId].votesFor++;
        } else {
            proposals[_proposalId].votesAgainst++;
        }
        
        emit VoteCast(msg.sender, _proposalId, _support);
    }
}
```

## Smart Contract Development

### Development Environment
```bash
# Install Hardhat
npm install --save-dev hardhat

# Initialize project
npx hardhat init

# Install dependencies
npm install @openzeppelin/contracts
npm install @nomiclabs/hardhat-ethers ethers
```

### Hardhat Configuration
```javascript
// hardhat.config.js
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.0",
  networks: {
    hardhat: {
      chainId: 1337
    },
    goerli: {
      url: process.env.GOERLI_URL,
      accounts: [process.env.PRIVATE_KEY]
    },
    polygon: {
      url: process.env.POLYGON_URL,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
```

### Contract Deployment
```javascript
// scripts/deploy.js
const hre = require("hardhat");

async function main() {
  const REChainDAO = await hre.ethers.getContractFactory("REChainDAO");
  const rechainDAO = await REChainDAO.deploy();
  
  await rechainDAO.deployed();
  
  console.log("REChainDAO deployed to:", rechainDAO.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

## Wallet Integration

### Web3 Provider Setup
```javascript
// src/services/Web3Service.js
import Web3 from 'web3';

class Web3Service {
  constructor() {
    this.web3 = null;
    this.account = null;
  }

  async connectWallet() {
    if (typeof window.ethereum !== 'undefined') {
      this.web3 = new Web3(window.ethereum);
      
      try {
        const accounts = await window.ethereum.request({
          method: 'eth_requestAccounts'
        });
        
        this.account = accounts[0];
        return this.account;
      } catch (error) {
        console.error('Error connecting wallet:', error);
        throw error;
      }
    } else {
      throw new Error('MetaMask not found');
    }
  }

  async getBalance(address) {
    const balance = await this.web3.eth.getBalance(address);
    return this.web3.utils.fromWei(balance, 'ether');
  }

  async sendTransaction(to, value) {
    const accounts = await this.web3.eth.getAccounts();
    
    const transaction = {
      from: accounts[0],
      to: to,
      value: this.web3.utils.toWei(value, 'ether')
    };

    return await this.web3.eth.sendTransaction(transaction);
  }
}

export default new Web3Service();
```

### WalletConnect Integration
```javascript
// src/services/WalletConnectService.js
import WalletConnect from '@walletconnect/client';
import QRCodeModal from '@walletconnect/qrcode-modal';

class WalletConnectService {
  constructor() {
    this.connector = null;
  }

  async connect() {
    this.connector = new WalletConnect({
      bridge: 'https://bridge.walletconnect.org',
      qrcodeModal: QRCodeModal
    });

    if (!this.connector.connected) {
      await this.connector.createSession();
    }

    return this.connector;
  }

  async sendTransaction(transaction) {
    if (!this.connector) {
      throw new Error('Wallet not connected');
    }

    return await this.connector.sendTransaction(transaction);
  }
}

export default new WalletConnectService();
```

## Token Operations

### ERC-20 Token Contract
```solidity
// contracts/REChainToken.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract REChainToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1000000000 * 10**18;
    
    constructor() ERC20("REChain Token", "RCH") {
        _mint(msg.sender, MAX_SUPPLY);
    }
    
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }
}
```

### Token Operations Service
```javascript
// src/services/TokenService.js
import { ethers } from 'ethers';

class TokenService {
  constructor(contractAddress, abi) {
    this.contractAddress = contractAddress;
    this.abi = abi;
    this.contract = null;
  }

  async initialize(provider) {
    this.contract = new ethers.Contract(this.contractAddress, this.abi, provider);
  }

  async getBalance(address) {
    const balance = await this.contract.balanceOf(address);
    return ethers.utils.formatEther(balance);
  }

  async transfer(to, amount) {
    const signer = this.contract.signer;
    const tx = await this.contract.transfer(to, ethers.utils.parseEther(amount));
    return await tx.wait();
  }

  async approve(spender, amount) {
    const tx = await this.contract.approve(spender, ethers.utils.parseEther(amount));
    return await tx.wait();
  }
}

export default TokenService;
```

## DeFi Integration

### Uniswap Integration
```javascript
// src/services/DeFiService.js
import { ethers } from 'ethers';

class DeFiService {
  constructor() {
    this.routerAddress = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D';
    this.routerABI = [
      'function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts)'
    ];
  }

  async swapETHForTokens(amountIn, amountOutMin, path, deadline) {
    const router = new ethers.Contract(this.routerAddress, this.routerABI, this.signer);
    
    const tx = await router.swapExactETHForTokens(
      amountOutMin,
      path,
      this.account,
      deadline,
      { value: ethers.utils.parseEther(amountIn) }
    );
    
    return await tx.wait();
  }
}

export default DeFiService;
```

## Security Considerations

### Smart Contract Security
```solidity
// Security best practices
contract SecureContract {
    // Use OpenZeppelin libraries
    using SafeMath for uint256;
    
    // Implement access controls
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    
    // Prevent reentrancy
    bool private locked;
    modifier noReentrancy() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }
    
    // Validate inputs
    function safeTransfer(address to, uint256 amount) external {
        require(to != address(0), "Invalid address");
        require(amount > 0, "Amount must be positive");
        // ... transfer logic
    }
}
```

### Frontend Security
```javascript
// Input validation
function validateAddress(address) {
    return ethers.utils.isAddress(address);
}

function validateAmount(amount) {
    const num = parseFloat(amount);
    return !isNaN(num) && num > 0;
}

// Transaction confirmation
async function confirmTransaction(tx) {
    const receipt = await tx.wait();
    if (receipt.status === 1) {
        console.log('Transaction successful');
    } else {
        console.log('Transaction failed');
    }
}
```

## Conclusion

This Blockchain Integration Guide provides the foundation for integrating blockchain functionality into the REChain DAO platform. Follow security best practices and test thoroughly on testnets before deploying to mainnet.
