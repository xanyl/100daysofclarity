import { Clarinet, Chain, Account } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';

import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const address1 = accounts.get("wallet_1")!;

/*
  The test below is an example. To learn more, read the testing documentation here:
  https://docs.hiro.so/stacks/clarinet-js-sdk
*/

describe("example tests", () => {
  it("ensures simnet is well initalised", () => {
    expect(simnet.blockHeight).toBeDefined();
  });

  // it("shows an example", () => {
  //   const { result } = simnet.callReadOnlyFn("counter", "get-counter", [], address1);
  //   expect(result).toBeUint(0);
  // });
});
Clarinet.test({
  name: "Get non-existent offspring-wallet, return none",
  async fn(chain: Chain, accounts: Map<string, Account>){
    let deploy = accounts.get("deployer")!;
    let wallet_1 = accounts.get("wallet_1")!;

    //All function to test
    let readResult = chain.callReadOnlyFn("offspring-will", "get-offspring-wallet", [types.principal(wallet_1.address)],deploy.address);
    readResult.result.expectNone();
  }
});