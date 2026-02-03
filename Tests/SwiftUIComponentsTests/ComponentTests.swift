import XCTest
import SwiftUI
@testable import SwiftUIComponents

final class ComponentTests: XCTestCase {
    
    // MARK: - Button Tests
    
    func testPrimaryButtonInitialization() {
        let button = PrimaryButton("Test", backgroundColor: .red, cornerRadius: 16) { }
        XCTAssertNotNil(button)
    }
    
    func testSecondaryButtonStyles() {
        let outlineButton = SecondaryButton("Outline", style: .outline) { }
        let subtleButton = SecondaryButton("Subtle", style: .subtle) { }
        let ghostButton = SecondaryButton("Ghost", style: .ghost) { }
        let tintedButton = SecondaryButton("Tinted", style: .tinted) { }
        
        XCTAssertNotNil(outlineButton)
        XCTAssertNotNil(subtleButton)
        XCTAssertNotNil(ghostButton)
        XCTAssertNotNil(tintedButton)
    }
    
    func testLoadingButtonStates() {
        var state: LoadingButton.LoadingState = .idle
        
        XCTAssertEqual(state, .idle)
        
        state = .loading
        XCTAssertEqual(state, .loading)
        
        state = .success
        XCTAssertEqual(state, .success)
        
        state = .failure
        XCTAssertEqual(state, .failure)
    }
    
    func testGradientButtonPresets() {
        let sunriseGradient = GradientButton.GradientType.sunrise
        let oceanGradient = GradientButton.GradientType.ocean
        let forestGradient = GradientButton.GradientType.forest
        
        XCTAssertNotNil(sunriseGradient)
        XCTAssertNotNil(oceanGradient)
        XCTAssertNotNil(forestGradient)
    }
    
    func testFloatingActionButtonSizes() {
        XCTAssertEqual(FloatingActionButton.Size.mini.dimension, 40)
        XCTAssertEqual(FloatingActionButton.Size.regular.dimension, 56)
        XCTAssertEqual(FloatingActionButton.Size.extended.dimension, 48)
    }
    
    // MARK: - Card Tests
    
    func testCardViewInitialization() {
        let card = CardView(cornerRadius: 20, shadowRadius: 10) {
            Text("Test")
        }
        XCTAssertNotNil(card)
    }
    
    func testGlassCardStyles() {
        let lightCard = GlassCard(style: .light) { Text("Light") }
        let darkCard = GlassCard(style: .dark) { Text("Dark") }
        let frostedCard = GlassCard(style: .frosted) { Text("Frosted") }
        
        XCTAssertNotNil(lightCard)
        XCTAssertNotNil(darkCard)
        XCTAssertNotNil(frostedCard)
    }
    
    func testActionCardCreation() {
        let action = ActionCard.Action(title: "Test", style: .filled) { }
        XCTAssertEqual(action.title, "Test")
    }
    
    // MARK: - Input Tests
    
    func testRatingInputPrecision() {
        let fullPrecision = RatingInput.Precision.full
        let halfPrecision = RatingInput.Precision.half
        let exactPrecision = RatingInput.Precision.exact
        
        XCTAssertNotNil(fullPrecision)
        XCTAssertNotNil(halfPrecision)
        XCTAssertNotNil(exactPrecision)
    }
    
    func testPinInputBoxStyles() {
        XCTAssertNotNil(PinInput.BoxStyle.outlined)
        XCTAssertNotNil(PinInput.BoxStyle.filled)
        XCTAssertNotNil(PinInput.BoxStyle.underlined)
        XCTAssertNotNil(PinInput.BoxStyle.rounded)
    }
    
    func testCreditCardTypeDetection() {
        XCTAssertEqual(CreditCardInput.CardType.detect(from: "4111111111111111"), .visa)
        XCTAssertEqual(CreditCardInput.CardType.detect(from: "5111111111111111"), .mastercard)
        XCTAssertEqual(CreditCardInput.CardType.detect(from: "341111111111111"), .amex)
        XCTAssertEqual(CreditCardInput.CardType.detect(from: "6011111111111111"), .discover)
    }
    
    func testPhoneInputCountries() {
        let countries = PhoneInput.Country.defaultCountries
        XCTAssertFalse(countries.isEmpty)
        XCTAssertTrue(countries.count >= 10)
        
        let usCountry = countries.first { $0.id == "US" }
        XCTAssertNotNil(usCountry)
        XCTAssertEqual(usCountry?.dialCode, "+1")
    }
    
