import { Clarinet, Tx, Chain, Account, types, Contract } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';


Clarinet.test({
  name: "Ensure that the right amount of stacks (NFT price) is transferred)",
  async fn(chain: Chain, accounts: Map<string, Account>, contracts: Map<string, Contract>) {
    let deployer = accounts.get("deployer")!;
    let wallet_1 = accounts.get("wallet_1")!;
    let block = chain.mineBlock([
      Tx.contractCall("nft-simple", "mint", [], wallet_1.address)
    ]);

    block.receipts[0].result.expectOk().expectBool(true);

    console.log(block.receipts[0].result.expectOk().expectBool(true));
    block.receipts[0].events.expectSTXTransferEvent(
      10000000,
      wallet_1.address,
      deployer.address

    )
  }
})
// Clarinet.test()

Clarinet.test({
  name: "Ensure that the right NFT is minted to the right address",
  async fn(chain: Chain, accounts: Map<string, Account>, contracts: Map<string, Contract>) {
    let deployer = accounts.get("deployer")!;
    let wallet_1 = accounts.get("wallet_1")!;
    let block = chain.mineBlock([
      Tx.contractCall("nft-simple", "mint", [], wallet_1.address)
    ]);

    block.receipts[0].result.expectOk().expectBool(true);

    console.log(block.receipts[0].result.expectOk().expectBool(true));
    block.receipts[0].events.expectNonFungibleTokenMintEvent(
      types.uint(1),
      wallet_1.address,
      `${deployer.address}.nft-simple`,
      "simple-nft"

    )
  }
})


