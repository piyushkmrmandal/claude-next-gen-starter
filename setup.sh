#!/bin/bash

echo "Installing dependencies..."

npm install \
framer-motion \
gsap \
lenis \
lucide-react \
clsx \
tailwind-merge \
react-intersection-observer \
@studio-freight/lenis \
three \
@react-three/fiber \
@react-three/drei \
ogl \
zustand \
@tabler/icons-react

echo "Initializing shadcn..."

npx shadcn@latest init -y

echo "Creating folders..."

mkdir -p \
src/components/ui \
src/components/magicui \
src/components/aceternity \
src/components/cinematic \
src/components/sections \
src/components/shared \
src/animations \
src/hooks \
src/shaders \
src/styles \
src/utils \
src/design-system \
docs \
.claude/agents \
.claude/prompts \
.claude/rules

echo "Done."
