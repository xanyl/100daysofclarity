import { Clarinet, Tx, Chain, Account, types,Contract } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';


Clarinet.test({
  name: "Ensure that the right amount of stacks (NFT price) is transferred)",
  async fn(chain: Chain, accounts: Map<string, Account>, contracts: Map<string, Contract>) {
    let deployer = accounts.get("deployer")!;
    let wallet_1 = accounts.get("wallet_1")!;
    
     
}
)

// Clarinet.test()