## Deinterlace
- https://askubuntu.com/questions/866186/how-to-get-good-quality-when-converting-digital-video
- https://www.reddit.com/r/ffmpeg/comments/d3cwxp/what_is_the_difference_between_bwdif_and_yadif1/
- https://www.reddit.com/r/ffmpeg/comments/m2pigw/deinterlacing_without_doubling_the_frame_rate/

### yadif (yet another deinterlacing filter)
It accepts the following parameters:
- *mode*: The interlacing mode to adopt. It accepts one of the following values:
  - 0, send_frame: Output one frame for each frame.
  - 1, send_field: Output one frame for each field.
  - 2, send_frame_nospatial: Like send_frame, but it skips the spatial interlacing check.
  - 3, send_field_nospatial: Like send_field, but it skips the spatial interlacing check.
  - The default value is send_frame.
- *parity*: The picture field parity assumed for the input interlaced video. It accepts one of the following values:
  - 0, tff: Assume the top field is first.
  - 1, bff: Assume the bottom field is first.
  - -1, auto: Enable automatic detection of field parity.
  - The default value is auto. If the interlacing is unknown or the decoder does not export this information, top field first will be assumed.
- *deint*: Specify which frames to deinterlace. Accepts one of the following values:
  - 0, all: Deinterlace all frames.
  - 1, interlaced: Only deinterlace frames marked as interlaced.
  - The default value is all.


