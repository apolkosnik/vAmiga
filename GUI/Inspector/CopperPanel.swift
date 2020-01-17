// -----------------------------------------------------------------------------
// This file is part of vAmiga
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

extension Inspector {

    func cacheCopper(count: Int = 0) {

        if amiga != nil {

            copperInfo = amiga!.agnus.getCopperInfo()
            if count % 4 == 0 {
                copList1.cache()
                copList2.cache()
            }
        }
    }

    func refreshCopper(everything: Bool) {

        if everything {

            let elements = [ copCOPPC: fmt24,
                             copCOPINS1: fmt16,
                             copCOPINS2: fmt16,
                             copCOP1LC: fmt24,
                             copCOP2LC: fmt24
            ]
            for (c, f) in elements { assignFormatter(f, c!) }
        }

        if copperInfo == nil { return }

        copActive.state = copperInfo!.active ? .on : .off
        copCDANG.state = copperInfo!.cdang ? .on : .off
        copCOPPC.integerValue = Int(copperInfo!.coppc)
        copCOPINS1.integerValue = Int(copperInfo!.cop1ins)
        copCOPINS2.integerValue = Int(copperInfo!.cop2ins)
        copCOP1LC.integerValue = Int(copperInfo!.cop1lc)
        copCOP2LC.integerValue = Int(copperInfo!.cop2lc)

        copList1.refresh(everything: everything)
        copList2.refresh(everything: everything)
    }
 
    @IBAction func copCOPLCAction(_ sender: NSTextField!) {
        
        track()
    }
    
}
