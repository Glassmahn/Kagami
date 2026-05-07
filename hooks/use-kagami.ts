'use client'

import { useState, useEffect } from 'react'
import { useReadContract, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { kagamiCoreAbi } from '@/lib/abis'
import { KAGAMI_CORE_ADDRESS } from '@/lib/constants'
import { useKagami } from './kagami-provider'

export function useKagami() {
  const [isLaunching, setIsLaunching] = useState(false)
  const { refetch } = useKagami()
  
  const { data: hash, writeContract } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash })
  
  const { data: totalReflections, refetch: refetchTotal } = useReadContract({
    address: KAGAMI_CORE_ADDRESS,
    abi: kagamiCoreAbi,
    functionName: 'totalReflections',
  })
  
  const launchReflection = (idea: string, types: string[]) => {
    setIsLaunching(true)
    const metadata = JSON.stringify({
      idea,
      types,
      timestamp: Date.now()
    })
    
    writeContract({
      address: KAGAMI_CORE_ADDRESS,
      abi: kagamiCoreAbi,
      functionName: 'createReflection',
      args: [metadata],
    })
  }
  
  useEffect(() => {
    if (isSuccess) {
      setIsLaunching(false)
      refetch()
      refetchTotal()
    }
  }, [isSuccess, refetch, refetchTotal])
  
  return {
    totalReflections: totalReflections ? Number(totalReflections) : 0,
    launchReflection,
    isLaunching,
    isConfirming,
    isSuccess,
  }
}
