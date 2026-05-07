'use client'

import { createContext, useContext, useEffect, useState } from 'react'
import { useReadContract } from 'wagmi'
import { kagamiCoreAbi } from '@/lib/abis'
import { KAGAMI_CORE_ADDRESS } from '@/lib/constants'

interface KagamiContextType {
  totalReflections: number
  isLoading: boolean
}

const KagamiContext = createContext<KagamiContextType>({
  totalReflections: 0,
  isLoading: true,
})

export function useKagami() {
  return useContext(KagamiContext)
}

export function KagamiProvider({ children }: { children: React.ReactNode }) {
  const [totalReflections, setTotalReflections] = useState(0)
  
  const { data, isLoading } = useReadContract({
    address: KAGAMI_CORE_ADDRESS,
    abi: kagamiCoreAbi,
    functionName: 'totalReflections',
  })
  
  useEffect(() => {
    if (data) {
      setTotalReflections(Number(data))
    }
  }, [data])
  
  return (
    <KagamiContext.Provider value={{ totalReflections, isLoading }}>
      {children}
    </KagamiContext.Provider>
  )
}
