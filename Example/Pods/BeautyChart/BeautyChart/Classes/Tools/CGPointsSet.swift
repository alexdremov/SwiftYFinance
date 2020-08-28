import Foundation
import SwiftUI

public struct CGPointsSet{
    var points:[CGPoint] = []
    
    
    
    var count:Int{
        return points.count
    }
    
    var limits:((CGFloat, CGFloat), (CGFloat, CGFloat)){
        var minx:CGFloat? = nil
        var maxx:CGFloat? = nil
        var miny:CGFloat? = nil
        var maxy:CGFloat? = nil
        
        for point in points{
            minx = min(point.x, minx ?? point.x)
            maxx = max(point.x, maxx ?? point.x)
            
            miny = min(point.y, miny ?? point.y)
            maxy = max(point.y, maxy ?? point.y)
        }
        return ((minx ?? 0, maxx ?? 0), (miny ?? 0, maxy ?? 0))
    }
    
    var ranges:(CGFloat, CGFloat){
        return rangeForLimits(lims: self.limits)
    }
    
    func rangeForLimits(lims:((CGFloat, CGFloat), (CGFloat, CGFloat)))->(CGFloat, CGFloat){
        return ((lims.0.1-lims.0.0),  (lims.1.1-lims.1.0))
    }
    
    func affineTransformed(width:Float, height:Float, vMirrored:Bool = true)->[CGPoint]{
        var res:[CGPoint] = []
        for i in 0..<self.points.count{
            let newPoint = self.affineTransformed(i: i, width: width, height: height)
            res.append(newPoint)
        }
        return res
       }
    
    func affineTransformed(i:Int, width:Float, height:Float, vMirrored:Bool = true)->CGPoint{
        let point = points[i]
        let limitsCache = self.limits
        let rangeCache = self.rangeForLimits(lims: limitsCache)
        
        if (points.count<=1){
            return CGPoint(x: 0, y: 0)
        }
        
        let newX = (point.x - limitsCache.0.0) / rangeCache.0 * CGFloat(width)
        
        var newY = (point.y - limitsCache.1.0) / rangeCache.1 * CGFloat(height)
        
        if vMirrored{
            newY = CGFloat(height) - newY
        }
        
        return CGPoint(x: newX, y: newY)
    }
    
    func reverseAffine(_ point:CGPoint, width:Float, height:Float, vMirrored:Bool = true)->CGPoint{
        let limitsCache = self.limits
        let rangeCache = self.rangeForLimits(lims: limitsCache)
        
        var newX = point.x
        var newY = point.y
        
        if vMirrored{
            newY = CGFloat(height) - newY 
        }
        
        newX = (newX) * rangeCache.0 / CGFloat(width) + limitsCache.0.0
        newY = (newY) * rangeCache.1 / CGFloat(height) + limitsCache.1.0
        
        
        return CGPoint(x: newX, y: newY)
    }
    
    func closestPoint(_ refPoint:CGPoint, axes:[Axis] = [.horizontal, .vertical])->CGPoint{
        if (self.points.count == 0){
            return CGPoint(x: 0, y:0)
        }
        var point = points[0]
        for i in 1..<points.count{
            switch axes {
            case let x where x.count == 0:
                 return refPoint
            case let x where x.count == 2:
                if refPoint.dist(to: point) > refPoint.dist(to: points[i]){
                    point = points[i]
                }
            case let x where x[0] == .horizontal:
                if abs(refPoint.x - point.x) > abs(refPoint.x - points[i].x) {
                    point = points[i]
                }
            case let x where x[0] == .vertical:
            if abs(refPoint.x - point.x) > abs(refPoint.x - points[i].x) {
                point = points[i]
            }
            default:
                return refPoint
            }
            
        }
        return point
    }
    
    subscript(i:Int)->CGPoint{
        points[i]
    }
}
