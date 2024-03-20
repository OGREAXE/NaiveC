#import "NCCocoaEnumStore.h"
#import "UIKit/UIKit.h"

@implementation NCCocoaEnumStore
+(id)enumForName:(NSString *)name {
   static NSDictionary *store = nil;
   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    store = @{

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDynamicBehavior.h
//   UIDynamicItemCollisionBoundsType
            @"UIDynamicItemCollisionBoundsTypeRectangle":P(UIDynamicItemCollisionBoundsTypeRectangle),
            @"UIDynamicItemCollisionBoundsTypeEllipse":P(UIDynamicItemCollisionBoundsTypeEllipse),
            @"UIDynamicItemCollisionBoundsTypePath":P(UIDynamicItemCollisionBoundsTypePath),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIVibrancyEffect.h
//   UIVibrancyEffectStyle

//   Enum definitions in ./enum_gen/UIKit/Headers/UIShape.h
//   UICornerCurve
            @"UICornerCurveAutomatic":P(UICornerCurveAutomatic),
            @"UICornerCurveCircular":P(UICornerCurveCircular),
            @"UICornerCurveContinuous":P(UICornerCurveContinuous),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIBandSelectionInteraction.h
//   UIBandSelectionInteractionState
            @"UIBandSelectionInteractionStatePossible":P(UIBandSelectionInteractionStatePossible),
            @"UIBandSelectionInteractionStateBegan":P(UIBandSelectionInteractionStateBegan),
            @"UIBandSelectionInteractionStateSelecting":P(UIBandSelectionInteractionStateSelecting),
            @"UIBandSelectionInteractionStateEnded":P(UIBandSelectionInteractionStateEnded),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSAttributedString.h
//   NSUnderlineStyle
            @"NSUnderlineStyleNone":P(NSUnderlineStyleNone),
            @"NSUnderlineStyleSingle":P(NSUnderlineStyleSingle),
            @"NSUnderlineStyleThick":P(NSUnderlineStyleThick),
            @"NSUnderlineStyleDouble":P(NSUnderlineStyleDouble),
            @"NSUnderlineStylePatternSolid":P(NSUnderlineStylePatternSolid),
            @"NSUnderlineStylePatternDot":P(NSUnderlineStylePatternDot),
            @"NSUnderlineStylePatternDash":P(NSUnderlineStylePatternDash),
            @"NSUnderlineStylePatternDashDot":P(NSUnderlineStylePatternDashDot),
            @"NSUnderlineStylePatternDashDotDot":P(NSUnderlineStylePatternDashDotDot),
            @"NSUnderlineStyleByWord":P(NSUnderlineStyleByWord),
//   NSWritingDirectionFormatType
            @"NSWritingDirectionEmbedding":P(NSWritingDirectionEmbedding),
            @"NSWritingDirectionOverride":P(NSWritingDirectionOverride),
//   NSTextScalingType
            @"NSTextScalingStandard":P(NSTextScalingStandard),
            @"NSTextScalingiOS":P(NSTextScalingiOS),
//   NSTextWritingDirection
            @"NSTextWritingDirectionEmbedding":P(NSTextWritingDirectionEmbedding),
            @"NSTextWritingDirectionOverride":P(NSTextWritingDirectionOverride),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIBarButtonItem.h
//   UIBarButtonItemStyle
            @"UIBarButtonItemStylePlain":P(UIBarButtonItemStylePlain),
            @"UIBarButtonItemStyleBordered":P(UIBarButtonItemStyleBordered),
            @"UIBarButtonItemStyleDone":P(UIBarButtonItemStyleDone),
//   UIBarButtonSystemItem
            @"UIBarButtonSystemItemDone":P(UIBarButtonSystemItemDone),
            @"UIBarButtonSystemItemCancel":P(UIBarButtonSystemItemCancel),
            @"UIBarButtonSystemItemEdit":P(UIBarButtonSystemItemEdit),
            @"UIBarButtonSystemItemSave":P(UIBarButtonSystemItemSave),
            @"UIBarButtonSystemItemAdd":P(UIBarButtonSystemItemAdd),
            @"UIBarButtonSystemItemFlexibleSpace":P(UIBarButtonSystemItemFlexibleSpace),
            @"UIBarButtonSystemItemFixedSpace":P(UIBarButtonSystemItemFixedSpace),
            @"UIBarButtonSystemItemCompose":P(UIBarButtonSystemItemCompose),
            @"UIBarButtonSystemItemReply":P(UIBarButtonSystemItemReply),
            @"UIBarButtonSystemItemAction":P(UIBarButtonSystemItemAction),
            @"UIBarButtonSystemItemOrganize":P(UIBarButtonSystemItemOrganize),
            @"UIBarButtonSystemItemBookmarks":P(UIBarButtonSystemItemBookmarks),
            @"UIBarButtonSystemItemSearch":P(UIBarButtonSystemItemSearch),
            @"UIBarButtonSystemItemRefresh":P(UIBarButtonSystemItemRefresh),
            @"UIBarButtonSystemItemStop":P(UIBarButtonSystemItemStop),
            @"UIBarButtonSystemItemCamera":P(UIBarButtonSystemItemCamera),
            @"UIBarButtonSystemItemTrash":P(UIBarButtonSystemItemTrash),
            @"UIBarButtonSystemItemPlay":P(UIBarButtonSystemItemPlay),
            @"UIBarButtonSystemItemPause":P(UIBarButtonSystemItemPause),
            @"UIBarButtonSystemItemRewind":P(UIBarButtonSystemItemRewind),
            @"UIBarButtonSystemItemFastForward":P(UIBarButtonSystemItemFastForward),
            @"UIBarButtonSystemItemUndo":P(UIBarButtonSystemItemUndo),
            @"UIBarButtonSystemItemRedo":P(UIBarButtonSystemItemRedo),
            @"UIBarButtonSystemItemPageCurl":P(UIBarButtonSystemItemPageCurl),
            @"UIBarButtonSystemItemClose":P(UIBarButtonSystemItemClose),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIWebView.h
//   UIWebViewNavigationType
            @"UIWebViewNavigationTypeLinkClicked":P(UIWebViewNavigationTypeLinkClicked),
            @"UIWebViewNavigationTypeFormSubmitted":P(UIWebViewNavigationTypeFormSubmitted),
            @"UIWebViewNavigationTypeBackForward":P(UIWebViewNavigationTypeBackForward),
            @"UIWebViewNavigationTypeReload":P(UIWebViewNavigationTypeReload),
            @"UIWebViewNavigationTypeFormResubmitted":P(UIWebViewNavigationTypeFormResubmitted),
            @"UIWebViewNavigationTypeOther":P(UIWebViewNavigationTypeOther),
//   UIWebPaginationMode
            @"UIWebPaginationModeUnpaginated":P(UIWebPaginationModeUnpaginated),
            @"UIWebPaginationModeLeftToRight":P(UIWebPaginationModeLeftToRight),
            @"UIWebPaginationModeTopToBottom":P(UIWebPaginationModeTopToBottom),
            @"UIWebPaginationModeBottomToTop":P(UIWebPaginationModeBottomToTop),
            @"UIWebPaginationModeRightToLeft":P(UIWebPaginationModeRightToLeft),
//   UIWebPaginationBreakingMode
            @"UIWebPaginationBreakingModePage":P(UIWebPaginationBreakingModePage),
            @"UIWebPaginationBreakingModeColumn":P(UIWebPaginationBreakingModeColumn),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSLayoutManager.h
//   NSTextLayoutOrientation
            @"NSTextLayoutOrientationHorizontal":P(NSTextLayoutOrientationHorizontal),
            @"NSTextLayoutOrientationVertical":P(NSTextLayoutOrientationVertical),
//   NSGlyphProperty
            @"NSGlyphPropertyNull":P(NSGlyphPropertyNull),
            @"NSGlyphPropertyControlCharacter":P(NSGlyphPropertyControlCharacter),
            @"NSGlyphPropertyElastic":P(NSGlyphPropertyElastic),
            @"NSGlyphPropertyNonBaseCharacter":P(NSGlyphPropertyNonBaseCharacter),
//   NSControlCharacterAction
            @"NSControlCharacterActionZeroAdvancement":P(NSControlCharacterActionZeroAdvancement),
            @"NSControlCharacterActionWhitespace":P(NSControlCharacterActionWhitespace),
            @"NSControlCharacterActionHorizontalTab":P(NSControlCharacterActionHorizontalTab),
            @"NSControlCharacterActionLineBreak":P(NSControlCharacterActionLineBreak),
            @"NSControlCharacterActionParagraphBreak":P(NSControlCharacterActionParagraphBreak),
            @"NSControlCharacterActionContainerBreak":P(NSControlCharacterActionContainerBreak),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIProgressView.h
//   UIProgressViewStyle
            @"UIProgressViewStyleDefault":P(UIProgressViewStyleDefault),
            @"UIProgressViewStyleBar":P(UIProgressViewStyleBar),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITimingCurveProvider.h
//   UITimingCurveType
            @"UITimingCurveTypeBuiltin":P(UITimingCurveTypeBuiltin),
            @"UITimingCurveTypeCubic":P(UITimingCurveTypeCubic),
            @"UITimingCurveTypeSpring":P(UITimingCurveTypeSpring),
            @"UITimingCurveTypeComposed":P(UITimingCurveTypeComposed),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPencilInteraction.h
//   UIPencilPreferredAction
            @"UIPencilPreferredActionIgnore":P(UIPencilPreferredActionIgnore),
            @"UIPencilPreferredActionSwitchEraser":P(UIPencilPreferredActionSwitchEraser),
            @"UIPencilPreferredActionSwitchPrevious":P(UIPencilPreferredActionSwitchPrevious),
            @"UIPencilPreferredActionShowColorPalette":P(UIPencilPreferredActionShowColorPalette),
            @"UIPencilPreferredActionShowInkAttributes":P(UIPencilPreferredActionShowInkAttributes),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSParagraphStyle.h
//   NSLineBreakMode
            @"NSLineBreakByWordWrapping":P(NSLineBreakByWordWrapping),
            @"NSLineBreakByCharWrapping":P(NSLineBreakByCharWrapping),
            @"NSLineBreakByClipping":P(NSLineBreakByClipping),
            @"NSLineBreakByTruncatingHead":P(NSLineBreakByTruncatingHead),
            @"NSLineBreakByTruncatingTail":P(NSLineBreakByTruncatingTail),
            @"NSLineBreakByTruncatingMiddle":P(NSLineBreakByTruncatingMiddle),
//   NSLineBreakStrategy
            @"NSLineBreakStrategyNone":P(NSLineBreakStrategyNone),
            @"NSLineBreakStrategyPushOut":P(NSLineBreakStrategyPushOut),
            @"NSLineBreakStrategyHangulWordPriority":P(NSLineBreakStrategyHangulWordPriority),
            @"NSLineBreakStrategyStandard":P(NSLineBreakStrategyStandard),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIAccessibilityConstants.h
//   UIAccessibilityNavigationStyle
//   UIAccessibilityContainerType
            @"UIAccessibilityContainerTypeNone":P(UIAccessibilityContainerTypeNone),
            @"UIAccessibilityContainerTypeDataTable":P(UIAccessibilityContainerTypeDataTable),
            @"UIAccessibilityContainerTypeList":P(UIAccessibilityContainerTypeList),
            @"UIAccessibilityContainerTypeLandmark":P(UIAccessibilityContainerTypeLandmark),
            @"UIAccessibilityContainerTypeSemanticGroup":P(UIAccessibilityContainerTypeSemanticGroup),
//   UIAccessibilityDirectTouchOptions
            @"UIAccessibilityDirectTouchOptionNone":P(UIAccessibilityDirectTouchOptionNone),
            @"UIAccessibilityDirectTouchOptionSilentOnTouch":P(UIAccessibilityDirectTouchOptionSilentOnTouch),
            @"UIAccessibilityDirectTouchOptionRequiresActivation":P(UIAccessibilityDirectTouchOptionRequiresActivation),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSTextStorage.h
//   NSTextStorageEditActions
            @"NSTextStorageEditedAttributes":P(NSTextStorageEditedAttributes),
            @"NSTextStorageEditedCharacters":P(NSTextStorageEditedCharacters),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIMenu.h
//   UIMenuOptions
            @"UIMenuOptionsDisplayInline":P(UIMenuOptionsDisplayInline),
            @"UIMenuOptionsDestructive":P(UIMenuOptionsDestructive),
            @"UIMenuOptionsSingleSelection":P(UIMenuOptionsSingleSelection),
            @"UIMenuOptionsDisplayAsPalette":P(UIMenuOptionsDisplayAsPalette),
//   UIMenuElementSize
            @"UIMenuElementSizeSmall":P(UIMenuElementSizeSmall),
            @"UIMenuElementSizeMedium":P(UIMenuElementSizeMedium),
            @"UIMenuElementSizeLarge":P(UIMenuElementSizeLarge),
            @"UIMenuElementSizeAutomatic":P(UIMenuElementSizeAutomatic),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIUserNotificationSettings.h
//   UIUserNotificationType
            @"UIUserNotificationTypeNone":P(UIUserNotificationTypeNone),
            @"UIUserNotificationTypeBadge":P(UIUserNotificationTypeBadge),
            @"UIUserNotificationTypeSound":P(UIUserNotificationTypeSound),
            @"UIUserNotificationTypeAlert":P(UIUserNotificationTypeAlert),
//   UIUserNotificationActionBehavior
            @"UIUserNotificationActionBehaviorDefault":P(UIUserNotificationActionBehaviorDefault),
            @"UIUserNotificationActionBehaviorTextInput":P(UIUserNotificationActionBehaviorTextInput),
//   UIUserNotificationActivationMode
            @"UIUserNotificationActivationModeForeground":P(UIUserNotificationActivationModeForeground),
            @"UIUserNotificationActivationModeBackground":P(UIUserNotificationActivationModeBackground),
//   UIUserNotificationActionContext
            @"UIUserNotificationActionContextDefault":P(UIUserNotificationActionContextDefault),
            @"UIUserNotificationActionContextMinimal":P(UIUserNotificationActionContextMinimal),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIBlurEffect.h
//   UIBlurEffectStyle

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPrintInteractionController.h
//   UIPrinterCutterBehavior
            @"UIPrinterCutterBehaviorNoCut":P(UIPrinterCutterBehaviorNoCut),
            @"UIPrinterCutterBehaviorPrinterDefault":P(UIPrinterCutterBehaviorPrinterDefault),
            @"UIPrinterCutterBehaviorCutAfterEachPage":P(UIPrinterCutterBehaviorCutAfterEachPage),
            @"UIPrinterCutterBehaviorCutAfterEachCopy":P(UIPrinterCutterBehaviorCutAfterEachCopy),
            @"UIPrinterCutterBehaviorCutAfterEachJob":P(UIPrinterCutterBehaviorCutAfterEachJob),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPopoverSupport.h
//   UIPopoverArrowDirection
            @"UIPopoverArrowDirectionUp":P(UIPopoverArrowDirectionUp),
            @"UIPopoverArrowDirectionDown":P(UIPopoverArrowDirectionDown),
            @"UIPopoverArrowDirectionLeft":P(UIPopoverArrowDirectionLeft),
            @"UIPopoverArrowDirectionRight":P(UIPopoverArrowDirectionRight),
            @"UIPopoverArrowDirectionAny":P(UIPopoverArrowDirectionAny),
            @"UIPopoverArrowDirectionUnknown":P(UIPopoverArrowDirectionUnknown),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITouch.h
//   UITouchPhase
            @"UITouchPhaseBegan":P(UITouchPhaseBegan),
            @"UITouchPhaseMoved":P(UITouchPhaseMoved),
            @"UITouchPhaseStationary":P(UITouchPhaseStationary),
            @"UITouchPhaseEnded":P(UITouchPhaseEnded),
            @"UITouchPhaseCancelled":P(UITouchPhaseCancelled),
            @"UITouchPhaseRegionEntered":P(UITouchPhaseRegionEntered),
            @"UITouchPhaseRegionMoved":P(UITouchPhaseRegionMoved),
            @"UITouchPhaseRegionExited":P(UITouchPhaseRegionExited),
//   UIForceTouchCapability
            @"UIForceTouchCapabilityUnknown":P(UIForceTouchCapabilityUnknown),
            @"UIForceTouchCapabilityUnavailable":P(UIForceTouchCapabilityUnavailable),
            @"UIForceTouchCapabilityAvailable":P(UIForceTouchCapabilityAvailable),
//   UITouchType
            @"UITouchTypeDirect":P(UITouchTypeDirect),
            @"UITouchTypeIndirect":P(UITouchTypeIndirect),
            @"UITouchTypePencil":P(UITouchTypePencil),
            @"UITouchTypeStylus":P(UITouchTypeStylus),
            @"UITouchTypeIndirectPointer":P(UITouchTypeIndirectPointer),
//   UITouchProperties
            @"UITouchPropertyForce":P(UITouchPropertyForce),
            @"UITouchPropertyAzimuth":P(UITouchPropertyAzimuth),
            @"UITouchPropertyAltitude":P(UITouchPropertyAltitude),
            @"UITouchPropertyLocation":P(UITouchPropertyLocation),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPageViewController.h
//   UIPageViewControllerNavigationOrientation
            @"UIPageViewControllerNavigationOrientationHorizontal":P(UIPageViewControllerNavigationOrientationHorizontal),
            @"UIPageViewControllerNavigationOrientationVertical":P(UIPageViewControllerNavigationOrientationVertical),
//   UIPageViewControllerSpineLocation
            @"UIPageViewControllerSpineLocationNone":P(UIPageViewControllerSpineLocationNone),
            @"UIPageViewControllerSpineLocationMin":P(UIPageViewControllerSpineLocationMin),
            @"UIPageViewControllerSpineLocationMid":P(UIPageViewControllerSpineLocationMid),
            @"UIPageViewControllerSpineLocationMax":P(UIPageViewControllerSpineLocationMax),
//   UIPageViewControllerNavigationDirection
            @"UIPageViewControllerNavigationDirectionForward":P(UIPageViewControllerNavigationDirectionForward),
            @"UIPageViewControllerNavigationDirectionReverse":P(UIPageViewControllerNavigationDirectionReverse),
//   UIPageViewControllerTransitionStyle
            @"UIPageViewControllerTransitionStylePageCurl":P(UIPageViewControllerTransitionStylePageCurl),
            @"UIPageViewControllerTransitionStyleScroll":P(UIPageViewControllerTransitionStyleScroll),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIViewAnimating.h
//   UIViewAnimatingState
            @"UIViewAnimatingStateInactive":P(UIViewAnimatingStateInactive),
            @"UIViewAnimatingStateActive":P(UIViewAnimatingStateActive),
            @"UIViewAnimatingStateStopped":P(UIViewAnimatingStateStopped),
//   UIViewAnimatingPosition
            @"UIViewAnimatingPositionEnd":P(UIViewAnimatingPositionEnd),
            @"UIViewAnimatingPositionStart":P(UIViewAnimatingPositionStart),
            @"UIViewAnimatingPositionCurrent":P(UIViewAnimatingPositionCurrent),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSItemProvider+UIKitAdditions.h
//   UIPreferredPresentationStyle
            @"UIPreferredPresentationStyleUnspecified":P(UIPreferredPresentationStyleUnspecified),
            @"UIPreferredPresentationStyleInline":P(UIPreferredPresentationStyleInline),
            @"UIPreferredPresentationStyleAttachment":P(UIPreferredPresentationStyleAttachment),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIMotionEffect.h
//   UIInterpolatingMotionEffectType

//   Enum definitions in ./enum_gen/UIKit/Headers/NSTextSelectionNavigation.h
//   NSTextSelectionNavigationDirection
            @"NSTextSelectionNavigationDirectionForward":P(NSTextSelectionNavigationDirectionForward),
            @"NSTextSelectionNavigationDirectionBackward":P(NSTextSelectionNavigationDirectionBackward),
            @"NSTextSelectionNavigationDirectionRight":P(NSTextSelectionNavigationDirectionRight),
            @"NSTextSelectionNavigationDirectionLeft":P(NSTextSelectionNavigationDirectionLeft),
            @"NSTextSelectionNavigationDirectionUp":P(NSTextSelectionNavigationDirectionUp),
            @"NSTextSelectionNavigationDirectionDown":P(NSTextSelectionNavigationDirectionDown),
//   NSTextSelectionNavigationDestination
            @"NSTextSelectionNavigationDestinationCharacter":P(NSTextSelectionNavigationDestinationCharacter),
            @"NSTextSelectionNavigationDestinationWord":P(NSTextSelectionNavigationDestinationWord),
            @"NSTextSelectionNavigationDestinationLine":P(NSTextSelectionNavigationDestinationLine),
            @"NSTextSelectionNavigationDestinationSentence":P(NSTextSelectionNavigationDestinationSentence),
            @"NSTextSelectionNavigationDestinationParagraph":P(NSTextSelectionNavigationDestinationParagraph),
            @"NSTextSelectionNavigationDestinationContainer":P(NSTextSelectionNavigationDestinationContainer),
            @"NSTextSelectionNavigationDestinationDocument":P(NSTextSelectionNavigationDestinationDocument),
//   NSTextSelectionNavigationModifier
            @"NSTextSelectionNavigationModifierExtend":P(NSTextSelectionNavigationModifierExtend),
            @"NSTextSelectionNavigationModifierVisual":P(NSTextSelectionNavigationModifierVisual),
            @"NSTextSelectionNavigationModifierMultiple":P(NSTextSelectionNavigationModifierMultiple),
//   NSTextSelectionNavigationWritingDirection
            @"NSTextSelectionNavigationWritingDirectionLeftToRight":P(NSTextSelectionNavigationWritingDirectionLeftToRight),
            @"NSTextSelectionNavigationWritingDirectionRightToLeft":P(NSTextSelectionNavigationWritingDirectionRightToLeft),
//   NSTextSelectionNavigationLayoutOrientation
            @"NSTextSelectionNavigationLayoutOrientationHorizontal":P(NSTextSelectionNavigationLayoutOrientationHorizontal),
            @"NSTextSelectionNavigationLayoutOrientationVertical":P(NSTextSelectionNavigationLayoutOrientationVertical),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIActivityIndicatorView.h
//   UIActivityIndicatorViewStyle
            @"UIActivityIndicatorViewStyleMedium":P(UIActivityIndicatorViewStyleMedium),
            @"UIActivityIndicatorViewStyleLarge":P(UIActivityIndicatorViewStyleLarge),
            @"UIActivityIndicatorViewStyleWhiteLarge":P(UIActivityIndicatorViewStyleWhiteLarge),
            @"UIActivityIndicatorViewStyleWhite":P(UIActivityIndicatorViewStyleWhite),
            @"UIActivityIndicatorViewStyleGray":P(UIActivityIndicatorViewStyleGray),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIKeyConstants.h
//   UIKeyboardHIDUsage
            @"UIKeyboardHIDUsageKeyboardErrorRollOver":P(UIKeyboardHIDUsageKeyboardErrorRollOver),
            @"UIKeyboardHIDUsageKeyboardPOSTFail":P(UIKeyboardHIDUsageKeyboardPOSTFail),
            @"UIKeyboardHIDUsageKeyboardErrorUndefined":P(UIKeyboardHIDUsageKeyboardErrorUndefined),
            @"UIKeyboardHIDUsageKeyboardA":P(UIKeyboardHIDUsageKeyboardA),
            @"UIKeyboardHIDUsageKeyboardB":P(UIKeyboardHIDUsageKeyboardB),
            @"UIKeyboardHIDUsageKeyboardC":P(UIKeyboardHIDUsageKeyboardC),
            @"UIKeyboardHIDUsageKeyboardD":P(UIKeyboardHIDUsageKeyboardD),
            @"UIKeyboardHIDUsageKeyboardE":P(UIKeyboardHIDUsageKeyboardE),
            @"UIKeyboardHIDUsageKeyboardF":P(UIKeyboardHIDUsageKeyboardF),
            @"UIKeyboardHIDUsageKeyboardG":P(UIKeyboardHIDUsageKeyboardG),
            @"UIKeyboardHIDUsageKeyboardH":P(UIKeyboardHIDUsageKeyboardH),
            @"UIKeyboardHIDUsageKeyboardI":P(UIKeyboardHIDUsageKeyboardI),
            @"UIKeyboardHIDUsageKeyboardJ":P(UIKeyboardHIDUsageKeyboardJ),
            @"UIKeyboardHIDUsageKeyboardK":P(UIKeyboardHIDUsageKeyboardK),
            @"UIKeyboardHIDUsageKeyboardL":P(UIKeyboardHIDUsageKeyboardL),
            @"UIKeyboardHIDUsageKeyboardM":P(UIKeyboardHIDUsageKeyboardM),
            @"UIKeyboardHIDUsageKeyboardN":P(UIKeyboardHIDUsageKeyboardN),
            @"UIKeyboardHIDUsageKeyboardO":P(UIKeyboardHIDUsageKeyboardO),
            @"UIKeyboardHIDUsageKeyboardP":P(UIKeyboardHIDUsageKeyboardP),
            @"UIKeyboardHIDUsageKeyboardQ":P(UIKeyboardHIDUsageKeyboardQ),
            @"UIKeyboardHIDUsageKeyboardR":P(UIKeyboardHIDUsageKeyboardR),
            @"UIKeyboardHIDUsageKeyboardS":P(UIKeyboardHIDUsageKeyboardS),
            @"UIKeyboardHIDUsageKeyboardT":P(UIKeyboardHIDUsageKeyboardT),
            @"UIKeyboardHIDUsageKeyboardU":P(UIKeyboardHIDUsageKeyboardU),
            @"UIKeyboardHIDUsageKeyboardV":P(UIKeyboardHIDUsageKeyboardV),
            @"UIKeyboardHIDUsageKeyboardW":P(UIKeyboardHIDUsageKeyboardW),
            @"UIKeyboardHIDUsageKeyboardX":P(UIKeyboardHIDUsageKeyboardX),
            @"UIKeyboardHIDUsageKeyboardY":P(UIKeyboardHIDUsageKeyboardY),
            @"UIKeyboardHIDUsageKeyboardZ":P(UIKeyboardHIDUsageKeyboardZ),
            @"UIKeyboardHIDUsageKeyboardReturnOrEnter":P(UIKeyboardHIDUsageKeyboardReturnOrEnter),
            @"UIKeyboardHIDUsageKeyboardEscape":P(UIKeyboardHIDUsageKeyboardEscape),
            @"UIKeyboardHIDUsageKeyboardDeleteOrBackspace":P(UIKeyboardHIDUsageKeyboardDeleteOrBackspace),
            @"UIKeyboardHIDUsageKeyboardTab":P(UIKeyboardHIDUsageKeyboardTab),
            @"UIKeyboardHIDUsageKeyboardSpacebar":P(UIKeyboardHIDUsageKeyboardSpacebar),
            @"UIKeyboardHIDUsageKeyboardHyphen":P(UIKeyboardHIDUsageKeyboardHyphen),
            @"UIKeyboardHIDUsageKeyboardEqualSign":P(UIKeyboardHIDUsageKeyboardEqualSign),
            @"UIKeyboardHIDUsageKeyboardOpenBracket":P(UIKeyboardHIDUsageKeyboardOpenBracket),
            @"UIKeyboardHIDUsageKeyboardCloseBracket":P(UIKeyboardHIDUsageKeyboardCloseBracket),
            @"UIKeyboardHIDUsageKeyboardBackslash":P(UIKeyboardHIDUsageKeyboardBackslash),
            @"UIKeyboardHIDUsageKeyboardNonUSPound":P(UIKeyboardHIDUsageKeyboardNonUSPound),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIEditMenuInteraction.h
//   UIEditMenuArrowDirection
            @"UIEditMenuArrowDirectionAutomatic":P(UIEditMenuArrowDirectionAutomatic),
            @"UIEditMenuArrowDirectionUp":P(UIEditMenuArrowDirectionUp),
            @"UIEditMenuArrowDirectionDown":P(UIEditMenuArrowDirectionDown),
            @"UIEditMenuArrowDirectionLeft":P(UIEditMenuArrowDirectionLeft),
            @"UIEditMenuArrowDirectionRight":P(UIEditMenuArrowDirectionRight),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPasteControl.h
//   UIPasteControlDisplayMode
            @"UIPasteControlDisplayModeIconAndLabel":P(UIPasteControlDisplayModeIconAndLabel),
            @"UIPasteControlDisplayModeIconOnly":P(UIPasteControlDisplayModeIconOnly),
            @"UIPasteControlDisplayModeLabelOnly":P(UIPasteControlDisplayModeLabelOnly),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICollectionViewLayout.h
//   UICollectionViewScrollDirection
            @"UICollectionViewScrollDirectionVertical":P(UICollectionViewScrollDirectionVertical),
            @"UICollectionViewScrollDirectionHorizontal":P(UICollectionViewScrollDirectionHorizontal),
//   UICollectionElementCategory
            @"UICollectionElementCategoryCell":P(UICollectionElementCategoryCell),
            @"UICollectionElementCategorySupplementaryView":P(UICollectionElementCategorySupplementaryView),
            @"UICollectionElementCategoryDecorationView":P(UICollectionElementCategoryDecorationView),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICloudSharingController.h
//   UICloudSharingPermissionOptions
            @"UICloudSharingPermissionStandard":P(UICloudSharingPermissionStandard),
            @"UICloudSharingPermissionAllowPublic":P(UICloudSharingPermissionAllowPublic),
            @"UICloudSharingPermissionAllowPrivate":P(UICloudSharingPermissionAllowPrivate),
            @"UICloudSharingPermissionAllowReadOnly":P(UICloudSharingPermissionAllowReadOnly),
            @"UICloudSharingPermissionAllowReadWrite":P(UICloudSharingPermissionAllowReadWrite),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIResponder.h
//   UIEditingInteractionConfiguration
            @"UIEditingInteractionConfigurationNone":P(UIEditingInteractionConfigurationNone),
            @"UIEditingInteractionConfigurationDefault":P(UIEditingInteractionConfigurationDefault),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIGraphicsImageRenderer.h
//   UIGraphicsImageRendererFormatRange
            @"UIGraphicsImageRendererFormatRangeUnspecified":P(UIGraphicsImageRendererFormatRangeUnspecified),
            @"UIGraphicsImageRendererFormatRangeAutomatic":P(UIGraphicsImageRendererFormatRangeAutomatic),
            @"UIGraphicsImageRendererFormatRangeExtended":P(UIGraphicsImageRendererFormatRangeExtended),
            @"UIGraphicsImageRendererFormatRangeStandard":P(UIGraphicsImageRendererFormatRangeStandard),

//   Enum definitions in ./enum_gen/UIKit/Headers/UINotificationFeedbackGenerator.h
//   UINotificationFeedbackType
            @"UINotificationFeedbackTypeSuccess":P(UINotificationFeedbackTypeSuccess),
            @"UINotificationFeedbackTypeWarning":P(UINotificationFeedbackTypeWarning),
            @"UINotificationFeedbackTypeError":P(UINotificationFeedbackTypeError),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIMenuElement.h
//   UIMenuElementState
            @"UIMenuElementStateOff":P(UIMenuElementStateOff),
            @"UIMenuElementStateOn":P(UIMenuElementStateOn),
            @"UIMenuElementStateMixed":P(UIMenuElementStateMixed),
//   UIMenuElementAttributes
            @"UIMenuElementAttributesDisabled":P(UIMenuElementAttributesDisabled),
            @"UIMenuElementAttributesDestructive":P(UIMenuElementAttributesDestructive),
            @"UIMenuElementAttributesHidden":P(UIMenuElementAttributesHidden),
            @"UIMenuElementAttributesKeepsMenuPresented":P(UIMenuElementAttributesKeepsMenuPresented),

//   Enum definitions in ./enum_gen/UIKit/Headers/UILetterformAwareAdjusting.h
//   UILetterformAwareSizingRule
            @"UILetterformAwareSizingRuleTypographic":P(UILetterformAwareSizingRuleTypographic),
            @"UILetterformAwareSizingRuleOversize":P(UILetterformAwareSizingRuleOversize),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPointerStyle.h
//   UIPointerEffectTintMode
            @"UIPointerEffectTintModeNone":P(UIPointerEffectTintModeNone),
            @"UIPointerEffectTintModeOverlay":P(UIPointerEffectTintModeOverlay),
            @"UIPointerEffectTintModeUnderlay":P(UIPointerEffectTintModeUnderlay),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextInput.h
//   UITextStorageDirection
            @"UITextStorageDirectionForward":P(UITextStorageDirectionForward),
            @"UITextStorageDirectionBackward":P(UITextStorageDirectionBackward),
//   UITextLayoutDirection
            @"UITextLayoutDirectionRight":P(UITextLayoutDirectionRight),
            @"UITextLayoutDirectionLeft":P(UITextLayoutDirectionLeft),
            @"UITextLayoutDirectionUp":P(UITextLayoutDirectionUp),
            @"UITextLayoutDirectionDown":P(UITextLayoutDirectionDown),
//   UITextGranularity
            @"UITextGranularityCharacter":P(UITextGranularityCharacter),
            @"UITextGranularityWord":P(UITextGranularityWord),
            @"UITextGranularitySentence":P(UITextGranularitySentence),
            @"UITextGranularityParagraph":P(UITextGranularityParagraph),
            @"UITextGranularityLine":P(UITextGranularityLine),
            @"UITextGranularityDocument":P(UITextGranularityDocument),
//   UITextAlternativeStyle
            @"UITextAlternativeStyleNone":P(UITextAlternativeStyleNone),
            @"UITextAlternativeStyleLowConfidence":P(UITextAlternativeStyleLowConfidence),

//   Enum definitions in ./enum_gen/UIKit/Headers/UISearchBar.h
//   UISearchBarIcon
            @"UISearchBarIconSearch":P(UISearchBarIconSearch),
            @"UISearchBarIconClear":P(UISearchBarIconClear),
            @"UISearchBarIconBookmark":P(UISearchBarIconBookmark),
            @"UISearchBarIconResultsList":P(UISearchBarIconResultsList),
//   UISearchBarStyle
            @"UISearchBarStyleDefault":P(UISearchBarStyleDefault),
            @"UISearchBarStyleProminent":P(UISearchBarStyleProminent),
            @"UISearchBarStyleMinimal":P(UISearchBarStyleMinimal),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIStringDrawing.h
//   UILineBreakMode
            @"UILineBreakModeWordWrap":P(UILineBreakModeWordWrap),
            @"UILineBreakModeCharacterWrap":P(UILineBreakModeCharacterWrap),
            @"UILineBreakModeClip":P(UILineBreakModeClip),
            @"UILineBreakModeHeadTruncation":P(UILineBreakModeHeadTruncation),
            @"UILineBreakModeTailTruncation":P(UILineBreakModeTailTruncation),
            @"UILineBreakModeMiddleTruncation":P(UILineBreakModeMiddleTruncation),
//   UITextAlignment
            @"UITextAlignmentLeft":P(UITextAlignmentLeft),
            @"UITextAlignmentCenter":P(UITextAlignmentCenter),
            @"UITextAlignmentRight":P(UITextAlignmentRight),
//   UIBaselineAdjustment
            @"UIBaselineAdjustmentAlignBaselines":P(UIBaselineAdjustmentAlignBaselines),
            @"UIBaselineAdjustmentAlignCenters":P(UIBaselineAdjustmentAlignCenters),
            @"UIBaselineAdjustmentNone":P(UIBaselineAdjustmentNone),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDevice.h
//   UIDeviceBatteryState
            @"UIDeviceBatteryStateUnknown":P(UIDeviceBatteryStateUnknown),
            @"UIDeviceBatteryStateUnplugged":P(UIDeviceBatteryStateUnplugged),
            @"UIDeviceBatteryStateCharging":P(UIDeviceBatteryStateCharging),
            @"UIDeviceBatteryStateFull":P(UIDeviceBatteryStateFull),
//   UIUserInterfaceIdiom
            @"UIUserInterfaceIdiomUnspecified":P(UIUserInterfaceIdiomUnspecified),
            @"UIUserInterfaceIdiomPhone":P(UIUserInterfaceIdiomPhone),
            @"UIUserInterfaceIdiomPad":P(UIUserInterfaceIdiomPad),
            @"UIUserInterfaceIdiomTV":P(UIUserInterfaceIdiomTV),
            @"UIUserInterfaceIdiomCarPlay":P(UIUserInterfaceIdiomCarPlay),
            @"UIUserInterfaceIdiomMac":P(UIUserInterfaceIdiomMac),
            @"UIUserInterfaceIdiomVision":P(UIUserInterfaceIdiomVision),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIWindowSceneGeometry.h
//   UIWindowSceneResizingRestrictions

//   Enum definitions in ./enum_gen/UIKit/Headers/UICollectionViewFlowLayout.h
//   UICollectionViewFlowLayoutSectionInsetReference
            @"UICollectionViewFlowLayoutSectionInsetFromContentInset":P(UICollectionViewFlowLayoutSectionInsetFromContentInset),
            @"UICollectionViewFlowLayoutSectionInsetFromSafeArea":P(UICollectionViewFlowLayoutSectionInsetFromSafeArea),
            @"UICollectionViewFlowLayoutSectionInsetFromLayoutMargins":P(UICollectionViewFlowLayoutSectionInsetFromLayoutMargins),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIApplicationShortcutItem.h
//   UIApplicationShortcutIconType
            @"UIApplicationShortcutIconTypeCompose":P(UIApplicationShortcutIconTypeCompose),
            @"UIApplicationShortcutIconTypePlay":P(UIApplicationShortcutIconTypePlay),
            @"UIApplicationShortcutIconTypePause":P(UIApplicationShortcutIconTypePause),
            @"UIApplicationShortcutIconTypeAdd":P(UIApplicationShortcutIconTypeAdd),
            @"UIApplicationShortcutIconTypeLocation":P(UIApplicationShortcutIconTypeLocation),
            @"UIApplicationShortcutIconTypeSearch":P(UIApplicationShortcutIconTypeSearch),
            @"UIApplicationShortcutIconTypeShare":P(UIApplicationShortcutIconTypeShare),
            @"UIApplicationShortcutIconTypeProhibit":P(UIApplicationShortcutIconTypeProhibit),
            @"UIApplicationShortcutIconTypeContact":P(UIApplicationShortcutIconTypeContact),
            @"UIApplicationShortcutIconTypeHome":P(UIApplicationShortcutIconTypeHome),
            @"UIApplicationShortcutIconTypeMarkLocation":P(UIApplicationShortcutIconTypeMarkLocation),
            @"UIApplicationShortcutIconTypeFavorite":P(UIApplicationShortcutIconTypeFavorite),
            @"UIApplicationShortcutIconTypeLove":P(UIApplicationShortcutIconTypeLove),
            @"UIApplicationShortcutIconTypeCloud":P(UIApplicationShortcutIconTypeCloud),
            @"UIApplicationShortcutIconTypeInvitation":P(UIApplicationShortcutIconTypeInvitation),
            @"UIApplicationShortcutIconTypeConfirmation":P(UIApplicationShortcutIconTypeConfirmation),
            @"UIApplicationShortcutIconTypeMail":P(UIApplicationShortcutIconTypeMail),
            @"UIApplicationShortcutIconTypeMessage":P(UIApplicationShortcutIconTypeMessage),
            @"UIApplicationShortcutIconTypeDate":P(UIApplicationShortcutIconTypeDate),
            @"UIApplicationShortcutIconTypeTime":P(UIApplicationShortcutIconTypeTime),
            @"UIApplicationShortcutIconTypeCapturePhoto":P(UIApplicationShortcutIconTypeCapturePhoto),
            @"UIApplicationShortcutIconTypeCaptureVideo":P(UIApplicationShortcutIconTypeCaptureVideo),
            @"UIApplicationShortcutIconTypeTask":P(UIApplicationShortcutIconTypeTask),
            @"UIApplicationShortcutIconTypeTaskCompleted":P(UIApplicationShortcutIconTypeTaskCompleted),
            @"UIApplicationShortcutIconTypeAlarm":P(UIApplicationShortcutIconTypeAlarm),
            @"UIApplicationShortcutIconTypeBookmark":P(UIApplicationShortcutIconTypeBookmark),
            @"UIApplicationShortcutIconTypeShuffle":P(UIApplicationShortcutIconTypeShuffle),
            @"UIApplicationShortcutIconTypeAudio":P(UIApplicationShortcutIconTypeAudio),
            @"UIApplicationShortcutIconTypeUpdate":P(UIApplicationShortcutIconTypeUpdate),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPress.h
//   UIPressPhase
            @"UIPressPhaseBegan":P(UIPressPhaseBegan),
            @"UIPressPhaseChanged":P(UIPressPhaseChanged),
            @"UIPressPhaseStationary":P(UIPressPhaseStationary),
            @"UIPressPhaseEnded":P(UIPressPhaseEnded),
            @"UIPressPhaseCancelled":P(UIPressPhaseCancelled),
//   UIPressType
            @"UIPressTypeUpArrow":P(UIPressTypeUpArrow),
            @"UIPressTypeDownArrow":P(UIPressTypeDownArrow),
            @"UIPressTypeLeftArrow":P(UIPressTypeLeftArrow),
            @"UIPressTypeRightArrow":P(UIPressTypeRightArrow),
            @"UIPressTypeSelect":P(UIPressTypeSelect),
            @"UIPressTypeMenu":P(UIPressTypeMenu),
            @"UIPressTypePlayPause":P(UIPressTypePlayPause),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIEvent.h
//   UIEventType
            @"UIEventTypeTouches":P(UIEventTypeTouches),
            @"UIEventTypeMotion":P(UIEventTypeMotion),
            @"UIEventTypeRemoteControl":P(UIEventTypeRemoteControl),
            @"UIEventTypePresses":P(UIEventTypePresses),
            @"UIEventTypeScroll":P(UIEventTypeScroll),
            @"UIEventTypeHover":P(UIEventTypeHover),
            @"UIEventTypeTransform":P(UIEventTypeTransform),
//   UIEventSubtype
            @"UIEventSubtypeNone":P(UIEventSubtypeNone),
            @"UIEventSubtypeMotionShake":P(UIEventSubtypeMotionShake),
            @"UIEventSubtypeRemoteControlPlay":P(UIEventSubtypeRemoteControlPlay),
            @"UIEventSubtypeRemoteControlPause":P(UIEventSubtypeRemoteControlPause),
            @"UIEventSubtypeRemoteControlStop":P(UIEventSubtypeRemoteControlStop),
            @"UIEventSubtypeRemoteControlTogglePlayPause":P(UIEventSubtypeRemoteControlTogglePlayPause),
            @"UIEventSubtypeRemoteControlNextTrack":P(UIEventSubtypeRemoteControlNextTrack),
            @"UIEventSubtypeRemoteControlPreviousTrack":P(UIEventSubtypeRemoteControlPreviousTrack),
            @"UIEventSubtypeRemoteControlBeginSeekingBackward":P(UIEventSubtypeRemoteControlBeginSeekingBackward),
            @"UIEventSubtypeRemoteControlEndSeekingBackward":P(UIEventSubtypeRemoteControlEndSeekingBackward),
            @"UIEventSubtypeRemoteControlBeginSeekingForward":P(UIEventSubtypeRemoteControlBeginSeekingForward),
            @"UIEventSubtypeRemoteControlEndSeekingForward":P(UIEventSubtypeRemoteControlEndSeekingForward),
//   UIEventButtonMask
            @"UIEventButtonMaskPrimary":P(UIEventButtonMaskPrimary),
            @"UIEventButtonMaskSecondary":P(UIEventButtonMaskSecondary),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICommand.h
//   UIKeyModifierFlags
            @"UIKeyModifierAlphaShift":P(UIKeyModifierAlphaShift),
            @"UIKeyModifierShift":P(UIKeyModifierShift),
            @"UIKeyModifierControl":P(UIKeyModifierControl),
            @"UIKeyModifierAlternate":P(UIKeyModifierAlternate),
            @"UIKeyModifierCommand":P(UIKeyModifierCommand),
            @"UIKeyModifierNumericPad":P(UIKeyModifierNumericPad),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIInputView.h
//   UIInputViewStyle
            @"UIInputViewStyleDefault":P(UIInputViewStyleDefault),
            @"UIInputViewStyleKeyboard":P(UIInputViewStyleKeyboard),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIInterface.h
//   UIBarStyle
            @"UIBarStyleDefault":P(UIBarStyleDefault),
            @"UIBarStyleBlack":P(UIBarStyleBlack),
            @"UIBarStyleBlackOpaque":P(UIBarStyleBlackOpaque),
            @"UIBarStyleBlackTranslucent":P(UIBarStyleBlackTranslucent),
//   UIUserInterfaceSizeClass
            @"UIUserInterfaceSizeClassUnspecified":P(UIUserInterfaceSizeClassUnspecified),
            @"UIUserInterfaceSizeClassCompact":P(UIUserInterfaceSizeClassCompact),
            @"UIUserInterfaceSizeClassRegular":P(UIUserInterfaceSizeClassRegular),
//   UIUserInterfaceStyle
            @"UIUserInterfaceStyleUnspecified":P(UIUserInterfaceStyleUnspecified),
            @"UIUserInterfaceStyleLight":P(UIUserInterfaceStyleLight),
            @"UIUserInterfaceStyleDark":P(UIUserInterfaceStyleDark),
//   UIUserInterfaceLayoutDirection
            @"UIUserInterfaceLayoutDirectionLeftToRight":P(UIUserInterfaceLayoutDirectionLeftToRight),
            @"UIUserInterfaceLayoutDirectionRightToLeft":P(UIUserInterfaceLayoutDirectionRightToLeft),
//   UITraitEnvironmentLayoutDirection
            @"UITraitEnvironmentLayoutDirectionUnspecified":P(UITraitEnvironmentLayoutDirectionUnspecified),
            @"UITraitEnvironmentLayoutDirectionLeftToRight":P(UITraitEnvironmentLayoutDirectionLeftToRight),
            @"UITraitEnvironmentLayoutDirectionRightToLeft":P(UITraitEnvironmentLayoutDirectionRightToLeft),
//   UIDisplayGamut
            @"UIDisplayGamutUnspecified":P(UIDisplayGamutUnspecified),
            @"UIDisplayGamutSRGB":P(UIDisplayGamutSRGB),
//   UIAccessibilityContrast
            @"UIAccessibilityContrastUnspecified":P(UIAccessibilityContrastUnspecified),
            @"UIAccessibilityContrastNormal":P(UIAccessibilityContrastNormal),
            @"UIAccessibilityContrastHigh":P(UIAccessibilityContrastHigh),
//   UILegibilityWeight
            @"UILegibilityWeightUnspecified":P(UILegibilityWeightUnspecified),
            @"UILegibilityWeightRegular":P(UILegibilityWeightRegular),
            @"UILegibilityWeightBold":P(UILegibilityWeightBold),
//   UIUserInterfaceLevel
            @"UIUserInterfaceLevelUnspecified":P(UIUserInterfaceLevelUnspecified),
            @"UIUserInterfaceLevelBase":P(UIUserInterfaceLevelBase),
            @"UIUserInterfaceLevelElevated":P(UIUserInterfaceLevelElevated),
//   UIUserInterfaceActiveAppearance
            @"UIUserInterfaceActiveAppearanceUnspecified":P(UIUserInterfaceActiveAppearanceUnspecified),
            @"UIUserInterfaceActiveAppearanceInactive":P(UIUserInterfaceActiveAppearanceInactive),
            @"UIUserInterfaceActiveAppearanceActive":P(UIUserInterfaceActiveAppearanceActive),
//   UINSToolbarItemPresentationSize
            @"UINSToolbarItemPresentationSizeUnspecified":P(UINSToolbarItemPresentationSizeUnspecified),
            @"UINSToolbarItemPresentationSizeRegular":P(UINSToolbarItemPresentationSizeRegular),
            @"UINSToolbarItemPresentationSizeSmall":P(UINSToolbarItemPresentationSizeSmall),
            @"UINSToolbarItemPresentationSizeLarge":P(UINSToolbarItemPresentationSizeLarge),
//   UIImageDynamicRange
            @"UIImageDynamicRangeUnspecified":P(UIImageDynamicRangeUnspecified),
            @"UIImageDynamicRangeStandard":P(UIImageDynamicRangeStandard),
            @"UIImageDynamicRangeConstrainedHigh":P(UIImageDynamicRangeConstrainedHigh),
            @"UIImageDynamicRangeHigh":P(UIImageDynamicRangeHigh),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIImagePickerController.h
//   UIImagePickerControllerSourceType
            @"UIImagePickerControllerSourceTypePhotoLibrary":P(UIImagePickerControllerSourceTypePhotoLibrary),
            @"UIImagePickerControllerSourceTypeCamera":P(UIImagePickerControllerSourceTypeCamera),
            @"UIImagePickerControllerSourceTypeSavedPhotosAlbum":P(UIImagePickerControllerSourceTypeSavedPhotosAlbum),
//   UIImagePickerControllerQualityType
            @"UIImagePickerControllerQualityTypeHigh":P(UIImagePickerControllerQualityTypeHigh),
            @"UIImagePickerControllerQualityTypeMedium":P(UIImagePickerControllerQualityTypeMedium),
            @"UIImagePickerControllerQualityTypeLow":P(UIImagePickerControllerQualityTypeLow),
//   UIImagePickerControllerCameraCaptureMode
            @"UIImagePickerControllerCameraCaptureModePhoto":P(UIImagePickerControllerCameraCaptureModePhoto),
            @"UIImagePickerControllerCameraCaptureModeVideo":P(UIImagePickerControllerCameraCaptureModeVideo),
//   UIImagePickerControllerCameraDevice
            @"UIImagePickerControllerCameraDeviceRear":P(UIImagePickerControllerCameraDeviceRear),
            @"UIImagePickerControllerCameraDeviceFront":P(UIImagePickerControllerCameraDeviceFront),
//   UIImagePickerControllerCameraFlashMode
            @"UIImagePickerControllerCameraFlashModeOff":P(UIImagePickerControllerCameraFlashModeOff),
            @"UIImagePickerControllerCameraFlashModeAuto":P(UIImagePickerControllerCameraFlashModeAuto),
            @"UIImagePickerControllerCameraFlashModeOn":P(UIImagePickerControllerCameraFlashModeOn),
//   UIImagePickerControllerImageURLExportPreset
            @"UIImagePickerControllerImageURLExportPresetCompatible":P(UIImagePickerControllerImageURLExportPresetCompatible),
            @"UIImagePickerControllerImageURLExportPresetCurrent":P(UIImagePickerControllerImageURLExportPresetCurrent),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPrintPageRenderer.h
//   UIPrintRenderingQuality

//   Enum definitions in ./enum_gen/UIKit/Headers/UIAccessibilityZoom.h
//   UIAccessibilityZoomType
            @"UIAccessibilityZoomTypeInsertionPoint":P(UIAccessibilityZoomTypeInsertionPoint),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDocumentBrowserAction.h
//   UIDocumentBrowserActionAvailability
            @"UIDocumentBrowserActionAvailabilityMenu":P(UIDocumentBrowserActionAvailabilityMenu),
            @"UIDocumentBrowserActionAvailabilityNavigationBar":P(UIDocumentBrowserActionAvailabilityNavigationBar),

//   Enum definitions in ./enum_gen/UIKit/Headers/UISwipeGestureRecognizer.h
//   UISwipeGestureRecognizerDirection
            @"UISwipeGestureRecognizerDirectionRight":P(UISwipeGestureRecognizerDirectionRight),
            @"UISwipeGestureRecognizerDirectionLeft":P(UISwipeGestureRecognizerDirectionLeft),
            @"UISwipeGestureRecognizerDirectionUp":P(UISwipeGestureRecognizerDirectionUp),
            @"UISwipeGestureRecognizerDirectionDown":P(UISwipeGestureRecognizerDirectionDown),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPrintInfo.h
//   UIPrintInfoOutputType
            @"UIPrintInfoOutputGeneral":P(UIPrintInfoOutputGeneral),
            @"UIPrintInfoOutputPhoto":P(UIPrintInfoOutputPhoto),
            @"UIPrintInfoOutputGrayscale":P(UIPrintInfoOutputGrayscale),
            @"UIPrintInfoOutputPhotoGrayscale":P(UIPrintInfoOutputPhotoGrayscale),
//   UIPrintInfoOrientation
            @"UIPrintInfoOrientationPortrait":P(UIPrintInfoOrientationPortrait),
            @"UIPrintInfoOrientationLandscape":P(UIPrintInfoOrientationLandscape),
//   UIPrintInfoDuplex
            @"UIPrintInfoDuplexNone":P(UIPrintInfoDuplexNone),
            @"UIPrintInfoDuplexLongEdge":P(UIPrintInfoDuplexLongEdge),
            @"UIPrintInfoDuplexShortEdge":P(UIPrintInfoDuplexShortEdge),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextDropProposal.h
//   UITextDropAction
//   UITextDropProgressMode
//   UITextDropPerformer

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextField.h
//   UITextBorderStyle
            @"UITextBorderStyleNone":P(UITextBorderStyleNone),
            @"UITextBorderStyleLine":P(UITextBorderStyleLine),
            @"UITextBorderStyleBezel":P(UITextBorderStyleBezel),
            @"UITextBorderStyleRoundedRect":P(UITextBorderStyleRoundedRect),
//   UITextFieldViewMode
            @"UITextFieldViewModeNever":P(UITextFieldViewModeNever),
            @"UITextFieldViewModeWhileEditing":P(UITextFieldViewModeWhileEditing),
            @"UITextFieldViewModeUnlessEditing":P(UITextFieldViewModeUnlessEditing),
            @"UITextFieldViewModeAlways":P(UITextFieldViewModeAlways),
//   UITextFieldDidEndEditingReason
            @"UITextFieldDidEndEditingReasonCommitted":P(UITextFieldDidEndEditingReasonCommitted),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSText.h
//   NSTextAlignment
            @"NSTextAlignmentLeft":P(NSTextAlignmentLeft),
            @"NSTextAlignmentCenter":P(NSTextAlignmentCenter),
            @"NSTextAlignmentRight":P(NSTextAlignmentRight),
            @"NSTextAlignmentRight":P(NSTextAlignmentRight),
            @"NSTextAlignmentCenter":P(NSTextAlignmentCenter),
            @"NSTextAlignmentJustified":P(NSTextAlignmentJustified),
            @"NSTextAlignmentNatural":P(NSTextAlignmentNatural),
//   NSWritingDirection
            @"NSWritingDirectionNatural":P(NSWritingDirectionNatural),
            @"NSWritingDirectionLeftToRight":P(NSWritingDirectionLeftToRight),
            @"NSWritingDirectionRightToLeft":P(NSWritingDirectionRightToLeft),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICellAccessory.h
//   UICellAccessoryDisplayedState
            @"UICellAccessoryDisplayedAlways":P(UICellAccessoryDisplayedAlways),
            @"UICellAccessoryDisplayedWhenEditing":P(UICellAccessoryDisplayedWhenEditing),
            @"UICellAccessoryDisplayedWhenNotEditing":P(UICellAccessoryDisplayedWhenNotEditing),
//   UICellAccessoryOutlineDisclosureStyle
            @"UICellAccessoryOutlineDisclosureStyleAutomatic":P(UICellAccessoryOutlineDisclosureStyleAutomatic),
            @"UICellAccessoryOutlineDisclosureStyleHeader":P(UICellAccessoryOutlineDisclosureStyleHeader),
            @"UICellAccessoryOutlineDisclosureStyleCell":P(UICellAccessoryOutlineDisclosureStyleCell),
//   UICellAccessoryPlacement
            @"UICellAccessoryPlacementLeading":P(UICellAccessoryPlacementLeading),
            @"UICellAccessoryPlacementTrailing":P(UICellAccessoryPlacementTrailing),

//   Enum definitions in ./enum_gen/UIKit/Headers/UILabel.h
//   UILabelVibrancy
            @"UILabelVibrancyNone":P(UILabelVibrancyNone),
            @"UILabelVibrancyAutomatic":P(UILabelVibrancyAutomatic),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIAlertController.h
//   UIAlertActionStyle
            @"UIAlertActionStyleDefault":P(UIAlertActionStyleDefault),
            @"UIAlertActionStyleCancel":P(UIAlertActionStyleCancel),
            @"UIAlertActionStyleDestructive":P(UIAlertActionStyleDestructive),
//   UIAlertControllerStyle
            @"UIAlertControllerStyleActionSheet":P(UIAlertControllerStyleActionSheet),
            @"UIAlertControllerStyleAlert":P(UIAlertControllerStyleAlert),
//   UIAlertControllerSeverity
            @"UIAlertControllerSeverityDefault":P(UIAlertControllerSeverityDefault),
            @"UIAlertControllerSeverityCritical":P(UIAlertControllerSeverityCritical),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIScrollView.h
//   UIScrollViewIndicatorStyle
            @"UIScrollViewIndicatorStyleDefault":P(UIScrollViewIndicatorStyleDefault),
            @"UIScrollViewIndicatorStyleBlack":P(UIScrollViewIndicatorStyleBlack),
            @"UIScrollViewIndicatorStyleWhite":P(UIScrollViewIndicatorStyleWhite),
//   UIScrollViewKeyboardDismissMode
            @"UIScrollViewKeyboardDismissModeNone":P(UIScrollViewKeyboardDismissModeNone),
            @"UIScrollViewKeyboardDismissModeOnDrag":P(UIScrollViewKeyboardDismissModeOnDrag),
            @"UIScrollViewKeyboardDismissModeInteractive":P(UIScrollViewKeyboardDismissModeInteractive),
            @"UIScrollViewKeyboardDismissModeOnDragWithAccessory":P(UIScrollViewKeyboardDismissModeOnDragWithAccessory),
            @"UIScrollViewKeyboardDismissModeInteractiveWithAccessory":P(UIScrollViewKeyboardDismissModeInteractiveWithAccessory),
//   UIScrollViewIndexDisplayMode
            @"UIScrollViewIndexDisplayModeAutomatic":P(UIScrollViewIndexDisplayModeAutomatic),
            @"UIScrollViewIndexDisplayModeAlwaysHidden":P(UIScrollViewIndexDisplayModeAlwaysHidden),
//   UIScrollViewContentInsetAdjustmentBehavior
            @"UIScrollViewContentInsetAdjustmentAutomatic":P(UIScrollViewContentInsetAdjustmentAutomatic),
            @"UIScrollViewContentInsetAdjustmentScrollableAxes":P(UIScrollViewContentInsetAdjustmentScrollableAxes),
            @"UIScrollViewContentInsetAdjustmentNever":P(UIScrollViewContentInsetAdjustmentNever),
            @"UIScrollViewContentInsetAdjustmentAlways":P(UIScrollViewContentInsetAdjustmentAlways),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIContextMenuInteraction.h
//   UIContextMenuInteractionCommitStyle
            @"UIContextMenuInteractionCommitStyleDismiss":P(UIContextMenuInteractionCommitStyleDismiss),
            @"UIContextMenuInteractionCommitStylePop":P(UIContextMenuInteractionCommitStylePop),
//   UIContextMenuInteractionAppearance
            @"UIContextMenuInteractionAppearanceUnknown":P(UIContextMenuInteractionAppearanceUnknown),
            @"UIContextMenuInteractionAppearanceRich":P(UIContextMenuInteractionAppearanceRich),
            @"UIContextMenuInteractionAppearanceCompact":P(UIContextMenuInteractionAppearanceCompact),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDropInteraction.h
//   UIDropOperation

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDragSession.h
//   UIDropSessionProgressIndicatorStyle
            @"UIDropSessionProgressIndicatorStyleNone":P(UIDropSessionProgressIndicatorStyleNone),
            @"UIDropSessionProgressIndicatorStyleDefault":P(UIDropSessionProgressIndicatorStyleDefault),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPushBehavior.h
//   UIPushBehaviorMode
            @"UIPushBehaviorModeContinuous":P(UIPushBehaviorModeContinuous),
            @"UIPushBehaviorModeInstantaneous":P(UIPushBehaviorModeInstantaneous),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIViewController.h
//   UIModalTransitionStyle
            @"UIModalTransitionStyleCoverVertical":P(UIModalTransitionStyleCoverVertical),
            @"UIModalTransitionStyleFlipHorizontal":P(UIModalTransitionStyleFlipHorizontal),
            @"UIModalTransitionStyleCrossDissolve":P(UIModalTransitionStyleCrossDissolve),
            @"UIModalTransitionStylePartialCurl":P(UIModalTransitionStylePartialCurl),
//   UIModalPresentationStyle
            @"UIModalPresentationFullScreen":P(UIModalPresentationFullScreen),
            @"UIModalPresentationPageSheet":P(UIModalPresentationPageSheet),
            @"UIModalPresentationFormSheet":P(UIModalPresentationFormSheet),
            @"UIModalPresentationCurrentContext":P(UIModalPresentationCurrentContext),
            @"UIModalPresentationCustom":P(UIModalPresentationCustom),
            @"UIModalPresentationOverFullScreen":P(UIModalPresentationOverFullScreen),
            @"UIModalPresentationOverCurrentContext":P(UIModalPresentationOverCurrentContext),
            @"UIModalPresentationPopover":P(UIModalPresentationPopover),
            @"UIModalPresentationNone":P(UIModalPresentationNone),
            @"UIModalPresentationAutomatic":P(UIModalPresentationAutomatic),
//   UIContainerBackgroundStyle
//  UIPreviewActionStyle
            @"UIPreviewActionStyleDefault":P(UIPreviewActionStyleDefault),
            @"UIPreviewActionStyleSelected":P(UIPreviewActionStyleSelected),
            @"UIPreviewActionStyleDestructive":P(UIPreviewActionStyleDestructive),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITabBarItem.h
//   UITabBarSystemItem
            @"UITabBarSystemItemMore":P(UITabBarSystemItemMore),
            @"UITabBarSystemItemFavorites":P(UITabBarSystemItemFavorites),
            @"UITabBarSystemItemFeatured":P(UITabBarSystemItemFeatured),
            @"UITabBarSystemItemTopRated":P(UITabBarSystemItemTopRated),
            @"UITabBarSystemItemRecents":P(UITabBarSystemItemRecents),
            @"UITabBarSystemItemContacts":P(UITabBarSystemItemContacts),
            @"UITabBarSystemItemHistory":P(UITabBarSystemItemHistory),
            @"UITabBarSystemItemBookmarks":P(UITabBarSystemItemBookmarks),
            @"UITabBarSystemItemSearch":P(UITabBarSystemItemSearch),
            @"UITabBarSystemItemDownloads":P(UITabBarSystemItemDownloads),
            @"UITabBarSystemItemMostRecent":P(UITabBarSystemItemMostRecent),
            @"UITabBarSystemItemMostViewed":P(UITabBarSystemItemMostViewed),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSLayoutConstraint.h
//   NSLayoutRelation
            @"NSLayoutRelationLessThanOrEqual":P(NSLayoutRelationLessThanOrEqual),
            @"NSLayoutRelationEqual":P(NSLayoutRelationEqual),
            @"NSLayoutRelationGreaterThanOrEqual":P(NSLayoutRelationGreaterThanOrEqual),
//   NSLayoutAttribute
            @"NSLayoutAttributeLeft":P(NSLayoutAttributeLeft),
            @"NSLayoutAttributeRight":P(NSLayoutAttributeRight),
            @"NSLayoutAttributeTop":P(NSLayoutAttributeTop),
            @"NSLayoutAttributeBottom":P(NSLayoutAttributeBottom),
            @"NSLayoutAttributeLeading":P(NSLayoutAttributeLeading),
            @"NSLayoutAttributeTrailing":P(NSLayoutAttributeTrailing),
            @"NSLayoutAttributeWidth":P(NSLayoutAttributeWidth),
            @"NSLayoutAttributeHeight":P(NSLayoutAttributeHeight),
            @"NSLayoutAttributeCenterX":P(NSLayoutAttributeCenterX),
            @"NSLayoutAttributeCenterY":P(NSLayoutAttributeCenterY),
            @"NSLayoutAttributeLastBaseline":P(NSLayoutAttributeLastBaseline),
            @"NSLayoutAttributeBaseline":P(NSLayoutAttributeBaseline),
            @"NSLayoutAttributeBaseline":P(NSLayoutAttributeBaseline),
            @"NSLayoutAttributeFirstBaseline":P(NSLayoutAttributeFirstBaseline),
            @"NSLayoutAttributeLeftMargin":P(NSLayoutAttributeLeftMargin),
            @"NSLayoutAttributeRightMargin":P(NSLayoutAttributeRightMargin),
            @"NSLayoutAttributeTopMargin":P(NSLayoutAttributeTopMargin),
            @"NSLayoutAttributeBottomMargin":P(NSLayoutAttributeBottomMargin),
            @"NSLayoutAttributeLeadingMargin":P(NSLayoutAttributeLeadingMargin),
            @"NSLayoutAttributeTrailingMargin":P(NSLayoutAttributeTrailingMargin),
            @"NSLayoutAttributeCenterXWithinMargins":P(NSLayoutAttributeCenterXWithinMargins),
            @"NSLayoutAttributeCenterYWithinMargins":P(NSLayoutAttributeCenterYWithinMargins),
            @"NSLayoutAttributeNotAnAttribute":P(NSLayoutAttributeNotAnAttribute),
//   NSLayoutFormatOptions
            @"NSLayoutFormatAlignAllLeft":P(NSLayoutFormatAlignAllLeft),
            @"NSLayoutFormatAlignAllRight":P(NSLayoutFormatAlignAllRight),
            @"NSLayoutFormatAlignAllTop":P(NSLayoutFormatAlignAllTop),
            @"NSLayoutFormatAlignAllBottom":P(NSLayoutFormatAlignAllBottom),
            @"NSLayoutFormatAlignAllLeading":P(NSLayoutFormatAlignAllLeading),
            @"NSLayoutFormatAlignAllTrailing":P(NSLayoutFormatAlignAllTrailing),
            @"NSLayoutFormatAlignAllCenterX":P(NSLayoutFormatAlignAllCenterX),
            @"NSLayoutFormatAlignAllCenterY":P(NSLayoutFormatAlignAllCenterY),
            @"NSLayoutFormatAlignAllLastBaseline":P(NSLayoutFormatAlignAllLastBaseline),
            @"NSLayoutFormatAlignAllFirstBaseline":P(NSLayoutFormatAlignAllFirstBaseline),
            @"NSLayoutFormatAlignAllBaseline":P(NSLayoutFormatAlignAllBaseline),
            @"NSLayoutFormatAlignAllBaseline":P(NSLayoutFormatAlignAllBaseline),
            @"NSLayoutFormatAlignmentMask":P(NSLayoutFormatAlignmentMask),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICollisionBehavior.h
//   UICollisionBehaviorMode
            @"UICollisionBehaviorModeItems":P(UICollisionBehaviorModeItems),
            @"UICollisionBehaviorModeBoundaries":P(UICollisionBehaviorModeBoundaries),
            @"UICollisionBehaviorModeEverything":P(UICollisionBehaviorModeEverything),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDataDetectors.h
//   UIDataDetectorTypes
            @"UIDataDetectorTypePhoneNumber":P(UIDataDetectorTypePhoneNumber),
            @"UIDataDetectorTypeLink":P(UIDataDetectorTypeLink),
            @"UIDataDetectorTypeAddress":P(UIDataDetectorTypeAddress),
            @"UIDataDetectorTypeCalendarEvent":P(UIDataDetectorTypeCalendarEvent),
            @"UIDataDetectorTypeShipmentTrackingNumber":P(UIDataDetectorTypeShipmentTrackingNumber),
            @"UIDataDetectorTypeFlightNumber":P(UIDataDetectorTypeFlightNumber),
            @"UIDataDetectorTypeLookupSuggestion":P(UIDataDetectorTypeLookupSuggestion),
            @"UIDataDetectorTypeMoney":P(UIDataDetectorTypeMoney),
            @"UIDataDetectorTypePhysicalValue":P(UIDataDetectorTypePhysicalValue),
            @"UIDataDetectorTypeNone":P(UIDataDetectorTypeNone),
            @"UIDataDetectorTypeAll":P(UIDataDetectorTypeAll),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIAttachmentBehavior.h
//   UIAttachmentBehaviorType
            @"UIAttachmentBehaviorTypeItems":P(UIAttachmentBehaviorTypeItems),
            @"UIAttachmentBehaviorTypeAnchor":P(UIAttachmentBehaviorTypeAnchor),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSTextContentManager.h
//   NSTextContentManagerEnumerationOptions
            @"NSTextContentManagerEnumerationOptionsNone":P(NSTextContentManagerEnumerationOptionsNone),
            @"NSTextContentManagerEnumerationOptionsReverse":P(NSTextContentManagerEnumerationOptionsReverse),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIImageSymbolConfiguration.h
//   UIImageSymbolScale
            @"UIImageSymbolScaleDefault":P(UIImageSymbolScaleDefault),
            @"UIImageSymbolScaleUnspecified":P(UIImageSymbolScaleUnspecified),
            @"UIImageSymbolScaleSmall":P(UIImageSymbolScaleSmall),
            @"UIImageSymbolScaleMedium":P(UIImageSymbolScaleMedium),
            @"UIImageSymbolScaleLarge":P(UIImageSymbolScaleLarge),
//   UIImageSymbolWeight
            @"UIImageSymbolWeightUnspecified":P(UIImageSymbolWeightUnspecified),
            @"UIImageSymbolWeightUltraLight":P(UIImageSymbolWeightUltraLight),
            @"UIImageSymbolWeightThin":P(UIImageSymbolWeightThin),
            @"UIImageSymbolWeightLight":P(UIImageSymbolWeightLight),
            @"UIImageSymbolWeightRegular":P(UIImageSymbolWeightRegular),
            @"UIImageSymbolWeightMedium":P(UIImageSymbolWeightMedium),
            @"UIImageSymbolWeightSemibold":P(UIImageSymbolWeightSemibold),
            @"UIImageSymbolWeightBold":P(UIImageSymbolWeightBold),
            @"UIImageSymbolWeightHeavy":P(UIImageSymbolWeightHeavy),
            @"UIImageSymbolWeightBlack":P(UIImageSymbolWeightBlack),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIControl.h
//   UIControlEvents
            @"UIControlEventTouchDown":P(UIControlEventTouchDown),
            @"UIControlEventTouchDownRepeat":P(UIControlEventTouchDownRepeat),
            @"UIControlEventTouchDragInside":P(UIControlEventTouchDragInside),
            @"UIControlEventTouchDragOutside":P(UIControlEventTouchDragOutside),
            @"UIControlEventTouchDragEnter":P(UIControlEventTouchDragEnter),
            @"UIControlEventTouchDragExit":P(UIControlEventTouchDragExit),
            @"UIControlEventTouchUpInside":P(UIControlEventTouchUpInside),
            @"UIControlEventTouchUpOutside":P(UIControlEventTouchUpOutside),
            @"UIControlEventTouchCancel":P(UIControlEventTouchCancel),
            @"UIControlEventValueChanged":P(UIControlEventValueChanged),
            @"UIControlEventPrimaryActionTriggered":P(UIControlEventPrimaryActionTriggered),
            @"UIControlEventMenuActionTriggered":P(UIControlEventMenuActionTriggered),
            @"UIControlEventEditingDidBegin":P(UIControlEventEditingDidBegin),
            @"UIControlEventEditingChanged":P(UIControlEventEditingChanged),
            @"UIControlEventEditingDidEnd":P(UIControlEventEditingDidEnd),
            @"UIControlEventEditingDidEndOnExit":P(UIControlEventEditingDidEndOnExit),
            @"UIControlEventAllTouchEvents":P(UIControlEventAllTouchEvents),
            @"UIControlEventAllEditingEvents":P(UIControlEventAllEditingEvents),
            @"UIControlEventApplicationReserved":P(UIControlEventApplicationReserved),
            @"UIControlEventSystemReserved":P(UIControlEventSystemReserved),
            @"UIControlEventAllEvents":P(UIControlEventAllEvents),
//   UIControlContentVerticalAlignment
            @"UIControlContentVerticalAlignmentCenter":P(UIControlContentVerticalAlignmentCenter),
            @"UIControlContentVerticalAlignmentTop":P(UIControlContentVerticalAlignmentTop),
            @"UIControlContentVerticalAlignmentBottom":P(UIControlContentVerticalAlignmentBottom),
            @"UIControlContentVerticalAlignmentFill":P(UIControlContentVerticalAlignmentFill),
//   UIControlContentHorizontalAlignment
            @"UIControlContentHorizontalAlignmentCenter":P(UIControlContentHorizontalAlignmentCenter),
            @"UIControlContentHorizontalAlignmentLeft":P(UIControlContentHorizontalAlignmentLeft),
            @"UIControlContentHorizontalAlignmentRight":P(UIControlContentHorizontalAlignmentRight),
            @"UIControlContentHorizontalAlignmentFill":P(UIControlContentHorizontalAlignmentFill),
            @"UIControlContentHorizontalAlignmentLeading":P(UIControlContentHorizontalAlignmentLeading),
            @"UIControlContentHorizontalAlignmentTrailing":P(UIControlContentHorizontalAlignmentTrailing),
//   UIControlState
            @"UIControlStateNormal":P(UIControlStateNormal),
            @"UIControlStateHighlighted":P(UIControlStateHighlighted),
            @"UIControlStateDisabled":P(UIControlStateDisabled),
            @"UIControlStateSelected":P(UIControlStateSelected),
            @"UIControlStateFocused":P(UIControlStateFocused),
            @"UIControlStateApplication":P(UIControlStateApplication),
            @"UIControlStateReserved":P(UIControlStateReserved),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIFocus.h
//   UIFocusHeading
            @"UIFocusHeadingNone":P(UIFocusHeadingNone),
            @"UIFocusHeadingUp":P(UIFocusHeadingUp),
            @"UIFocusHeadingDown":P(UIFocusHeadingDown),
            @"UIFocusHeadingLeft":P(UIFocusHeadingLeft),
            @"UIFocusHeadingRight":P(UIFocusHeadingRight),
            @"UIFocusHeadingNext":P(UIFocusHeadingNext),
            @"UIFocusHeadingPrevious":P(UIFocusHeadingPrevious),
            @"UIFocusHeadingFirst":P(UIFocusHeadingFirst),
            @"UIFocusHeadingLast":P(UIFocusHeadingLast),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICalendarViewDecoration.h
//   UICalendarViewDecorationSize
            @"UICalendarViewDecorationSizeSmall":P(UICalendarViewDecorationSizeSmall),
            @"UICalendarViewDecorationSizeMedium":P(UICalendarViewDecorationSizeMedium),
            @"UICalendarViewDecorationSizeLarge":P(UICalendarViewDecorationSizeLarge),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDatePicker.h
//   UIDatePickerMode
            @"UIDatePickerModeTime":P(UIDatePickerModeTime),
            @"UIDatePickerModeDate":P(UIDatePickerModeDate),
            @"UIDatePickerModeDateAndTime":P(UIDatePickerModeDateAndTime),
            @"UIDatePickerModeCountDownTimer":P(UIDatePickerModeCountDownTimer),
//   UIDatePickerStyle
            @"UIDatePickerStyleAutomatic":P(UIDatePickerStyleAutomatic),
            @"UIDatePickerStyleWheels":P(UIDatePickerStyleWheels),
            @"UIDatePickerStyleCompact":P(UIDatePickerStyleCompact),
            @"UIDatePickerStyleInline":P(UIDatePickerStyleInline),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICollectionLayoutList.h
//   UICollectionLayoutListAppearance
            @"UICollectionLayoutListAppearancePlain":P(UICollectionLayoutListAppearancePlain),
            @"UICollectionLayoutListAppearanceGrouped":P(UICollectionLayoutListAppearanceGrouped),
            @"UICollectionLayoutListAppearanceInsetGrouped":P(UICollectionLayoutListAppearanceInsetGrouped),
            @"UICollectionLayoutListAppearanceSidebar":P(UICollectionLayoutListAppearanceSidebar),
            @"UICollectionLayoutListAppearanceSidebarPlain":P(UICollectionLayoutListAppearanceSidebarPlain),
//   UICollectionLayoutListHeaderMode
            @"UICollectionLayoutListHeaderModeNone":P(UICollectionLayoutListHeaderModeNone),
            @"UICollectionLayoutListHeaderModeSupplementary":P(UICollectionLayoutListHeaderModeSupplementary),
            @"UICollectionLayoutListHeaderModeFirstItemInSection":P(UICollectionLayoutListHeaderModeFirstItemInSection),
//   UICollectionLayoutListFooterMode
            @"UICollectionLayoutListFooterModeNone":P(UICollectionLayoutListFooterModeNone),
            @"UICollectionLayoutListFooterModeSupplementary":P(UICollectionLayoutListFooterModeSupplementary),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextInputTraits.h
//   UITextAutocapitalizationType
            @"UITextAutocapitalizationTypeNone":P(UITextAutocapitalizationTypeNone),
            @"UITextAutocapitalizationTypeWords":P(UITextAutocapitalizationTypeWords),
            @"UITextAutocapitalizationTypeSentences":P(UITextAutocapitalizationTypeSentences),
            @"UITextAutocapitalizationTypeAllCharacters":P(UITextAutocapitalizationTypeAllCharacters),
//   UITextAutocorrectionType
            @"UITextAutocorrectionTypeDefault":P(UITextAutocorrectionTypeDefault),
            @"UITextAutocorrectionTypeNo":P(UITextAutocorrectionTypeNo),
            @"UITextAutocorrectionTypeYes":P(UITextAutocorrectionTypeYes),
//   UITextSpellCheckingType
            @"UITextSpellCheckingTypeDefault":P(UITextSpellCheckingTypeDefault),
            @"UITextSpellCheckingTypeNo":P(UITextSpellCheckingTypeNo),
            @"UITextSpellCheckingTypeYes":P(UITextSpellCheckingTypeYes),
//   UITextSmartQuotesType
            @"UITextSmartQuotesTypeDefault":P(UITextSmartQuotesTypeDefault),
            @"UITextSmartQuotesTypeNo":P(UITextSmartQuotesTypeNo),
            @"UITextSmartQuotesTypeYes":P(UITextSmartQuotesTypeYes),
//   UITextSmartDashesType
            @"UITextSmartDashesTypeDefault":P(UITextSmartDashesTypeDefault),
            @"UITextSmartDashesTypeNo":P(UITextSmartDashesTypeNo),
            @"UITextSmartDashesTypeYes":P(UITextSmartDashesTypeYes),
//   UITextSmartInsertDeleteType
            @"UITextSmartInsertDeleteTypeDefault":P(UITextSmartInsertDeleteTypeDefault),
            @"UITextSmartInsertDeleteTypeNo":P(UITextSmartInsertDeleteTypeNo),
            @"UITextSmartInsertDeleteTypeYes":P(UITextSmartInsertDeleteTypeYes),
//   UITextInlinePredictionType
            @"UITextInlinePredictionTypeDefault":P(UITextInlinePredictionTypeDefault),
            @"UITextInlinePredictionTypeNo":P(UITextInlinePredictionTypeNo),
            @"UITextInlinePredictionTypeYes":P(UITextInlinePredictionTypeYes),
//   UIKeyboardType
            @"UIKeyboardTypeDefault":P(UIKeyboardTypeDefault),
            @"UIKeyboardTypeASCIICapable":P(UIKeyboardTypeASCIICapable),
            @"UIKeyboardTypeNumbersAndPunctuation":P(UIKeyboardTypeNumbersAndPunctuation),
            @"UIKeyboardTypeURL":P(UIKeyboardTypeURL),
            @"UIKeyboardTypeNumberPad":P(UIKeyboardTypeNumberPad),
            @"UIKeyboardTypePhonePad":P(UIKeyboardTypePhonePad),
            @"UIKeyboardTypeNamePhonePad":P(UIKeyboardTypeNamePhonePad),
            @"UIKeyboardTypeEmailAddress":P(UIKeyboardTypeEmailAddress),
            @"UIKeyboardTypeDecimalPad":P(UIKeyboardTypeDecimalPad),
            @"UIKeyboardTypeTwitter":P(UIKeyboardTypeTwitter),
            @"UIKeyboardTypeWebSearch":P(UIKeyboardTypeWebSearch),
            @"UIKeyboardTypeASCIICapableNumberPad":P(UIKeyboardTypeASCIICapableNumberPad),
            @"UIKeyboardTypeAlphabet":P(UIKeyboardTypeAlphabet),
//   UIKeyboardAppearance
            @"UIKeyboardAppearanceDefault":P(UIKeyboardAppearanceDefault),
            @"UIKeyboardAppearanceDark":P(UIKeyboardAppearanceDark),
            @"UIKeyboardAppearanceLight":P(UIKeyboardAppearanceLight),
            @"UIKeyboardAppearanceAlert":P(UIKeyboardAppearanceAlert),
//   UIReturnKeyType
            @"UIReturnKeyDefault":P(UIReturnKeyDefault),
            @"UIReturnKeyGo":P(UIReturnKeyGo),
            @"UIReturnKeyGoogle":P(UIReturnKeyGoogle),
            @"UIReturnKeyJoin":P(UIReturnKeyJoin),
            @"UIReturnKeyNext":P(UIReturnKeyNext),
            @"UIReturnKeyRoute":P(UIReturnKeyRoute),
            @"UIReturnKeySearch":P(UIReturnKeySearch),
            @"UIReturnKeySend":P(UIReturnKeySend),
            @"UIReturnKeyYahoo":P(UIReturnKeyYahoo),
            @"UIReturnKeyDone":P(UIReturnKeyDone),
            @"UIReturnKeyEmergencyCall":P(UIReturnKeyEmergencyCall),
            @"UIReturnKeyContinue":P(UIReturnKeyContinue),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextDragging.h
//   UITextDragOptions
            @"UITextDragOptionsNone":P(UITextDragOptionsNone),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICellConfigurationState.h
//   UICellConfigurationDragState
            @"UICellConfigurationDragStateNone":P(UICellConfigurationDragStateNone),
            @"UICellConfigurationDragStateLifting":P(UICellConfigurationDragStateLifting),
            @"UICellConfigurationDragStateDragging":P(UICellConfigurationDragStateDragging),
//   UICellConfigurationDropState
            @"UICellConfigurationDropStateNone":P(UICellConfigurationDropStateNone),
            @"UICellConfigurationDropStateNotTargeted":P(UICellConfigurationDropStateNotTargeted),
            @"UICellConfigurationDropStateTargeted":P(UICellConfigurationDropStateTargeted),

//   Enum definitions in ./enum_gen/UIKit/Headers/UINavigationItem.h
//   UINavigationItemLargeTitleDisplayMode
            @"UINavigationItemLargeTitleDisplayModeAutomatic":P(UINavigationItemLargeTitleDisplayModeAutomatic),
            @"UINavigationItemLargeTitleDisplayModeAlways":P(UINavigationItemLargeTitleDisplayModeAlways),
            @"UINavigationItemLargeTitleDisplayModeNever":P(UINavigationItemLargeTitleDisplayModeNever),
            @"UINavigationItemLargeTitleDisplayModeInline":P(UINavigationItemLargeTitleDisplayModeInline),
//   UINavigationItemBackButtonDisplayMode
            @"UINavigationItemBackButtonDisplayModeDefault":P(UINavigationItemBackButtonDisplayModeDefault),
            @"UINavigationItemBackButtonDisplayModeGeneric":P(UINavigationItemBackButtonDisplayModeGeneric),
            @"UINavigationItemBackButtonDisplayModeMinimal":P(UINavigationItemBackButtonDisplayModeMinimal),
//   UINavigationItemSearchBarPlacement
            @"UINavigationItemSearchBarPlacementAutomatic":P(UINavigationItemSearchBarPlacementAutomatic),
            @"UINavigationItemSearchBarPlacementInline":P(UINavigationItemSearchBarPlacementInline),
            @"UINavigationItemSearchBarPlacementStacked":P(UINavigationItemSearchBarPlacementStacked),
//   UINavigationItemStyle
            @"UINavigationItemStyleNavigator":P(UINavigationItemStyleNavigator),
            @"UINavigationItemStyleBrowser":P(UINavigationItemStyleBrowser),
            @"UINavigationItemStyleEditor":P(UINavigationItemStyleEditor),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDocumentBrowserViewController.h
//   UIDocumentBrowserImportMode
            @"UIDocumentBrowserImportModeNone":P(UIDocumentBrowserImportModeNone),
            @"UIDocumentBrowserImportModeCopy":P(UIDocumentBrowserImportModeCopy),
            @"UIDocumentBrowserImportModeMove":P(UIDocumentBrowserImportModeMove),
//   UIDocumentBrowserUserInterfaceStyle
            @"UIDocumentBrowserUserInterfaceStyleWhite":P(UIDocumentBrowserUserInterfaceStyleWhite),
            @"UIDocumentBrowserUserInterfaceStyleLight":P(UIDocumentBrowserUserInterfaceStyleLight),
            @"UIDocumentBrowserUserInterfaceStyleDark":P(UIDocumentBrowserUserInterfaceStyleDark),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPrinter.h
//   UIPrinterJobTypes
            @"UIPrinterJobTypeUnknown":P(UIPrinterJobTypeUnknown),
            @"UIPrinterJobTypeDocument":P(UIPrinterJobTypeDocument),
            @"UIPrinterJobTypeEnvelope":P(UIPrinterJobTypeEnvelope),
            @"UIPrinterJobTypeLabel":P(UIPrinterJobTypeLabel),
            @"UIPrinterJobTypePhoto":P(UIPrinterJobTypePhoto),
            @"UIPrinterJobTypeReceipt":P(UIPrinterJobTypeReceipt),
            @"UIPrinterJobTypeRoll":P(UIPrinterJobTypeRoll),
            @"UIPrinterJobTypeLargeFormat":P(UIPrinterJobTypeLargeFormat),
            @"UIPrinterJobTypePostcard":P(UIPrinterJobTypePostcard),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIImage.h
//   UIImageOrientation
            @"UIImageOrientationUp":P(UIImageOrientationUp),
            @"UIImageOrientationDown":P(UIImageOrientationDown),
            @"UIImageOrientationLeft":P(UIImageOrientationLeft),
            @"UIImageOrientationRight":P(UIImageOrientationRight),
            @"UIImageOrientationUpMirrored":P(UIImageOrientationUpMirrored),
            @"UIImageOrientationDownMirrored":P(UIImageOrientationDownMirrored),
            @"UIImageOrientationLeftMirrored":P(UIImageOrientationLeftMirrored),
            @"UIImageOrientationRightMirrored":P(UIImageOrientationRightMirrored),
//   UIImageResizingMode
            @"UIImageResizingModeTile":P(UIImageResizingModeTile),
            @"UIImageResizingModeStretch":P(UIImageResizingModeStretch),
            @"UIImageResizingModeStretch":P(UIImageResizingModeStretch),
            @"UIImageResizingModeTile":P(UIImageResizingModeTile),
//   UIImageRenderingMode
            @"UIImageRenderingModeAutomatic":P(UIImageRenderingModeAutomatic),
            @"UIImageRenderingModeAlwaysOriginal":P(UIImageRenderingModeAlwaysOriginal),
            @"UIImageRenderingModeAlwaysTemplate":P(UIImageRenderingModeAlwaysTemplate),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPanGestureRecognizer.h
//   UIScrollType
            @"UIScrollTypeDiscrete":P(UIScrollTypeDiscrete),
            @"UIScrollTypeContinuous":P(UIScrollTypeContinuous),
//   UIScrollTypeMask
            @"UIScrollTypeMaskDiscrete":P(UIScrollTypeMaskDiscrete),
            @"UIScrollTypeMaskContinuous":P(UIScrollTypeMaskContinuous),
            @"UIScrollTypeMaskAll":P(UIScrollTypeMaskAll),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIBehavioralStyle.h
//   UIBehavioralStyle
            @"UIBehavioralStyleAutomatic":P(UIBehavioralStyleAutomatic),
            @"UIBehavioralStylePad":P(UIBehavioralStylePad),
            @"UIBehavioralStyleMac":P(UIBehavioralStyleMac),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextDropping.h
//   UITextDropEditability

//   Enum definitions in ./enum_gen/UIKit/Headers/UICollectionViewCell.h
//   UICollectionViewCellDragState
            @"UICollectionViewCellDragStateNone":P(UICollectionViewCellDragStateNone),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIMenuController.h
//   UIMenuControllerArrowDirection
            @"UIMenuControllerArrowDefault":P(UIMenuControllerArrowDefault),
            @"UIMenuControllerArrowUp":P(UIMenuControllerArrowUp),
            @"UIMenuControllerArrowDown":P(UIMenuControllerArrowDown),
            @"UIMenuControllerArrowLeft":P(UIMenuControllerArrowLeft),
            @"UIMenuControllerArrowRight":P(UIMenuControllerArrowRight),

//   Enum definitions in ./enum_gen/UIKit/Headers/UISpringLoadedInteraction.h
//   UISpringLoadedInteractionEffectState
            @"UISpringLoadedInteractionEffectStateInactive":P(UISpringLoadedInteractionEffectStateInactive),
            @"UISpringLoadedInteractionEffectStatePossible":P(UISpringLoadedInteractionEffectStatePossible),
            @"UISpringLoadedInteractionEffectStateActivating":P(UISpringLoadedInteractionEffectStateActivating),
            @"UISpringLoadedInteractionEffectStateActivated":P(UISpringLoadedInteractionEffectStateActivated),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDocumentMenuViewController.h
//   UIDocumentMenuOrder
            @"UIDocumentMenuOrderFirst":P(UIDocumentMenuOrderFirst),
            @"UIDocumentMenuOrderLast":P(UIDocumentMenuOrderLast),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIPageControl.h
//   UIPageControlInteractionState
            @"UIPageControlInteractionStateNone":P(UIPageControlInteractionStateNone),
            @"UIPageControlInteractionStateDiscrete":P(UIPageControlInteractionStateDiscrete),
            @"UIPageControlInteractionStateContinuous":P(UIPageControlInteractionStateContinuous),
//   UIPageControlBackgroundStyle
            @"UIPageControlBackgroundStyleAutomatic":P(UIPageControlBackgroundStyleAutomatic),
            @"UIPageControlBackgroundStyleProminent":P(UIPageControlBackgroundStyleProminent),
            @"UIPageControlBackgroundStyleMinimal":P(UIPageControlBackgroundStyleMinimal),
//   UIPageControlDirection
            @"UIPageControlDirectionNatural":P(UIPageControlDirectionNatural),
            @"UIPageControlDirectionLeftToRight":P(UIPageControlDirectionLeftToRight),
            @"UIPageControlDirectionRightToLeft":P(UIPageControlDirectionRightToLeft),
            @"UIPageControlDirectionTopToBottom":P(UIPageControlDirectionTopToBottom),
            @"UIPageControlDirectionBottomToTop":P(UIPageControlDirectionBottomToTop),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIContentUnavailableConfiguration.h
//   UIContentUnavailableAlignment
            @"UIContentUnavailableAlignmentCenter":P(UIContentUnavailableAlignmentCenter),
            @"UIContentUnavailableAlignmentNatural":P(UIContentUnavailableAlignmentNatural),

//   Enum definitions in ./enum_gen/UIKit/Headers/UINavigationBar.h
//   UINavigationBarNSToolbarSection
            @"UINavigationBarNSToolbarSectionNone":P(UINavigationBarNSToolbarSectionNone),
            @"UINavigationBarNSToolbarSectionSidebar":P(UINavigationBarNSToolbarSectionSidebar),
            @"UINavigationBarNSToolbarSectionSupplementary":P(UINavigationBarNSToolbarSectionSupplementary),
            @"UINavigationBarNSToolbarSectionContent":P(UINavigationBarNSToolbarSectionContent),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIGuidedAccess.h
//   UIGuidedAccessRestrictionState
            @"UIGuidedAccessRestrictionStateAllow":P(UIGuidedAccessRestrictionStateAllow),
            @"UIGuidedAccessRestrictionStateDeny":P(UIGuidedAccessRestrictionStateDeny),
//   UIGuidedAccessAccessibilityFeature
            @"UIGuidedAccessAccessibilityFeatureVoiceOver":P(UIGuidedAccessAccessibilityFeatureVoiceOver),
            @"UIGuidedAccessAccessibilityFeatureZoom":P(UIGuidedAccessAccessibilityFeatureZoom),
            @"UIGuidedAccessAccessibilityFeatureAssistiveTouch":P(UIGuidedAccessAccessibilityFeatureAssistiveTouch),
            @"UIGuidedAccessAccessibilityFeatureInvertColors":P(UIGuidedAccessAccessibilityFeatureInvertColors),
            @"UIGuidedAccessAccessibilityFeatureGrayscaleDisplay":P(UIGuidedAccessAccessibilityFeatureGrayscaleDisplay),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDocument.h
//   UIDocumentChangeKind
            @"UIDocumentChangeDone":P(UIDocumentChangeDone),
            @"UIDocumentChangeUndone":P(UIDocumentChangeUndone),
            @"UIDocumentChangeRedone":P(UIDocumentChangeRedone),
            @"UIDocumentChangeCleared":P(UIDocumentChangeCleared),
//   UIDocumentSaveOperation
            @"UIDocumentSaveForCreating":P(UIDocumentSaveForCreating),
            @"UIDocumentSaveForOverwriting":P(UIDocumentSaveForOverwriting),
//   UIDocumentState
            @"UIDocumentStateNormal":P(UIDocumentStateNormal),
            @"UIDocumentStateClosed":P(UIDocumentStateClosed),
            @"UIDocumentStateInConflict":P(UIDocumentStateInConflict),
            @"UIDocumentStateSavingError":P(UIDocumentStateSavingError),
            @"UIDocumentStateEditingDisabled":P(UIDocumentStateEditingDisabled),
            @"UIDocumentStateProgressAvailable":P(UIDocumentStateProgressAvailable),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIScreen.h
//   UIScreenOverscanCompensation
            @"UIScreenOverscanCompensationScale":P(UIScreenOverscanCompensationScale),
            @"UIScreenOverscanCompensationInsetBounds":P(UIScreenOverscanCompensationInsetBounds),
            @"UIScreenOverscanCompensationNone":P(UIScreenOverscanCompensationNone),
            @"UIScreenOverscanCompensationInsetApplicationFrame":P(UIScreenOverscanCompensationInsetApplicationFrame),
//   UIScreenReferenceDisplayModeStatus
            @"UIScreenReferenceDisplayModeStatusNotSupported":P(UIScreenReferenceDisplayModeStatusNotSupported),
            @"UIScreenReferenceDisplayModeStatusNotEnabled":P(UIScreenReferenceDisplayModeStatusNotEnabled),
            @"UIScreenReferenceDisplayModeStatusLimited":P(UIScreenReferenceDisplayModeStatusLimited),
            @"UIScreenReferenceDisplayModeStatusEnabled":P(UIScreenReferenceDisplayModeStatusEnabled),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIDocumentPickerViewController.h
//   UIDocumentPickerMode
            @"UIDocumentPickerModeImport":P(UIDocumentPickerModeImport),
            @"UIDocumentPickerModeOpen":P(UIDocumentPickerModeOpen),
            @"UIDocumentPickerModeExportToService":P(UIDocumentPickerModeExportToService),
            @"UIDocumentPickerModeMoveToService":P(UIDocumentPickerModeMoveToService),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSTextList.h
//   NSTextListOptions
            @"NSTextListPrependEnclosingMarker":P(NSTextListPrependEnclosingMarker),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIContextMenuConfiguration.h
//   UIContextMenuConfigurationElementOrder
            @"UIContextMenuConfigurationElementOrderAutomatic":P(UIContextMenuConfigurationElementOrderAutomatic),
            @"UIContextMenuConfigurationElementOrderPriority":P(UIContextMenuConfigurationElementOrderPriority),
            @"UIContextMenuConfigurationElementOrderFixed":P(UIContextMenuConfigurationElementOrderFixed),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSTextSelection.h
//   NSTextSelectionGranularity
            @"NSTextSelectionGranularityCharacter":P(NSTextSelectionGranularityCharacter),
            @"NSTextSelectionGranularityWord":P(NSTextSelectionGranularityWord),
            @"NSTextSelectionGranularityParagraph":P(NSTextSelectionGranularityParagraph),
            @"NSTextSelectionGranularityLine":P(NSTextSelectionGranularityLine),
            @"NSTextSelectionGranularitySentence":P(NSTextSelectionGranularitySentence),
//   NSTextSelectionAffinity
            @"NSTextSelectionAffinityUpstream":P(NSTextSelectionAffinityUpstream),
            @"NSTextSelectionAffinityDownstream":P(NSTextSelectionAffinityDownstream),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIAccessibility.h
//   UIAccessibilityScrollDirection
            @"UIAccessibilityScrollDirectionRight":P(UIAccessibilityScrollDirectionRight),
            @"UIAccessibilityScrollDirectionLeft":P(UIAccessibilityScrollDirectionLeft),
            @"UIAccessibilityScrollDirectionUp":P(UIAccessibilityScrollDirectionUp),
            @"UIAccessibilityScrollDirectionDown":P(UIAccessibilityScrollDirectionDown),
            @"UIAccessibilityScrollDirectionNext":P(UIAccessibilityScrollDirectionNext),
            @"UIAccessibilityScrollDirectionPrevious":P(UIAccessibilityScrollDirectionPrevious),
//   UIAccessibilityHearingDeviceEar
            @"UIAccessibilityHearingDeviceEarNone":P(UIAccessibilityHearingDeviceEarNone),
            @"UIAccessibilityHearingDeviceEarLeft":P(UIAccessibilityHearingDeviceEarLeft),
            @"UIAccessibilityHearingDeviceEarRight":P(UIAccessibilityHearingDeviceEarRight),
            @"UIAccessibilityHearingDeviceEarBoth":P(UIAccessibilityHearingDeviceEarBoth),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextSearching.h
//   UITextSearchFoundTextStyle
            @"UITextSearchFoundTextStyleNormal":P(UITextSearchFoundTextStyleNormal),
            @"UITextSearchFoundTextStyleFound":P(UITextSearchFoundTextStyleFound),
            @"UITextSearchFoundTextStyleHighlighted":P(UITextSearchFoundTextStyleHighlighted),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICollectionView.h
//   UICollectionViewScrollPosition
            @"UICollectionViewScrollPositionNone":P(UICollectionViewScrollPositionNone),
            @"UICollectionViewScrollPositionTop":P(UICollectionViewScrollPositionTop),
            @"UICollectionViewScrollPositionCenteredVertically":P(UICollectionViewScrollPositionCenteredVertically),
            @"UICollectionViewScrollPositionBottom":P(UICollectionViewScrollPositionBottom),
            @"UICollectionViewScrollPositionLeft":P(UICollectionViewScrollPositionLeft),
            @"UICollectionViewScrollPositionCenteredHorizontally":P(UICollectionViewScrollPositionCenteredHorizontally),
            @"UICollectionViewScrollPositionRight":P(UICollectionViewScrollPositionRight),
//   UICollectionViewReorderingCadence
            @"UICollectionViewReorderingCadenceImmediate":P(UICollectionViewReorderingCadenceImmediate),
            @"UICollectionViewReorderingCadenceFast":P(UICollectionViewReorderingCadenceFast),
            @"UICollectionViewReorderingCadenceSlow":P(UICollectionViewReorderingCadenceSlow),
//   UICollectionViewSelfSizingInvalidation
            @"UICollectionViewSelfSizingInvalidationDisabled":P(UICollectionViewSelfSizingInvalidationDisabled),
            @"UICollectionViewSelfSizingInvalidationEnabled":P(UICollectionViewSelfSizingInvalidationEnabled),
            @"UICollectionViewSelfSizingInvalidationEnabledIncludingConstraints":P(UICollectionViewSelfSizingInvalidationEnabledIncludingConstraints),
//   UICollectionViewDropIntent

//   Enum definitions in ./enum_gen/UIKit/Headers/UIWindowSceneActivationRequestOptions.h
//   UIWindowScenePresentationStyle
            @"UIWindowScenePresentationStyleAutomatic":P(UIWindowScenePresentationStyleAutomatic),
            @"UIWindowScenePresentationStyleStandard":P(UIWindowScenePresentationStyleStandard),
            @"UIWindowScenePresentationStyleProminent":P(UIWindowScenePresentationStyleProminent),

//   Enum definitions in ./enum_gen/UIKit/Headers/UISceneDefinitions.h
//   UISceneActivationState
            @"UISceneActivationStateUnattached":P(UISceneActivationStateUnattached),
            @"UISceneActivationStateForegroundActive":P(UISceneActivationStateForegroundActive),
            @"UISceneActivationStateForegroundInactive":P(UISceneActivationStateForegroundInactive),
            @"UISceneActivationStateBackground":P(UISceneActivationStateBackground),
//   UISceneCaptureState
            @"UISceneCaptureStateUnspecified":P(UISceneCaptureStateUnspecified),
            @"UISceneCaptureStateInactive":P(UISceneCaptureStateInactive),
            @"UISceneCaptureStateActive":P(UISceneCaptureStateActive),

//   Enum definitions in ./enum_gen/UIKit/Headers/UICollectionViewUpdateItem.h
//   UICollectionUpdateAction
            @"UICollectionUpdateActionInsert":P(UICollectionUpdateActionInsert),
            @"UICollectionUpdateActionDelete":P(UICollectionUpdateActionDelete),
            @"UICollectionUpdateActionReload":P(UICollectionUpdateActionReload),
            @"UICollectionUpdateActionMove":P(UICollectionUpdateActionMove),
            @"UICollectionUpdateActionNone":P(UICollectionUpdateActionNone),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIBarCommon.h
//   UIBarMetrics
            @"UIBarMetricsDefault":P(UIBarMetricsDefault),
            @"UIBarMetricsCompact":P(UIBarMetricsCompact),
            @"UIBarMetricsDefaultPrompt":P(UIBarMetricsDefaultPrompt),
            @"UIBarMetricsCompactPrompt":P(UIBarMetricsCompactPrompt),
            @"UIBarMetricsLandscapePhone":P(UIBarMetricsLandscapePhone),
            @"UIBarMetricsLandscapePhonePrompt":P(UIBarMetricsLandscapePhonePrompt),
//   UIBarPosition
            @"UIBarPositionAny":P(UIBarPositionAny),
            @"UIBarPositionBottom":P(UIBarPositionBottom),
            @"UIBarPositionTop":P(UIBarPositionTop),
            @"UIBarPositionTopAttached":P(UIBarPositionTopAttached),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIFocusEffect.h
//   UIFocusHaloEffectPosition
            @"UIFocusHaloEffectPositionAutomatic":P(UIFocusHaloEffectPositionAutomatic),
            @"UIFocusHaloEffectPositionOutside":P(UIFocusHaloEffectPositionOutside),
            @"UIFocusHaloEffectPositionInside":P(UIFocusHaloEffectPositionInside),

//   Enum definitions in ./enum_gen/UIKit/Headers/UINavigationController.h
//   UINavigationControllerOperation
            @"UINavigationControllerOperationNone":P(UINavigationControllerOperationNone),
            @"UINavigationControllerOperationPush":P(UINavigationControllerOperationPush),
            @"UINavigationControllerOperationPop":P(UINavigationControllerOperationPop),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITableViewCell.h
//   UITableViewCellStyle
            @"UITableViewCellStyleDefault":P(UITableViewCellStyleDefault),
            @"UITableViewCellStyleSubtitle":P(UITableViewCellStyleSubtitle),
//   UITableViewCellSeparatorStyle
            @"UITableViewCellSeparatorStyleNone":P(UITableViewCellSeparatorStyleNone),
            @"UITableViewCellSeparatorStyleSingleLine":P(UITableViewCellSeparatorStyleSingleLine),
            @"UITableViewCellSeparatorStyleSingleLineEtched":P(UITableViewCellSeparatorStyleSingleLineEtched),
//   UITableViewCellSelectionStyle
            @"UITableViewCellSelectionStyleNone":P(UITableViewCellSelectionStyleNone),
            @"UITableViewCellSelectionStyleBlue":P(UITableViewCellSelectionStyleBlue),
            @"UITableViewCellSelectionStyleGray":P(UITableViewCellSelectionStyleGray),
            @"UITableViewCellSelectionStyleDefault":P(UITableViewCellSelectionStyleDefault),
//   UITableViewCellFocusStyle
            @"UITableViewCellFocusStyleDefault":P(UITableViewCellFocusStyleDefault),
            @"UITableViewCellFocusStyleCustom":P(UITableViewCellFocusStyleCustom),
//   UITableViewCellEditingStyle
            @"UITableViewCellEditingStyleNone":P(UITableViewCellEditingStyleNone),
            @"UITableViewCellEditingStyleDelete":P(UITableViewCellEditingStyleDelete),
            @"UITableViewCellEditingStyleInsert":P(UITableViewCellEditingStyleInsert),
//   UITableViewCellAccessoryType
            @"UITableViewCellAccessoryNone":P(UITableViewCellAccessoryNone),
            @"UITableViewCellAccessoryDisclosureIndicator":P(UITableViewCellAccessoryDisclosureIndicator),
            @"UITableViewCellAccessoryDetailDisclosureButton":P(UITableViewCellAccessoryDetailDisclosureButton),
            @"UITableViewCellAccessoryCheckmark":P(UITableViewCellAccessoryCheckmark),
            @"UITableViewCellAccessoryDetailButton":P(UITableViewCellAccessoryDetailButton),
//   UITableViewCellStateMask
            @"UITableViewCellStateDefaultMask":P(UITableViewCellStateDefaultMask),
            @"UITableViewCellStateShowingEditControlMask":P(UITableViewCellStateShowingEditControlMask),
            @"UITableViewCellStateShowingDeleteConfirmationMask":P(UITableViewCellStateShowingDeleteConfirmationMask),
//   UITableViewCellDragState
            @"UITableViewCellDragStateNone":P(UITableViewCellDragStateNone),
            @"UITableViewCellDragStateLifting":P(UITableViewCellDragStateLifting),
            @"UITableViewCellDragStateDragging":P(UITableViewCellDragStateDragging),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIApplication.h
//   UIStatusBarStyle
            @"UIStatusBarStyleDefault":P(UIStatusBarStyleDefault),
            @"UIStatusBarStyleLightContent":P(UIStatusBarStyleLightContent),
            @"UIStatusBarStyleDarkContent":P(UIStatusBarStyleDarkContent),
            @"UIStatusBarStyleBlackTranslucent":P(UIStatusBarStyleBlackTranslucent),
            @"UIStatusBarStyleBlackOpaque":P(UIStatusBarStyleBlackOpaque),
//   UIStatusBarAnimation
            @"UIStatusBarAnimationNone":P(UIStatusBarAnimationNone),
            @"UIStatusBarAnimationFade":P(UIStatusBarAnimationFade),
            @"UIStatusBarAnimationSlide":P(UIStatusBarAnimationSlide),
//   UIRemoteNotificationType
            @"UIRemoteNotificationTypeNone":P(UIRemoteNotificationTypeNone),
            @"UIRemoteNotificationTypeBadge":P(UIRemoteNotificationTypeBadge),
            @"UIRemoteNotificationTypeSound":P(UIRemoteNotificationTypeSound),
            @"UIRemoteNotificationTypeAlert":P(UIRemoteNotificationTypeAlert),
            @"UIRemoteNotificationTypeNewsstandContentAvailability":P(UIRemoteNotificationTypeNewsstandContentAvailability),
//   UIBackgroundFetchResult
            @"UIBackgroundFetchResultNewData":P(UIBackgroundFetchResultNewData),
            @"UIBackgroundFetchResultNoData":P(UIBackgroundFetchResultNoData),
            @"UIBackgroundFetchResultFailed":P(UIBackgroundFetchResultFailed),
//   UIBackgroundRefreshStatus
            @"UIBackgroundRefreshStatusRestricted":P(UIBackgroundRefreshStatusRestricted),
            @"UIBackgroundRefreshStatusDenied":P(UIBackgroundRefreshStatusDenied),
            @"UIBackgroundRefreshStatusAvailable":P(UIBackgroundRefreshStatusAvailable),
//   UIApplicationState
            @"UIApplicationStateActive":P(UIApplicationStateActive),
            @"UIApplicationStateInactive":P(UIApplicationStateInactive),
            @"UIApplicationStateBackground":P(UIApplicationStateBackground),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIFindSession.h
//   UIFindSessionSearchResultDisplayStyle
            @"UIFindSessionSearchResultDisplayStyleCurrentAndTotal":P(UIFindSessionSearchResultDisplayStyleCurrentAndTotal),
            @"UIFindSessionSearchResultDisplayStyleTotal":P(UIFindSessionSearchResultDisplayStyleTotal),
            @"UIFindSessionSearchResultDisplayStyleNone":P(UIFindSessionSearchResultDisplayStyleNone),
//   UITextSearchMatchMethod
            @"UITextSearchMatchMethodContains":P(UITextSearchMatchMethodContains),
            @"UITextSearchMatchMethodStartsWith":P(UITextSearchMatchMethodStartsWith),
            @"UITextSearchMatchMethodFullWord":P(UITextSearchMatchMethodFullWord),

//   Enum definitions in ./enum_gen/UIKit/Headers/UISwitch.h
//   UISwitchStyle
            @"UISwitchStyleAutomatic":P(UISwitchStyleAutomatic),
            @"UISwitchStyleCheckbox":P(UISwitchStyleCheckbox),
            @"UISwitchStyleSliding":P(UISwitchStyleSliding),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIAccessibilityCustomRotor.h
//   UIAccessibilityCustomRotorDirection
            @"UIAccessibilityCustomRotorDirectionPrevious":P(UIAccessibilityCustomRotorDirectionPrevious),
            @"UIAccessibilityCustomRotorDirectionNext":P(UIAccessibilityCustomRotorDirectionNext),
//   UIAccessibilityCustomSystemRotorType
            @"UIAccessibilityCustomSystemRotorTypeNone":P(UIAccessibilityCustomSystemRotorTypeNone),
            @"UIAccessibilityCustomSystemRotorTypeLink":P(UIAccessibilityCustomSystemRotorTypeLink),
            @"UIAccessibilityCustomSystemRotorTypeVisitedLink":P(UIAccessibilityCustomSystemRotorTypeVisitedLink),
            @"UIAccessibilityCustomSystemRotorTypeHeading":P(UIAccessibilityCustomSystemRotorTypeHeading),
            @"UIAccessibilityCustomSystemRotorTypeBoldText":P(UIAccessibilityCustomSystemRotorTypeBoldText),
            @"UIAccessibilityCustomSystemRotorTypeItalicText":P(UIAccessibilityCustomSystemRotorTypeItalicText),
            @"UIAccessibilityCustomSystemRotorTypeUnderlineText":P(UIAccessibilityCustomSystemRotorTypeUnderlineText),
            @"UIAccessibilityCustomSystemRotorTypeMisspelledWord":P(UIAccessibilityCustomSystemRotorTypeMisspelledWord),
            @"UIAccessibilityCustomSystemRotorTypeImage":P(UIAccessibilityCustomSystemRotorTypeImage),
            @"UIAccessibilityCustomSystemRotorTypeTextField":P(UIAccessibilityCustomSystemRotorTypeTextField),
            @"UIAccessibilityCustomSystemRotorTypeTable":P(UIAccessibilityCustomSystemRotorTypeTable),
            @"UIAccessibilityCustomSystemRotorTypeList":P(UIAccessibilityCustomSystemRotorTypeList),
            @"UIAccessibilityCustomSystemRotorTypeLandmark":P(UIAccessibilityCustomSystemRotorTypeLandmark),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIGestureRecognizer.h
//   UIGestureRecognizerState
            @"UIGestureRecognizerStatePossible":P(UIGestureRecognizerStatePossible),
            @"UIGestureRecognizerStateBegan":P(UIGestureRecognizerStateBegan),
            @"UIGestureRecognizerStateChanged":P(UIGestureRecognizerStateChanged),
            @"UIGestureRecognizerStateEnded":P(UIGestureRecognizerStateEnded),
            @"UIGestureRecognizerStateCancelled":P(UIGestureRecognizerStateCancelled),
            @"UIGestureRecognizerStateFailed":P(UIGestureRecognizerStateFailed),
            @"UIGestureRecognizerStateRecognized":P(UIGestureRecognizerStateRecognized),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIWindowScene.h
//   UIWindowSceneDismissalAnimation
            @"UIWindowSceneDismissalAnimationStandard":P(UIWindowSceneDismissalAnimationStandard),
            @"UIWindowSceneDismissalAnimationCommit":P(UIWindowSceneDismissalAnimationCommit),
            @"UIWindowSceneDismissalAnimationDecline":P(UIWindowSceneDismissalAnimationDecline),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITableView.h
//   UITableViewStyle
            @"UITableViewStylePlain":P(UITableViewStylePlain),
            @"UITableViewStyleGrouped":P(UITableViewStyleGrouped),
            @"UITableViewStyleInsetGrouped":P(UITableViewStyleInsetGrouped),
//   UITableViewScrollPosition
            @"UITableViewScrollPositionNone":P(UITableViewScrollPositionNone),
            @"UITableViewScrollPositionTop":P(UITableViewScrollPositionTop),
            @"UITableViewScrollPositionMiddle":P(UITableViewScrollPositionMiddle),
            @"UITableViewScrollPositionBottom":P(UITableViewScrollPositionBottom),
//   UITableViewRowAnimation
            @"UITableViewRowAnimationFade":P(UITableViewRowAnimationFade),
            @"UITableViewRowAnimationRight":P(UITableViewRowAnimationRight),
            @"UITableViewRowAnimationLeft":P(UITableViewRowAnimationLeft),
            @"UITableViewRowAnimationTop":P(UITableViewRowAnimationTop),
            @"UITableViewRowAnimationBottom":P(UITableViewRowAnimationBottom),
            @"UITableViewRowAnimationNone":P(UITableViewRowAnimationNone),
            @"UITableViewRowAnimationMiddle":P(UITableViewRowAnimationMiddle),
            @"UITableViewRowAnimationAutomatic":P(UITableViewRowAnimationAutomatic),
//   UITableViewRowActionStyle
            @"UITableViewRowActionStyleDefault":P(UITableViewRowActionStyleDefault),
            @"UITableViewRowActionStyleDestructive":P(UITableViewRowActionStyleDestructive),
            @"UITableViewRowActionStyleNormal":P(UITableViewRowActionStyleNormal),
//   UITableViewSeparatorInsetReference
            @"UITableViewSeparatorInsetFromCellEdges":P(UITableViewSeparatorInsetFromCellEdges),
            @"UITableViewSeparatorInsetFromAutomaticInsets":P(UITableViewSeparatorInsetFromAutomaticInsets),
//   UITableViewSelfSizingInvalidation
            @"UITableViewSelfSizingInvalidationDisabled":P(UITableViewSelfSizingInvalidationDisabled),
            @"UITableViewSelfSizingInvalidationEnabled":P(UITableViewSelfSizingInvalidationEnabled),
            @"UITableViewSelfSizingInvalidationEnabledIncludingConstraints":P(UITableViewSelfSizingInvalidationEnabledIncludingConstraints),
//   UITableViewDropIntent
            @"UITableViewDropIntentUnspecified":P(UITableViewDropIntentUnspecified),
            @"UITableViewDropIntentInsertAtDestinationIndexPath":P(UITableViewDropIntentInsertAtDestinationIndexPath),
            @"UITableViewDropIntentInsertIntoDestinationIndexPath":P(UITableViewDropIntentInsertIntoDestinationIndexPath),
            @"UITableViewDropIntentAutomatic":P(UITableViewDropIntentAutomatic),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextItemInteraction.h
//   UITextItemInteraction
            @"UITextItemInteractionInvokeDefaultAction":P(UITextItemInteractionInvokeDefaultAction),
            @"UITextItemInteractionPresentActions":P(UITextItemInteractionPresentActions),
            @"UITextItemInteractionPreview":P(UITextItemInteractionPreview),

//   Enum definitions in ./enum_gen/UIKit/Headers/UISplitViewController.h
//   UISplitViewControllerDisplayMode
            @"UISplitViewControllerDisplayModeAutomatic":P(UISplitViewControllerDisplayModeAutomatic),
            @"UISplitViewControllerDisplayModeSecondaryOnly":P(UISplitViewControllerDisplayModeSecondaryOnly),
            @"UISplitViewControllerDisplayModeOneBesideSecondary":P(UISplitViewControllerDisplayModeOneBesideSecondary),
            @"UISplitViewControllerDisplayModeOneOverSecondary":P(UISplitViewControllerDisplayModeOneOverSecondary),
            @"UISplitViewControllerDisplayModeTwoBesideSecondary":P(UISplitViewControllerDisplayModeTwoBesideSecondary),
            @"UISplitViewControllerDisplayModeTwoOverSecondary":P(UISplitViewControllerDisplayModeTwoOverSecondary),
            @"UISplitViewControllerDisplayModeTwoDisplaceSecondary":P(UISplitViewControllerDisplayModeTwoDisplaceSecondary),
            @"UISplitViewControllerDisplayModePrimaryHidden":P(UISplitViewControllerDisplayModePrimaryHidden),
            @"UISplitViewControllerDisplayModeAllVisible":P(UISplitViewControllerDisplayModeAllVisible),
            @"UISplitViewControllerDisplayModePrimaryOverlay":P(UISplitViewControllerDisplayModePrimaryOverlay),
//   UISplitViewControllerPrimaryEdge
            @"UISplitViewControllerPrimaryEdgeLeading":P(UISplitViewControllerPrimaryEdgeLeading),
            @"UISplitViewControllerPrimaryEdgeTrailing":P(UISplitViewControllerPrimaryEdgeTrailing),
//   UISplitViewControllerBackgroundStyle
            @"UISplitViewControllerBackgroundStyleNone":P(UISplitViewControllerBackgroundStyleNone),
            @"UISplitViewControllerBackgroundStyleSidebar":P(UISplitViewControllerBackgroundStyleSidebar),
//   UISplitViewControllerStyle
            @"UISplitViewControllerStyleUnspecified":P(UISplitViewControllerStyleUnspecified),
            @"UISplitViewControllerStyleDoubleColumn":P(UISplitViewControllerStyleDoubleColumn),
            @"UISplitViewControllerStyleTripleColumn":P(UISplitViewControllerStyleTripleColumn),
//   UISplitViewControllerColumn
            @"UISplitViewControllerColumnPrimary":P(UISplitViewControllerColumnPrimary),
            @"UISplitViewControllerColumnSupplementary":P(UISplitViewControllerColumnSupplementary),
            @"UISplitViewControllerColumnSecondary":P(UISplitViewControllerColumnSecondary),
            @"UISplitViewControllerColumnCompact":P(UISplitViewControllerColumnCompact),
//   UISplitViewControllerSplitBehavior
            @"UISplitViewControllerSplitBehaviorAutomatic":P(UISplitViewControllerSplitBehaviorAutomatic),
            @"UISplitViewControllerSplitBehaviorTile":P(UISplitViewControllerSplitBehaviorTile),
            @"UISplitViewControllerSplitBehaviorOverlay":P(UISplitViewControllerSplitBehaviorOverlay),
            @"UISplitViewControllerSplitBehaviorDisplace":P(UISplitViewControllerSplitBehaviorDisplace),
//   UISplitViewControllerDisplayModeButtonVisibility
            @"UISplitViewControllerDisplayModeButtonVisibilityAutomatic":P(UISplitViewControllerDisplayModeButtonVisibilityAutomatic),
            @"UISplitViewControllerDisplayModeButtonVisibilityNever":P(UISplitViewControllerDisplayModeButtonVisibilityNever),
            @"UISplitViewControllerDisplayModeButtonVisibilityAlways":P(UISplitViewControllerDisplayModeButtonVisibilityAlways),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextItem.h
//   UITextItemContentType
            @"UITextItemContentTypeLink":P(UITextItemContentTypeLink),
            @"UITextItemContentTypeTextAttachment":P(UITextItemContentTypeTextAttachment),
            @"UITextItemContentTypeTag":P(UITextItemContentTypeTag),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIListContentTextProperties.h
//   UIListContentTextAlignment
            @"UIListContentTextAlignmentNatural":P(UIListContentTextAlignmentNatural),
            @"UIListContentTextAlignmentCenter":P(UIListContentTextAlignmentCenter),
            @"UIListContentTextAlignmentJustified":P(UIListContentTextAlignmentJustified),
//   UIListContentTextTransform
            @"UIListContentTextTransformNone":P(UIListContentTextTransformNone),
            @"UIListContentTextTransformUppercase":P(UIListContentTextTransformUppercase),
            @"UIListContentTextTransformLowercase":P(UIListContentTextTransformLowercase),
            @"UIListContentTextTransformCapitalized":P(UIListContentTextTransformCapitalized),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIButton.h
//   UIButtonType
            @"UIButtonTypeCustom":P(UIButtonTypeCustom),
            @"UIButtonTypeSystem":P(UIButtonTypeSystem),
            @"UIButtonTypeDetailDisclosure":P(UIButtonTypeDetailDisclosure),
            @"UIButtonTypeInfoLight":P(UIButtonTypeInfoLight),
            @"UIButtonTypeInfoDark":P(UIButtonTypeInfoDark),
            @"UIButtonTypeContactAdd":P(UIButtonTypeContactAdd),
            @"UIButtonTypeClose":P(UIButtonTypeClose),
            @"UIButtonTypeRoundedRect":P(UIButtonTypeRoundedRect),
//   UIButtonRole
            @"UIButtonRoleNormal":P(UIButtonRoleNormal),
            @"UIButtonRolePrimary":P(UIButtonRolePrimary),
            @"UIButtonRoleCancel":P(UIButtonRoleCancel),
            @"UIButtonRoleDestructive":P(UIButtonRoleDestructive),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSToolbar+UIKitAdditions.h
//   UITitlebarSeparatorStyle
//   UITitlebarTitleVisibility
//   UITitlebarToolbarStyle

//   Enum definitions in ./enum_gen/UIKit/Headers/UITabBarAppearance.h
//   UITabBarItemAppearanceStyle
            @"UITabBarItemAppearanceStyleStacked":P(UITabBarItemAppearanceStyleStacked),
            @"UITabBarItemAppearanceStyleInline":P(UITabBarItemAppearanceStyleInline),
            @"UITabBarItemAppearanceStyleCompactInline":P(UITabBarItemAppearanceStyleCompactInline),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSTextLayoutManager.h
//   NSTextLayoutManagerSegmentType
            @"NSTextLayoutManagerSegmentTypeStandard":P(NSTextLayoutManagerSegmentTypeStandard),
            @"NSTextLayoutManagerSegmentTypeSelection":P(NSTextLayoutManagerSegmentTypeSelection),
            @"NSTextLayoutManagerSegmentTypeHighlight":P(NSTextLayoutManagerSegmentTypeHighlight),
//   NSTextLayoutManagerSegmentOptions
            @"NSTextLayoutManagerSegmentOptionsNone":P(NSTextLayoutManagerSegmentOptionsNone),
            @"NSTextLayoutManagerSegmentOptionsRangeNotRequired":P(NSTextLayoutManagerSegmentOptionsRangeNotRequired),
            @"NSTextLayoutManagerSegmentOptionsMiddleFragmentsExcluded":P(NSTextLayoutManagerSegmentOptionsMiddleFragmentsExcluded),
            @"NSTextLayoutManagerSegmentOptionsHeadSegmentExtended":P(NSTextLayoutManagerSegmentOptionsHeadSegmentExtended),
            @"NSTextLayoutManagerSegmentOptionsTailSegmentExtended":P(NSTextLayoutManagerSegmentOptionsTailSegmentExtended),
            @"NSTextLayoutManagerSegmentOptionsUpstreamAffinity":P(NSTextLayoutManagerSegmentOptionsUpstreamAffinity),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIContextualAction.h
//   UIContextualActionStyle
            @"UIContextualActionStyleNormal":P(UIContextualActionStyleNormal),
            @"UIContextualActionStyleDestructive":P(UIContextualActionStyleDestructive),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIView.h
//   UIViewAnimationCurve
            @"UIViewAnimationCurveEaseInOut":P(UIViewAnimationCurveEaseInOut),
            @"UIViewAnimationCurveEaseIn":P(UIViewAnimationCurveEaseIn),
            @"UIViewAnimationCurveEaseOut":P(UIViewAnimationCurveEaseOut),
            @"UIViewAnimationCurveLinear":P(UIViewAnimationCurveLinear),
//   UIViewContentMode
            @"UIViewContentModeScaleToFill":P(UIViewContentModeScaleToFill),
            @"UIViewContentModeScaleAspectFit":P(UIViewContentModeScaleAspectFit),
            @"UIViewContentModeScaleAspectFill":P(UIViewContentModeScaleAspectFill),
            @"UIViewContentModeRedraw":P(UIViewContentModeRedraw),
            @"UIViewContentModeCenter":P(UIViewContentModeCenter),
            @"UIViewContentModeTop":P(UIViewContentModeTop),
            @"UIViewContentModeBottom":P(UIViewContentModeBottom),
            @"UIViewContentModeLeft":P(UIViewContentModeLeft),
            @"UIViewContentModeRight":P(UIViewContentModeRight),
            @"UIViewContentModeTopLeft":P(UIViewContentModeTopLeft),
            @"UIViewContentModeTopRight":P(UIViewContentModeTopRight),
            @"UIViewContentModeBottomLeft":P(UIViewContentModeBottomLeft),
            @"UIViewContentModeBottomRight":P(UIViewContentModeBottomRight),
//   UIViewAnimationTransition
            @"UIViewAnimationTransitionNone":P(UIViewAnimationTransitionNone),
            @"UIViewAnimationTransitionFlipFromLeft":P(UIViewAnimationTransitionFlipFromLeft),
            @"UIViewAnimationTransitionFlipFromRight":P(UIViewAnimationTransitionFlipFromRight),
            @"UIViewAnimationTransitionCurlUp":P(UIViewAnimationTransitionCurlUp),
            @"UIViewAnimationTransitionCurlDown":P(UIViewAnimationTransitionCurlDown),
//   UIViewAutoresizing
            @"UIViewAutoresizingNone":P(UIViewAutoresizingNone),
            @"UIViewAutoresizingFlexibleLeftMargin":P(UIViewAutoresizingFlexibleLeftMargin),
            @"UIViewAutoresizingFlexibleWidth":P(UIViewAutoresizingFlexibleWidth),
            @"UIViewAutoresizingFlexibleRightMargin":P(UIViewAutoresizingFlexibleRightMargin),
            @"UIViewAutoresizingFlexibleTopMargin":P(UIViewAutoresizingFlexibleTopMargin),
            @"UIViewAutoresizingFlexibleHeight":P(UIViewAutoresizingFlexibleHeight),
            @"UIViewAutoresizingFlexibleBottomMargin":P(UIViewAutoresizingFlexibleBottomMargin),
//   UIViewAnimationOptions
            @"UIViewAnimationOptionLayoutSubviews":P(UIViewAnimationOptionLayoutSubviews),
            @"UIViewAnimationOptionAllowUserInteraction":P(UIViewAnimationOptionAllowUserInteraction),
            @"UIViewAnimationOptionBeginFromCurrentState":P(UIViewAnimationOptionBeginFromCurrentState),
            @"UIViewAnimationOptionRepeat":P(UIViewAnimationOptionRepeat),
            @"UIViewAnimationOptionAutoreverse":P(UIViewAnimationOptionAutoreverse),
            @"UIViewAnimationOptionOverrideInheritedDuration":P(UIViewAnimationOptionOverrideInheritedDuration),
            @"UIViewAnimationOptionOverrideInheritedCurve":P(UIViewAnimationOptionOverrideInheritedCurve),
            @"UIViewAnimationOptionAllowAnimatedContent":P(UIViewAnimationOptionAllowAnimatedContent),
            @"UIViewAnimationOptionShowHideTransitionViews":P(UIViewAnimationOptionShowHideTransitionViews),
            @"UIViewAnimationOptionOverrideInheritedOptions":P(UIViewAnimationOptionOverrideInheritedOptions),
            @"UIViewAnimationOptionCurveEaseInOut":P(UIViewAnimationOptionCurveEaseInOut),
            @"UIViewAnimationOptionCurveEaseIn":P(UIViewAnimationOptionCurveEaseIn),
            @"UIViewAnimationOptionCurveEaseOut":P(UIViewAnimationOptionCurveEaseOut),
            @"UIViewAnimationOptionCurveLinear":P(UIViewAnimationOptionCurveLinear),
            @"UIViewAnimationOptionTransitionNone":P(UIViewAnimationOptionTransitionNone),
            @"UIViewAnimationOptionTransitionFlipFromLeft":P(UIViewAnimationOptionTransitionFlipFromLeft),
            @"UIViewAnimationOptionTransitionFlipFromRight":P(UIViewAnimationOptionTransitionFlipFromRight),
            @"UIViewAnimationOptionTransitionCurlUp":P(UIViewAnimationOptionTransitionCurlUp),
            @"UIViewAnimationOptionTransitionCurlDown":P(UIViewAnimationOptionTransitionCurlDown),
            @"UIViewAnimationOptionTransitionCrossDissolve":P(UIViewAnimationOptionTransitionCrossDissolve),
            @"UIViewAnimationOptionTransitionFlipFromTop":P(UIViewAnimationOptionTransitionFlipFromTop),
            @"UIViewAnimationOptionTransitionFlipFromBottom":P(UIViewAnimationOptionTransitionFlipFromBottom),
            @"UIViewAnimationOptionPreferredFramesPerSecondDefault":P(UIViewAnimationOptionPreferredFramesPerSecondDefault),
//   UIViewKeyframeAnimationOptions
            @"UIViewKeyframeAnimationOptionLayoutSubviews":P(UIViewKeyframeAnimationOptionLayoutSubviews),
            @"UIViewKeyframeAnimationOptionAllowUserInteraction":P(UIViewKeyframeAnimationOptionAllowUserInteraction),
            @"UIViewKeyframeAnimationOptionBeginFromCurrentState":P(UIViewKeyframeAnimationOptionBeginFromCurrentState),
            @"UIViewKeyframeAnimationOptionRepeat":P(UIViewKeyframeAnimationOptionRepeat),
            @"UIViewKeyframeAnimationOptionAutoreverse":P(UIViewKeyframeAnimationOptionAutoreverse),
            @"UIViewKeyframeAnimationOptionOverrideInheritedDuration":P(UIViewKeyframeAnimationOptionOverrideInheritedDuration),
            @"UIViewKeyframeAnimationOptionOverrideInheritedOptions":P(UIViewKeyframeAnimationOptionOverrideInheritedOptions),
            @"UIViewKeyframeAnimationOptionCalculationModeLinear":P(UIViewKeyframeAnimationOptionCalculationModeLinear),
            @"UIViewKeyframeAnimationOptionCalculationModeDiscrete":P(UIViewKeyframeAnimationOptionCalculationModeDiscrete),
            @"UIViewKeyframeAnimationOptionCalculationModePaced":P(UIViewKeyframeAnimationOptionCalculationModePaced),
            @"UIViewKeyframeAnimationOptionCalculationModeCubic":P(UIViewKeyframeAnimationOptionCalculationModeCubic),
            @"UIViewKeyframeAnimationOptionCalculationModeCubicPaced":P(UIViewKeyframeAnimationOptionCalculationModeCubicPaced),
//   UISystemAnimation
            @"UISystemAnimationDelete":P(UISystemAnimationDelete),
//   UIViewTintAdjustmentMode
            @"UIViewTintAdjustmentModeAutomatic":P(UIViewTintAdjustmentModeAutomatic),
            @"UIViewTintAdjustmentModeNormal":P(UIViewTintAdjustmentModeNormal),
            @"UIViewTintAdjustmentModeDimmed":P(UIViewTintAdjustmentModeDimmed),
//   UISemanticContentAttribute
            @"UISemanticContentAttributeUnspecified":P(UISemanticContentAttributeUnspecified),
            @"UISemanticContentAttributePlayback":P(UISemanticContentAttributePlayback),
            @"UISemanticContentAttributeSpatial":P(UISemanticContentAttributeSpatial),
            @"UISemanticContentAttributeForceLeftToRight":P(UISemanticContentAttributeForceLeftToRight),
            @"UISemanticContentAttributeForceRightToLeft":P(UISemanticContentAttributeForceRightToLeft),
//   UILayoutConstraintAxis
            @"UILayoutConstraintAxisHorizontal":P(UILayoutConstraintAxisHorizontal),
            @"UILayoutConstraintAxisVertical":P(UILayoutConstraintAxisVertical),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITabBar.h
//   UITabBarItemPositioning
            @"UITabBarItemPositioningAutomatic":P(UITabBarItemPositioningAutomatic),
            @"UITabBarItemPositioningFill":P(UITabBarItemPositioningFill),
            @"UITabBarItemPositioningCentered":P(UITabBarItemPositioningCentered),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIAlertView.h
//   UIAlertViewStyle
            @"UIAlertViewStyleDefault":P(UIAlertViewStyleDefault),
            @"UIAlertViewStyleSecureTextInput":P(UIAlertViewStyleSecureTextInput),
            @"UIAlertViewStylePlainTextInput":P(UIAlertViewStylePlainTextInput),
            @"UIAlertViewStyleLoginAndPasswordInput":P(UIAlertViewStyleLoginAndPasswordInput),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIListSeparatorConfiguration.h
//   UIListSeparatorVisibility
            @"UIListSeparatorVisibilityAutomatic":P(UIListSeparatorVisibilityAutomatic),
            @"UIListSeparatorVisibilityVisible":P(UIListSeparatorVisibilityVisible),
            @"UIListSeparatorVisibilityHidden":P(UIListSeparatorVisibilityHidden),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIActionSheet.h
//   UIActionSheetStyle
            @"UIActionSheetStyleAutomatic":P(UIActionSheetStyleAutomatic),
            @"UIActionSheetStyleDefault":P(UIActionSheetStyleDefault),
            @"UIActionSheetStyleBlackTranslucent":P(UIActionSheetStyleBlackTranslucent),
            @"UIActionSheetStyleBlackOpaque":P(UIActionSheetStyleBlackOpaque),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIOrientation.h
//   UIDeviceOrientation
            @"UIDeviceOrientationUnknown":P(UIDeviceOrientationUnknown),
            @"UIDeviceOrientationPortrait":P(UIDeviceOrientationPortrait),
            @"UIDeviceOrientationPortraitUpsideDown":P(UIDeviceOrientationPortraitUpsideDown),
            @"UIDeviceOrientationLandscapeLeft":P(UIDeviceOrientationLandscapeLeft),
            @"UIDeviceOrientationLandscapeRight":P(UIDeviceOrientationLandscapeRight),
            @"UIDeviceOrientationFaceUp":P(UIDeviceOrientationFaceUp),
            @"UIDeviceOrientationFaceDown":P(UIDeviceOrientationFaceDown),
//   UIInterfaceOrientation
            @"UIInterfaceOrientationUnknown":P(UIInterfaceOrientationUnknown),
            @"UIInterfaceOrientationPortrait":P(UIInterfaceOrientationPortrait),
            @"UIInterfaceOrientationPortraitUpsideDown":P(UIInterfaceOrientationPortraitUpsideDown),
            @"UIInterfaceOrientationLandscapeLeft":P(UIInterfaceOrientationLandscapeLeft),
            @"UIInterfaceOrientationLandscapeRight":P(UIInterfaceOrientationLandscapeRight),
//   UIInterfaceOrientationMask
            @"UIInterfaceOrientationMaskPortrait":P(UIInterfaceOrientationMaskPortrait),
            @"UIInterfaceOrientationMaskLandscapeLeft":P(UIInterfaceOrientationMaskLandscapeLeft),
            @"UIInterfaceOrientationMaskLandscapeRight":P(UIInterfaceOrientationMaskLandscapeRight),
            @"UIInterfaceOrientationMaskPortraitUpsideDown":P(UIInterfaceOrientationMaskPortraitUpsideDown),
            @"UIInterfaceOrientationMaskLandscape":P(UIInterfaceOrientationMaskLandscape),
            @"UIInterfaceOrientationMaskAll":P(UIInterfaceOrientationMaskAll),
            @"UIInterfaceOrientationMaskAllButUpsideDown":P(UIInterfaceOrientationMaskAllButUpsideDown),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIImpactFeedbackGenerator.h
//   UIImpactFeedbackStyle
            @"UIImpactFeedbackStyleLight":P(UIImpactFeedbackStyleLight),
            @"UIImpactFeedbackStyleMedium":P(UIImpactFeedbackStyleMedium),
            @"UIImpactFeedbackStyleHeavy":P(UIImpactFeedbackStyleHeavy),
            @"UIImpactFeedbackStyleSoft":P(UIImpactFeedbackStyleSoft),
            @"UIImpactFeedbackStyleRigid":P(UIImpactFeedbackStyleRigid),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIStackView.h
//   UIStackViewDistribution
//   UIStackViewAlignment

//   Enum definitions in ./enum_gen/UIKit/Headers/UISegmentedControl.h
//   UISegmentedControlStyle
            @"UISegmentedControlStylePlain":P(UISegmentedControlStylePlain),
            @"UISegmentedControlStyleBordered":P(UISegmentedControlStyleBordered),
            @"UISegmentedControlStyleBar":P(UISegmentedControlStyleBar),
            @"UISegmentedControlStyleBezeled":P(UISegmentedControlStyleBezeled),
//   UISegmentedControlSegment
            @"UISegmentedControlSegmentAny":P(UISegmentedControlSegmentAny),
            @"UISegmentedControlSegmentLeft":P(UISegmentedControlSegmentLeft),
            @"UISegmentedControlSegmentCenter":P(UISegmentedControlSegmentCenter),
            @"UISegmentedControlSegmentRight":P(UISegmentedControlSegmentRight),
            @"UISegmentedControlSegmentAlone":P(UISegmentedControlSegmentAlone),

//   Enum definitions in ./enum_gen/UIKit/Headers/NSStringDrawing.h
//   NSStringDrawingOptions
            @"NSStringDrawingUsesLineFragmentOrigin":P(NSStringDrawingUsesLineFragmentOrigin),
            @"NSStringDrawingUsesFontLeading":P(NSStringDrawingUsesFontLeading),
            @"NSStringDrawingUsesDeviceMetrics":P(NSStringDrawingUsesDeviceMetrics),
            @"NSStringDrawingTruncatesLastVisibleLine":P(NSStringDrawingTruncatesLastVisibleLine),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIActivity.h
//   UIActivityCategory
            @"UIActivityCategoryAction":P(UIActivityCategoryAction),
            @"UIActivityCategoryShare":P(UIActivityCategoryShare),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIButtonConfiguration.h
//   UIButtonConfigurationSize
            @"UIButtonConfigurationSizeMedium":P(UIButtonConfigurationSizeMedium),
            @"UIButtonConfigurationSizeSmall":P(UIButtonConfigurationSizeSmall),
            @"UIButtonConfigurationSizeMini":P(UIButtonConfigurationSizeMini),
            @"UIButtonConfigurationSizeLarge":P(UIButtonConfigurationSizeLarge),
//   UIButtonConfigurationTitleAlignment
            @"UIButtonConfigurationTitleAlignmentAutomatic":P(UIButtonConfigurationTitleAlignmentAutomatic),
            @"UIButtonConfigurationTitleAlignmentLeading":P(UIButtonConfigurationTitleAlignmentLeading),
            @"UIButtonConfigurationTitleAlignmentCenter":P(UIButtonConfigurationTitleAlignmentCenter),
            @"UIButtonConfigurationTitleAlignmentTrailing":P(UIButtonConfigurationTitleAlignmentTrailing),
//   UIButtonConfigurationCornerStyle
            @"UIButtonConfigurationCornerStyleFixed":P(UIButtonConfigurationCornerStyleFixed),
            @"UIButtonConfigurationCornerStyleDynamic":P(UIButtonConfigurationCornerStyleDynamic),
            @"UIButtonConfigurationCornerStyleSmall":P(UIButtonConfigurationCornerStyleSmall),
            @"UIButtonConfigurationCornerStyleMedium":P(UIButtonConfigurationCornerStyleMedium),
            @"UIButtonConfigurationCornerStyleLarge":P(UIButtonConfigurationCornerStyleLarge),
            @"UIButtonConfigurationCornerStyleCapsule":P(UIButtonConfigurationCornerStyleCapsule),
//   UIButtonConfigurationMacIdiomStyle
            @"UIButtonConfigurationMacIdiomStyleAutomatic":P(UIButtonConfigurationMacIdiomStyleAutomatic),
            @"UIButtonConfigurationMacIdiomStyleBordered":P(UIButtonConfigurationMacIdiomStyleBordered),
            @"UIButtonConfigurationMacIdiomStyleBorderless":P(UIButtonConfigurationMacIdiomStyleBorderless),
            @"UIButtonConfigurationMacIdiomStyleBorderlessTinted":P(UIButtonConfigurationMacIdiomStyleBorderlessTinted),
//   UIButtonConfigurationIndicator
            @"UIButtonConfigurationIndicatorAutomatic":P(UIButtonConfigurationIndicatorAutomatic),
            @"UIButtonConfigurationIndicatorNone":P(UIButtonConfigurationIndicatorNone),
            @"UIButtonConfigurationIndicatorPopup":P(UIButtonConfigurationIndicatorPopup),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIGeometry.h
//   UIRectEdge
            @"UIRectEdgeNone":P(UIRectEdgeNone),
            @"UIRectEdgeTop":P(UIRectEdgeTop),
            @"UIRectEdgeLeft":P(UIRectEdgeLeft),
            @"UIRectEdgeBottom":P(UIRectEdgeBottom),
            @"UIRectEdgeRight":P(UIRectEdgeRight),
            @"UIRectEdgeAll":P(UIRectEdgeAll),
//   UIRectCorner
            @"UIRectCornerTopLeft":P(UIRectCornerTopLeft),
            @"UIRectCornerTopRight":P(UIRectCornerTopRight),
            @"UIRectCornerBottomLeft":P(UIRectCornerBottomLeft),
            @"UIRectCornerBottomRight":P(UIRectCornerBottomRight),
            @"UIRectCornerAllCorners":P(UIRectCornerAllCorners),
//   UIAxis
            @"UIAxisNeither":P(UIAxisNeither),
            @"UIAxisHorizontal":P(UIAxisHorizontal),
            @"UIAxisVertical":P(UIAxisVertical),
            @"UIAxisBoth":P(UIAxisBoth),
//   NSDirectionalRectEdge
            @"NSDirectionalRectEdgeNone":P(NSDirectionalRectEdgeNone),
            @"NSDirectionalRectEdgeTop":P(NSDirectionalRectEdgeTop),
            @"NSDirectionalRectEdgeLeading":P(NSDirectionalRectEdgeLeading),
            @"NSDirectionalRectEdgeBottom":P(NSDirectionalRectEdgeBottom),
            @"NSDirectionalRectEdgeTrailing":P(NSDirectionalRectEdgeTrailing),
            @"NSDirectionalRectEdgeAll":P(NSDirectionalRectEdgeAll),
//   UIDirectionalRectEdge
            @"UIDirectionalRectEdgeNone":P(UIDirectionalRectEdgeNone),
            @"UIDirectionalRectEdgeTop":P(UIDirectionalRectEdgeTop),
            @"UIDirectionalRectEdgeLeading":P(UIDirectionalRectEdgeLeading),
            @"UIDirectionalRectEdgeBottom":P(UIDirectionalRectEdgeBottom),
            @"UIDirectionalRectEdgeTrailing":P(UIDirectionalRectEdgeTrailing),
            @"UIDirectionalRectEdgeAll":P(UIDirectionalRectEdgeAll),
//   NSRectAlignment
            @"NSRectAlignmentNone":P(NSRectAlignmentNone),
            @"NSRectAlignmentTop":P(NSRectAlignmentTop),
            @"NSRectAlignmentTopLeading":P(NSRectAlignmentTopLeading),
            @"NSRectAlignmentLeading":P(NSRectAlignmentLeading),
            @"NSRectAlignmentBottomLeading":P(NSRectAlignmentBottomLeading),
            @"NSRectAlignmentBottom":P(NSRectAlignmentBottom),
            @"NSRectAlignmentBottomTrailing":P(NSRectAlignmentBottomTrailing),
            @"NSRectAlignmentTrailing":P(NSRectAlignmentTrailing),
            @"NSRectAlignmentTopTrailing":P(NSRectAlignmentTopTrailing),

//   Enum definitions in ./enum_gen/UIKit/Headers/UIFontDescriptor.h
//   UIFontDescriptorSymbolicTraits

//   Enum definitions in ./enum_gen/UIKit/Headers/NSTextLayoutFragment.h
//   NSTextLayoutFragmentEnumerationOptions
            @"NSTextLayoutFragmentEnumerationOptionsNone":P(NSTextLayoutFragmentEnumerationOptionsNone),
            @"NSTextLayoutFragmentEnumerationOptionsReverse":P(NSTextLayoutFragmentEnumerationOptionsReverse),
            @"NSTextLayoutFragmentEnumerationOptionsEstimatesSize":P(NSTextLayoutFragmentEnumerationOptionsEstimatesSize),
            @"NSTextLayoutFragmentEnumerationOptionsEnsuresLayout":P(NSTextLayoutFragmentEnumerationOptionsEnsuresLayout),
            @"NSTextLayoutFragmentEnumerationOptionsEnsuresExtraLineFragment":P(NSTextLayoutFragmentEnumerationOptionsEnsuresExtraLineFragment),
//   NSTextLayoutFragmentState
            @"NSTextLayoutFragmentStateNone":P(NSTextLayoutFragmentStateNone),
            @"NSTextLayoutFragmentStateEstimatedUsageBounds":P(NSTextLayoutFragmentStateEstimatedUsageBounds),
            @"NSTextLayoutFragmentStateCalculatedUsageBounds":P(NSTextLayoutFragmentStateCalculatedUsageBounds),
            @"NSTextLayoutFragmentStateLayoutAvailable":P(NSTextLayoutFragmentStateLayoutAvailable),

//   Enum definitions in ./enum_gen/UIKit/Headers/UISceneOptions.h
//   UISceneCollectionJoinBehavior

//   Enum definitions in ./enum_gen/UIKit/Headers/UICollectionViewCompositionalLayout.h
//   UIContentInsetsReference
            @"UIContentInsetsReferenceAutomatic":P(UIContentInsetsReferenceAutomatic),
            @"UIContentInsetsReferenceNone":P(UIContentInsetsReferenceNone),
            @"UIContentInsetsReferenceSafeArea":P(UIContentInsetsReferenceSafeArea),
            @"UIContentInsetsReferenceLayoutMargins":P(UIContentInsetsReferenceLayoutMargins),
            @"UIContentInsetsReferenceReadableContent":P(UIContentInsetsReferenceReadableContent),
//  UICollectionLayoutSectionOrthogonalScrollingBehavior
            @"UICollectionLayoutSectionOrthogonalScrollingBehaviorNone":P(UICollectionLayoutSectionOrthogonalScrollingBehaviorNone),
            @"UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous":P(UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous),
            @"UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary":P(UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary),
            @"UICollectionLayoutSectionOrthogonalScrollingBehaviorPaging":P(UICollectionLayoutSectionOrthogonalScrollingBehaviorPaging),
            @"UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging":P(UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging),
            @"UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered":P(UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered),
//   UICollectionLayoutSectionOrthogonalScrollingBounce
            @"UICollectionLayoutSectionOrthogonalScrollingBounceAutomatic":P(UICollectionLayoutSectionOrthogonalScrollingBounceAutomatic),
            @"UICollectionLayoutSectionOrthogonalScrollingBounceAlways":P(UICollectionLayoutSectionOrthogonalScrollingBounceAlways),
            @"UICollectionLayoutSectionOrthogonalScrollingBounceNever":P(UICollectionLayoutSectionOrthogonalScrollingBounceNever),

//   Enum definitions in ./enum_gen/UIKit/Headers/UITextView.h
//   UITextViewBorderStyle
            @"UITextViewBorderStyleNone":P(UITextViewBorderStyleNone),

//   Enum definitions in ./enum_gen/UIKit/Headers/UISearchController.h
//   UISearchControllerScopeBarActivation
            @"UISearchControllerScopeBarActivationAutomatic":P(UISearchControllerScopeBarActivationAutomatic),
            @"UISearchControllerScopeBarActivationManual":P(UISearchControllerScopeBarActivationManual),
            @"UISearchControllerScopeBarActivationOnTextEntry":P(UISearchControllerScopeBarActivationOnTextEntry),
            @"UISearchControllerScopeBarActivationOnSearchActivation":P(UISearchControllerScopeBarActivationOnSearchActivation),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSLocale.h
//   NSLocaleLanguageDirection
            @"NSLocaleLanguageDirectionUnknown":P(NSLocaleLanguageDirectionUnknown),
            @"NSLocaleLanguageDirectionLeftToRight":P(NSLocaleLanguageDirectionLeftToRight),
            @"NSLocaleLanguageDirectionRightToLeft":P(NSLocaleLanguageDirectionRightToLeft),
            @"NSLocaleLanguageDirectionTopToBottom":P(NSLocaleLanguageDirectionTopToBottom),
            @"NSLocaleLanguageDirectionBottomToTop":P(NSLocaleLanguageDirectionBottomToTop),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSFileVersion.h
//   NSFileVersionAddingOptions
//   NSFileVersionReplacingOptions

//   Enum definitions in ./enum_gen/Foundation/Headers/NSAttributedString.h
//   NSAttributedStringEnumerationOptions
            @"NSAttributedStringEnumerationReverse":P(NSAttributedStringEnumerationReverse),
            @"NSAttributedStringEnumerationLongestEffectiveRangeNotRequired":P(NSAttributedStringEnumerationLongestEffectiveRangeNotRequired),
//   NSInlinePresentationIntent
            @"NSInlinePresentationIntentEmphasized":P(NSInlinePresentationIntentEmphasized),
            @"NSInlinePresentationIntentStronglyEmphasized":P(NSInlinePresentationIntentStronglyEmphasized),
            @"NSInlinePresentationIntentCode":P(NSInlinePresentationIntentCode),
            @"NSInlinePresentationIntentStrikethrough":P(NSInlinePresentationIntentStrikethrough),
            @"NSInlinePresentationIntentSoftBreak":P(NSInlinePresentationIntentSoftBreak),
            @"NSInlinePresentationIntentLineBreak":P(NSInlinePresentationIntentLineBreak),
            @"NSInlinePresentationIntentInlineHTML":P(NSInlinePresentationIntentInlineHTML),
            @"NSInlinePresentationIntentBlockHTML":P(NSInlinePresentationIntentBlockHTML),
//   NSAttributedStringMarkdownParsingFailurePolicy
            @"NSAttributedStringMarkdownParsingFailureReturnError":P(NSAttributedStringMarkdownParsingFailureReturnError),
            @"NSAttributedStringMarkdownParsingFailureReturnPartiallyParsedIfPossible":P(NSAttributedStringMarkdownParsingFailureReturnPartiallyParsedIfPossible),
//   NSAttributedStringMarkdownInterpretedSyntax
            @"NSAttributedStringMarkdownInterpretedSyntaxFull":P(NSAttributedStringMarkdownInterpretedSyntaxFull),
            @"NSAttributedStringMarkdownInterpretedSyntaxInlineOnly":P(NSAttributedStringMarkdownInterpretedSyntaxInlineOnly),
            @"NSAttributedStringMarkdownInterpretedSyntaxInlineOnlyPreservingWhitespace":P(NSAttributedStringMarkdownInterpretedSyntaxInlineOnlyPreservingWhitespace),
//   NSAttributedStringFormattingOptions
            @"NSAttributedStringFormattingInsertArgumentAttributesWithoutMerging":P(NSAttributedStringFormattingInsertArgumentAttributesWithoutMerging),
            @"NSAttributedStringFormattingApplyReplacementIndexAttribute":P(NSAttributedStringFormattingApplyReplacementIndexAttribute),
//   NSPresentationIntentKind
            @"NSPresentationIntentKindParagraph":P(NSPresentationIntentKindParagraph),
            @"NSPresentationIntentKindHeader":P(NSPresentationIntentKindHeader),
            @"NSPresentationIntentKindOrderedList":P(NSPresentationIntentKindOrderedList),
            @"NSPresentationIntentKindUnorderedList":P(NSPresentationIntentKindUnorderedList),
            @"NSPresentationIntentKindListItem":P(NSPresentationIntentKindListItem),
            @"NSPresentationIntentKindCodeBlock":P(NSPresentationIntentKindCodeBlock),
            @"NSPresentationIntentKindBlockQuote":P(NSPresentationIntentKindBlockQuote),
            @"NSPresentationIntentKindThematicBreak":P(NSPresentationIntentKindThematicBreak),
            @"NSPresentationIntentKindTable":P(NSPresentationIntentKindTable),
            @"NSPresentationIntentKindTableHeaderRow":P(NSPresentationIntentKindTableHeaderRow),
            @"NSPresentationIntentKindTableRow":P(NSPresentationIntentKindTableRow),
            @"NSPresentationIntentKindTableCell":P(NSPresentationIntentKindTableCell),
//   NSPresentationIntentTableColumnAlignment
            @"NSPresentationIntentTableColumnAlignmentLeft":P(NSPresentationIntentTableColumnAlignmentLeft),
            @"NSPresentationIntentTableColumnAlignmentCenter":P(NSPresentationIntentTableColumnAlignmentCenter),
            @"NSPresentationIntentTableColumnAlignmentRight":P(NSPresentationIntentTableColumnAlignmentRight),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSURL.h
//   NSURLBookmarkCreationOptions
            @"NSURLBookmarkCreationPreferFileIDResolution":P(NSURLBookmarkCreationPreferFileIDResolution),
            @"NSURLBookmarkCreationMinimalBookmark":P(NSURLBookmarkCreationMinimalBookmark),
            @"NSURLBookmarkCreationSuitableForBookmarkFile":P(NSURLBookmarkCreationSuitableForBookmarkFile),
            @"NSURLBookmarkCreationWithoutImplicitSecurityScope":P(NSURLBookmarkCreationWithoutImplicitSecurityScope),
//   NSURLBookmarkResolutionOptions
            @"NSURLBookmarkResolutionWithoutUI":P(NSURLBookmarkResolutionWithoutUI),
            @"NSURLBookmarkResolutionWithoutMounting":P(NSURLBookmarkResolutionWithoutMounting),
            @"NSURLBookmarkResolutionWithoutImplicitStartAccessing":P(NSURLBookmarkResolutionWithoutImplicitStartAccessing),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSData.h
//   NSDataReadingOptions
            @"NSDataReadingMappedIfSafe":P(NSDataReadingMappedIfSafe),
            @"NSDataReadingUncached":P(NSDataReadingUncached),
            @"NSDataReadingMappedAlways":P(NSDataReadingMappedAlways),
            @"NSDataReadingMapped":P(NSDataReadingMapped),
            @"NSMappedRead":P(NSMappedRead),
            @"NSUncachedRead":P(NSUncachedRead),
//   NSDataWritingOptions
            @"NSDataWritingAtomic":P(NSDataWritingAtomic),
            @"NSDataWritingWithoutOverwriting":P(NSDataWritingWithoutOverwriting),
            @"NSDataWritingFileProtectionNone":P(NSDataWritingFileProtectionNone),
            @"NSDataWritingFileProtectionComplete":P(NSDataWritingFileProtectionComplete),
            @"NSDataWritingFileProtectionCompleteUnlessOpen":P(NSDataWritingFileProtectionCompleteUnlessOpen),
            @"NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication":P(NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication),
            @"NSDataWritingFileProtectionCompleteWhenUserInactive":P(NSDataWritingFileProtectionCompleteWhenUserInactive),
            @"NSDataWritingFileProtectionMask":P(NSDataWritingFileProtectionMask),
            @"NSAtomicWrite":P(NSAtomicWrite),
//   NSDataSearchOptions
            @"NSDataSearchBackwards":P(NSDataSearchBackwards),
            @"NSDataSearchAnchored":P(NSDataSearchAnchored),
//   NSDataBase64EncodingOptions
//   NSDataBase64DecodingOptions
//   NSDataCompressionAlgorithm
            @"NSDataCompressionAlgorithmLZFSE":P(NSDataCompressionAlgorithmLZFSE),
            @"NSDataCompressionAlgorithmLZMA":P(NSDataCompressionAlgorithmLZMA),
            @"NSDataCompressionAlgorithmZlib":P(NSDataCompressionAlgorithmZlib),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSHTTPCookieStorage.h
//   NSHTTPCookieAcceptPolicy
            @"NSHTTPCookieAcceptPolicyAlways":P(NSHTTPCookieAcceptPolicyAlways),
            @"NSHTTPCookieAcceptPolicyNever":P(NSHTTPCookieAcceptPolicyNever),
            @"NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain":P(NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSURLError.h
//   NSURLErrorNetworkUnavailableReason
            @"NSURLErrorNetworkUnavailableReasonCellular":P(NSURLErrorNetworkUnavailableReasonCellular),
            @"NSURLErrorNetworkUnavailableReasonExpensive":P(NSURLErrorNetworkUnavailableReasonExpensive),
            @"NSURLErrorNetworkUnavailableReasonConstrained":P(NSURLErrorNetworkUnavailableReasonConstrained),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSPointerFunctions.h
//   NSPointerFunctionsOptions
            @"NSPointerFunctionsStrongMemory":P(NSPointerFunctionsStrongMemory),
            @"NSPointerFunctionsOpaqueMemory":P(NSPointerFunctionsOpaqueMemory),
            @"NSPointerFunctionsMallocMemory":P(NSPointerFunctionsMallocMemory),
            @"NSPointerFunctionsMachVirtualMemory":P(NSPointerFunctionsMachVirtualMemory),
            @"NSPointerFunctionsWeakMemory":P(NSPointerFunctionsWeakMemory),
            @"NSPointerFunctionsObjectPersonality":P(NSPointerFunctionsObjectPersonality),
            @"NSPointerFunctionsOpaquePersonality":P(NSPointerFunctionsOpaquePersonality),
            @"NSPointerFunctionsObjectPointerPersonality":P(NSPointerFunctionsObjectPointerPersonality),
            @"NSPointerFunctionsCStringPersonality":P(NSPointerFunctionsCStringPersonality),
            @"NSPointerFunctionsStructPersonality":P(NSPointerFunctionsStructPersonality),
            @"NSPointerFunctionsIntegerPersonality":P(NSPointerFunctionsIntegerPersonality),
            @"NSPointerFunctionsCopyIn":P(NSPointerFunctionsCopyIn),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSURLSession.h
//   NSURLSessionTaskState
            @"NSURLSessionTaskStateRunning":P(NSURLSessionTaskStateRunning),
            @"NSURLSessionTaskStateSuspended":P(NSURLSessionTaskStateSuspended),
            @"NSURLSessionTaskStateCanceling":P(NSURLSessionTaskStateCanceling),
            @"NSURLSessionTaskStateCompleted":P(NSURLSessionTaskStateCompleted),
//   NSURLSessionWebSocketMessageType
            @"NSURLSessionWebSocketMessageTypeData":P(NSURLSessionWebSocketMessageTypeData),
            @"NSURLSessionWebSocketMessageTypeString":P(NSURLSessionWebSocketMessageTypeString),
//   NSURLSessionWebSocketCloseCode
            @"NSURLSessionWebSocketCloseCodeInvalid":P(NSURLSessionWebSocketCloseCodeInvalid),
            @"NSURLSessionWebSocketCloseCodeNormalClosure":P(NSURLSessionWebSocketCloseCodeNormalClosure),
            @"NSURLSessionWebSocketCloseCodeGoingAway":P(NSURLSessionWebSocketCloseCodeGoingAway),
            @"NSURLSessionWebSocketCloseCodeProtocolError":P(NSURLSessionWebSocketCloseCodeProtocolError),
            @"NSURLSessionWebSocketCloseCodeUnsupportedData":P(NSURLSessionWebSocketCloseCodeUnsupportedData),
            @"NSURLSessionWebSocketCloseCodeNoStatusReceived":P(NSURLSessionWebSocketCloseCodeNoStatusReceived),
            @"NSURLSessionWebSocketCloseCodeAbnormalClosure":P(NSURLSessionWebSocketCloseCodeAbnormalClosure),
            @"NSURLSessionWebSocketCloseCodeInvalidFramePayloadData":P(NSURLSessionWebSocketCloseCodeInvalidFramePayloadData),
            @"NSURLSessionWebSocketCloseCodePolicyViolation":P(NSURLSessionWebSocketCloseCodePolicyViolation),
            @"NSURLSessionWebSocketCloseCodeMessageTooBig":P(NSURLSessionWebSocketCloseCodeMessageTooBig),
            @"NSURLSessionWebSocketCloseCodeMandatoryExtensionMissing":P(NSURLSessionWebSocketCloseCodeMandatoryExtensionMissing),
            @"NSURLSessionWebSocketCloseCodeInternalServerError":P(NSURLSessionWebSocketCloseCodeInternalServerError),
            @"NSURLSessionWebSocketCloseCodeTLSHandshakeFailure":P(NSURLSessionWebSocketCloseCodeTLSHandshakeFailure),
//   NSURLSessionMultipathServiceType
            @"NSURLSessionMultipathServiceTypeNone":P(NSURLSessionMultipathServiceTypeNone),
            @"NSURLSessionMultipathServiceTypeHandover":P(NSURLSessionMultipathServiceTypeHandover),
            @"NSURLSessionMultipathServiceTypeInteractive":P(NSURLSessionMultipathServiceTypeInteractive),
            @"NSURLSessionMultipathServiceTypeAggregate":P(NSURLSessionMultipathServiceTypeAggregate),
//   NSURLSessionDelayedRequestDisposition
            @"NSURLSessionDelayedRequestContinueLoading":P(NSURLSessionDelayedRequestContinueLoading),
            @"NSURLSessionDelayedRequestUseNewRequest":P(NSURLSessionDelayedRequestUseNewRequest),
            @"NSURLSessionDelayedRequestCancel":P(NSURLSessionDelayedRequestCancel),
//   NSURLSessionAuthChallengeDisposition
            @"NSURLSessionAuthChallengeUseCredential":P(NSURLSessionAuthChallengeUseCredential),
            @"NSURLSessionAuthChallengePerformDefaultHandling":P(NSURLSessionAuthChallengePerformDefaultHandling),
            @"NSURLSessionAuthChallengeCancelAuthenticationChallenge":P(NSURLSessionAuthChallengeCancelAuthenticationChallenge),
            @"NSURLSessionAuthChallengeRejectProtectionSpace":P(NSURLSessionAuthChallengeRejectProtectionSpace),
//   NSURLSessionResponseDisposition
            @"NSURLSessionResponseCancel":P(NSURLSessionResponseCancel),
            @"NSURLSessionResponseAllow":P(NSURLSessionResponseAllow),
            @"NSURLSessionResponseBecomeDownload":P(NSURLSessionResponseBecomeDownload),
            @"NSURLSessionResponseBecomeStream":P(NSURLSessionResponseBecomeStream),
//   NSURLSessionTaskMetricsResourceFetchType
            @"NSURLSessionTaskMetricsResourceFetchTypeUnknown":P(NSURLSessionTaskMetricsResourceFetchTypeUnknown),
            @"NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad":P(NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad),
            @"NSURLSessionTaskMetricsResourceFetchTypeServerPush":P(NSURLSessionTaskMetricsResourceFetchTypeServerPush),
            @"NSURLSessionTaskMetricsResourceFetchTypeLocalCache":P(NSURLSessionTaskMetricsResourceFetchTypeLocalCache),
//   NSURLSessionTaskMetricsDomainResolutionProtocol
            @"NSURLSessionTaskMetricsDomainResolutionProtocolUnknown":P(NSURLSessionTaskMetricsDomainResolutionProtocolUnknown),
            @"NSURLSessionTaskMetricsDomainResolutionProtocolUDP":P(NSURLSessionTaskMetricsDomainResolutionProtocolUDP),
            @"NSURLSessionTaskMetricsDomainResolutionProtocolTCP":P(NSURLSessionTaskMetricsDomainResolutionProtocolTCP),
            @"NSURLSessionTaskMetricsDomainResolutionProtocolTLS":P(NSURLSessionTaskMetricsDomainResolutionProtocolTLS),
            @"NSURLSessionTaskMetricsDomainResolutionProtocolHTTPS":P(NSURLSessionTaskMetricsDomainResolutionProtocolHTTPS),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSOperation.h
//   NSOperationQueuePriority
            @"NSOperationQueuePriorityVeryLow":P(NSOperationQueuePriorityVeryLow),
            @"NSOperationQueuePriorityLow":P(NSOperationQueuePriorityLow),
            @"NSOperationQueuePriorityNormal":P(NSOperationQueuePriorityNormal),
            @"NSOperationQueuePriorityHigh":P(NSOperationQueuePriorityHigh),
            @"NSOperationQueuePriorityVeryHigh":P(NSOperationQueuePriorityVeryHigh),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSNetServices.h
//   NSNetServicesError
//   NSNetServiceOptions

//   Enum definitions in ./enum_gen/Foundation/Headers/NSURLRequest.h
//   NSURLRequestCachePolicy
            @"NSURLRequestUseProtocolCachePolicy":P(NSURLRequestUseProtocolCachePolicy),
            @"NSURLRequestReloadIgnoringLocalCacheData":P(NSURLRequestReloadIgnoringLocalCacheData),
            @"NSURLRequestReloadIgnoringLocalAndRemoteCacheData":P(NSURLRequestReloadIgnoringLocalAndRemoteCacheData),
            @"NSURLRequestReloadIgnoringCacheData":P(NSURLRequestReloadIgnoringCacheData),
            @"NSURLRequestReturnCacheDataElseLoad":P(NSURLRequestReturnCacheDataElseLoad),
            @"NSURLRequestReturnCacheDataDontLoad":P(NSURLRequestReturnCacheDataDontLoad),
            @"NSURLRequestReloadRevalidatingCacheData":P(NSURLRequestReloadRevalidatingCacheData),
//   NSURLRequestNetworkServiceType
            @"NSURLNetworkServiceTypeDefault":P(NSURLNetworkServiceTypeDefault),
            @"NSURLNetworkServiceTypeVoIP":P(NSURLNetworkServiceTypeVoIP),
            @"NSURLNetworkServiceTypeVideo":P(NSURLNetworkServiceTypeVideo),
            @"NSURLNetworkServiceTypeBackground":P(NSURLNetworkServiceTypeBackground),
            @"NSURLNetworkServiceTypeVoice":P(NSURLNetworkServiceTypeVoice),
            @"NSURLNetworkServiceTypeResponsiveData":P(NSURLNetworkServiceTypeResponsiveData),
            @"NSURLNetworkServiceTypeAVStreaming":P(NSURLNetworkServiceTypeAVStreaming),
            @"NSURLNetworkServiceTypeResponsiveAV":P(NSURLNetworkServiceTypeResponsiveAV),
            @"NSURLNetworkServiceTypeCallSignaling":P(NSURLNetworkServiceTypeCallSignaling),
//   NSURLRequestAttribution
            @"NSURLRequestAttributionDeveloper":P(NSURLRequestAttributionDeveloper),
            @"NSURLRequestAttributionUser":P(NSURLRequestAttributionUser),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSExpression.h
//   NSExpressionType
            @"NSConstantValueExpressionType":P(NSConstantValueExpressionType),
            @"NSEvaluatedObjectExpressionType":P(NSEvaluatedObjectExpressionType),
            @"NSVariableExpressionType":P(NSVariableExpressionType),
            @"NSKeyPathExpressionType":P(NSKeyPathExpressionType),
            @"NSFunctionExpressionType":P(NSFunctionExpressionType),
            @"NSUnionSetExpressionType":P(NSUnionSetExpressionType),
            @"NSIntersectSetExpressionType":P(NSIntersectSetExpressionType),
            @"NSMinusSetExpressionType":P(NSMinusSetExpressionType),
            @"NSSubqueryExpressionType":P(NSSubqueryExpressionType),
            @"NSAggregateExpressionType":P(NSAggregateExpressionType),
            @"NSAnyKeyExpressionType":P(NSAnyKeyExpressionType),
            @"NSBlockExpressionType":P(NSBlockExpressionType),
            @"NSConditionalExpressionType":P(NSConditionalExpressionType),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSCoder.h
//   NSDecodingFailurePolicy
            @"NSDecodingFailurePolicyRaiseException":P(NSDecodingFailurePolicyRaiseException),
            @"NSDecodingFailurePolicySetErrorAndReturn":P(NSDecodingFailurePolicySetErrorAndReturn),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSByteCountFormatter.h
//   NSByteCountFormatterUnits
            @"NSByteCountFormatterUseDefault":P(NSByteCountFormatterUseDefault),
            @"NSByteCountFormatterUseBytes":P(NSByteCountFormatterUseBytes),
            @"NSByteCountFormatterUseKB":P(NSByteCountFormatterUseKB),
            @"NSByteCountFormatterUseMB":P(NSByteCountFormatterUseMB),
            @"NSByteCountFormatterUseGB":P(NSByteCountFormatterUseGB),
            @"NSByteCountFormatterUseTB":P(NSByteCountFormatterUseTB),
            @"NSByteCountFormatterUsePB":P(NSByteCountFormatterUsePB),
            @"NSByteCountFormatterUseEB":P(NSByteCountFormatterUseEB),
            @"NSByteCountFormatterUseZB":P(NSByteCountFormatterUseZB),
            @"NSByteCountFormatterUseYBOrHigher":P(NSByteCountFormatterUseYBOrHigher),
            @"NSByteCountFormatterUseAll":P(NSByteCountFormatterUseAll),
//   NSByteCountFormatterCountStyle
            @"NSByteCountFormatterCountStyleFile":P(NSByteCountFormatterCountStyleFile),
            @"NSByteCountFormatterCountStyleMemory":P(NSByteCountFormatterCountStyleMemory),
            @"NSByteCountFormatterCountStyleDecimal":P(NSByteCountFormatterCountStyleDecimal),
            @"NSByteCountFormatterCountStyleBinary":P(NSByteCountFormatterCountStyleBinary),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSLengthFormatter.h
//   NSLengthFormatterUnit
            @"NSLengthFormatterUnitMillimeter":P(NSLengthFormatterUnitMillimeter),
            @"NSLengthFormatterUnitCentimeter":P(NSLengthFormatterUnitCentimeter),
            @"NSLengthFormatterUnitMeter":P(NSLengthFormatterUnitMeter),
            @"NSLengthFormatterUnitKilometer":P(NSLengthFormatterUnitKilometer),
            @"NSLengthFormatterUnitInch":P(NSLengthFormatterUnitInch),
            @"NSLengthFormatterUnitFoot":P(NSLengthFormatterUnitFoot),
            @"NSLengthFormatterUnitYard":P(NSLengthFormatterUnitYard),
            @"NSLengthFormatterUnitMile":P(NSLengthFormatterUnitMile),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSObjCRuntime.h
//   NSComparisonResult
//   NSComparisonResult
            @"NSOrderedAscending":P(NSOrderedAscending),
            @"NSOrderedSame":P(NSOrderedSame),
            @"NSOrderedDescending":P(NSOrderedDescending),
//   NSEnumerationOptions
            @"NSEnumerationConcurrent":P(NSEnumerationConcurrent),
            @"NSEnumerationReverse":P(NSEnumerationReverse),
//   NSSortOptions
            @"NSSortConcurrent":P(NSSortConcurrent),
            @"NSSortStable":P(NSSortStable),
//   NSQualityOfService
            @"NSQualityOfServiceUserInteractive":P(NSQualityOfServiceUserInteractive),
            @"NSQualityOfServiceUserInitiated":P(NSQualityOfServiceUserInitiated),
            @"NSQualityOfServiceUtility":P(NSQualityOfServiceUtility),
            @"NSQualityOfServiceBackground":P(NSQualityOfServiceBackground),
            @"NSQualityOfServiceDefault":P(NSQualityOfServiceDefault),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSComparisonPredicate.h
//   NSComparisonPredicateOptions
            @"NSCaseInsensitivePredicateOption":P(NSCaseInsensitivePredicateOption),
            @"NSDiacriticInsensitivePredicateOption":P(NSDiacriticInsensitivePredicateOption),
            @"NSNormalizedPredicateOption":P(NSNormalizedPredicateOption),
//   NSComparisonPredicateModifier
            @"NSDirectPredicateModifier":P(NSDirectPredicateModifier),
            @"NSAllPredicateModifier":P(NSAllPredicateModifier),
            @"NSAnyPredicateModifier":P(NSAnyPredicateModifier),
//   NSPredicateOperatorType
            @"NSLessThanPredicateOperatorType":P(NSLessThanPredicateOperatorType),
            @"NSLessThanOrEqualToPredicateOperatorType":P(NSLessThanOrEqualToPredicateOperatorType),
            @"NSGreaterThanPredicateOperatorType":P(NSGreaterThanPredicateOperatorType),
            @"NSGreaterThanOrEqualToPredicateOperatorType":P(NSGreaterThanOrEqualToPredicateOperatorType),
            @"NSEqualToPredicateOperatorType":P(NSEqualToPredicateOperatorType),
            @"NSNotEqualToPredicateOperatorType":P(NSNotEqualToPredicateOperatorType),
            @"NSMatchesPredicateOperatorType":P(NSMatchesPredicateOperatorType),
            @"NSLikePredicateOperatorType":P(NSLikePredicateOperatorType),
            @"NSBeginsWithPredicateOperatorType":P(NSBeginsWithPredicateOperatorType),
            @"NSEndsWithPredicateOperatorType":P(NSEndsWithPredicateOperatorType),
            @"NSInPredicateOperatorType":P(NSInPredicateOperatorType),
            @"NSCustomSelectorPredicateOperatorType":P(NSCustomSelectorPredicateOperatorType),
            @"NSContainsPredicateOperatorType":P(NSContainsPredicateOperatorType),
            @"NSBetweenPredicateOperatorType":P(NSBetweenPredicateOperatorType),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSFileWrapper.h
//   NSFileWrapperReadingOptions
//   NSFileWrapperWritingOptions

//   Enum definitions in ./enum_gen/Foundation/Headers/NSISO8601DateFormatter.h
//   NSISO8601DateFormatOptions

//   Enum definitions in ./enum_gen/Foundation/Headers/NSDateIntervalFormatter.h
//   NSDateIntervalFormatterStyle
            @"NSDateIntervalFormatterNoStyle":P(NSDateIntervalFormatterNoStyle),
            @"NSDateIntervalFormatterShortStyle":P(NSDateIntervalFormatterShortStyle),
            @"NSDateIntervalFormatterMediumStyle":P(NSDateIntervalFormatterMediumStyle),
            @"NSDateIntervalFormatterLongStyle":P(NSDateIntervalFormatterLongStyle),
            @"NSDateIntervalFormatterFullStyle":P(NSDateIntervalFormatterFullStyle),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSURLCache.h
//   NSURLCacheStoragePolicy
            @"NSURLCacheStorageAllowed":P(NSURLCacheStorageAllowed),
            @"NSURLCacheStorageAllowedInMemoryOnly":P(NSURLCacheStorageAllowedInMemoryOnly),
            @"NSURLCacheStorageNotAllowed":P(NSURLCacheStorageNotAllowed),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSDateComponentsFormatter.h
//   NSDateComponentsFormatterUnitsStyle
            @"NSDateComponentsFormatterUnitsStylePositional":P(NSDateComponentsFormatterUnitsStylePositional),
            @"NSDateComponentsFormatterUnitsStyleAbbreviated":P(NSDateComponentsFormatterUnitsStyleAbbreviated),
            @"NSDateComponentsFormatterUnitsStyleShort":P(NSDateComponentsFormatterUnitsStyleShort),
            @"NSDateComponentsFormatterUnitsStyleFull":P(NSDateComponentsFormatterUnitsStyleFull),
            @"NSDateComponentsFormatterUnitsStyleSpellOut":P(NSDateComponentsFormatterUnitsStyleSpellOut),
            @"NSDateComponentsFormatterUnitsStyleBrief":P(NSDateComponentsFormatterUnitsStyleBrief),
//   NSDateComponentsFormatterZeroFormattingBehavior
            @"NSDateComponentsFormatterZeroFormattingBehaviorNone":P(NSDateComponentsFormatterZeroFormattingBehaviorNone),
            @"NSDateComponentsFormatterZeroFormattingBehaviorDefault":P(NSDateComponentsFormatterZeroFormattingBehaviorDefault),
            @"NSDateComponentsFormatterZeroFormattingBehaviorDropLeading":P(NSDateComponentsFormatterZeroFormattingBehaviorDropLeading),
            @"NSDateComponentsFormatterZeroFormattingBehaviorDropMiddle":P(NSDateComponentsFormatterZeroFormattingBehaviorDropMiddle),
            @"NSDateComponentsFormatterZeroFormattingBehaviorDropTrailing":P(NSDateComponentsFormatterZeroFormattingBehaviorDropTrailing),
            @"NSDateComponentsFormatterZeroFormattingBehaviorDropAll":P(NSDateComponentsFormatterZeroFormattingBehaviorDropAll),
            @"NSDateComponentsFormatterZeroFormattingBehaviorPad":P(NSDateComponentsFormatterZeroFormattingBehaviorPad),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSDateFormatter.h
//   NSDateFormatterStyle
            @"NSDateFormatterNoStyle":P(NSDateFormatterNoStyle),
            @"NSDateFormatterShortStyle":P(NSDateFormatterShortStyle),
            @"NSDateFormatterMediumStyle":P(NSDateFormatterMediumStyle),
            @"NSDateFormatterLongStyle":P(NSDateFormatterLongStyle),
            @"NSDateFormatterFullStyle":P(NSDateFormatterFullStyle),
//   NSDateFormatterBehavior
            @"NSDateFormatterBehaviorDefault":P(NSDateFormatterBehaviorDefault),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSTextCheckingResult.h
//   NSTextCheckingType
            @"NSTextCheckingTypeOrthography":P(NSTextCheckingTypeOrthography),
            @"NSTextCheckingTypeSpelling":P(NSTextCheckingTypeSpelling),
            @"NSTextCheckingTypeGrammar":P(NSTextCheckingTypeGrammar),
            @"NSTextCheckingTypeDate":P(NSTextCheckingTypeDate),
            @"NSTextCheckingTypeAddress":P(NSTextCheckingTypeAddress),
            @"NSTextCheckingTypeLink":P(NSTextCheckingTypeLink),
            @"NSTextCheckingTypeQuote":P(NSTextCheckingTypeQuote),
            @"NSTextCheckingTypeDash":P(NSTextCheckingTypeDash),
            @"NSTextCheckingTypeReplacement":P(NSTextCheckingTypeReplacement),
            @"NSTextCheckingTypeCorrection":P(NSTextCheckingTypeCorrection),
            @"NSTextCheckingTypeRegularExpression":P(NSTextCheckingTypeRegularExpression),
            @"NSTextCheckingTypePhoneNumber":P(NSTextCheckingTypePhoneNumber),
            @"NSTextCheckingTypeTransitInformation":P(NSTextCheckingTypeTransitInformation),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSStream.h
//   NSStreamStatus
            @"NSStreamStatusNotOpen":P(NSStreamStatusNotOpen),
            @"NSStreamStatusOpening":P(NSStreamStatusOpening),
            @"NSStreamStatusOpen":P(NSStreamStatusOpen),
            @"NSStreamStatusReading":P(NSStreamStatusReading),
            @"NSStreamStatusWriting":P(NSStreamStatusWriting),
            @"NSStreamStatusAtEnd":P(NSStreamStatusAtEnd),
            @"NSStreamStatusClosed":P(NSStreamStatusClosed),
            @"NSStreamStatusError":P(NSStreamStatusError),
//   NSStreamEvent
            @"NSStreamEventNone":P(NSStreamEventNone),
            @"NSStreamEventOpenCompleted":P(NSStreamEventOpenCompleted),
            @"NSStreamEventHasBytesAvailable":P(NSStreamEventHasBytesAvailable),
            @"NSStreamEventHasSpaceAvailable":P(NSStreamEventHasSpaceAvailable),
            @"NSStreamEventErrorOccurred":P(NSStreamEventErrorOccurred),
            @"NSStreamEventEndEncountered":P(NSStreamEventEndEncountered),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSArray.h
//   NSBinarySearchingOptions
            @"NSBinarySearchingFirstEqual":P(NSBinarySearchingFirstEqual),
            @"NSBinarySearchingLastEqual":P(NSBinarySearchingLastEqual),
            @"NSBinarySearchingInsertionIndex":P(NSBinarySearchingInsertionIndex),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSPort.h
//   NSMachPortOptions
            @"NSMachPortDeallocateNone":P(NSMachPortDeallocateNone),
            @"NSMachPortDeallocateSendRight":P(NSMachPortDeallocateSendRight),
            @"NSMachPortDeallocateReceiveRight":P(NSMachPortDeallocateReceiveRight),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSFileManager.h
//   NSVolumeEnumerationOptions
//   NSDirectoryEnumerationOptions
//   NSFileManagerItemReplacementOptions
//   NSURLRelationship
            @"NSURLRelationshipContains":P(NSURLRelationshipContains),
            @"NSURLRelationshipSame":P(NSURLRelationshipSame),
            @"NSURLRelationshipOther":P(NSURLRelationshipOther),
//   NSFileManagerUnmountOptions

//   Enum definitions in ./enum_gen/Foundation/Headers/NSMeasurementFormatter.h
//   NSMeasurementFormatterUnitOptions
            @"NSMeasurementFormatterUnitOptionsProvidedUnit":P(NSMeasurementFormatterUnitOptionsProvidedUnit),
            @"NSMeasurementFormatterUnitOptionsNaturalScale":P(NSMeasurementFormatterUnitOptionsNaturalScale),
            @"NSMeasurementFormatterUnitOptionsTemperatureWithoutUnit":P(NSMeasurementFormatterUnitOptionsTemperatureWithoutUnit),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSPersonNameComponentsFormatter.h
//   NSPersonNameComponentsFormatterStyle
            @"NSPersonNameComponentsFormatterStyleDefault":P(NSPersonNameComponentsFormatterStyleDefault),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSNotificationQueue.h
//   NSPostingStyle
            @"NSPostWhenIdle":P(NSPostWhenIdle),
            @"NSPostASAP":P(NSPostASAP),
            @"NSPostNow":P(NSPostNow),
//   NSNotificationCoalescing
            @"NSNotificationNoCoalescing":P(NSNotificationNoCoalescing),
            @"NSNotificationCoalescingOnName":P(NSNotificationCoalescingOnName),
            @"NSNotificationCoalescingOnSender":P(NSNotificationCoalescingOnSender),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSURLCredential.h
//   NSURLCredentialPersistence
            @"NSURLCredentialPersistenceNone":P(NSURLCredentialPersistenceNone),
            @"NSURLCredentialPersistenceForSession":P(NSURLCredentialPersistenceForSession),
            @"NSURLCredentialPersistencePermanent":P(NSURLCredentialPersistencePermanent),
            @"NSURLCredentialPersistenceSynchronizable":P(NSURLCredentialPersistenceSynchronizable),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSFileCoordinator.h
//   NSFileCoordinatorReadingOptions
//   NSFileCoordinatorWritingOptions

//   Enum definitions in ./enum_gen/Foundation/Headers/NSTimeZone.h
//   NSTimeZoneNameStyle
            @"NSTimeZoneNameStyleStandard":P(NSTimeZoneNameStyleStandard),
            @"NSTimeZoneNameStyleShortStandard":P(NSTimeZoneNameStyleShortStandard),
            @"NSTimeZoneNameStyleDaylightSaving":P(NSTimeZoneNameStyleDaylightSaving),
            @"NSTimeZoneNameStyleShortDaylightSaving":P(NSTimeZoneNameStyleShortDaylightSaving),
            @"NSTimeZoneNameStyleGeneric":P(NSTimeZoneNameStyleGeneric),
            @"NSTimeZoneNameStyleShortGeneric":P(NSTimeZoneNameStyleShortGeneric),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSOrderedCollectionChange.h
//   NSCollectionChangeType
            @"NSCollectionChangeInsert":P(NSCollectionChangeInsert),
            @"NSCollectionChangeRemove":P(NSCollectionChangeRemove),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSFormatter.h
//   NSFormattingContext
            @"NSFormattingContextUnknown":P(NSFormattingContextUnknown),
            @"NSFormattingContextDynamic":P(NSFormattingContextDynamic),
            @"NSFormattingContextStandalone":P(NSFormattingContextStandalone),
            @"NSFormattingContextListItem":P(NSFormattingContextListItem),
            @"NSFormattingContextBeginningOfSentence":P(NSFormattingContextBeginningOfSentence),
            @"NSFormattingContextMiddleOfSentence":P(NSFormattingContextMiddleOfSentence),
//   NSFormattingUnitStyle
            @"NSFormattingUnitStyleShort":P(NSFormattingUnitStyleShort),
            @"NSFormattingUnitStyleMedium":P(NSFormattingUnitStyleMedium),
            @"NSFormattingUnitStyleLong":P(NSFormattingUnitStyleLong),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSLinguisticTagger.h
//   NSLinguisticTaggerUnit
            @"NSLinguisticTaggerUnitWord":P(NSLinguisticTaggerUnitWord),
            @"NSLinguisticTaggerUnitSentence":P(NSLinguisticTaggerUnitSentence),
            @"NSLinguisticTaggerUnitParagraph":P(NSLinguisticTaggerUnitParagraph),
            @"NSLinguisticTaggerUnitDocument":P(NSLinguisticTaggerUnitDocument),
//   NSLinguisticTaggerOptions
            @"NSLinguisticTaggerOmitWords":P(NSLinguisticTaggerOmitWords),
            @"NSLinguisticTaggerOmitPunctuation":P(NSLinguisticTaggerOmitPunctuation),
            @"NSLinguisticTaggerOmitWhitespace":P(NSLinguisticTaggerOmitWhitespace),
            @"NSLinguisticTaggerOmitOther":P(NSLinguisticTaggerOmitOther),
            @"NSLinguisticTaggerJoinNames":P(NSLinguisticTaggerJoinNames),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSXPCConnection.h
//   NSXPCConnectionOptions
            @"NSXPCConnectionPrivileged":P(NSXPCConnectionPrivileged),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSItemProvider.h
//   NSItemProviderRepresentationVisibility
            @"NSItemProviderRepresentationVisibilityAll":P(NSItemProviderRepresentationVisibilityAll),
            @"NSItemProviderRepresentationVisibilityTeam":P(NSItemProviderRepresentationVisibilityTeam),
            @"NSItemProviderRepresentationVisibilityOwnProcess":P(NSItemProviderRepresentationVisibilityOwnProcess),
//   NSItemProviderFileOptions
            @"NSItemProviderFileOptionOpenInPlace":P(NSItemProviderFileOptionOpenInPlace),
//   NSItemProviderErrorCode
            @"NSItemProviderUnknownError":P(NSItemProviderUnknownError),
            @"NSItemProviderItemUnavailableError":P(NSItemProviderItemUnavailableError),
            @"NSItemProviderUnexpectedValueClassError":P(NSItemProviderUnexpectedValueClassError),
            @"NSItemProviderUnavailableCoercionError":P(NSItemProviderUnavailableCoercionError),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSCompoundPredicate.h
//   NSCompoundPredicateType
            @"NSNotPredicateType":P(NSNotPredicateType),
            @"NSAndPredicateType":P(NSAndPredicateType),
            @"NSOrPredicateType":P(NSOrPredicateType),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSMorphology.h
//   NSGrammaticalGender
            @"NSGrammaticalGenderNotSet":P(NSGrammaticalGenderNotSet),
            @"NSGrammaticalGenderFeminine":P(NSGrammaticalGenderFeminine),
            @"NSGrammaticalGenderMasculine":P(NSGrammaticalGenderMasculine),
            @"NSGrammaticalGenderNeuter":P(NSGrammaticalGenderNeuter),
//   NSGrammaticalPartOfSpeech
            @"NSGrammaticalPartOfSpeechNotSet":P(NSGrammaticalPartOfSpeechNotSet),
            @"NSGrammaticalPartOfSpeechDeterminer":P(NSGrammaticalPartOfSpeechDeterminer),
            @"NSGrammaticalPartOfSpeechPronoun":P(NSGrammaticalPartOfSpeechPronoun),
            @"NSGrammaticalPartOfSpeechLetter":P(NSGrammaticalPartOfSpeechLetter),
            @"NSGrammaticalPartOfSpeechAdverb":P(NSGrammaticalPartOfSpeechAdverb),
            @"NSGrammaticalPartOfSpeechParticle":P(NSGrammaticalPartOfSpeechParticle),
            @"NSGrammaticalPartOfSpeechAdjective":P(NSGrammaticalPartOfSpeechAdjective),
            @"NSGrammaticalPartOfSpeechAdposition":P(NSGrammaticalPartOfSpeechAdposition),
            @"NSGrammaticalPartOfSpeechVerb":P(NSGrammaticalPartOfSpeechVerb),
            @"NSGrammaticalPartOfSpeechNoun":P(NSGrammaticalPartOfSpeechNoun),
            @"NSGrammaticalPartOfSpeechConjunction":P(NSGrammaticalPartOfSpeechConjunction),
            @"NSGrammaticalPartOfSpeechNumeral":P(NSGrammaticalPartOfSpeechNumeral),
            @"NSGrammaticalPartOfSpeechInterjection":P(NSGrammaticalPartOfSpeechInterjection),
            @"NSGrammaticalPartOfSpeechPreposition":P(NSGrammaticalPartOfSpeechPreposition),
            @"NSGrammaticalPartOfSpeechAbbreviation":P(NSGrammaticalPartOfSpeechAbbreviation),
//   NSGrammaticalNumber
            @"NSGrammaticalNumberNotSet":P(NSGrammaticalNumberNotSet),
            @"NSGrammaticalNumberSingular":P(NSGrammaticalNumberSingular),
            @"NSGrammaticalNumberZero":P(NSGrammaticalNumberZero),
            @"NSGrammaticalNumberPlural":P(NSGrammaticalNumberPlural),
            @"NSGrammaticalNumberPluralTwo":P(NSGrammaticalNumberPluralTwo),
            @"NSGrammaticalNumberPluralFew":P(NSGrammaticalNumberPluralFew),
            @"NSGrammaticalNumberPluralMany":P(NSGrammaticalNumberPluralMany),
//   NSGrammaticalCase
            @"NSGrammaticalCaseNotSet":P(NSGrammaticalCaseNotSet),
            @"NSGrammaticalCaseNominative":P(NSGrammaticalCaseNominative),
            @"NSGrammaticalCaseAccusative":P(NSGrammaticalCaseAccusative),
            @"NSGrammaticalCaseDative":P(NSGrammaticalCaseDative),
            @"NSGrammaticalCaseGenitive":P(NSGrammaticalCaseGenitive),
            @"NSGrammaticalCasePrepositional":P(NSGrammaticalCasePrepositional),
            @"NSGrammaticalCaseAblative":P(NSGrammaticalCaseAblative),
            @"NSGrammaticalCaseAdessive":P(NSGrammaticalCaseAdessive),
            @"NSGrammaticalCaseAllative":P(NSGrammaticalCaseAllative),
            @"NSGrammaticalCaseElative":P(NSGrammaticalCaseElative),
            @"NSGrammaticalCaseIllative":P(NSGrammaticalCaseIllative),
            @"NSGrammaticalCaseEssive":P(NSGrammaticalCaseEssive),
            @"NSGrammaticalCaseInessive":P(NSGrammaticalCaseInessive),
            @"NSGrammaticalCaseLocative":P(NSGrammaticalCaseLocative),
            @"NSGrammaticalCaseTranslative":P(NSGrammaticalCaseTranslative),
//   NSGrammaticalPronounType
            @"NSGrammaticalPronounTypeNotSet":P(NSGrammaticalPronounTypeNotSet),
            @"NSGrammaticalPronounTypePersonal":P(NSGrammaticalPronounTypePersonal),
            @"NSGrammaticalPronounTypeReflexive":P(NSGrammaticalPronounTypeReflexive),
            @"NSGrammaticalPronounTypePossessive":P(NSGrammaticalPronounTypePossessive),
//   NSGrammaticalPerson
            @"NSGrammaticalPersonNotSet":P(NSGrammaticalPersonNotSet),
            @"NSGrammaticalPersonFirst":P(NSGrammaticalPersonFirst),
            @"NSGrammaticalPersonSecond":P(NSGrammaticalPersonSecond),
            @"NSGrammaticalPersonThird":P(NSGrammaticalPersonThird),
//   NSGrammaticalDetermination
            @"NSGrammaticalDeterminationNotSet":P(NSGrammaticalDeterminationNotSet),
            @"NSGrammaticalDeterminationIndependent":P(NSGrammaticalDeterminationIndependent),
            @"NSGrammaticalDeterminationDependent":P(NSGrammaticalDeterminationDependent),
//   NSGrammaticalDefiniteness
            @"NSGrammaticalDefinitenessNotSet":P(NSGrammaticalDefinitenessNotSet),
            @"NSGrammaticalDefinitenessIndefinite":P(NSGrammaticalDefinitenessIndefinite),
            @"NSGrammaticalDefinitenessDefinite":P(NSGrammaticalDefinitenessDefinite),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSJSONSerialization.h
//   NSJSONReadingOptions
            @"NSJSONReadingMutableContainers":P(NSJSONReadingMutableContainers),
            @"NSJSONReadingMutableLeaves":P(NSJSONReadingMutableLeaves),
            @"NSJSONReadingFragmentsAllowed":P(NSJSONReadingFragmentsAllowed),
            @"NSJSONReadingTopLevelDictionaryAssumed":P(NSJSONReadingTopLevelDictionaryAssumed),
            @"NSJSONReadingAllowFragments":P(NSJSONReadingAllowFragments),
//   NSJSONWritingOptions
            @"NSJSONWritingPrettyPrinted":P(NSJSONWritingPrettyPrinted),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSEnergyFormatter.h
//   NSEnergyFormatterUnit
            @"NSEnergyFormatterUnitJoule":P(NSEnergyFormatterUnitJoule),
            @"NSEnergyFormatterUnitKilojoule":P(NSEnergyFormatterUnitKilojoule),
            @"NSEnergyFormatterUnitCalorie":P(NSEnergyFormatterUnitCalorie),
            @"NSEnergyFormatterUnitKilocalorie":P(NSEnergyFormatterUnitKilocalorie),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSPathUtilities.h
//   NSSearchPathDirectory
            @"NSApplicationDirectory":P(NSApplicationDirectory),
            @"NSDemoApplicationDirectory":P(NSDemoApplicationDirectory),
            @"NSDeveloperApplicationDirectory":P(NSDeveloperApplicationDirectory),
            @"NSAdminApplicationDirectory":P(NSAdminApplicationDirectory),
            @"NSLibraryDirectory":P(NSLibraryDirectory),
            @"NSDeveloperDirectory":P(NSDeveloperDirectory),
            @"NSUserDirectory":P(NSUserDirectory),
            @"NSDocumentationDirectory":P(NSDocumentationDirectory),
            @"NSDocumentDirectory":P(NSDocumentDirectory),
            @"NSCoreServiceDirectory":P(NSCoreServiceDirectory),
            @"NSAutosavedInformationDirectory":P(NSAutosavedInformationDirectory),
            @"NSDesktopDirectory":P(NSDesktopDirectory),
            @"NSCachesDirectory":P(NSCachesDirectory),
            @"NSApplicationSupportDirectory":P(NSApplicationSupportDirectory),
            @"NSDownloadsDirectory":P(NSDownloadsDirectory),
            @"NSInputMethodsDirectory":P(NSInputMethodsDirectory),
            @"NSMoviesDirectory":P(NSMoviesDirectory),
            @"NSMusicDirectory":P(NSMusicDirectory),
            @"NSPicturesDirectory":P(NSPicturesDirectory),
            @"NSPrinterDescriptionDirectory":P(NSPrinterDescriptionDirectory),
            @"NSSharedPublicDirectory":P(NSSharedPublicDirectory),
            @"NSPreferencePanesDirectory":P(NSPreferencePanesDirectory),
            @"NSItemReplacementDirectory":P(NSItemReplacementDirectory),
            @"NSAllApplicationsDirectory":P(NSAllApplicationsDirectory),
            @"NSAllLibrariesDirectory":P(NSAllLibrariesDirectory),
            @"NSTrashDirectory":P(NSTrashDirectory),
//   NSSearchPathDomainMask
            @"NSUserDomainMask":P(NSUserDomainMask),
            @"NSLocalDomainMask":P(NSLocalDomainMask),
            @"NSNetworkDomainMask":P(NSNetworkDomainMask),
            @"NSSystemDomainMask":P(NSSystemDomainMask),
            @"NSAllDomainsMask":P(NSAllDomainsMask),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSCalendar.h
//   NSCalendarUnit
            @"NSCalendarUnitEra":P(NSCalendarUnitEra),
            @"NSCalendarUnitYear":P(NSCalendarUnitYear),
            @"NSCalendarUnitMonth":P(NSCalendarUnitMonth),
            @"NSCalendarUnitDay":P(NSCalendarUnitDay),
            @"NSCalendarUnitHour":P(NSCalendarUnitHour),
            @"NSCalendarUnitMinute":P(NSCalendarUnitMinute),
            @"NSCalendarUnitSecond":P(NSCalendarUnitSecond),
            @"NSCalendarUnitWeekday":P(NSCalendarUnitWeekday),
            @"NSCalendarUnitWeekdayOrdinal":P(NSCalendarUnitWeekdayOrdinal),
            @"NSCalendarUnitQuarter":P(NSCalendarUnitQuarter),
            @"NSCalendarUnitWeekOfMonth":P(NSCalendarUnitWeekOfMonth),
            @"NSCalendarUnitWeekOfYear":P(NSCalendarUnitWeekOfYear),
            @"NSCalendarUnitYearForWeekOfYear":P(NSCalendarUnitYearForWeekOfYear),
            @"NSCalendarUnitNanosecond":P(NSCalendarUnitNanosecond),
            @"NSCalendarUnitCalendar":P(NSCalendarUnitCalendar),
            @"NSCalendarUnitTimeZone":P(NSCalendarUnitTimeZone),
            @"NSEraCalendarUnit":P(NSEraCalendarUnit),
            @"NSYearCalendarUnit":P(NSYearCalendarUnit),
            @"NSMonthCalendarUnit":P(NSMonthCalendarUnit),
            @"NSDayCalendarUnit":P(NSDayCalendarUnit),
            @"NSHourCalendarUnit":P(NSHourCalendarUnit),
            @"NSMinuteCalendarUnit":P(NSMinuteCalendarUnit),
            @"NSSecondCalendarUnit":P(NSSecondCalendarUnit),
            @"NSWeekCalendarUnit":P(NSWeekCalendarUnit),
            @"NSWeekdayCalendarUnit":P(NSWeekdayCalendarUnit),
            @"NSWeekdayOrdinalCalendarUnit":P(NSWeekdayOrdinalCalendarUnit),
            @"NSQuarterCalendarUnit":P(NSQuarterCalendarUnit),
            @"NSWeekOfMonthCalendarUnit":P(NSWeekOfMonthCalendarUnit),
            @"NSWeekOfYearCalendarUnit":P(NSWeekOfYearCalendarUnit),
            @"NSYearForWeekOfYearCalendarUnit":P(NSYearForWeekOfYearCalendarUnit),
            @"NSCalendarCalendarUnit":P(NSCalendarCalendarUnit),
            @"NSTimeZoneCalendarUnit":P(NSTimeZoneCalendarUnit),
//   NSCalendarOptions
            @"NSCalendarWrapComponents":P(NSCalendarWrapComponents),
            @"NSCalendarMatchStrictly":P(NSCalendarMatchStrictly),
            @"NSCalendarSearchBackwards":P(NSCalendarSearchBackwards),
            @"NSCalendarMatchPreviousTimePreservingSmallerUnits":P(NSCalendarMatchPreviousTimePreservingSmallerUnits),
            @"NSCalendarMatchNextTimePreservingSmallerUnits":P(NSCalendarMatchNextTimePreservingSmallerUnits),
            @"NSCalendarMatchNextTime":P(NSCalendarMatchNextTime),
            @"NSCalendarMatchFirst":P(NSCalendarMatchFirst),
            @"NSCalendarMatchLast":P(NSCalendarMatchLast),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSKeyValueObserving.h
//   NSKeyValueObservingOptions
//   NSKeyValueChange
            @"NSKeyValueChangeSetting":P(NSKeyValueChangeSetting),
            @"NSKeyValueChangeInsertion":P(NSKeyValueChangeInsertion),
            @"NSKeyValueChangeRemoval":P(NSKeyValueChangeRemoval),
            @"NSKeyValueChangeReplacement":P(NSKeyValueChangeReplacement),
//   NSKeyValueSetMutationKind
            @"NSKeyValueUnionSetMutation":P(NSKeyValueUnionSetMutation),
            @"NSKeyValueMinusSetMutation":P(NSKeyValueMinusSetMutation),
            @"NSKeyValueIntersectSetMutation":P(NSKeyValueIntersectSetMutation),
            @"NSKeyValueSetSetMutation":P(NSKeyValueSetSetMutation),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSMassFormatter.h
//   NSMassFormatterUnit
            @"NSMassFormatterUnitGram":P(NSMassFormatterUnitGram),
            @"NSMassFormatterUnitKilogram":P(NSMassFormatterUnitKilogram),
            @"NSMassFormatterUnitOunce":P(NSMassFormatterUnitOunce),
            @"NSMassFormatterUnitPound":P(NSMassFormatterUnitPound),
            @"NSMassFormatterUnitStone":P(NSMassFormatterUnitStone),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSOrderedCollectionDifference.h
//   NSOrderedCollectionDifferenceCalculationOptions
            @"NSOrderedCollectionDifferenceCalculationOmitInsertedObjects":P(NSOrderedCollectionDifferenceCalculationOmitInsertedObjects),
            @"NSOrderedCollectionDifferenceCalculationOmitRemovedObjects":P(NSOrderedCollectionDifferenceCalculationOmitRemovedObjects),
            @"NSOrderedCollectionDifferenceCalculationInferMoves":P(NSOrderedCollectionDifferenceCalculationInferMoves),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSString.h
//   NSStringCompareOptions
            @"NSCaseInsensitiveSearch":P(NSCaseInsensitiveSearch),
            @"NSLiteralSearch":P(NSLiteralSearch),
            @"NSBackwardsSearch":P(NSBackwardsSearch),
            @"NSAnchoredSearch":P(NSAnchoredSearch),
            @"NSNumericSearch":P(NSNumericSearch),
            @"NSDiacriticInsensitiveSearch":P(NSDiacriticInsensitiveSearch),
            @"NSWidthInsensitiveSearch":P(NSWidthInsensitiveSearch),
            @"NSForcedOrderingSearch":P(NSForcedOrderingSearch),
            @"NSRegularExpressionSearch":P(NSRegularExpressionSearch),
//   NSStringEncodingConversionOptions
            @"NSStringEncodingConversionAllowLossy":P(NSStringEncodingConversionAllowLossy),
            @"NSStringEncodingConversionExternalRepresentation":P(NSStringEncodingConversionExternalRepresentation),
//   NSStringEnumerationOptions
            @"NSStringEnumerationByLines":P(NSStringEnumerationByLines),
            @"NSStringEnumerationByParagraphs":P(NSStringEnumerationByParagraphs),
            @"NSStringEnumerationByComposedCharacterSequences":P(NSStringEnumerationByComposedCharacterSequences),
            @"NSStringEnumerationByWords":P(NSStringEnumerationByWords),
            @"NSStringEnumerationBySentences":P(NSStringEnumerationBySentences),
            @"NSStringEnumerationByCaretPositions":P(NSStringEnumerationByCaretPositions),
            @"NSStringEnumerationByDeletionClusters":P(NSStringEnumerationByDeletionClusters),
            @"NSStringEnumerationReverse":P(NSStringEnumerationReverse),
            @"NSStringEnumerationSubstringNotRequired":P(NSStringEnumerationSubstringNotRequired),
            @"NSStringEnumerationLocalized":P(NSStringEnumerationLocalized),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSDecimal.h
//   NSRoundingMode
            @"NSRoundPlain":P(NSRoundPlain),
            @"NSRoundDown":P(NSRoundDown),
            @"NSRoundUp":P(NSRoundUp),
            @"NSRoundBankers":P(NSRoundBankers),
//   NSCalculationError
            @"NSCalculationNoError":P(NSCalculationNoError),
            @"NSCalculationLossOfPrecision":P(NSCalculationLossOfPrecision),
            @"NSCalculationUnderflow":P(NSCalculationUnderflow),
            @"NSCalculationOverflow":P(NSCalculationOverflow),
            @"NSCalculationDivideByZero":P(NSCalculationDivideByZero),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSProcessInfo.h
//   NSActivityOptions
            @"NSActivityIdleDisplaySleepDisabled":P(NSActivityIdleDisplaySleepDisabled),
            @"NSActivityIdleSystemSleepDisabled":P(NSActivityIdleSystemSleepDisabled),
            @"NSActivitySuddenTerminationDisabled":P(NSActivitySuddenTerminationDisabled),
            @"NSActivityAutomaticTerminationDisabled":P(NSActivityAutomaticTerminationDisabled),
            @"NSActivityAnimationTrackingEnabled":P(NSActivityAnimationTrackingEnabled),
            @"NSActivityTrackingEnabled":P(NSActivityTrackingEnabled),
            @"NSActivityUserInitiated":P(NSActivityUserInitiated),
            @"NSActivityUserInitiatedAllowingIdleSystemSleep":P(NSActivityUserInitiatedAllowingIdleSystemSleep),
            @"NSActivityBackground":P(NSActivityBackground),
            @"NSActivityLatencyCritical":P(NSActivityLatencyCritical),
            @"NSActivityUserInteractive":P(NSActivityUserInteractive),
//   NSProcessInfoThermalState
            @"NSProcessInfoThermalStateNominal":P(NSProcessInfoThermalStateNominal),
            @"NSProcessInfoThermalStateFair":P(NSProcessInfoThermalStateFair),
            @"NSProcessInfoThermalStateSerious":P(NSProcessInfoThermalStateSerious),
            @"NSProcessInfoThermalStateCritical":P(NSProcessInfoThermalStateCritical),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSRegularExpression.h
//   NSRegularExpressionOptions
            @"NSRegularExpressionCaseInsensitive":P(NSRegularExpressionCaseInsensitive),
            @"NSRegularExpressionAllowCommentsAndWhitespace":P(NSRegularExpressionAllowCommentsAndWhitespace),
            @"NSRegularExpressionIgnoreMetacharacters":P(NSRegularExpressionIgnoreMetacharacters),
            @"NSRegularExpressionDotMatchesLineSeparators":P(NSRegularExpressionDotMatchesLineSeparators),
            @"NSRegularExpressionAnchorsMatchLines":P(NSRegularExpressionAnchorsMatchLines),
            @"NSRegularExpressionUseUnixLineSeparators":P(NSRegularExpressionUseUnixLineSeparators),
            @"NSRegularExpressionUseUnicodeWordBoundaries":P(NSRegularExpressionUseUnicodeWordBoundaries),
//   NSMatchingOptions
            @"NSMatchingReportProgress":P(NSMatchingReportProgress),
            @"NSMatchingReportCompletion":P(NSMatchingReportCompletion),
            @"NSMatchingAnchored":P(NSMatchingAnchored),
            @"NSMatchingWithTransparentBounds":P(NSMatchingWithTransparentBounds),
            @"NSMatchingWithoutAnchoringBounds":P(NSMatchingWithoutAnchoringBounds),
//   NSMatchingFlags
            @"NSMatchingProgress":P(NSMatchingProgress),
            @"NSMatchingCompleted":P(NSMatchingCompleted),
            @"NSMatchingHitEnd":P(NSMatchingHitEnd),
            @"NSMatchingRequiredEnd":P(NSMatchingRequiredEnd),
            @"NSMatchingInternalError":P(NSMatchingInternalError),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSRelativeDateTimeFormatter.h
//   NSRelativeDateTimeFormatterStyle
            @"NSRelativeDateTimeFormatterStyleNumeric":P(NSRelativeDateTimeFormatterStyleNumeric),
            @"NSRelativeDateTimeFormatterStyleNamed":P(NSRelativeDateTimeFormatterStyleNamed),
//   NSRelativeDateTimeFormatterUnitsStyle
            @"NSRelativeDateTimeFormatterUnitsStyleFull":P(NSRelativeDateTimeFormatterUnitsStyleFull),
            @"NSRelativeDateTimeFormatterUnitsStyleSpellOut":P(NSRelativeDateTimeFormatterUnitsStyleSpellOut),
            @"NSRelativeDateTimeFormatterUnitsStyleShort":P(NSRelativeDateTimeFormatterUnitsStyleShort),
            @"NSRelativeDateTimeFormatterUnitsStyleAbbreviated":P(NSRelativeDateTimeFormatterUnitsStyleAbbreviated),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSXMLParser.h
//   NSXMLParserExternalEntityResolvingPolicy
            @"NSXMLParserResolveExternalEntitiesNever":P(NSXMLParserResolveExternalEntitiesNever),
            @"NSXMLParserResolveExternalEntitiesNoNetwork":P(NSXMLParserResolveExternalEntitiesNoNetwork),
            @"NSXMLParserResolveExternalEntitiesSameOriginOnly":P(NSXMLParserResolveExternalEntitiesSameOriginOnly),
            @"NSXMLParserResolveExternalEntitiesAlways":P(NSXMLParserResolveExternalEntitiesAlways),
//   NSXMLParserError
            @"NSXMLParserInternalError":P(NSXMLParserInternalError),
            @"NSXMLParserOutOfMemoryError":P(NSXMLParserOutOfMemoryError),
            @"NSXMLParserDocumentStartError":P(NSXMLParserDocumentStartError),
            @"NSXMLParserEmptyDocumentError":P(NSXMLParserEmptyDocumentError),
            @"NSXMLParserPrematureDocumentEndError":P(NSXMLParserPrematureDocumentEndError),
            @"NSXMLParserInvalidHexCharacterRefError":P(NSXMLParserInvalidHexCharacterRefError),
            @"NSXMLParserInvalidDecimalCharacterRefError":P(NSXMLParserInvalidDecimalCharacterRefError),
            @"NSXMLParserInvalidCharacterRefError":P(NSXMLParserInvalidCharacterRefError),
            @"NSXMLParserInvalidCharacterError":P(NSXMLParserInvalidCharacterError),
            @"NSXMLParserCharacterRefAtEOFError":P(NSXMLParserCharacterRefAtEOFError),
            @"NSXMLParserCharacterRefInPrologError":P(NSXMLParserCharacterRefInPrologError),
            @"NSXMLParserCharacterRefInEpilogError":P(NSXMLParserCharacterRefInEpilogError),
            @"NSXMLParserCharacterRefInDTDError":P(NSXMLParserCharacterRefInDTDError),
            @"NSXMLParserEntityRefAtEOFError":P(NSXMLParserEntityRefAtEOFError),
            @"NSXMLParserEntityRefInPrologError":P(NSXMLParserEntityRefInPrologError),
            @"NSXMLParserEntityRefInEpilogError":P(NSXMLParserEntityRefInEpilogError),
            @"NSXMLParserEntityRefInDTDError":P(NSXMLParserEntityRefInDTDError),
            @"NSXMLParserParsedEntityRefAtEOFError":P(NSXMLParserParsedEntityRefAtEOFError),
            @"NSXMLParserParsedEntityRefInPrologError":P(NSXMLParserParsedEntityRefInPrologError),
            @"NSXMLParserParsedEntityRefInEpilogError":P(NSXMLParserParsedEntityRefInEpilogError),
            @"NSXMLParserParsedEntityRefInInternalSubsetError":P(NSXMLParserParsedEntityRefInInternalSubsetError),
            @"NSXMLParserEntityReferenceWithoutNameError":P(NSXMLParserEntityReferenceWithoutNameError),
            @"NSXMLParserEntityReferenceMissingSemiError":P(NSXMLParserEntityReferenceMissingSemiError),
            @"NSXMLParserParsedEntityRefNoNameError":P(NSXMLParserParsedEntityRefNoNameError),
            @"NSXMLParserParsedEntityRefMissingSemiError":P(NSXMLParserParsedEntityRefMissingSemiError),
            @"NSXMLParserUndeclaredEntityError":P(NSXMLParserUndeclaredEntityError),
            @"NSXMLParserUnparsedEntityError":P(NSXMLParserUnparsedEntityError),
            @"NSXMLParserEntityIsExternalError":P(NSXMLParserEntityIsExternalError),
            @"NSXMLParserEntityIsParameterError":P(NSXMLParserEntityIsParameterError),
            @"NSXMLParserUnknownEncodingError":P(NSXMLParserUnknownEncodingError),
            @"NSXMLParserEncodingNotSupportedError":P(NSXMLParserEncodingNotSupportedError),
            @"NSXMLParserStringNotStartedError":P(NSXMLParserStringNotStartedError),
            @"NSXMLParserStringNotClosedError":P(NSXMLParserStringNotClosedError),
            @"NSXMLParserNamespaceDeclarationError":P(NSXMLParserNamespaceDeclarationError),
            @"NSXMLParserEntityNotStartedError":P(NSXMLParserEntityNotStartedError),
            @"NSXMLParserEntityNotFinishedError":P(NSXMLParserEntityNotFinishedError),
            @"NSXMLParserLessThanSymbolInAttributeError":P(NSXMLParserLessThanSymbolInAttributeError),
            @"NSXMLParserAttributeNotStartedError":P(NSXMLParserAttributeNotStartedError),
            @"NSXMLParserAttributeNotFinishedError":P(NSXMLParserAttributeNotFinishedError),
            @"NSXMLParserAttributeHasNoValueError":P(NSXMLParserAttributeHasNoValueError),
            @"NSXMLParserAttributeRedefinedError":P(NSXMLParserAttributeRedefinedError),
            @"NSXMLParserLiteralNotStartedError":P(NSXMLParserLiteralNotStartedError),
            @"NSXMLParserLiteralNotFinishedError":P(NSXMLParserLiteralNotFinishedError),
            @"NSXMLParserCommentNotFinishedError":P(NSXMLParserCommentNotFinishedError),
            @"NSXMLParserProcessingInstructionNotStartedError":P(NSXMLParserProcessingInstructionNotStartedError),
            @"NSXMLParserProcessingInstructionNotFinishedError":P(NSXMLParserProcessingInstructionNotFinishedError),
            @"NSXMLParserNotationNotStartedError":P(NSXMLParserNotationNotStartedError),
            @"NSXMLParserNotationNotFinishedError":P(NSXMLParserNotationNotFinishedError),
            @"NSXMLParserAttributeListNotStartedError":P(NSXMLParserAttributeListNotStartedError),
            @"NSXMLParserAttributeListNotFinishedError":P(NSXMLParserAttributeListNotFinishedError),
            @"NSXMLParserMixedContentDeclNotStartedError":P(NSXMLParserMixedContentDeclNotStartedError),
            @"NSXMLParserMixedContentDeclNotFinishedError":P(NSXMLParserMixedContentDeclNotFinishedError),
            @"NSXMLParserElementContentDeclNotStartedError":P(NSXMLParserElementContentDeclNotStartedError),
            @"NSXMLParserElementContentDeclNotFinishedError":P(NSXMLParserElementContentDeclNotFinishedError),
            @"NSXMLParserXMLDeclNotStartedError":P(NSXMLParserXMLDeclNotStartedError),
            @"NSXMLParserXMLDeclNotFinishedError":P(NSXMLParserXMLDeclNotFinishedError),
            @"NSXMLParserConditionalSectionNotStartedError":P(NSXMLParserConditionalSectionNotStartedError),
            @"NSXMLParserConditionalSectionNotFinishedError":P(NSXMLParserConditionalSectionNotFinishedError),
            @"NSXMLParserExternalSubsetNotFinishedError":P(NSXMLParserExternalSubsetNotFinishedError),
            @"NSXMLParserDOCTYPEDeclNotFinishedError":P(NSXMLParserDOCTYPEDeclNotFinishedError),
            @"NSXMLParserMisplacedCDATAEndStringError":P(NSXMLParserMisplacedCDATAEndStringError),
            @"NSXMLParserCDATANotFinishedError":P(NSXMLParserCDATANotFinishedError),
            @"NSXMLParserMisplacedXMLDeclarationError":P(NSXMLParserMisplacedXMLDeclarationError),
            @"NSXMLParserSpaceRequiredError":P(NSXMLParserSpaceRequiredError),
            @"NSXMLParserSeparatorRequiredError":P(NSXMLParserSeparatorRequiredError),
            @"NSXMLParserNMTOKENRequiredError":P(NSXMLParserNMTOKENRequiredError),
            @"NSXMLParserNAMERequiredError":P(NSXMLParserNAMERequiredError),
            @"NSXMLParserPCDATARequiredError":P(NSXMLParserPCDATARequiredError),
            @"NSXMLParserURIRequiredError":P(NSXMLParserURIRequiredError),
            @"NSXMLParserPublicIdentifierRequiredError":P(NSXMLParserPublicIdentifierRequiredError),
            @"NSXMLParserLTRequiredError":P(NSXMLParserLTRequiredError),
            @"NSXMLParserGTRequiredError":P(NSXMLParserGTRequiredError),
            @"NSXMLParserLTSlashRequiredError":P(NSXMLParserLTSlashRequiredError),
            @"NSXMLParserEqualExpectedError":P(NSXMLParserEqualExpectedError),
            @"NSXMLParserTagNameMismatchError":P(NSXMLParserTagNameMismatchError),
            @"NSXMLParserUnfinishedTagError":P(NSXMLParserUnfinishedTagError),
            @"NSXMLParserStandaloneValueError":P(NSXMLParserStandaloneValueError),
            @"NSXMLParserInvalidEncodingNameError":P(NSXMLParserInvalidEncodingNameError),
            @"NSXMLParserCommentContainsDoubleHyphenError":P(NSXMLParserCommentContainsDoubleHyphenError),
            @"NSXMLParserInvalidEncodingError":P(NSXMLParserInvalidEncodingError),
            @"NSXMLParserExternalStandaloneEntityError":P(NSXMLParserExternalStandaloneEntityError),
            @"NSXMLParserInvalidConditionalSectionError":P(NSXMLParserInvalidConditionalSectionError),
            @"NSXMLParserEntityValueRequiredError":P(NSXMLParserEntityValueRequiredError),
            @"NSXMLParserNotWellBalancedError":P(NSXMLParserNotWellBalancedError),
            @"NSXMLParserExtraContentError":P(NSXMLParserExtraContentError),
            @"NSXMLParserInvalidCharacterInEntityError":P(NSXMLParserInvalidCharacterInEntityError),
            @"NSXMLParserParsedEntityRefInInternalError":P(NSXMLParserParsedEntityRefInInternalError),
            @"NSXMLParserEntityRefLoopError":P(NSXMLParserEntityRefLoopError),
            @"NSXMLParserEntityBoundaryError":P(NSXMLParserEntityBoundaryError),
            @"NSXMLParserInvalidURIError":P(NSXMLParserInvalidURIError),
            @"NSXMLParserURIFragmentError":P(NSXMLParserURIFragmentError),
            @"NSXMLParserNoDTDError":P(NSXMLParserNoDTDError),
            @"NSXMLParserDelegateAbortedParseError":P(NSXMLParserDelegateAbortedParseError),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSNumberFormatter.h
//   NSNumberFormatterBehavior
            @"NSNumberFormatterBehaviorDefault":P(NSNumberFormatterBehaviorDefault),
//   NSNumberFormatterStyle
            @"NSNumberFormatterNoStyle":P(NSNumberFormatterNoStyle),
            @"NSNumberFormatterDecimalStyle":P(NSNumberFormatterDecimalStyle),
            @"NSNumberFormatterCurrencyStyle":P(NSNumberFormatterCurrencyStyle),
            @"NSNumberFormatterPercentStyle":P(NSNumberFormatterPercentStyle),
            @"NSNumberFormatterScientificStyle":P(NSNumberFormatterScientificStyle),
            @"NSNumberFormatterSpellOutStyle":P(NSNumberFormatterSpellOutStyle),
            @"NSNumberFormatterOrdinalStyle":P(NSNumberFormatterOrdinalStyle),
            @"NSNumberFormatterCurrencyISOCodeStyle":P(NSNumberFormatterCurrencyISOCodeStyle),
            @"NSNumberFormatterCurrencyPluralStyle":P(NSNumberFormatterCurrencyPluralStyle),
            @"NSNumberFormatterCurrencyAccountingStyle":P(NSNumberFormatterCurrencyAccountingStyle),
//   NSNumberFormatterPadPosition
            @"NSNumberFormatterPadBeforePrefix":P(NSNumberFormatterPadBeforePrefix),
            @"NSNumberFormatterPadAfterPrefix":P(NSNumberFormatterPadAfterPrefix),
            @"NSNumberFormatterPadBeforeSuffix":P(NSNumberFormatterPadBeforeSuffix),
            @"NSNumberFormatterPadAfterSuffix":P(NSNumberFormatterPadAfterSuffix),
//   NSNumberFormatterRoundingMode
            @"NSNumberFormatterRoundCeiling":P(NSNumberFormatterRoundCeiling),
            @"NSNumberFormatterRoundFloor":P(NSNumberFormatterRoundFloor),
            @"NSNumberFormatterRoundDown":P(NSNumberFormatterRoundDown),
            @"NSNumberFormatterRoundUp":P(NSNumberFormatterRoundUp),
            @"NSNumberFormatterRoundHalfEven":P(NSNumberFormatterRoundHalfEven),
            @"NSNumberFormatterRoundHalfDown":P(NSNumberFormatterRoundHalfDown),
            @"NSNumberFormatterRoundHalfUp":P(NSNumberFormatterRoundHalfUp),

//   Enum definitions in ./enum_gen/Foundation/Headers/NSPropertyList.h
//   NSPropertyListMutabilityOptions
            @"NSPropertyListImmutable":P(NSPropertyListImmutable),
            @"NSPropertyListMutableContainers":P(NSPropertyListMutableContainers),
            @"NSPropertyListMutableContainersAndLeaves":P(NSPropertyListMutableContainersAndLeaves),
//   NSPropertyListFormat
            @"NSPropertyListOpenStepFormat":P(NSPropertyListOpenStepFormat),

//total entry count is 1996
        };
    });

    return store[name];
}
@end
