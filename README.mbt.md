# onnxruntime-web-mbt

MoonBit bindings for [ONNX Runtime Web](https://github.com/microsoft/onnxruntime), based on the companion-module pattern used by [three-mbt](https://github.com/mizchi/three-mbt). The package targets MoonBit's JavaScript backend and keeps inference, tensor storage, and execution on the ONNX Runtime side.

## Supported API

- Create float32 tensors and inspect their data and dimensions.
- Load an ONNX model from a URL or file path with `InferenceSession::create`.
- Select execution providers, including WebGPU, when creating a session.
- Inspect input and output names, run inference, and release the session.

The current binding intentionally covers the common float32 inference path. Other tensor types, general session options, and fetch selection are not exposed yet. WebGPU requires browser support and only accelerates operators supported by its execution provider.

## Install

Add the MoonBit package to your project:

```sh
moon add OJII3/onnxruntime_web
```

Add the import to the MoonBit package that uses the binding:

```toml
import {
  "OJII3/onnxruntime_web",
}
```

Build for JavaScript with `moon build --target js`. In the JavaScript application, install ONNX Runtime Web with your package manager (for example, `pnpm add onnxruntime-web`). The adapter is included in the Mooncakes module under `js/`; it is not published as an npm package. Configure the application's bundler to resolve `@ojii3/onnxruntime-web-mbt` to that adapter.

## Example

```moonbit
async fn main {
  let session = @onnxruntime_web.InferenceSession::create(
    "./model.onnx",
    execution_providers=["webgpu"],
  )
  let input = @onnxruntime_web.Tensor::float32([1.0, 2.0, 3.0, 4.0], [1, 4])
  let outputs = session.run([("input", input)])
  let scores = outputs[0].float32_data()
  session.release()
}
```

Inference methods are `async`; call them from an async MoonBit function. `run` returns tensors in the order of `session.output_names()`.

## Development

```sh
nix develop
moon info
moon fmt
moon build --target js
```

The JavaScript adapter lives in `js/adapter.js`. It imports ONNX Runtime Web and adapts the module's API to the small FFI surface in `src/onnxruntime.mbt`.

## Release

Update the versions in `moon.mod` and `js/package.json` together, then push the matching `v<version>` tag. The release workflow checks the tag and module/adapter versions, runs the MoonBit checks and build, publishes the module and its JavaScript adapter together to Mooncakes, then creates a GitHub Release with generated notes.

Configure these repository Actions secrets before publishing:

- `MOONCAKES_TOKEN`: Mooncakes API token. The workflow writes it to `~/.moon/credentials.json`.
