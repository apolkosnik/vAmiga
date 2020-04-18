// -----------------------------------------------------------------------------
// This file is part of vAmiga
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

/* All user-customizable items are managed by two different classes.
 *
 * Preferences
 * This class stores all items that belong to the application level. There is
 * a single object of this class and the stored values apply to all emulator
 * instances.
 *
 * Configuration
 * This class stores all items that are specific to an individual emulator
 * instance. Each instance keeps its own object of this class.
 */

class Preferences {
    
    var parent: MyAppDelegate!
 
    //
    // General
    //
        
    // Floppy
    var warpLoad = GeneralDefaults.std.warpLoad {
        didSet { for c in parent.controllers { c.updateWarp() } }
    }
    var driveSounds = GeneralDefaults.std.driveSounds
    var driveSoundPan = GeneralDefaults.std.driveSoundPan
    var driveInsertSound = GeneralDefaults.std.driveInsertSound
    var driveEjectSound = GeneralDefaults.std.driveEjectSound
    var driveHeadSound = GeneralDefaults.std.driveHeadSound
    var drivePollSound = GeneralDefaults.std.drivePollSound
    var driveBlankDiskFormat = GeneralDefaults.std.driveBlankDiskFormat
    var driveBlankDiskFormatIntValue: Int {
        get { return Int(driveBlankDiskFormat.rawValue) }
        set { driveBlankDiskFormat = FileSystemType.init(newValue) }
    }
    
    // Fullscreen
    var keepAspectRatio = GeneralDefaults.std.keepAspectRatio
    var exitOnEsc = GeneralDefaults.std.exitOnEsc
        
    // Snapshots and screenshots
    var autoSnapshots = GeneralDefaults.std.autoSnapshots
    var snapshotInterval = 0 {
        didSet { for c in parent.controllers { c.startSnapshotTimer() } }
    }
    var autoScreenshots = GeneralDefaults.std.autoScreenshots
    var screenshotInterval = 0 {
        didSet { for c in parent.controllers { c.startScreenshotTimer() } }
    }
    var screenshotSource = GeneralDefaults.std.screenshotSource
    var screenshotTarget = GeneralDefaults.std.screenshotTarget
    var screenshotTargetIntValue: Int {
        get { return Int(screenshotTarget.rawValue) }
        set { screenshotTarget = NSBitmapImageRep.FileType(rawValue: UInt(newValue))! }
    }
    
    // Misc
    var closeWithoutAsking = GeneralDefaults.std.closeWithoutAsking
    var ejectWithoutAsking = GeneralDefaults.std.ejectWithoutAsking
    var pauseInBackground = GeneralDefaults.std.pauseInBackground

    //
    // Devices preferences
    //
        
    // Emulation keys
    var keyMaps = [ DevicesDefaults.std.joyKeyMap1,
                     DevicesDefaults.std.joyKeyMap2,
                     DevicesDefaults.std.mouseKeyMap ]
    
    // Joystick
    var disconnectJoyKeys = DevicesDefaults.std.disconnectJoyKeys
    var autofire = DevicesDefaults.std.autofire {
        didSet {
            for amiga in myAppDelegate.proxies {
                amiga.joystick1.setAutofire(autofire)
                amiga.joystick2.setAutofire(autofire)
            }
        }
    }
    var autofireBullets = DevicesDefaults.std.autofireBullets {
        didSet {
            for amiga in myAppDelegate.proxies {
                amiga.joystick1.setAutofireBullets(autofireBullets)
                amiga.joystick2.setAutofireBullets(autofireBullets)
            }
        }
    }
    var autofireFrequency = DevicesDefaults.std.autofireFrequency {
        didSet {
            for amiga in myAppDelegate.proxies {
                amiga.joystick1.setAutofireFrequency(autofireFrequency)
                amiga.joystick2.setAutofireFrequency(autofireFrequency)
            }
        }
    }
    
    // Mouse
    var retainMouseKeyComb = DevicesDefaults.std.retainMouseKeyComb
    var retainMouseWithKeys = DevicesDefaults.std.retainMouseWithKeys
    var retainMouseByClick = DevicesDefaults.std.retainMouseByClick
    var retainMouseByEntering = DevicesDefaults.std.retainMouseByEntering
    var releaseMouseKeyComb = DevicesDefaults.std.retainMouseKeyComb
    var releaseMouseWithKeys = DevicesDefaults.std.releaseMouseWithKeys
    var releaseMouseByShaking = DevicesDefaults.std.releaseMouseByShaking
 
