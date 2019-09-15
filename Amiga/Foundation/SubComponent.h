// -----------------------------------------------------------------------------
// This file is part of vAmiga
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

#ifndef _SUB_COMPONENT_INC
#define _SUB_COMPONENT_INC

#include "HardwareComponent.h"

//
// Forward declarations of all sub components
//

class CPU;
class CIAA;
class CIAB;
class RTC;
class Memory;
class Agnus;
class DmaDebugger;
class Denise;
class PixelEngine;
class Paula;
class DiskController;
class UART;
class ZorroManager;
class ControlPort;
class SerialPort;
class Mouse;
class Joystick;
class Keyboard;
class Drive;


/* Base class for all sub components.
 * Exhibits references to all Amiga components.
 */
class SubComponent : public HardwareComponent {

protected:

    Amiga &amiga;
    CPU &cpu;
    CIAA &ciaa;
    CIAB &ciab;
    RTC &rtc;
    Memory &mem;
    Agnus &agnus;
    DmaDebugger &dmaDebugger;
    Denise &denise;
    PixelEngine &pixelEngine;
    Paula &paula;
    DiskController &diskController;
    UART &uart;
    ZorroManager &zorro;
    ControlPort &controlPort1;
    ControlPort &controlPort2;
    SerialPort &serialPort;
    Mouse &mouse;
    Joystick &joystick1;
    Joystick &joystick2;
    Keyboard &keyboard;
    Drive &df0;
    Drive &df1;
    Drive &df2;
    Drive &df3;

    Drive *df[4] = { &df0, &df1, &df2, &df3 };

public:

    SubComponent(Amiga& ref);
};

#endif