    // MARK: - Loading Tests
    
    func testPulseLoaderStyles() {
        XCTAssertNotNil(PulseLoader.Style.single)
        XCTAssertNotNil(PulseLoader.Style.rings)
        XCTAssertNotNil(PulseLoader.Style.dots)
        XCTAssertNotNil(PulseLoader.Style.wave)
        XCTAssertNotNil(PulseLoader.Style.heartbeat)
    }
    
    func testSkeletonViewTemplates() {
        let listItem = SkeletonView.listItem()
        let card = SkeletonView.card()
        let profile = SkeletonView.profile()
        let article = SkeletonView.article()
        
        XCTAssertNotNil(listItem)
        XCTAssertNotNil(card)
        XCTAssertNotNil(profile)
        XCTAssertNotNil(article)
    }
    
    func testDotLoaderStyles() {
        XCTAssertNotNil(DotLoader.Style.bouncing)
        XCTAssertNotNil(DotLoader.Style.fading)
        XCTAssertNotNil(DotLoader.Style.scaling)
        XCTAssertNotNil(DotLoader.Style.typing)
        XCTAssertNotNil(DotLoader.Style.elastic)
        XCTAssertNotNil(DotLoader.Style.orbital)
    }
    
    // MARK: - Toast Tests
    
    func testSnackBarStyles() {
        XCTAssertNotNil(SnackBar.Style.standard)
        XCTAssertNotNil(SnackBar.Style.info)
        XCTAssertNotNil(SnackBar.Style.success)
        XCTAssertNotNil(SnackBar.Style.warning)
        XCTAssertNotNil(SnackBar.Style.error)
    }
    
    func testBannerStyles() {
        XCTAssertNotNil(Banner.Style.info)
        XCTAssertNotNil(Banner.Style.success)
        XCTAssertNotNil(Banner.Style.warning)
        XCTAssertNotNil(Banner.Style.error)
    }
    
    // MARK: - List Tests
    
    func testSwipeableRowActions() {
        let deleteAction = SwipeableRow<Text>.SwipeAction.delete { }
        let archiveAction = SwipeableRow<Text>.SwipeAction.archive { }
        let pinAction = SwipeableRow<Text>.SwipeAction.pin { }
        
        XCTAssertEqual(deleteAction.title, "Delete")
        XCTAssertTrue(deleteAction.isDestructive)
        XCTAssertEqual(archiveAction.title, "Archive")
        XCTAssertEqual(pinAction.title, "Pin")
    }
    
    func testFAQListItem() {
        let item = FAQList.FAQItem(question: "What is SwiftUI?", answer: "A UI framework")
        XCTAssertEqual(item.question, "What is SwiftUI?")
        XCTAssertEqual(item.answer, "A UI framework")
    }
    
    // MARK: - Chart Tests
    
    func testSparklineChartStyles() {
        XCTAssertNotNil(SparklineChart.Style.line)
        XCTAssertNotNil(SparklineChart.Style.filled)
        XCTAssertNotNil(SparklineChart.Style.gradient)
        XCTAssertNotNil(SparklineChart.Style.dashed)
    }
    
    func testRingChartSegments() {
        let segment = RingChart.Segment(value: 50, color: .blue, label: "Test")
        XCTAssertEqual(segment.value, 50)
        XCTAssertEqual(segment.label, "Test")
    }
    
    // MARK: - Navigation Tests
    
    func testTabBarViewStyles() {
        XCTAssertNotNil(TabBarView.Style.standard)
        XCTAssertNotNil(TabBarView.Style.pill)
        XCTAssertNotNil(TabBarView.Style.floating)
        XCTAssertNotNil(TabBarView.Style.minimal)
    }
    
    func testSegmentedControlStyles() {
        XCTAssertNotNil(SegmentedControl.Style.capsule)
        XCTAssertNotNil(SegmentedControl.Style.rounded)
        XCTAssertNotNil(SegmentedControl.Style.underline)
        XCTAssertNotNil(SegmentedControl.Style.boxed)
    }
    
    func testPageIndicatorStyles() {
        XCTAssertNotNil(PageIndicator.Style.dots)
        XCTAssertNotNil(PageIndicator.Style.pills)
        XCTAssertNotNil(PageIndicator.Style.numbers)
        XCTAssertNotNil(PageIndicator.Style.progress)
        XCTAssertNotNil(PageIndicator.Style.worm)
    }
    
