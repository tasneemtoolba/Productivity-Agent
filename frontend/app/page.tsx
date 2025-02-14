"use client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAccount } from "wagmi";
import {
  ConnectWallet,
  Wallet,
  WalletDropdown,
  WalletDropdownLink,
  WalletDropdownDisconnect,
} from "@coinbase/onchainkit/wallet";
import {
  Address,
  Avatar,
  Name,
  Identity,
  EthBalance,
} from "@coinbase/onchainkit/identity";
import {
  Transaction,
  TransactionButton,
  TransactionSponsor,
  TransactionStatus,
  TransactionStatusAction,
  TransactionStatusLabel,
} from "@coinbase/onchainkit/transaction";
import type { LifecycleStatus } from "@coinbase/onchainkit/transaction";
import { calls } from "./calls";
import { userSchema } from "./schemas/user.schema";
import { z } from "zod";
import { border, cn, pressable, text } from "@coinbase/onchainkit/theme";
import Image from "next/image";

export default function App() {
  const telegramInputRef = useRef<HTMLInputElement>(null);

  const { address, status: addressStatus } = useAccount();

  const [providedLiquidity, setProvidedLiquidity] = useState<boolean>();

  const [telegram, setTelegram] = useState<string | null>();
  const [telegramLoading, setTelegramLoading] = useState(false);
  const [telegramErrorMessage, setTelegramErrorMessage] = useState<string>();

  async function checkTelegramStatus() {
    try {
      await fetch(`/api/user?address=${address}`)
        .then((res) => {
          if (!res.ok)
            throw new Error(
              `GET /api/user?address=${address} responded with status ${res.status}`,
            );

          console.log("res.status", res.status);

          return res.json();
        })
        .then(
          (json: {
            status: "success" | "unknown";
            user: z.infer<typeof userSchema>;
          }) => {
            console.log("json", json);
            if (json.status === "success") {
              setTelegram(json.user.telegram);
            } else {
              setTelegram(null);
            }
          },
        );
    } catch (e) {
      setTelegram(undefined);
      setTelegramLoading(false);
    }
  }

  async function getProvidedLiquidity() {
    setProvidedLiquidity(false);
  }

  async function handleSubmitTelegram() {
    const _telegram = telegramInputRef.current?.value;

    console.log("_telegram", _telegram);

    // TODO verify address and telegram

    await fetch("/api/user", {
      method: "POST",
      body: JSON.stringify({
        address,
        telegram: _telegram,
      }),
    }).then((res) => {
      if (!res.ok) {
        setTelegramErrorMessage("Unexpected error, try again later");
        return;
      }

      setTelegramErrorMessage(undefined);
      setTelegram(_telegram);
    });
  }

  useEffect(() => {
    console.log("telegram", telegram);
  }, [telegram]);

  useEffect(() => {
    if (
      addressStatus !== "connected" ||
      telegram !== undefined ||
      telegramLoading === true
    ) {
      return;
    }

    setTelegramLoading(true);
    checkTelegramStatus();
    getProvidedLiquidity();
  }, [address, addressStatus]);

  // TODO check approval

  const handleOnStatus = useCallback((status: LifecycleStatus) => {
    console.log("LifecycleStatus", status);
  }, []);

  return (
    <div className="flex flex-col min-h-screen font-sans dark:bg-background dark:text-white bg-white text-black">
      <header className="pt-4 pr-4">
        <div className="flex justify-end">
          <div className="wallet-container">
            <Wallet>
              <ConnectWallet>
                <Avatar className="h-6 w-6" />
                <Name />
                <EthBalance />
              </ConnectWallet>

              <WalletDropdown>
                <Identity className="px-4 pt-3 pb-2" hasCopyAddressOnClick>
                  <Avatar />
                  <Name />
                  <Address />
                  <EthBalance />
                </Identity>
                <WalletDropdownLink
                  icon="wallet"
                  href="https://keys.coinbase.com"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Wallet
                </WalletDropdownLink>
                <WalletDropdownDisconnect />
              </WalletDropdown>
            </Wallet>
          </div>
        </div>
      </header>

      <main className="flex-grow flex items-center justify-center">
        <div className="max-w-3xl w-full p-4">
          <Image
            src="/productivity_logo.png"
            alt="Productivity God logo"
            width={512}
            height={405}
            style={{
              marginLeft: "auto",
              marginRight: "auto",
            }}
          />
          {addressStatus !== "connected" ? (
            <div
              style={{
                display: "flex",
                justifyContent: "center",
                marginBottom: "18px",
              }}
            >
              <ConnectWallet>
                <Avatar className="h-6 w-6" />
                <Name />
                <EthBalance />
              </ConnectWallet>
            </div>
          ) : telegram === null ? (
            <>
              <h1 style={{ fontSize: "1.25rem", margin: "1.5rem 0 .75rem 0" }}>
                {"Please setup your telegram"}
              </h1>
              <div
                style={{
                  display: "flex",
                  gap: 12,
                  marginBottom: "18px",
                }}
              >
                <div style={{ width: "100%", position: "relative" }}>
                  <input
                    type="text"
                    placeholder="Telegram handle"
                    ref={telegramInputRef}
                    style={{
                      width: "100%",
                      backgroundColor: "black",
                      border: "1px solid white",
                      padding: ".75rem",
                      borderRadius: "var(--ock-border-radius)",
                    }}
                  />
                  {telegramErrorMessage && (
                    <span
                      style={{
                        position: "absolute",
                        top: "calc(100% + 4px)",
                        left: 0,
                        color: "#f88181",
                        fontSize: "80%",
                        paddingLeft: ".75rem",
                      }}
                    >
                      {telegramErrorMessage}
                    </span>
                  )}
                </div>
                <button
                  onClick={handleSubmitTelegram}
                  className={
                    // same as for TransactionButton
                    cn(
                      pressable.primary,
                      border.radius,
                      "w-full rounded-xl",
                      "px-4 py-3 font-medium text-base text-white leading-6",
                      false,
                      text.headline,
                    )
                  }
                  style={{
                    color: "var(--ock-text-inverse)",
                  }}
                >
                  Confirm Telegram Handle
                </button>
              </div>
            </>
          ) : (
            !!telegram &&
            providedLiquidity === false && (
              <>
                <h1
                  style={{ fontSize: "1.25rem", margin: "1.5rem 0 .75rem 0" }}
                >
                  {"Supply liquidity and get productive 😉"}
                </h1>
                <div
                  style={{
                    marginBottom: "18px",
                  }}
                >
                  <Transaction
                    chainId={8453}
                    calls={calls}
                    onStatus={handleOnStatus}
                  >
                    <TransactionButton text={`Supply 0.01 USDC`} />
                    <TransactionSponsor />
                    <TransactionStatus>
                      <TransactionStatusLabel />
                      <TransactionStatusAction />
                    </TransactionStatus>
                  </Transaction>
                </div>
              </>
            )
          )}
          <div
            style={{
              display: "flex",
              justifyContent: "center",
              textDecoration: "underline",
            }}
          >
            <a
              href="https://t.me/ProductivityGodBot"
              target="_blank"
              rel="noreferrer"
            >
              Go and chat on Telegram
            </a>
          </div>
        </div>
      </main>
    </div>
  );
}
