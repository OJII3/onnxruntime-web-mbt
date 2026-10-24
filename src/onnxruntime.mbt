///|
#external
pub type Tensor

///|
#external
pub type InferenceSession

///|
#module("@ojii3/onnxruntime-web-mbt")
pub extern "js" fn Tensor::float32(
  data : FixedArray[Double],
  dims : FixedArray[Int32],
) -> Tensor = "tensorFloat32"

///|
pub extern "js" fn Tensor::float32_data(self : Tensor) -> FixedArray[Double] = "tensorFloat32Data"

///|
pub extern "js" fn Tensor::dims(self : Tensor) -> FixedArray[Int32] = "tensorDims"

///|
extern "js" fn ffi_create(
  model_path : String,
  execution_providers : FixedArray[String],
) -> @js_async.Promise[InferenceSession] = "createSession"

///|
pub async fn InferenceSession::create(
  model_path : String,
  execution_providers~ : FixedArray[String] = [],
) -> InferenceSession {
  ffi_create(model_path, execution_providers).wait()
}

///|
pub extern "js" fn InferenceSession::input_names(
  self : InferenceSession,
) -> FixedArray[String] = "inputNames"

///|
pub extern "js" fn InferenceSession::output_names(
  self : InferenceSession,
) -> FixedArray[String] = "outputNames"

///|
extern "js" fn InferenceSession::ffi_run(
  self : InferenceSession,
  names : FixedArray[String],
  values : FixedArray[Tensor],
) -> @js_async.Promise[FixedArray[Tensor]] = "runSession"

///|
pub async fn InferenceSession::run(
  self : InferenceSession,
  feeds : FixedArray[(String, Tensor)],
) -> FixedArray[Tensor] {
  let names = feeds.map(fn(feed) { feed.0 })
  let values = feeds.map(fn(feed) { feed.1 })
  let outputs = self.ffi_run(names, values).wait()
  outputs
}

///|
extern "js" fn InferenceSession::ffi_release(
  self : InferenceSession,
) -> @js_async.Promise[Unit] = "releaseSession"

///|
pub async fn InferenceSession::release(self : InferenceSession) -> Unit {
  self.ffi_release().wait()
}
