'use client'

import { useRef, useMemo, useEffect, useState } from 'react'
import { Canvas, useFrame, useThree } from '@react-three/fiber'
import { Environment, MeshReflectorMaterial, useTexture } from '@react-three/drei'
import * as THREE from 'three'

// Recursive mirror portal rings
function MirrorPortal({ depth = 0, maxDepth = 12 }: { depth?: number; maxDepth?: number }) {
  const groupRef = useRef<THREE.Group>(null)
  const ringRef = useRef<THREE.Mesh>(null)
  
  const scale = Math.pow(0.82, depth)
  const zOffset = depth * -0.6
  const rotation = depth * 0.08
  
  useFrame((state) => {
    if (groupRef.current) {
      groupRef.current.rotation.z = Math.sin(state.clock.elapsedTime * 0.3 + depth * 0.3) * 0.02 + rotation
    }
    if (ringRef.current) {
      const pulse = Math.sin(state.clock.elapsedTime * 1.5 - depth * 0.4) * 0.02 + 1
      ringRef.current.scale.setScalar(pulse)
    }
  })

  const opacity = Math.max(0.15, 1 - depth * 0.07)
  const emissiveIntensity = Math.max(0.1, 0.6 - depth * 0.04)

  return (
    <group ref={groupRef} position={[0, 0, zOffset]} scale={scale}>
      {/* Outer ring - chrome */}
      <mesh ref={ringRef}>
        <torusGeometry args={[2.2, 0.04, 16, 100]} />
        <meshStandardMaterial
          color="#e8e8e8"
          metalness={1}
          roughness={0.1}
          emissive="#ffffff"
          emissiveIntensity={emissiveIntensity}
          transparent
          opacity={opacity}
        />
      </mesh>
      
      {/* Inner accent ring */}
      <mesh>
        <torusGeometry args={[2.0, 0.015, 16, 100]} />
        <meshStandardMaterial
          color="#c0c0c0"
          metalness={1}
          roughness={0.2}
          transparent
          opacity={opacity * 0.7}
        />
      </mesh>

      {/* Mirror surface */}
      <mesh position={[0, 0, -0.01]}>
        <circleGeometry args={[1.95, 64]} />
        <meshPhysicalMaterial
          color="#0a0a0a"
          metalness={0.95}
          roughness={0.05}
          reflectivity={1}
          clearcoat={1}
          clearcoatRoughness={0.05}
          transparent
          opacity={0.85 - depth * 0.05}
        />
      </mesh>

      {/* Recurse */}
      {depth < maxDepth && <MirrorPortal depth={depth + 1} maxDepth={maxDepth} />}
    </group>
  )
}

// Floating chrome shards
function ChromeShards() {
  const shardsRef = useRef<THREE.Group>(null)
  
  const shards = useMemo(() => {
    return Array.from({ length: 20 }, (_, i) => ({
      id: i,
      position: [
        (Math.random() - 0.5) * 8,
        (Math.random() - 0.5) * 6,
        (Math.random() - 0.5) * 4 - 2
      ] as [number, number, number],
      rotation: [
        Math.random() * Math.PI,
        Math.random() * Math.PI,
        Math.random() * Math.PI
      ] as [number, number, number],
      scale: 0.02 + Math.random() * 0.06,
      speed: 0.2 + Math.random() * 0.5
    }))
  }, [])

  useFrame((state) => {
    if (shardsRef.current) {
      shardsRef.current.children.forEach((child, i) => {
        const shard = shards[i]
        child.rotation.x += shard.speed * 0.01
        child.rotation.y += shard.speed * 0.015
        child.position.y += Math.sin(state.clock.elapsedTime * shard.speed + i) * 0.001
      })
    }
  })

  return (
    <group ref={shardsRef}>
      {shards.map((shard) => (
        <mesh
          key={shard.id}
          position={shard.position}
          rotation={shard.rotation}
          scale={shard.scale}
        >
          <octahedronGeometry args={[1, 0]} />
          <meshStandardMaterial
            color="#e0e0e0"
            metalness={1}
            roughness={0.1}
            emissive="#ffffff"
            emissiveIntensity={0.1}
          />
        </mesh>
      ))}
    </group>
  )
}

