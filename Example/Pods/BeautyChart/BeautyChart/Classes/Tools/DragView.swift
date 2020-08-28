import SwiftUI
import simd

/// Data structure used to store CGPath commands for easier manipulation of individual components
struct PathCommand {
    let type: CGPathElementType
    let point: CGPoint
    let controlPoints: [CGPoint]
}

// MARK: CGPath Extensions

extension CGPath {
    /// Provides access to the information of each individual path command in order.
    func forEach( body: @escaping @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
    
    /// Returns an array of all path command data of the CGPath
    func commands() -> [PathCommand] {
        var pathCommands = [PathCommand]()
        self.forEach(body: { (element: CGPathElement) in
            let numberOfPoints: Int = {
                switch element.type {
                    case .moveToPoint, .addLineToPoint:
                        return 1
                    case .addQuadCurveToPoint:
                        return 2
                    case .addCurveToPoint:
                        return 3
                    case .closeSubpath:
                        return 0
                    @unknown default:
                        return 0
                }
            }()
            var points = [CGPoint]()
            
            for index in 0..<(numberOfPoints) {
                let point = element.points[index]
                points.append(point)
            }
            let command = PathCommand(type: element.type, point: element.points[numberOfPoints - 1], controlPoints: points)
            pathCommands.append(command)
        })
        return pathCommands
    }
    
    
    
    /// Convenience for accessing the value of the first point in the CGPath
    func getStartPoint() -> CGPoint {
        return commands()[0].point
    }
    
    
}


// MARK: Look Up Table

/// # Sampled Path Points Look Up Table
///
/// Contains a reference to a sample of points for the given CGPath
///
/// Using the equations for the linear, quadratic and cubic bezier curve components, we can interpolate and sample locations within each segment of the Path.
/// After generating our sampled points, we keep a reference of the locations to compare with the views current location.  We then find which point on the curve
/// is closest to our views current location.
///
class LookUpTable: ObservableObject {
    
    /// Lookup table is an array containing real points for the path.
    private(set) var lookupTable = [CGPoint]()
    var cgPath: CGPath
    
    var capacity:UInt
    
    init(path: Path, capacity:UInt=1000) {
        self.cgPath = path.cgPath
        self.capacity = capacity
        generateLookupTable()
    }
    
    
    func generateLookupTable() {
        let commands = cgPath.commands()
        var previousPoint: CGPoint?
        let lookupTableCapacity = Int(capacity)
        let commandCount = commands.count
        guard commandCount > 0 else {
            return
        }
        let numberOfDivisions = lookupTableCapacity / commandCount
        let divisions = 0...numberOfDivisions
        for command in commands {
            let endPoint = command.point
            guard let startPoint = previousPoint else {
                previousPoint = endPoint
                continue
            }
            switch command.type {
                
                case .addLineToPoint:
                    lookupTable.append(contentsOf: divisions.map {
                        lerp(t: Double($0) / Double(numberOfDivisions), p1: startPoint, p2: endPoint)
                    })
                
                case .addQuadCurveToPoint:
                    lookupTable.append(contentsOf: divisions.map {
                        quadraticInterpolation(t: Double($0) / Double(numberOfDivisions), p1: startPoint, p2: command.controlPoints[0], p3: endPoint)
                    })
                
                case .addCurveToPoint:
                    lookupTable.append(contentsOf: divisions.map {
                        cubicInterpolation(t: Double($0) / Double(numberOfDivisions), p1: startPoint, p2: command.controlPoints[0], p3: command.controlPoints[1], p4: endPoint)
                    })
                
                case .closeSubpath:
                    lookupTable.append(contentsOf: divisions.map {
                        lerp(t: Double($0) / Double(numberOfDivisions), p1: startPoint, p2: lookupTable[0])
                    })
                
                default:
                    break
            }
            previousPoint = endPoint
        }
    }
    
    
    /// Calculates a point at given t value, where t in 0.0...1.0
    private func lerp(t: Double, p1: CGPoint, p2: CGPoint) -> CGPoint {
        let point = mix(simd_double2(x: Double(p1.x) ,y: Double(p1.y)), simd_double2(x: Double(p2.x) ,y: Double(p2.y)), t: t)
        return CGPoint(x: point.x, y: point.y)
    }
    
