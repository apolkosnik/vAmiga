// -----------------------------------------------------------------------------
// This file is part of vAmiga
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

class Monitor: DialogController {

    // Display colors
    @IBOutlet weak var colCopper: NSColorWell!
    @IBOutlet weak var colBlitter: NSColorWell!
    @IBOutlet weak var colDisk: NSColorWell!
    @IBOutlet weak var colAudio: NSColorWell!
    @IBOutlet weak var colSprites: NSColorWell!
    @IBOutlet weak var colBitplanes: NSColorWell!
    @IBOutlet weak var colCPU: NSColorWell!
    @IBOutlet weak var colRefresh: NSColorWell!
    
    // Bus debugger
    @IBOutlet weak var busEnable: NSButton!
    
    @IBOutlet weak var busCopper: NSButton!
    @IBOutlet weak var busBlitter: NSButton!
    @IBOutlet weak var busDisk: NSButton!
    @IBOutlet weak var busAudio: NSButton!
    @IBOutlet weak var busSprites: NSButton!
    @IBOutlet weak var busBitplanes: NSButton!
    @IBOutlet weak var busCPU: NSButton!
    @IBOutlet weak var busRefresh: NSButton!
        
    @IBOutlet weak var busOpacity: NSSlider!
    @IBOutlet weak var busDisplayMode: NSPopUpButton!
    
    // Activity monitors
    @IBOutlet weak var monEnable: NSButton!
    
    @IBOutlet weak var monCopper: NSButton!
    @IBOutlet weak var monBlitter: NSButton!
    @IBOutlet weak var monDisk: NSButton!
    @IBOutlet weak var monAudio: NSButton!
    @IBOutlet weak var monSprites: NSButton!
    @IBOutlet weak var monBitplanes: NSButton!

    @IBOutlet weak var monWaveforms: NSButton!
    @IBOutlet weak var monChipRam: NSButton!
    @IBOutlet weak var monSlowRam: NSButton!
    @IBOutlet weak var monFastRam: NSButton!
    @IBOutlet weak var monKickRom: NSButton!

    @IBOutlet weak var monOpacity: NSSlider!
    @IBOutlet weak var monDisplayMode: NSPopUpButton!
    @IBOutlet weak var monSlider: NSSlider!

    override func awakeFromNib() {

        track()
        refresh()
    }

    override func refresh() {
        
        let info = amiga.agnus.getDebuggerInfo()
        
        let visualize = [
            info.visualize.0,
            info.visualize.1,
            info.visualize.2,
            info.visualize.3,
            info.visualize.4,
            info.visualize.5,
            info.visualize.6,
            info.visualize.7,
            info.visualize.8
        ]
        let rgb = [
            info.colorRGB.0,
            info.colorRGB.1,
            info.colorRGB.2,
            info.colorRGB.3,
            info.colorRGB.4,
            info.colorRGB.5,
            info.colorRGB.6,
            info.colorRGB.7,
            info.colorRGB.8
        ]
        
        // Bus debugger
        busEnable.state = info.enabled ? .on : .off
        busBlitter.state = visualize[Int(BUS_BLITTER.rawValue)] ? .on : .off
        busCopper.state = visualize[Int(BUS_COPPER.rawValue)] ? .on : .off
        busDisk.state = visualize[Int(BUS_DISK.rawValue)] ? .on : .off
        busAudio.state = visualize[Int(BUS_AUDIO.rawValue)] ? .on : .off
        busSprites.state = visualize[Int(BUS_SPRITE.rawValue)] ? .on : .off
        busBitplanes.state = visualize[Int(BUS_BITPLANE.rawValue)] ? .on : .off
        busCPU.state = visualize[Int(BUS_CPU.rawValue)] ? .on : .off
        busRefresh.state = visualize[Int(BUS_REFRESH.rawValue)] ? .on : .off
        busOpacity.doubleValue = info.opacity * 100.0
        busDisplayMode.selectItem(withTag: info.displayMode.rawValue)

        // Activity monitors
        monEnable.state = parent.renderer.drawActivityMonitors ? .on : .off
        monCopper.state = parent.renderer.monitorEnabled[0] ? .on : .off
        monBlitter.state = parent.renderer.monitorEnabled[1] ? .on : .off
        monDisk.state = parent.renderer.monitorEnabled[2] ? .on : .off
        monAudio.state = parent.renderer.monitorEnabled[3] ? .on : .off
        monSprites.state = parent.renderer.monitorEnabled[4] ? .on : .off
        monBitplanes.state = parent.renderer.monitorEnabled[5] ? .on : .off
        monWaveforms.state = .off
        monChipRam.state = .off
        monSlowRam.state = .off
        monFastRam.state = .off
        monKickRom.state = .off
        monOpacity.floatValue = parent.renderer.monitorGlobalAlpha * 100.0
        monSlider.floatValue = parent.renderer.dmaMonitors[0]!.angle
        switch parent.renderer.dmaMonitors[0]!.rotationSide {
        case .lower: monDisplayMode.selectItem(withTag: 0)
        case .upper: monDisplayMode.selectItem(withTag: 1)
        case .left: monDisplayMode.selectItem(withTag: 2)
        case .right: monDisplayMode.selectItem(withTag: 3)
        }
        
        // Colors
        colBlitter.setColor(rgb[Int(BUS_BLITTER.rawValue)])
        colCopper.setColor(rgb[Int(BUS_COPPER.rawValue)])
        colDisk.setColor(rgb[Int(BUS_DISK.rawValue)])
        colAudio.setColor(rgb[Int(BUS_AUDIO.rawValue)])
        colSprites.setColor(rgb[Int(BUS_SPRITE.rawValue)])
        colBitplanes.setColor(rgb[Int(BUS_BITPLANE.rawValue)])
        colCPU.setColor(rgb[Int(BUS_CPU.rawValue)])
        colRefresh.setColor(rgb[Int(BUS_REFRESH.rawValue)])
    }

