// -----------------------------------------------------------------------------
// This file is part of vAmiga
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

import AppKit

public extension MetalView {

    //
    // Keyboard events
    //
    
    override func keyDown(with event: NSEvent) {

        parent.kbController.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {

        parent.kbController.keyUp(with: event)
    }
    
    override func flagsChanged(with event: NSEvent) {
        
        parent.kbController.flagsChanged(with: event)
    }
    
    //
    // Mouse events
    //
    
    func retainMouse() {
        
        NSCursor.hide()
        CGAssociateMouseAndMouseCursorPosition(boolean_t(truncating: false))
        gotMouse = true
    }
    
    func releaseMouse() {
        
        NSCursor.unhide()
        CGAssociateMouseAndMouseCursorPosition(boolean_t(truncating: true))
        gotMouse = false
    }
    
    override func updateTrackingAreas() {

        let options: NSTrackingArea.Options = [ .activeInKeyWindow, .mouseEnteredAndExited ]
        
        if trackingArea != nil {
            removeTrackingArea(trackingArea!)
        }
        trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        addTrackingArea(trackingArea!)
    }
    
    override func mouseEntered(with event: NSEvent) {
        
        insideTrackingArea = true
        
        // Check if we need to retain the mouse
        if prefs.retainMouseByEntering {
   
            // Only retain if the user didn't shake the mouse recently
            if DispatchTime.diffMilliSec(lastShake) > UInt64(500) {
                retainMouse()
            } else {
                track("Last shake too recent")
            }
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        
        insideTrackingArea = false
        releaseMouse()
    }
    
    override func mouseDown(with event: NSEvent) {

        if gotMouse {
            parent.amiga.mouse.setLeftButton(true)
            return
        }
        
        // Check if we need to retain the mouse
        if prefs.retainMouseByClick && insideTrackingArea {
            retainMouse()
        }
    }
    
    override func mouseUp(with event: NSEvent) {

        if gotMouse {
            parent.amiga.mouse.setLeftButton(false)
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {

        if gotMouse {
            parent.amiga.mouse.setRightButton(true)
        }
    }

    override func rightMouseUp(with event: NSEvent) {

        if gotMouse {
            parent.amiga.mouse.setRightButton(false)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        
        if gotMouse {
            
            // Determine delta movement steps
            let dx = event.deltaX
            let dy = event.deltaY
            
            parent.mouseXY.x += dx
            parent.mouseXY.y += dy
            
            // Make coordinate independent of the actual window size
            let scaleX = (256.0 * 400.0) / frame.width
            let scaleY = (256.0 * 300.0) / frame.height
            let newX = parent.mouseXY.x * scaleX
            let newY = parent.mouseXY.y * scaleY
            let newLocation = NSPoint.init(x: newX, y: newY)
            
            // Report the new location to the Amiga mouse
            parent.amiga.mouse.setXY(newLocation)
            
            // Check for a shaking mouse movement
            if prefs.releaseMouseByShaking && mouseIsShaking(dx: dx, dy: dy) {
                releaseMouse()
            }
        }
    }
    
    override func mouseDragged(with event: NSEvent) {

        mouseMoved(with: event)
    }
    
    override func rightMouseDragged(with event: NSEvent) {

        mouseMoved(with: event)
    }
    
    func checkForMouseKeys(with event: NSEvent) {
                
        if !gotMouse && prefs.retainMouseWithKeys {
            
            switch prefs.retainMouseKeyComb {
              
            case 0 where event.modifierFlags.contains([.option, .command]),
                 1 where event.modifierFlags.contains([.option, .control]):
                
                track()
                retainMouse()
                
            default: break
            }

        } else if gotMouse && prefs.releaseMouseWithKeys {
            
            switch prefs.releaseMouseKeyComb {
                
            case 0 where event.modifierFlags.contains([.option, .command]),
                 1 where event.modifierFlags.contains([.option, .control]):
                
                track()
                releaseMouse()
                
            default: break
            }
        }
    }
    
    func mouseIsShaking(dx: CGFloat, dy: CGFloat) -> Bool {
        
        // Accumulate the travelled distance
        dxsum += abs(dx)
        
        // Check for a direction reversal
        if dx * dxsign < 0 {
        
            let dt = DispatchTime.diffMilliSec(lastTurn)
            dxsign = -dxsign

            // track("\(dxturns) \(dxsign) \(dx) \(dxabssum) \(dt)")

            // A direction reversal is considered part of a shake, if the
            // previous reversal happened a short while ago.
            if dt < 400 {
      
                // Eliminate jitter by demanding that the mouse has travelled
                // a long enough distance.
                if dxsum > 400 {
                    
                    dxturns += 1
                    dxsum = 0
                    
                    // Report a shake if the threshold has been reached.
                    if dxturns > 3 {
                        
                        // track("Mouse shake detected")
                        lastShake = DispatchTime.now()
                        dxturns = 0
                        return true
                    }
                }
                
            } else {
                
                // Time out. The user is definitely not shaking the mouse.
                // Let's reset the recorded movement histoy.
                dxturns = 0
                dxsum = 0
            }
            
            lastTurn = DispatchTime.now()
        }
        
        return false
    }
}
