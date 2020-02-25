// -----------------------------------------------------------------------------
// This file is part of vAmiga
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

extension Inspector {

    func cacheAgnus() {

        agnusInfo = amiga!.agnus.getInfo()
    }

    func refreshAgnus(count: Int) {

        // Perform a full refresh if needed
        if count == 0 { refreshAgnusFormatters() }

        // Update display cache
        cacheAgnus()

        // Refresh display with cached values
        refreshAgnusValues()
    }

    func refreshAgnusFormatters() {

        let elements = [ dmaVPOS: fmt16,
                         dmaHPOS: fmt16,

                         dmaDMACON: fmt16,
                         dmaBPL0CON: fmt16,
                         dmaDDFSTRT: fmt16,
                         dmaDDFSTOP: fmt16,
                         dmaDIWSTRT: fmt16,
                         dmaDIWSTOP: fmt16,

                         dmaBLTAMOD: fmt16,
                         dmaBLTBMOD: fmt16,
                         dmaBLTCMOD: fmt16,
                         dmaBLTDMOD: fmt16,
                         dmaBPL1MOD: fmt16,
                         dmaBPL2MOD: fmt16,

                         dmaBPL1PT: fmt32,
                         dmaBPL2PT: fmt32,
                         dmaBPL3PT: fmt32,
                         dmaBPL4PT: fmt32,
                         dmaBPL5PT: fmt32,
                         dmaBPL6PT: fmt32,

                         dmaAUD0PT: fmt32,
                         dmaAUD1PT: fmt32,
                         dmaAUD2PT: fmt32,
                         dmaAUD3PT: fmt32,

                         dmaBLTAPT: fmt32,
                         dmaBLTBPT: fmt32,
                         dmaBLTCPT: fmt32,
                         dmaBLTDPT: fmt32,

                         dmaCOPPC: fmt32,

                         dmaSPR0PT: fmt32,
                         dmaSPR1PT: fmt32,
                         dmaSPR2PT: fmt32,
                         dmaSPR3PT: fmt32,
                         dmaSPR4PT: fmt32,
                         dmaSPR5PT: fmt32,
                         dmaSPR6PT: fmt32,
                         dmaSPR7PT: fmt32,

                         dmaDSKPT: fmt32
        ]
        for (c, f) in elements { assignFormatter(f, c!) }
    }

