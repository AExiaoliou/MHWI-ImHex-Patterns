import std.io;
import type.color;

struct f4 {
    float _f1, _f2, _f3, _f4;
    s32 separator;
};

struct block {
    float f1;
    u8 b1, b2, b3, b4;
    s32 i1;
    float f2, f3;
    s32 separator;
};

struct packed_path {
    char path[];
};

struct epvcolor {
    s32 efxslot [[color("0000ff")]];
    type::RGBA8 hexcolor;
    float saturation [[color("3c14ac")]];
    s32 size [[color("3c14ac")]];
    float frequency [[color("95c9a6")]];
};

fn fmtRecord(auto record){
    return std::format("{}|{}: {} - RGB: {}",record.unknownID, record.recordID, record.paths[0].path,record.epvc[0].hexcolor);    
};

struct Position {
    float X, Y, Z;
};

using Rotation = Position;

struct record {
    packed_path paths[4] [[static]];
    s32 _padding;
    s32 unknownID;
    s16 recordID;
    s32 paramU_0[3] [[color("95c9a6")]];//12 might be short followed by another short
    float paramU_1 [[color("95c9a6")]];
    s32 paramU_2[4] [[color("95c9a6")]];
    s16 paramU_3[2] [[color("95c9a6")]];
    s16 paramU_4[2] [[color("95c9a6")]];
    s32 paramU_5[2] [[color("ff0000")]];

    Position position [[color("ff3000")]];
    s32 AlwaysZero[3] [[color("3c14dc"), hidden]];//always 0
    Rotation rotation [[color("3c14dc")]];
    float paramU2[3] [[color("a009000")]];//first field always 0

    s32 paramU3[2] [[color("a00f000")]];

    s32 boneID [[color("3c14dc")]];

    s32 paramU4[3] [[color("3c14dc")]];

    epvcolor epvc[8];
    float separator[2] [[color("3c14dc")]];
    block block1 [[color("3c14dc")]];
    s32 paramV[4] [[color("3c14dc")]];
} [[format_read("fmtRecord")]];;



struct group {
    u32 recordCount;
    s16 groupID;
    record records[recordCount] [[static, name("Records Group"), color("ddaaff")]];
};

struct trailRecord {
    u32 trailID, blockID, recordID;
};

struct trail {
    u64 _padding;
    u32 trailCount;
    trailRecord trails[trailCount];
    char epvPath[];
    u8 ONE;
    u32 NULL;
};

struct blockSection{
    u32 blockCount;
    group effectGroups[blockCount];
};

struct epv {
    u64 signature;
    blockSection blocks [[static]];
    trail t;
};

epv epv @ 0;
