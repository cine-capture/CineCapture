# CineCapture for Unity

This repository builds the unified CineCapture release. It does not contain the
component source code.

Component source repositories:

- [CameraOperator](https://github.com/cine-capture/CameraOperator)
- [FFmpegMediaWriter](https://github.com/cine-capture/FFmpegMediaWriter)
- [UnityRuntimeCameraRecorder](https://github.com/cine-capture/UnityRuntimeCameraRecorder)
- [Direct3DVideoEncoder](https://github.com/cine-capture/Direct3DVideoEncoder)

## Example of use

[SagaCapture](https://thunderstore.io/c/valheim/p/Landoria/SagaCapture/) is a
Valheim mod that uses CineCapture to create cinematic gameplay recordings.

Watch the [SagaCapture video](https://youtu.be/_2L1In2dieM) to see it in action.

## Archive contents

The release archive contains:

- `CineCapture.dll`, built from CameraOperator, FFmpegMediaWriter, and
  UnityRuntimeCameraRecorder, with YamlDotNet embedded;
- `Direct3DVideoEncoder.dll`, the Windows x64 native encoder;
- `build-info.json`, with the exact component revisions and file hashes.

## Namespaces in CineCapture.dll

ILRepack combines the managed components into one assembly while preserving
their original namespaces.

| Namespace | Purpose | Main public types |
| --- | --- | --- |
| `CameraOperator` | Moves, aims, and repositions a Unity camera while following terrain and avoiding obstacles. | `CameraOperatorController`, `CameraPlacement`, `CameraWorld`, `Configuration` |
| `FFmpegMediaWriter` | Sends encoded video and audio to FFmpeg and finalizes the output media file. | `FfmpegMediaWriter`, `IMediaWriter`, `MediaWriterSettings`, `VideoStreamFormat`, `AudioEncodingCodec` |
| `UnityRuntimeCameraRecorder` | Captures cameras, textures, the screen, audio, image sequences, and video sequences at runtime. | `UnityRuntimeCameraRecorder`, `RecordingSettings`, `RecordingQualityPreset`, `RecordingQualityProfile`, `VideoSequenceSettings`, `VideoSequenceSource`, `ImageSequenceSettings`, `VideoCaptureBackend`, `VideoCaptureBackendRegistry`, `VideoCaptureContext`, `RecorderLog` |

`YamlDotNet` is also embedded in `CineCapture.dll` as the configuration parser
used by `CameraOperator`. Application code should use the three CineCapture
namespaces above instead of depending on the embedded implementation directly.

### CameraOperator

- `CameraOperatorController` controls movement, aiming, repositioning, and
  configuration reloads.
- `CameraWorld` connects terrain, obstacle, actor, and logging callbacks.
- `CameraPlacement` identifies the supported horizontal and elevated views.
- `Configuration` exposes validated numeric and sequence settings.

### FFmpegMediaWriter

- `FfmpegMediaWriter` manages FFmpeg input pipes and output finalization.
- `IMediaWriter` defines the media writer lifecycle.
- `MediaWriterSettings` configures paths, codecs, frame rate, audio, and error
  callbacks.
- `VideoStreamFormat` selects H.264 or HEVC input.

### UnityRuntimeCameraRecorder

- `UnityRuntimeCameraRecorder` starts, stops, recovers, and monitors recordings.
- `RecordingSettings` configures output, resolution, frame rate, quality, HDR,
  statistics, and FFmpeg paths.
- `VideoSequenceSettings` and `VideoSequenceSource` define multi-source video
  sequences and transitions.
- `ImageSequenceSettings` configures PNG or JPEG image-sequence capture.
- `VideoCaptureBackend` and `VideoCaptureBackendRegistry` support custom capture
  backends.
- `RecorderLog` connects recorder information, warnings, and errors to the host.

## Issues

Report bugs and request features in the
[CineCapture issue tracker](https://github.com/cine-capture/CineCapture/issues).
