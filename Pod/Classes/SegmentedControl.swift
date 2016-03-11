
import Foundation

public protocol ToggleOptionType: Equatable {
    var name: String { get }
}

public class FeedToggle<T: ToggleOptionType>: UIView {
    
    let scBackgroundColor = UIColor.whiteColor()
    let scTintColor = UIColor.blackColor()
    let textColorNormalState = UIColor.grayColor()
    let textColorSelectedState = UIColor.darkGrayColor()
    let textFontAndSize = UIFont.systemFontOfSize(12)
    let verticalInset: CGFloat = 10
    let horizontalInset: CGFloat = 15
    
    private let segmentedControl: UISegmentedControl
    private var options: [T]
    private let action: (T) -> ()
    
    init(options: [T], action: (T) -> ()) {
        self.segmentedControl = UISegmentedControl(items: options.map({ $0.name }))
        self.options = options
        self.action = action
        
        super.init(frame:CGRect.zero)
        
        self.backgroundColor = .whiteColor()
        
        self.addSubview(self.segmentedControl)
        self.styleSegmentedControl()
        self.segmentedControl.addTarget(
            self,
            action: Selector("toggled"),
            forControlEvents: .ValueChanged
        )
        
        let insets = UIEdgeInsets(
            top: self.verticalInset,
            left: self.horizontalInset,
            bottom: self.verticalInset,
            right: self.horizontalInset
        )
        
        self.setupConstraints(insets)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("not supported")
    }
    
    private func styleSegmentedControl() {
        self.segmentedControl.backgroundColor = self.scBackgroundColor
        self.segmentedControl.tintColor = self.scTintColor
        self.segmentedControl.setTitleTextAttributes([
            NSForegroundColorAttributeName: self.textColorNormalState,
            NSFontAttributeName: self.textFontAndSize
            ], forState: .Normal)
        self.segmentedControl.setTitleTextAttributes([
            NSForegroundColorAttributeName: self.textColorSelectedState,
            NSFontAttributeName: self.textFontAndSize
            ], forState: .Selected)
    }
    
    private func setupConstraints(insets: UIEdgeInsets) {
        self.constrainViewToAllEdges(self.segmentedControl, insets: insets)
    }
    
    func selectOption(option: T) {
        guard let index = self.options.indexOf(option) else { return }
        self.segmentedControl.selectedSegmentIndex = index
        self.toggled()
    }
    
    func updateOptions(options: [T]) {
        let index = self.segmentedControl.selectedSegmentIndex
        self.replaceSegmentsInControl(self.segmentedControl, withOptions: options)
        self.options = options
        
        if index < self.options.count {
            self.segmentedControl.selectedSegmentIndex = index
        }
    }
    
    private func replaceSegmentsInControl(control: UISegmentedControl, withOptions options: [T]) {
        control.removeAllSegments()
        for (index, option) in options.enumerate() {
            control.insertSegmentWithTitle(option.name, atIndex: index, animated: false)
        }
    }
    
    @objc func toggled() {
        self.action(self.options[self.segmentedControl.selectedSegmentIndex])
    }
    
    //MARK: Autolayout methods
    
    func constrainViewToAllEdges(view: UIView, insets: UIEdgeInsets = UIEdgeInsetsZero) {
        let edges: [NSLayoutAttribute] = [.Leading, .Trailing, .Top, .Bottom]
        self.constrainView(view, edges: edges, insets: insets)
    }
    
    func constrainView(
        view: UIView,
        edges: [NSLayoutAttribute],
        insets: UIEdgeInsets = UIEdgeInsetsZero,
        priority: Float? = nil
        ) {
            
            let constraints = self.constraintsForView(
                view,
                edges: edges,
                insets: insets,
                priority: priority
            )
            self.addConstraints(constraints)
    }
    
    func constraintsForView(
        view: UIView,
        edges: [NSLayoutAttribute],
        insets: UIEdgeInsets,
        priority: Float? = nil
        ) -> [NSLayoutConstraint] {
            return edges.map({ (edge) -> NSLayoutConstraint in
                return self.constrainView(view, toEdge: edge, insets: insets, priority: priority)
            })
    }
    
    func constrainView(
        view: UIView,
        toEdge edge: NSLayoutAttribute,
        insets: UIEdgeInsets = UIEdgeInsetsZero,
        priority: Float?
        ) -> NSLayoutConstraint {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let inset: CGFloat = {
                switch edge {
                case .Leading: return insets.left
                case .Trailing: return -1 * insets.right
                case .Bottom: return -1 * insets.bottom
                case .Top: return insets.top
                default: return 0
                }
            }()
            
            let constraint = NSLayoutConstraint(
                item: view,
                attribute: edge,
                relatedBy: .Equal,
                toItem: self,
                attribute: edge,
                multiplier: 1,
                constant: inset
            )
            
            if let priority = priority {
                constraint.priority = priority
            }
            return constraint
    }

    
}
