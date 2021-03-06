// -----------------------------------------------------------------------------
// This file is part of vAmiga
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

#pragma once

#include "FSBlock.h"

struct FSEmptyBlock : FSBlock {
    
    FSEmptyBlock(FSPartition &p, u32 nr) : FSBlock(p, nr) { }
     
    const char *getDescription() const override { return "FSEmptyBlock"; }
    
    
    //
    // Methods from Block class
    //

    FSBlockType type() const override { return FS_EMPTY_BLOCK; }
    FSItemType itemType(u32 byte) const override; 
    u32 typeID() const override { return 0; }
    u32 subtypeID() const override { return 0; }
    void dumpData() const override { };

    void importBlock(const u8 *src, size_t bsize) override;
    void exportBlock(u8 *dst, size_t bsize) override;
};
