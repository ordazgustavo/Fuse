# Fuse

Swift ssr wasm framework

## Build

1. Client

Build for development

```sh
swift run carton bundle --debug-info --wasm-optimizations none --output public --product Client
```

Build for production

```sh
swift run carton bundle --output public --product Client
```

2. Server

```sh
swift build Server
```

## Runing (no ssr)

```sh
swift run carton dev --Client
```

## Runing (ssr)

```sh
swift run Server
```
