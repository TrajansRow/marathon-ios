static const uint8_t metal_wall_fs[1634] =
{
	0x46, 0x53, 0x48, 0x06, 0x56, 0x2a, 0xf0, 0x9e, 0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x07, 0x70, // FSH.V*.........p
	0x75, 0x6c, 0x73, 0x61, 0x74, 0x65, 0x11, 0x01, 0x00, 0x00, 0x01, 0x00, 0x06, 0x77, 0x6f, 0x62, // ulsate.......wob
	0x62, 0x6c, 0x65, 0x11, 0x01, 0x04, 0x00, 0x01, 0x00, 0x0e, 0x73, 0x65, 0x6c, 0x66, 0x4c, 0x75, // ble.......selfLu
	0x6d, 0x69, 0x6e, 0x6f, 0x73, 0x69, 0x74, 0x79, 0x11, 0x01, 0x10, 0x00, 0x01, 0x00, 0x05, 0x66, // minosity.......f
	0x6c, 0x61, 0x72, 0x65, 0x11, 0x01, 0x0c, 0x00, 0x01, 0x00, 0x04, 0x67, 0x6c, 0x6f, 0x77, 0x11, // lare.......glow.
	0x01, 0x08, 0x00, 0x01, 0x00, 0x08, 0x74, 0x65, 0x78, 0x74, 0x75, 0x72, 0x65, 0x30, 0x10, 0x00, // ......texture0..
	0x00, 0x00, 0x00, 0x00, 0xf6, 0x05, 0x00, 0x00, 0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65, // ........#include
	0x20, 0x3c, 0x6d, 0x65, 0x74, 0x61, 0x6c, 0x5f, 0x73, 0x74, 0x64, 0x6c, 0x69, 0x62, 0x3e, 0x0a, //  <metal_stdlib>.
	0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65, 0x20, 0x3c, 0x73, 0x69, 0x6d, 0x64, 0x2f, 0x73, // #include <simd/s
	0x69, 0x6d, 0x64, 0x2e, 0x68, 0x3e, 0x0a, 0x0a, 0x75, 0x73, 0x69, 0x6e, 0x67, 0x20, 0x6e, 0x61, // imd.h>..using na
	0x6d, 0x65, 0x73, 0x70, 0x61, 0x63, 0x65, 0x20, 0x6d, 0x65, 0x74, 0x61, 0x6c, 0x3b, 0x0a, 0x0a, // mespace metal;..
	0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x5f, 0x47, 0x6c, 0x6f, 0x62, 0x61, 0x6c, 0x0a, 0x7b, // struct _Global.{
	0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, 0x70, 0x75, 0x6c, 0x73, 0x61, // .    float pulsa
	0x74, 0x65, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, 0x77, 0x6f, // te;.    float wo
	0x62, 0x62, 0x6c, 0x65, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, // bble;.    float 
	0x67, 0x6c, 0x6f, 0x77, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, // glow;.    float 
	0x66, 0x6c, 0x61, 0x72, 0x65, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, // flare;.    float
	0x20, 0x73, 0x65, 0x6c, 0x66, 0x4c, 0x75, 0x6d, 0x69, 0x6e, 0x6f, 0x73, 0x69, 0x74, 0x79, 0x3b, //  selfLuminosity;
	0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x78, 0x6c, 0x61, 0x74, // .};..struct xlat
	0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, 0x6f, 0x75, 0x74, 0x0a, 0x7b, 0x0a, 0x20, 0x20, // MtlMain_out.{.  
	0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x62, 0x67, 0x66, 0x78, 0x5f, 0x46, 0x72, //   float4 bgfx_Fr
	0x61, 0x67, 0x44, 0x61, 0x74, 0x61, 0x30, 0x20, 0x5b, 0x5b, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x28, // agData0 [[color(
	0x30, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, // 0)]];.};..struct
	0x20, 0x78, 0x6c, 0x61, 0x74, 0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, 0x69, 0x6e, 0x0a, //  xlatMtlMain_in.
	0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, 0x63, 0x6c, 0x61, 0x73, // {.    float clas
	0x73, 0x69, 0x63, 0x44, 0x65, 0x70, 0x74, 0x68, 0x20, 0x5b, 0x5b, 0x75, 0x73, 0x65, 0x72, 0x28, // sicDepth [[user(
	0x6c, 0x6f, 0x63, 0x6e, 0x31, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, // locn1)]];.    fl
	0x6f, 0x61, 0x74, 0x34, 0x20, 0x66, 0x6f, 0x67, 0x43, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x5b, 0x5b, // oat4 fogColor [[
	0x75, 0x73, 0x65, 0x72, 0x28, 0x6c, 0x6f, 0x63, 0x6e, 0x32, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x20, // user(locn2)]];. 
	0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x76, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, //    float4 v_colo
	0x72, 0x30, 0x20, 0x5b, 0x5b, 0x75, 0x73, 0x65, 0x72, 0x28, 0x6c, 0x6f, 0x63, 0x6e, 0x33, 0x29, // r0 [[user(locn3)
	0x5d, 0x5d, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x32, 0x20, 0x76, // ]];.    float2 v
	0x5f, 0x74, 0x65, 0x78, 0x63, 0x6f, 0x6f, 0x72, 0x64, 0x30, 0x20, 0x5b, 0x5b, 0x75, 0x73, 0x65, // _texcoord0 [[use
	0x72, 0x28, 0x6c, 0x6f, 0x63, 0x6e, 0x36, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, // r(locn6)]];.    
	0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, 0x20, 0x76, 0x69, 0x65, 0x77, 0x44, 0x69, 0x72, 0x20, 0x5b, // float3 viewDir [
	0x5b, 0x75, 0x73, 0x65, 0x72, 0x28, 0x6c, 0x6f, 0x63, 0x6e, 0x38, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, // [user(locn8)]];.
	0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, 0x20, 0x76, 0x69, 0x65, 0x77, 0x58, //     float3 viewX
	0x59, 0x20, 0x5b, 0x5b, 0x75, 0x73, 0x65, 0x72, 0x28, 0x6c, 0x6f, 0x63, 0x6e, 0x39, 0x29, 0x5d, // Y [[user(locn9)]
	0x5d, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x66, 0x72, 0x61, 0x67, 0x6d, 0x65, 0x6e, 0x74, 0x20, // ];.};..fragment 
	0x78, 0x6c, 0x61, 0x74, 0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, 0x6f, 0x75, 0x74, 0x20, // xlatMtlMain_out 
	0x78, 0x6c, 0x61, 0x74, 0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x28, 0x78, 0x6c, 0x61, 0x74, // xlatMtlMain(xlat
	0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, 0x69, 0x6e, 0x20, 0x69, 0x6e, 0x20, 0x5b, 0x5b, // MtlMain_in in [[
	0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x5d, 0x5d, 0x2c, 0x20, 0x63, 0x6f, 0x6e, 0x73, // stage_in]], cons
	0x74, 0x61, 0x6e, 0x74, 0x20, 0x5f, 0x47, 0x6c, 0x6f, 0x62, 0x61, 0x6c, 0x26, 0x20, 0x5f, 0x6d, // tant _Global& _m
	0x74, 0x6c, 0x5f, 0x75, 0x20, 0x5b, 0x5b, 0x62, 0x75, 0x66, 0x66, 0x65, 0x72, 0x28, 0x30, 0x29, // tl_u [[buffer(0)
	0x5d, 0x5d, 0x2c, 0x20, 0x74, 0x65, 0x78, 0x74, 0x75, 0x72, 0x65, 0x32, 0x64, 0x3c, 0x66, 0x6c, // ]], texture2d<fl
	0x6f, 0x61, 0x74, 0x3e, 0x20, 0x74, 0x65, 0x78, 0x74, 0x75, 0x72, 0x65, 0x30, 0x20, 0x5b, 0x5b, // oat> texture0 [[
	0x74, 0x65, 0x78, 0x74, 0x75, 0x72, 0x65, 0x28, 0x30, 0x29, 0x5d, 0x5d, 0x2c, 0x20, 0x73, 0x61, // texture(0)]], sa
	0x6d, 0x70, 0x6c, 0x65, 0x72, 0x20, 0x74, 0x65, 0x78, 0x74, 0x75, 0x72, 0x65, 0x30, 0x53, 0x61, // mpler texture0Sa
	0x6d, 0x70, 0x6c, 0x65, 0x72, 0x20, 0x5b, 0x5b, 0x73, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x72, 0x28, // mpler [[sampler(
	0x30, 0x29, 0x5d, 0x5d, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x78, 0x6c, 0x61, 0x74, // 0)]]).{.    xlat
	0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, 0x6f, 0x75, 0x74, 0x20, 0x6f, 0x75, 0x74, 0x20, // MtlMain_out out 
	0x3d, 0x20, 0x7b, 0x7d, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, // = {};.    float3
	0x20, 0x5f, 0x33, 0x31, 0x33, 0x20, 0x3d, 0x20, 0x6e, 0x6f, 0x72, 0x6d, 0x61, 0x6c, 0x69, 0x7a, //  _313 = normaliz
	0x65, 0x28, 0x69, 0x6e, 0x2e, 0x76, 0x69, 0x65, 0x77, 0x58, 0x59, 0x29, 0x3b, 0x0a, 0x20, 0x20, // e(in.viewXY);.  
	0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, 0x20, 0x5f, 0x33, 0x32, 0x37, 0x20, 0x3d, 0x20, //   float3 _327 = 
	0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, 0x28, 0x69, 0x6e, 0x2e, 0x76, 0x5f, 0x74, 0x65, 0x78, 0x63, // float3(in.v_texc
	0x6f, 0x6f, 0x72, 0x64, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x29, 0x20, 0x2b, 0x20, 0x66, 0x6c, // oord0, 0.0) + fl
	0x6f, 0x61, 0x74, 0x33, 0x28, 0x5f, 0x33, 0x31, 0x33, 0x2e, 0x79, 0x20, 0x2a, 0x20, 0x28, 0x2d, // oat3(_313.y * (-
	0x5f, 0x6d, 0x74, 0x6c, 0x5f, 0x75, 0x2e, 0x70, 0x75, 0x6c, 0x73, 0x61, 0x74, 0x65, 0x29, 0x2c, // _mtl_u.pulsate),
	0x20, 0x5f, 0x33, 0x31, 0x33, 0x2e, 0x78, 0x20, 0x2a, 0x20, 0x5f, 0x6d, 0x74, 0x6c, 0x5f, 0x75, //  _313.x * _mtl_u
	0x2e, 0x70, 0x75, 0x6c, 0x73, 0x61, 0x74, 0x65, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x29, 0x3b, 0x0a, // .pulsate, 0.0);.
	0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x20, 0x5f, 0x33, 0x35, 0x32, 0x20, 0x3d, //     float _352 =
	0x20, 0x66, 0x61, 0x73, 0x74, 0x3a, 0x3a, 0x63, 0x6c, 0x61, 0x6d, 0x70, 0x28, 0x28, 0x5f, 0x6d, //  fast::clamp((_m
	0x74, 0x6c, 0x5f, 0x75, 0x2e, 0x73, 0x65, 0x6c, 0x66, 0x4c, 0x75, 0x6d, 0x69, 0x6e, 0x6f, 0x73, // tl_u.selfLuminos
	0x69, 0x74, 0x79, 0x20, 0x2b, 0x20, 0x5f, 0x6d, 0x74, 0x6c, 0x5f, 0x75, 0x2e, 0x66, 0x6c, 0x61, // ity + _mtl_u.fla
	0x72, 0x65, 0x29, 0x20, 0x2d, 0x20, 0x69, 0x6e, 0x2e, 0x63, 0x6c, 0x61, 0x73, 0x73, 0x69, 0x63, // re) - in.classic
	0x44, 0x65, 0x70, 0x74, 0x68, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x29, // Depth, 0.0, 1.0)
	0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, 0x20, 0x5f, 0x34, 0x34, // ;.    float3 _44
	0x30, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x69, 0x66, 0x20, 0x28, 0x69, 0x6e, 0x2e, 0x76, 0x5f, // 0;.    if (in.v_
	0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x2e, 0x78, 0x20, 0x3e, 0x20, 0x5f, 0x33, 0x35, 0x32, 0x29, // color0.x > _352)
	0x0a, 0x20, 0x20, 0x20, 0x20, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x5f, // .    {.        _
	0x34, 0x34, 0x30, 0x20, 0x3d, 0x20, 0x69, 0x6e, 0x2e, 0x76, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, // 440 = in.v_color
	0x30, 0x2e, 0x78, 0x79, 0x7a, 0x20, 0x2b, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, 0x28, 0x5f, // 0.xyz + float3(_
	0x33, 0x35, 0x32, 0x20, 0x2a, 0x20, 0x30, 0x2e, 0x35, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, // 352 * 0.5);.    
	0x7d, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x65, 0x6c, 0x73, 0x65, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x7b, // }.    else.    {
	0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x5f, 0x34, 0x34, 0x30, 0x20, 0x3d, 0x20, // .        _440 = 
	0x28, 0x69, 0x6e, 0x2e, 0x76, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x2e, 0x78, 0x79, 0x7a, // (in.v_color0.xyz
	0x20, 0x2a, 0x20, 0x30, 0x2e, 0x35, 0x29, 0x20, 0x2b, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, //  * 0.5) + float3
	0x28, 0x5f, 0x33, 0x35, 0x32, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x7d, 0x0a, 0x20, 0x20, // (_352);.    }.  
	0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x5f, 0x34, 0x32, 0x31, 0x20, 0x3d, 0x20, //   float4 _421 = 
	0x74, 0x65, 0x78, 0x74, 0x75, 0x72, 0x65, 0x30, 0x2e, 0x73, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x28, // texture0.sample(
	0x74, 0x65, 0x78, 0x74, 0x75, 0x72, 0x65, 0x30, 0x53, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x72, 0x2c, // texture0Sampler,
	0x20, 0x28, 0x5f, 0x33, 0x32, 0x37, 0x20, 0x2b, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, 0x28, //  (_327 + float3(
	0x28, 0x5f, 0x33, 0x31, 0x33, 0x2e, 0x79, 0x20, 0x2a, 0x20, 0x28, 0x2d, 0x5f, 0x6d, 0x74, 0x6c, // (_313.y * (-_mtl
	0x5f, 0x75, 0x2e, 0x77, 0x6f, 0x62, 0x62, 0x6c, 0x65, 0x29, 0x29, 0x20, 0x2a, 0x20, 0x5f, 0x33, // _u.wobble)) * _3
	0x32, 0x37, 0x2e, 0x79, 0x2c, 0x20, 0x5f, 0x6d, 0x74, 0x6c, 0x5f, 0x75, 0x2e, 0x77, 0x6f, 0x62, // 27.y, _mtl_u.wob
	0x62, 0x6c, 0x65, 0x20, 0x2a, 0x20, 0x5f, 0x33, 0x32, 0x37, 0x2e, 0x79, 0x2c, 0x20, 0x30, 0x2e, // ble * _327.y, 0.
	0x30, 0x29, 0x29, 0x2e, 0x78, 0x79, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x6f, 0x75, 0x74, // 0)).xy);.    out
	0x2e, 0x62, 0x67, 0x66, 0x78, 0x5f, 0x46, 0x72, 0x61, 0x67, 0x44, 0x61, 0x74, 0x61, 0x30, 0x20, // .bgfx_FragData0 
	0x3d, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x28, 0x6d, 0x69, 0x78, 0x28, 0x69, 0x6e, 0x2e, // = float4(mix(in.
	0x66, 0x6f, 0x67, 0x43, 0x6f, 0x6c, 0x6f, 0x72, 0x2e, 0x78, 0x79, 0x7a, 0x2c, 0x20, 0x5f, 0x34, // fogColor.xyz, _4
	0x32, 0x31, 0x2e, 0x78, 0x79, 0x7a, 0x20, 0x2a, 0x20, 0x66, 0x61, 0x73, 0x74, 0x3a, 0x3a, 0x63, // 21.xyz * fast::c
	0x6c, 0x61, 0x6d, 0x70, 0x28, 0x5f, 0x34, 0x34, 0x30, 0x2c, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, // lamp(_440, float
	0x33, 0x28, 0x5f, 0x6d, 0x74, 0x6c, 0x5f, 0x75, 0x2e, 0x67, 0x6c, 0x6f, 0x77, 0x29, 0x2c, 0x20, // 3(_mtl_u.glow), 
	0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, 0x28, 0x31, 0x2e, 0x30, 0x29, 0x29, 0x2c, 0x20, 0x66, 0x6c, // float3(1.0)), fl
	0x6f, 0x61, 0x74, 0x33, 0x28, 0x66, 0x61, 0x73, 0x74, 0x3a, 0x3a, 0x63, 0x6c, 0x61, 0x6d, 0x70, // oat3(fast::clamp
	0x28, 0x6c, 0x65, 0x6e, 0x67, 0x74, 0x68, 0x28, 0x69, 0x6e, 0x2e, 0x76, 0x69, 0x65, 0x77, 0x44, // (length(in.viewD
	0x69, 0x72, 0x29, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x29, 0x29, 0x29, // ir), 0.0, 1.0)))
	0x2c, 0x20, 0x69, 0x6e, 0x2e, 0x76, 0x5f, 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x30, 0x2e, 0x77, 0x20, // , in.v_color0.w 
	0x2a, 0x20, 0x5f, 0x34, 0x32, 0x31, 0x2e, 0x77, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, // * _421.w);.    r
	0x65, 0x74, 0x75, 0x72, 0x6e, 0x20, 0x6f, 0x75, 0x74, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00, 0x00, // eturn out;.}....
	0x50, 0x00,                                                                                     // P.
};
