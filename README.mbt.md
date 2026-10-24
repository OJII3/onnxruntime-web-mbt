# onnxruntime-web-mbt

MoonBit bindings for [ONNX Runtime Web](https://github.com/microsoft/onnxruntime), based on the companion-module pattern used by [three-mbt](https://github.com/mizchi/three-mbt). The package targets MoonBit's JavaScript backend and keeps inference, tensor storage, and execution on the ONNX Runtime side.

## Supported API

- Create float32 tensors and inspect their data and dimensions.
- Load an ONNX model from a URL or file path with `InferenceSession::create`.
- Inspect input and output names, run inference, and release the session.

The current binding intentionally covers the common float32 inference path. Other tensor types, session options, fetch selection, and browser-specific execution providers are not exposed yet.

## Install

Add the MoonBit package and its JavaScript companion to your project:

```sh
moon add ojii3/onnxruntime_web
pnpm add onnxruntime-web @ojii3/onnxruntime-web-mbt@link:./.mooncakes/ojii3/onnxruntime_web/js
```

Add the import to the MoonBit package that uses the binding:

```toml
import {
  "ojii3/onnxruntime_web",
}
```

Build for JavaScript with `moon build --target js`. The consumer must bundle or otherwise resolve the `onnxruntime-web` npm package and the companion package.

## Example

```moonbit
async fn main {
  let session = @onnxruntime_web.InferenceSession::create("./model.onnx")
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

The npm companion lives in `js/adapter.js`. It imports ONNX Runtime Web and adapts the module's API to the small FFI surface in `src/onnxruntime.mbt`.
