// -----------------------------------------------------------------------------
// This file is part of vAmiga
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

// This file must conform to standard ANSI-C to be compatible with Swift.

#ifndef _DISKCONTROLLER_T_INC
#define _DISKCONTROLLER_T_INC

//
// Enumerations
//

typedef enum
{
    DRIVE_DMA_OFF,     // Drive is idle

    DRIVE_DMA_WAIT,    // Drive is waiting for the sync word
    DRIVE_DMA_READ,    // Drive is reading

    DRIVE_DMA_WRITE,   // Drive is writing
    DRIVE_DMA_FLUSH,   // Drive is finishing up the write process
}
DriveState;

inline bool isDriveState(long value)
{
    return value >= DRIVE_DMA_OFF && value <= DRIVE_DMA_FLUSH;
}

inline const char *driveStateName(DriveState state)
{
    assert(isDriveState(state));

    switch (state) {
        case DRIVE_DMA_OFF:   return "DRIVE_DMA_OFF";
        case DRIVE_DMA_WAIT:  return "DRIVE_DMA_WAIT";
        case DRIVE_DMA_READ:  return "DRIVE_DMA_READ";
        case DRIVE_DMA_WRITE: return "DRIVE_DMA_WRITE";
        case DRIVE_DMA_FLUSH: return "DRIVE_DMA_FLUSH";
        default:              return "???";
    }
}

//
// Structures
//

typedef struct
{
    bool connected[4];
    bool useFifo;
}
DiskControllerConfig;

typedef struct
{
    int8_t selectedDrive;
    DriveState state;
    int32_t fifo[6];
    uint8_t fifoCount;

    uint16_t dsklen;
    uint16_t dskbytr;
    uint16_t dsksync;
    uint8_t prb;
}
DiskControllerInfo;

typedef struct
{
    long wordCount[4];
}
DiskControllerStats;

#endif