    init(with delegate: MyAppDelegate) { parent = delegate }
    
    //
    // General
    //
    
    func loadGeneralDefaults(_ defaults: GeneralDefaults) {
        
        // Floppy
        warpLoad = defaults.warpLoad
        driveSounds = defaults.driveSounds
        driveSoundPan = defaults.driveSoundPan
        driveInsertSound = defaults.driveInsertSound
        driveEjectSound = defaults.driveEjectSound
        driveHeadSound = defaults.driveHeadSound
        drivePollSound = defaults.drivePollSound
        driveBlankDiskFormat = defaults.driveBlankDiskFormat

        // Fullscreen
        keepAspectRatio = defaults.keepAspectRatio
        exitOnEsc = defaults.exitOnEsc

        // Snapshots and screenshots
        autoSnapshots = defaults.autoSnapshots
        snapshotInterval = defaults.autoSnapshotInterval
        autoScreenshots = defaults.autoScreenshots
        screenshotInterval = defaults.autoScreenshotInterval
        screenshotSource = defaults.screenshotSource
        screenshotTarget = defaults.screenshotTarget
        
        // Misc
        pauseInBackground = defaults.pauseInBackground
        closeWithoutAsking = defaults.closeWithoutAsking
        ejectWithoutAsking = defaults.ejectWithoutAsking
    }
    
    func loadGeneralUserDefaults() {
        
        let defaults = UserDefaults.standard
           
        // Floppy
        warpLoad = defaults.bool(forKey: Keys.warpLoad)
        driveSounds = defaults.bool(forKey: Keys.driveSounds)
        driveSoundPan = defaults.double(forKey: Keys.driveSoundPan)
        driveInsertSound = defaults.bool(forKey: Keys.driveInsertSound)
        driveEjectSound = defaults.bool(forKey: Keys.driveEjectSound)
        driveHeadSound = defaults.bool(forKey: Keys.driveHeadSound)
        drivePollSound = defaults.bool(forKey: Keys.drivePollSound)
        driveBlankDiskFormatIntValue = defaults.integer(forKey: Keys.driveBlankDiskFormat)
        
        // Fullscreen
        keepAspectRatio = defaults.bool(forKey: Keys.keepAspectRatio)
        exitOnEsc = defaults.bool(forKey: Keys.exitOnEsc)

        // Snapshots and screenshots
        autoSnapshots = defaults.bool(forKey: Keys.autoSnapshots)
        snapshotInterval = defaults.integer(forKey: Keys.autoSnapshotInterval)
        autoScreenshots = defaults.bool(forKey: Keys.autoScreenshots)
        screenshotInterval = defaults.integer(forKey: Keys.autoScreenshotInterval)
        screenshotSource = defaults.integer(forKey: Keys.screenshotSource)
        screenshotTargetIntValue = defaults.integer(forKey: Keys.screenshotTarget)
    
        // Misc
        pauseInBackground = defaults.bool(forKey: Keys.pauseInBackground)
        closeWithoutAsking = defaults.bool(forKey: Keys.closeWithoutAsking)
        ejectWithoutAsking = defaults.bool(forKey: Keys.ejectWithoutAsking)
    }
    
    func saveGeneralUserDefaults() {
        
        let defaults = UserDefaults.standard
        
        // Floppy
        defaults.set(warpLoad, forKey: Keys.warpLoad)
        defaults.set(driveSounds, forKey: Keys.driveSounds)
        defaults.set(driveSoundPan, forKey: Keys.driveSoundPan)
        defaults.set(driveInsertSound, forKey: Keys.driveInsertSound)
        defaults.set(driveEjectSound, forKey: Keys.driveEjectSound)
        defaults.set(driveHeadSound, forKey: Keys.driveHeadSound)
        defaults.set(drivePollSound, forKey: Keys.drivePollSound)
        defaults.set(driveBlankDiskFormatIntValue, forKey: Keys.driveBlankDiskFormat)
        
        // Fullscreen
        defaults.set(keepAspectRatio, forKey: Keys.keepAspectRatio)
        defaults.set(exitOnEsc, forKey: Keys.exitOnEsc)

        // Snapshots and screenshots
        defaults.set(autoSnapshots, forKey: Keys.autoSnapshots)
        defaults.set(snapshotInterval, forKey: Keys.autoSnapshotInterval)
        defaults.set(autoScreenshots, forKey: Keys.autoScreenshots)
        defaults.set(screenshotInterval, forKey: Keys.autoScreenshotInterval)
        defaults.set(screenshotSource, forKey: Keys.screenshotSource)
        defaults.set(screenshotTargetIntValue, forKey: Keys.screenshotTarget)
        
        // Misc
        defaults.set(pauseInBackground, forKey: Keys.pauseInBackground)
        defaults.set(closeWithoutAsking, forKey: Keys.closeWithoutAsking)
        defaults.set(ejectWithoutAsking, forKey: Keys.ejectWithoutAsking)
    }
    