    /// Calculates a point at given t value, on the quadractic bezier segment where t in 0.0...1.0
    private func quadraticInterpolation(t: Double, p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGPoint {
        
        
        let a = (1-t)*(1-t)*simd_double2(x: Double(p1.x) ,y: Double(p1.y))
        let b = 2*(1-t)*t*simd_double2(x: Double(p2.x) ,y: Double(p2.y))
        let c = Double(t*t)*simd_double2(x: Double(p3.x) ,y: Double(p3.y))
        
        let final = a + b + c
        return CGPoint(x: final.x, y: final.y)
    }
    
    /// Calculates a point at given t value, on the cubic bezier segment  where t in 0.0...1.0
    private func cubicInterpolation(t: Double, p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) -> CGPoint {
        
        let a = (1-t)*(1-t)*(1-t)*simd_double2(x: Double(p1.x) ,y: Double(p1.y))
        let b = (1-t)*(1-t)*t*3*simd_double2(x: Double(p2.x) ,y: Double(p2.y))
        let c = (1-t)*t*t*3*simd_double2(x: Double(p3.x) ,y: Double(p3.y))
        let d = t*t*t*simd_double2(x: Double(p4.x) ,y: Double(p4.y))
        
        let final = a + b + d + c
        
        return CGPoint(x: final.x, y: final.y)
    }
    
    /// Finds the closest point on the curve to the drag gestures current offset.
    /// May be faster if I use functions from the vForce library, but simd doesnt seem to have any performance issues
    func getClosestPoint(fromPoint: CGPoint, axes:[Axis] = [.horizontal, .vertical]) -> CGPoint {
        
        let minimum = {
            (0..<lookupTable.count).map {
                (distance: distance_squared(simd_double2(x: Double(fromPoint.x), y:Double(fromPoint.y)), simd_double2(x: Double(lookupTable[$0].x), y: Double(lookupTable[$0].y))
                ), index: $0,
                distanceH: abs(fromPoint.x - lookupTable[$0].x),
                distanceV: abs(fromPoint.y - lookupTable[$0].y))
            }.min {
                if (axes.count == 2)
                {return $0.distance < $1.distance}
                else if axes.count == 0{
                    return false
                }else if axes[0] == .horizontal{
                    return $0.distanceH < $1.distanceH
                }else{
                    return $0.distanceV < $1.distanceV
                }
            }
        }()
        
        return lookupTable[minimum!.index]
    }
}

/// # Follow Path View Modifier
/// Use this modifier on a view which you would like to constrain to a certain shaped path.
struct FollowPath: ViewModifier {
    @ObservedObject var lookUpTable: LookUpTable
    @State private var position: CGPoint = .zero
    @State private var dragState: CGSize = .zero
    var path: Path
    
    func getDisplacement(closestPoint: CGPoint) -> CGSize {
        return CGSize(width: closestPoint.x - position.x, height: closestPoint.y - position.y)
    }
    
    var gesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("follow"))
            .onChanged { (value) in
                let closestPoint = self.lookUpTable.getClosestPoint(fromPoint: value.location)
                self.dragState = self.getDisplacement(closestPoint: closestPoint)
                
        }.onEnded { (value) in
            let closestPoint = self.lookUpTable.getClosestPoint(fromPoint: value.location)
            let displacement = self.getDisplacement(closestPoint: closestPoint)
            withAnimation(.linear) {
                self.position.x += displacement.width
                self.position.y += displacement.height
                self.dragState = .zero
            }
        }
    }
    
    func body(content: Content) -> some View {
        path.stroke(Color.blue, lineWidth: 1)
            .overlay(content.gesture(gesture).position(position).offset(dragState))
            .coordinateSpace(name: "follow")
            .onAppear(perform: {
                self.position = self.path.cgPath.getStartPoint()
            })
    }
    
    init(_ path: Path) {
        self.lookUpTable = LookUpTable(path: path)
        self.path = path
    }
}


extension View {
    
    func constrainToPath(_ path: Path) -> some View {
        self.modifier(FollowPath(path))
    }
}


// MARK: View

/// # Draggable Path Constrained View
/// Creates a draggable circular view constrained to the given Path
struct PathConstrained: View {
    
    @ObservedObject var lookup: LookUpTable
    @State var position: CGPoint = .zero
    @State var dragState: CGSize = .zero
    
    
    var path: Path
    
    init(_ path: Path) {
        self.lookup = LookUpTable(path: path)
        self.path = path
        self.lookup.generateLookupTable()
    }
    
    func getDisplacement(closestPoint: CGPoint) -> CGSize {
        return CGSize(width: closestPoint.x - position.x, height: closestPoint.y - position.y)
    }
    
    var gesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .named("MY"))
            .onChanged { (value) in
                let closestPoint = self.lookup.getClosestPoint(fromPoint: value.location)
                self.dragState = self.getDisplacement(closestPoint: closestPoint)
                
        }.onEnded { (value) in
            let closestPoint = self.lookup.getClosestPoint(fromPoint: value.location)
            let displacement = self.getDisplacement(closestPoint: closestPoint)
            withAnimation(.linear) {
                self.position.x += displacement.width
                self.position.y += displacement.height
                self.dragState = .zero
            }
        }
    }
    
    @State var myText: String = ""
    
    var thumb: some View {
        TextField("Testing", text: $myText)
            .foregroundColor(.blue)
            .frame(width: 100, height: 100, alignment: .center)
            .gesture(gesture)
            .position(x: position.x , y: position.y)
            .offset(x: dragState.width, y: dragState.height)
    }
    
    var body: some View {
        path
            .stroke(Color.red, lineWidth: 2)
            .overlay(thumb)
            .coordinateSpace(name: "MY")
            .onAppear(perform: {
                self.position = self.path.cgPath.getStartPoint()
            })
        
    }
}


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { (path) in
            let w = rect.width
            let h = rect.height
            
            path.move(to: CGPoint(x: w/2, y: h/4))
            path.addLine(to: CGPoint(x: 3*w/4, y: 3*h/4))
            path.addLine(to: CGPoint(x: w/4, y: 3*h/4))
            path.closeSubpath()
            
        }
    }
}

/// Examples of how to use the different constraint components.
struct ContentView: View {
    var body: some View {
        VStack {
            
            PathConstrained(Triangle().path(in: CGRect(x: 0, y: 0, width: 250, height: 250)))
            
            PathConstrained(Circle().path(in: CGRect(x: 0, y: 0, width: 250, height: 250)))
            
            Ellipse()
                .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .topTrailing, endPoint: .bottomLeading))
                .frame(width: 75, height: 50)
                .constrainToPath(Rectangle().path(in: CGRect(x: 0, y: 0, width: 100, height: 250)))
                .offset(x: 200, y: 0)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
