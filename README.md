# STX Investment Pool

A decentralized investment pool smart contract built on the Stacks blockchain that enables multiple investors to collectively manage STX funds and distribute profits proportionally.

## Overview

The STX Investment Pool is a Clarity smart contract that facilitates:
- **Collective Fund Management**: Multiple investors can deposit STX into a shared pool
- **Admin Controls**: Pool administrators can manage pool status and operations
- **Transparent Tracking**: Real-time visibility into pool balances and individual investments
- **Secure Withdrawals**: Investors can safely withdraw their funds with balance verification
- **Profit Distribution**: Framework for distributing profits proportionally among investors

## Features

### Admin Functions
- **`close-pool`**: Prevent new investors from joining the pool
- **`open-pool`**: Reopen the pool for new investments
- **`transfer-admin`**: Transfer admin rights to a new principal
- **`distribute-profit`**: Initiate profit distribution to investors

### Investor Functions
- **`invest`**: Deposit STX into the investment pool
- **`withdraw`**: Withdraw your investment with balance checks

### Read-Only Functions
- **`get-admin`**: Retrieve current pool administrator
- **`get-pool-balance`**: Get total STX balance in the pool
- **`get-total-invested`**: Get total amount invested by all investors
- **`get-investor`**: Retrieve specific investor's investment amount
- **`is-pool-open`**: Check if pool is open for new investments

## Error Codes

| Code | Error | Description |
|------|-------|-------------|
| u100 | ERR-NOT-ADMIN | Only admin can perform this action |
| u101 | ERR-NO-INVESTMENT | No investment found for caller |
| u102 | ERR-INSUFFICIENT-FUNDS | Withdrawal amount exceeds balance |
| u103 | ERR-ALREADY-INVESTOR | Address already has an investment |
| u104 | ERR-NOT-INVESTOR | Address is not an investor |
| u105 | ERR-ZERO-INVESTMENT | Investment amount cannot be zero |
| u106 | ERR-INVALID-TRANSFER | Invalid admin transfer attempt |
| u200 | ERR-NO-TOTAL-INVESTED | Pool has no invested funds |
| u201 | ERR-POOL-CLOSED | Investment pool is currently closed |

## Usage

### Deploy the Contract
```bash
stx deploy stx-invest-pool ./contracts/stx-invest-pool.clar
```

### Example: Invest in the Pool
```clarity
(contract-call? .stx-invest-pool invest u1000000)
```

### Example: Withdraw Investment
```clarity
(contract-call? .stx-invest-pool withdraw u500000)
```

### Example: Check Pool Balance
```clarity
(contract-call? .stx-invest-pool get-pool-balance)
```

## Contract Structure

```
stx-invest-pool/
├── contracts/
│   └── stx-invest-pool.clar    # Main contract
├── README.md                    # This file
└── .gitattributes              # Git configuration
```

## State Variables

- **`admin`** (principal): Current pool administrator address
- **`total-invested`** (uint): Total STX amount invested by all investors
- **`pool-open`** (bool): Flag indicating if pool accepts new investments
- **`investors`** (map): Mapping of investor addresses to their investment amounts

## Security Considerations

 **Important Notes**:
- Only the admin can manage pool operations
- Investors can only withdraw amounts they have invested
- Pool must remain solvent (sufficient STX balance for withdrawals)
- Admin transfer includes validation to prevent self-transfer

## Testing

To test the contract locally:

```bash
npm install
npm run test
```

## Development

### Prerequisites
- Node.js >= 16
- Clarity CLI
- Stacks testnet setup

### Building
```bash
clarify build
```

### Validation
```bash
clarify validate contracts/stx-invest-pool.clar
```

## Author

**Muhammad Miftahu**

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Roadmap

- [ ] Automated profit distribution algorithm
- [ ] Multi-signature admin control
- [ ] Time-locked withdrawal restrictions
- [ ] Fee management system
- [ ] Dividend yield calculations
- [ ] Integration with DeFi protocols

## Support

For issues and questions, please open an issue on GitHub.

## Disclaimer

This smart contract is provided as-is. Users should conduct thorough testing and security audits before deploying to mainnet. The author assumes no liability for any losses or damages resulting from contract usage.
