import { useAccount, useConnect, useDisconnect } from "wagmi";
import { coinbaseWallet } from "wagmi/connectors";

export function useBaseWallet() {
  const { address, isConnected } = useAccount();
  const { connect } = useConnect({
    connector: coinbaseWallet({ 
      appName: "KAGAMI",
      preference: "smartWalletOnly"
    }),
  });
  const { disconnect } = useDisconnect();

  return {
    address,
    isConnected,
    connect,
    disconnect,
  };
}