    func refreshAgnusValues() {

        dmaVPOS.integerValue = Int(agnusInfo!.vpos)
        dmaHPOS.integerValue = Int(agnusInfo!.hpos)

        let dmacon  = Int(agnusInfo!.dmacon)
        let bplcon0 = Int(agnusInfo!.bplcon0)

        dmaDMACON.integerValue = dmacon
        let bltpri  = (dmacon & 0b0000010000000000) != 0
        let dmaen   = (dmacon & 0b0000001000000000) != 0
        let bplen   = (dmacon & 0b0000000100000000) != 0 && dmaen
        let copen   = (dmacon & 0b0000000010000000) != 0 && dmaen
        let blten   = (dmacon & 0b0000000001000000) != 0 && dmaen
        let spren   = (dmacon & 0b0000000000100000) != 0 && dmaen
        let dsken   = (dmacon & 0b0000000000010000) != 0 && dmaen
        let aud3en  = (dmacon & 0b0000000000001000) != 0 && dmaen
        let aud2en  = (dmacon & 0b0000000000000100) != 0 && dmaen
        let aud1en  = (dmacon & 0b0000000000000010) != 0 && dmaen
        let aud0en  = (dmacon & 0b0000000000000001) != 0 && dmaen

        dmaBPL0CON.integerValue = bplcon0
        let bpu     = (bplcon0 >> 12) & 0b111

        dmaDIWSTRT.integerValue = Int(agnusInfo!.diwstrt)
        dmaDIWSTOP.integerValue = Int(agnusInfo!.diwstop)
        dmaDDFSTRT.integerValue = Int(agnusInfo!.ddfstrt)
        dmaDDFSTOP.integerValue = Int(agnusInfo!.ddfstop)

        dmaBLTAMOD.integerValue = Int(agnusInfo!.bltamod)
        dmaBLTBMOD.integerValue = Int(agnusInfo!.bltbmod)
        dmaBLTCMOD.integerValue = Int(agnusInfo!.bltcmod)
        dmaBLTDMOD.integerValue = Int(agnusInfo!.bltdmod)
        dmaBPL1MOD.integerValue = Int(agnusInfo!.bpl1mod)
        dmaBPL2MOD.integerValue = Int(agnusInfo!.bpl2mod)

        dmaBPL1PT.integerValue = Int(agnusInfo!.bplpt.0)
        dmaBPL2PT.integerValue = Int(agnusInfo!.bplpt.1)
        dmaBPL3PT.integerValue = Int(agnusInfo!.bplpt.2)
        dmaBPL4PT.integerValue = Int(agnusInfo!.bplpt.3)
        dmaBPL5PT.integerValue = Int(agnusInfo!.bplpt.4)
        dmaBPL6PT.integerValue = Int(agnusInfo!.bplpt.5)
        dmaBPL1Enable.state = bplen && dmaen && bpu >= 1 ? .on : .off
        dmaBPL2Enable.state = bplen && dmaen && bpu >= 2 ? .on : .off
        dmaBPL3Enable.state = bplen && bpu >= 3 ? .on : .off
        dmaBPL4Enable.state = bplen && bpu >= 4 ? .on : .off
        dmaBPL5Enable.state = bplen && bpu >= 5 ? .on : .off
        dmaBPL6Enable.state = bplen && bpu >= 6 ? .on : .off

        dmaAUD0PT.integerValue = Int(agnusInfo!.audlc.0)
        dmaAUD1PT.integerValue = Int(agnusInfo!.audlc.1)
        dmaAUD2PT.integerValue = Int(agnusInfo!.audlc.2)
        dmaAUD3PT.integerValue = Int(agnusInfo!.audlc.3)
        dmaAUD0Enable.state = aud0en ? .on : .off
        dmaAUD1Enable.state = aud1en ? .on : .off
        dmaAUD2Enable.state = aud2en ? .on : .off
        dmaAUD3Enable.state = aud3en ? .on : .off

        dmaBLTAPT.integerValue = Int(agnusInfo!.bltpt.0)
        dmaBLTBPT.integerValue = Int(agnusInfo!.bltpt.1)
        dmaBLTCPT.integerValue = Int(agnusInfo!.bltpt.2)
        dmaBLTDPT.integerValue = Int(agnusInfo!.bltpt.3)
        dmaBLTAEnable.state = blten ? .on : .off
        dmaBLTBEnable.state = blten ? .on : .off
        dmaBLTCEnable.state = blten ? .on : .off
        dmaBLTDEnable.state = blten ? .on : .off
        dmaBLTPRI.state = bltpri ? .on : .off
        dmaBLS.state = agnusInfo!.bls ? .on : .off

        dmaCOPPC.integerValue = Int(agnusInfo!.coppc)
        dmaCOPEnable.state = copen ? .on : .off

        dmaSPR0PT.integerValue = Int(agnusInfo!.sprpt.0)
        dmaSPR1PT.integerValue = Int(agnusInfo!.sprpt.1)
        dmaSPR2PT.integerValue = Int(agnusInfo!.sprpt.2)
        dmaSPR3PT.integerValue = Int(agnusInfo!.sprpt.3)
        dmaSPR4PT.integerValue = Int(agnusInfo!.sprpt.4)
        dmaSPR5PT.integerValue = Int(agnusInfo!.sprpt.5)
        dmaSPR6PT.integerValue = Int(agnusInfo!.sprpt.6)
        dmaSPR7PT.integerValue = Int(agnusInfo!.sprpt.7)
        dmaSPR0Enable.state = spren ? .on : .off
        dmaSPR1Enable.state = spren ? .on : .off
        dmaSPR2Enable.state = spren ? .on : .off
        dmaSPR3Enable.state = spren ? .on : .off
        dmaSPR4Enable.state = spren ? .on : .off
        dmaSPR5Enable.state = spren ? .on : .off
        dmaSPR6Enable.state = spren ? .on : .off
        dmaSPR7Enable.state = spren ? .on : .off

        dmaDSKPT.integerValue = Int(agnusInfo!.dskpt)
        dmaDSKEnable.state = dsken ? .on : .off
    }
}