    //
    // Devices
    //
    
    func loadDevicesDefaults(_ defaults: DevicesDefaults) {
        
        // Emulation keys
        keyMaps[0] = defaults.joyKeyMap1
        keyMaps[1] = defaults.joyKeyMap2
        keyMaps[2] = defaults.mouseKeyMap
        disconnectJoyKeys = defaults.disconnectJoyKeys
        
        // Joysticks
        autofire = defaults.autofire
        autofireBullets = defaults.autofireBullets
        autofireFrequency = defaults.autofireFrequency
        
        // Mouse
        retainMouseKeyComb = defaults.retainMouseKeyComb
        retainMouseWithKeys = defaults.retainMouseWithKeys
        retainMouseByClick = defaults.retainMouseByClick
        retainMouseByEntering = defaults.retainMouseByEntering
        releaseMouseKeyComb = defaults.releaseMouseKeyComb
        releaseMouseWithKeys = defaults.releaseMouseWithKeys
        releaseMouseByShaking = defaults.releaseMouseByShaking
    }
    
    func loadDevicesUserDefaults() {
        
        let defaults = UserDefaults.standard
        
        // Emulation keys
        defaults.decode(&keyMaps[0], forKey: Keys.joyKeyMap1)
        defaults.decode(&keyMaps[1], forKey: Keys.joyKeyMap2)
        defaults.decode(&keyMaps[2], forKey: Keys.mouseKeyMap)
        disconnectJoyKeys = defaults.bool(forKey: Keys.disconnectJoyKeys)
        
        // Joysticks
        autofire = defaults.bool(forKey: Keys.autofire)
        autofireBullets = defaults.integer(forKey: Keys.autofireBullets)
        autofireFrequency = defaults.float(forKey: Keys.autofireFrequency)
        
        // Mouse
        retainMouseKeyComb = defaults.integer(forKey: Keys.retainMouseKeyComb)
        retainMouseWithKeys = defaults.bool(forKey: Keys.retainMouseWithKeys)
        retainMouseByClick = defaults.bool(forKey: Keys.retainMouseByClick)
        retainMouseByEntering = defaults.bool(forKey: Keys.retainMouseByEntering)
        releaseMouseKeyComb = defaults.integer(forKey: Keys.releaseMouseKeyComb)
        releaseMouseWithKeys = defaults.bool(forKey: Keys.releaseMouseWithKeys)
        releaseMouseByShaking = defaults.bool(forKey: Keys.releaseMouseByShaking)
    }
    
    func saveDevicesUserDefaults() {
        
        let defaults = UserDefaults.standard
        
        // Emulation keys
        defaults.encode(keyMaps[0], forKey: Keys.joyKeyMap1)
        defaults.encode(keyMaps[1], forKey: Keys.joyKeyMap2)
        defaults.encode(keyMaps[2], forKey: Keys.mouseKeyMap)
        defaults.set(disconnectJoyKeys, forKey: Keys.disconnectJoyKeys)
        
        // Joysticks
        defaults.set(autofire, forKey: Keys.autofire)
        defaults.set(autofireBullets, forKey: Keys.autofireBullets)
        defaults.set(autofireFrequency, forKey: Keys.autofireFrequency)
        
        // Mouse
        defaults.set(retainMouseKeyComb, forKey: Keys.retainMouseKeyComb)
        defaults.set(retainMouseWithKeys, forKey: Keys.retainMouseWithKeys)
        defaults.set(retainMouseByClick, forKey: Keys.retainMouseByClick)
        defaults.set(retainMouseByEntering, forKey: Keys.retainMouseByEntering)
        defaults.set(releaseMouseKeyComb, forKey: Keys.releaseMouseKeyComb)
        defaults.set(releaseMouseWithKeys, forKey: Keys.releaseMouseWithKeys)
        defaults.set(releaseMouseByShaking, forKey: Keys.releaseMouseByShaking)
    }
}