// Particle field
function ParticleField() {
  const pointsRef = useRef<THREE.Points>(null)
  
  const geometry = useMemo(() => {
    const count = 200
    const positions = new Float32Array(count * 3)
    const sizes = new Float32Array(count)
    
    for (let i = 0; i < count; i++) {
      const theta = Math.random() * Math.PI * 2
      const phi = Math.acos(2 * Math.random() - 1)
      const r = 3 + Math.random() * 5
      
      positions[i * 3] = r * Math.sin(phi) * Math.cos(theta)
      positions[i * 3 + 1] = r * Math.sin(phi) * Math.sin(theta)
      positions[i * 3 + 2] = r * Math.cos(phi) - 5
      sizes[i] = Math.random()
    }
    
    const geo = new THREE.BufferGeometry()
    geo.setAttribute('position', new THREE.BufferAttribute(positions, 3))
    geo.setAttribute('size', new THREE.BufferAttribute(sizes, 1))
    return geo
  }, [])

  useFrame((state) => {
    if (pointsRef.current) {
      pointsRef.current.rotation.y = state.clock.elapsedTime * 0.02
      pointsRef.current.rotation.z = state.clock.elapsedTime * 0.01
    }
  })

  return (
    <points ref={pointsRef} geometry={geometry}>
      <pointsMaterial
        size={0.015}
        color="#ffffff"
        transparent
        opacity={0.4}
        sizeAttenuation
      />
    </points>
  )
}

// Mouse-reactive camera
function CameraRig() {
  const { camera } = useThree()
  const mouseRef = useRef({ x: 0, y: 0 })

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      mouseRef.current = {
        x: (e.clientX / window.innerWidth) * 2 - 1,
        y: (e.clientY / window.innerHeight) * 2 - 1
      }
    }
    window.addEventListener('mousemove', handleMouseMove)
    return () => window.removeEventListener('mousemove', handleMouseMove)
  }, [])

  useFrame(() => {
    camera.position.x += (mouseRef.current.x * 0.5 - camera.position.x) * 0.02
    camera.position.y += (-mouseRef.current.y * 0.3 - camera.position.y) * 0.02
    camera.lookAt(0, 0, -5)
  })

  return null
}

// Center glow
function CenterGlow() {
  const glowRef = useRef<THREE.Mesh>(null)
  
  useFrame((state) => {
    if (glowRef.current) {
      const scale = 1 + Math.sin(state.clock.elapsedTime * 2) * 0.1
      glowRef.current.scale.setScalar(scale)
    }
  })

  return (
    <mesh ref={glowRef} position={[0, 0, -7]}>
      <circleGeometry args={[0.3, 32]} />
      <meshBasicMaterial color="#ffffff" transparent opacity={0.8} />
    </mesh>
  )
}

function Scene() {
  return (
    <>
      <fog attach="fog" args={['#000000', 5, 18]} />
      <ambientLight intensity={0.1} />
      <pointLight position={[0, 0, 5]} intensity={1} color="#ffffff" />
      <pointLight position={[3, 3, 2]} intensity={0.5} color="#e0e0e0" />
      <pointLight position={[-3, -3, 2]} intensity={0.3} color="#c0c0c0" />
      
      <CameraRig />
      <CenterGlow />
      <MirrorPortal maxDepth={14} />
      <ChromeShards />
      <ParticleField />
      
      <Environment preset="city" />
    </>
  )
}

export function InfiniteMirror() {
  const [mounted, setMounted] = useState(false)
  
  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return (
      <div className="absolute inset-0 z-0 bg-background" />
    )
  }

  return (
    <div className="absolute inset-0 z-0">
      <Canvas
        camera={{ position: [0, 0, 5], fov: 50 }}
        dpr={[1, 2]}
        gl={{ antialias: true, alpha: false }}
      >
        <color attach="background" args={['#000000']} />
        <Scene />
      </Canvas>
    </div>
  )
}
