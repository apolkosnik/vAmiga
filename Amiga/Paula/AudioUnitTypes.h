// -----------------------------------------------------------------------------
// This file is part of vAmiga
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

// This file must conform to standard ANSI-C to be compatible with Swift.

#ifndef _AUDIOUNIT_T_INC
#define _AUDIOUNIT_T_INC

//
// Enumerations
//

typedef enum : long
{
    SMP_NONE,
    SMP_NEAREST,
    SMP_LINEAR
}
SamplingMethod;

static inline bool isSamplingMethod(long value) { return value >= 0 && value <= SMP_LINEAR; }

typedef enum : long
{
    FILT_NONE,
    FILT_BUTTERWORTH,
    FILT_COUNT
}
FilterType;

static inline bool isFilterType(long value) { return value >= 0 && value < FILT_COUNT; }

typedef enum : long
{
    FILTACT_POWER_LED,
    FILTACT_NEVER,
    FILTACT_ALWAYS,
    FILTACT_COUNT
}
FilterActivation;

static inline bool isFilterActivation(long value) { return value >= 0 && value < FILTACT_COUNT; }

//
// Structures
//

typedef struct
{
    // The sample rate in Hz
    double sampleRate;

    // The sample interpolation method
    SamplingMethod samplingMethod;

    // Determines when the audio filter is active
    FilterActivation filterActivation;

    // Selected audio filter type
    FilterType filterType;
}
AudioConfig;

typedef struct
{
    int8_t state;

    uint16_t audlenLatch;
    uint16_t audlen;
    uint16_t audperLatch;
    int32_t audper;
    uint16_t audvolLatch;
    uint16_t audvol;
    uint16_t auddatLatch;
    uint16_t auddat;
    uint32_t audlcLatch;
}
AudioChannelInfo;

typedef struct
{
    AudioChannelInfo channel[4];
}
AudioInfo;

typedef struct
{
    long bufferUnderflows;
    long bufferOverflows;
}
AudioStats;

#endif