    func testBreadcrumbStyles() {
        XCTAssertNotNil(BreadcrumbView.Style.chevron)
        XCTAssertNotNil(BreadcrumbView.Style.slash)
        XCTAssertNotNil(BreadcrumbView.Style.arrow)
        XCTAssertNotNil(BreadcrumbView.Style.dot)
    }
    
    // MARK: - Overlay Tests
    
    func testBottomSheetDetents() {
        let small = BottomSheet<Text>.DetentHeight.small
        let medium = BottomSheet<Text>.DetentHeight.medium
        let large = BottomSheet<Text>.DetentHeight.large
        let full = BottomSheet<Text>.DetentHeight.full
        let custom = BottomSheet<Text>.DetentHeight.custom(300)
        let fraction = BottomSheet<Text>.DetentHeight.fraction(0.6)
        
        XCTAssertEqual(small.height(in: 1000), 250)
        XCTAssertEqual(medium.height(in: 1000), 500)
        XCTAssertEqual(large.height(in: 1000), 750)
        XCTAssertEqual(full.height(in: 1000), 1000)
        XCTAssertEqual(custom.height(in: 1000), 300)
        XCTAssertEqual(fraction.height(in: 1000), 600)
    }
    
    func testTooltipPositions() {
        XCTAssertNotNil(Tooltip.Position.top)
        XCTAssertNotNil(Tooltip.Position.bottom)
        XCTAssertNotNil(Tooltip.Position.leading)
        XCTAssertNotNil(Tooltip.Position.trailing)
        XCTAssertNotNil(Tooltip.Position.auto)
    }
    
    func testModalViewStyles() {
        XCTAssertNotNil(ModalView<Text>.Style.center)
        XCTAssertNotNil(ModalView<Text>.Style.fullScreen)
        XCTAssertNotNil(ModalView<Text>.Style.bottomSheet)
        XCTAssertNotNil(ModalView<Text>.Style.alert)
    }
    
    // MARK: - Misc Tests
    
    func testBadgeStyles() {
        XCTAssertNotNil(Badge.Style.filled)
        XCTAssertNotNil(Badge.Style.outlined)
        XCTAssertNotNil(Badge.Style.subtle)
        XCTAssertNotNil(Badge.Style.notification)
        XCTAssertNotNil(Badge.Style.dot)
    }
    
    func testBadgeSizes() {
        XCTAssertEqual(Badge.Size.small.dotSize, 6)
        XCTAssertEqual(Badge.Size.medium.dotSize, 8)
        XCTAssertEqual(Badge.Size.large.dotSize, 10)
    }
    
    func testAvatarSizes() {
        XCTAssertEqual(Avatar.Size.tiny.dimension, 24)
        XCTAssertEqual(Avatar.Size.small.dimension, 32)
        XCTAssertEqual(Avatar.Size.medium.dimension, 44)
        XCTAssertEqual(Avatar.Size.large.dimension, 64)
        XCTAssertEqual(Avatar.Size.extraLarge.dimension, 96)
        XCTAssertEqual(Avatar.Size.custom(100).dimension, 100)
    }
    
    func testChipStyles() {
        XCTAssertNotNil(Chip.Style.filled)
        XCTAssertNotNil(Chip.Style.outlined)
        XCTAssertNotNil(Chip.Style.subtle)
    }
    
    func testChipSizes() {
        XCTAssertNotNil(Chip.Size.small)
        XCTAssertNotNil(Chip.Size.medium)
        XCTAssertNotNil(Chip.Size.large)
    }
    
    func testCustomDividerStyles() {
        XCTAssertNotNil(CustomDivider.Style.solid)
        XCTAssertNotNil(CustomDivider.Style.dashed)
        XCTAssertNotNil(CustomDivider.Style.dotted)
    }
    
    func testStatusBadgeStatuses() {
        XCTAssertEqual(StatusBadge.Status.active.label, "Active")
        XCTAssertEqual(StatusBadge.Status.inactive.label, "Inactive")
        XCTAssertEqual(StatusBadge.Status.pending.label, "Pending")
        XCTAssertEqual(StatusBadge.Status.error.label, "Error")
        XCTAssertEqual(StatusBadge.Status.success.label, "Success")
        XCTAssertEqual(StatusBadge.Status.warning.label, "Warning")
    }
}
