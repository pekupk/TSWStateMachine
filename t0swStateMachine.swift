//
//  t0swStateMachine.swift
//  GPKitTest
//
//  Created by Tmi Parabits on 21/05/2018.
//  Copyright © 2018 Thousand Software. All rights reserved.
//

//
// GameplayKit GKState and GKStateMachine class clones, e.g., for WatchKit
//
// Implements update, isValidNextState, didEnter, update, enter and init
// with states array for state machine.
//

import Foundation


class TSWStateNone {
    
    public var stateMachine:TSWStateMachine?
    
    public func update(deltaTime seconds: TimeInterval) {
        
        //
        // override in subclass
        //
        
    }
    
    func isValidNextState(_ state: AnyClass ) -> Bool {
        
        //
        // TSWStateNone returns true for all states as valid next states.
        //
        
        return true
        
    }
}


class TSWState:TSWStateNone {
    
    func didEnter(from previousState: TSWState?)
    {
        //
        // override in subclass
        //
    }
    
    override func isValidNextState(_ state: AnyClass ) -> Bool {
        
        //
        // override in subclass, returns false by default
        //
        return false
        
    }
}


class TSWStateMachine {
    
    var states:[TSWState]
    
    var currentState:Int
    
    init(states array:[TSWState]) {
        
        self.states=array
        self.currentState = -1
        
        for (_ , st) in self.states.enumerated() {
            st.stateMachine=self
        }
        
    }
    
    func update(deltaTime seconds: TimeInterval) {
        
        self.getCurrentState().update(deltaTime: seconds)
        
    }
    
    
    func getCurrentState() -> TSWStateNone {
        
        if (currentState == -1) {
            return TSWStateNone()
        }
        
        return states[currentState]
        
    }
    
    func enter(_ stateType:TSWState.Type) {
        
        if let currentState=self.getCurrentState() as? TSWState {
        
            if (currentState.isValidNextState(stateType)) {
                
                let previousState=currentState
                
                for (index, st) in self.states.enumerated() {
                    
                    
                    if (type(of: st) == stateType) {
                        
                        st.didEnter(from: previousState)
                        
                        self.currentState = index
                        return
                        
                    } 
                    
                }
            }
            
        } else { // we are setting the initial state
            
            
            for (index, st) in self.states.enumerated() {
                
                
                if (type(of: st) == stateType) {
                    
                    st.didEnter(from: TSWState?.none)
                    
                    self.currentState = index
                    return
                    
                } 
            }
            
        }
    }
}