    //
    // Action methods
    //
    
    func busOwner(forTag tag: Int) -> BusOwner {
        
        track("tag = \(tag)")

        switch tag {
        case 0: return BUS_COPPER
        case 1: return BUS_BLITTER
        case 2: return BUS_DISK
        case 3: return BUS_AUDIO
        case 4: return BUS_SPRITE
        case 5: return BUS_BITPLANE
        case 6: return BUS_CPU
        case 7: return BUS_REFRESH
        default: fatalError()
        }
    }
    
    @IBAction func colorAction(_ sender: NSColorWell!) {
        
        let owner = busOwner(forTag: sender.tag)
        let r = Double(sender.color.redComponent)
        let g = Double(sender.color.greenComponent)
        let b = Double(sender.color.blueComponent)
        amiga.agnus.dmaDebugSetColor(owner, r: r, g: g, b: b)
        parent.renderer.monitor(forTag: sender.tag)?.color = sender.color
        refresh()
    }

    @IBAction func busEnableAction(_ sender: NSButton!) {
        
        amiga.agnus.dmaDebugSetEnable(sender.state == .on)
        refresh()
    }
    
    @IBAction func busDisplayAction(_ sender: NSButton!) {
        
        let owner = busOwner(forTag: sender.tag)
        amiga.agnus.dmaDebugSetVisualize(owner, value: sender.state == .on)
        refresh()
    }
    
    @IBAction func busDisplayModeAction(_ sender: NSPopUpButton!) {
        
        amiga.agnus.dmaDebugSetDisplayMode(sender.selectedTag())
        refresh()
    }
    
    @IBAction func busOpacityAction(_ sender: NSSlider!) {
        
        amiga.agnus.dmaDebugSetOpacity(sender.doubleValue / 100.0)
        refresh()
    }
    
    @IBAction func monEnableAction(_ sender: NSButton!) {
    
        parent.renderer.drawActivityMonitors = sender.state == .on
        refresh()
    }
    
    @IBAction func monDisplayAction(_ sender: NSButton!) {
        
        track("\(sender.tag)")
        parent.renderer.monitorEnabled[sender.tag] = sender.state == .on
        refresh()
    }
    
    @IBAction func monDisplayModeAction(_ sender: NSPopUpButton!) {
        
        track("\(sender.selectedTag())")
        for i in 0 ..< parent.renderer.dmaMonitors.count {
            switch sender.selectedTag() {
            case 0: parent.renderer.dmaMonitors[i]?.rotationSide = .lower
            case 1: parent.renderer.dmaMonitors[i]?.rotationSide = .upper
            case 2: parent.renderer.dmaMonitors[i]?.rotationSide = .left
            case 3: parent.renderer.dmaMonitors[i]?.rotationSide = .right
            default: fatalError()
            }
        }
        parent.renderer.updateMonitorPositions()
        refresh()
    }
    
    @IBAction func monRotationAction(_ sender: NSSlider!) {
        
        track()
        for i in 0 ..< parent.renderer.dmaMonitors.count {
            parent.renderer.dmaMonitors[i]?.angle = sender.floatValue
        }
        refresh()
    }
    
    @IBAction func monOpacityAction(_ sender: NSSlider!) {
        
        parent.renderer.monitorGlobalAlpha = sender.floatValue / 100.0
        refresh()
    }
}

extension Monitor: NSWindowDelegate {

    func windowWillClose(_ notification: Notification) {

        track("Closing monitor")
    }
}

extension NSColorWell {
    
    func setColor(_ rgb: (Double, Double, Double) ) {
        
        color = NSColor.init(r: rgb.0, g: rgb.1, b: rgb.2)
    }
}
