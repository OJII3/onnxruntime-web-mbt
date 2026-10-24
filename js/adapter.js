import { InferenceSession, Tensor } from 'onnxruntime-web';

export function tensorFloat32(data, dims) {
  return new Tensor('float32', Float32Array.from(data), dims);
}

export function tensorFloat32Data(tensor) {
  return Array.from(tensor.data, Number);
}

export function tensorDims(tensor) {
  return Array.from(tensor.dims, Number);
}

export function createSession(modelPath) {
  return InferenceSession.create(modelPath);
}

export function inputNames(session) {
  return [...session.inputNames];
}

export function outputNames(session) {
  return [...session.outputNames];
}

export function runSession(session, names, values) {
  const feeds = Object.fromEntries(names.map((name, index) => [name, values[index]]));
  return session.run(feeds).then((outputs) => session.outputNames.map((name) => outputs[name]));
}

export function releaseSession(session) {
  return session.release();
}
