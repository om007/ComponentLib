//
//  YLWComponent.swift
//  MobileERP
//
//  Created by Sunil Luitel on 8/26/15.
//  Copyright (c) 2015 Sunil Luitel. All rights reserved.
//

import UIKit
import AudioToolbox
import Foundation
import JavaScriptCore

class YLWComponent: UIView, YLWComponentJSDelegate, UIGestureRecognizerDelegate {
    
    var grayA = ColorConstants.ylw_grayA
    var grayC = ColorConstants.ylw_grayC
    
    var green = ColorConstants.color_set_green
    var white = ColorConstants.white_color
    var black = ColorConstants.black_color
    var red = ColorConstants.ylwComponent_red
    var blue = ColorConstants.ylwComponent_blue
    var purpleTheme = ColorConstants.NewPadDesign_themeColor
    
    var lineWidth: CGFloat = 0;
    var defaultLineWidth: CGFloat = DimenConstants.control_border * Utils.getScale()
    var focusedLineWidth:CGFloat = DimenConstants.control_border_focused * Utils.getScale()
    
    var padding = DimenConstants.caption_margin * Utils.getScale()
    let iconPadding_default = DimenConstants.standard_margin/4

    var iconSize = DimenConstants.control_icon_size * Utils.getScale()
    var textSize = DimenConstants.control_text_size * Utils.getScale()
    var customIconSize = DimenConstants.control_customIcon_size * Utils.getScale()

    var captionSize = DimenConstants.control_caption_text_size * Utils.getScale()
    
    var textColor: Int? = nil
    
    var textColor_readOnly: Int = ColorConstants.ylw_grayA
    var background_readOnly = ColorConstants.ylw_bg_readOnly
    
    var captionColor_normalBig = ColorConstants.captionColor_big
    var captionColor_essentialBig = ColorConstants.ylw_caption_essentialBig
    var captionColor_normalSmall = ColorConstants.captionColor_big
    var captionColor_essentialSmall = ColorConstants.ylwComponent_red
    var dblClickColor = ColorConstants.cell_highlight
    
    var lineColor: Int = 0
    var defaultLineColor: Int = ColorConstants.default_line_color
    var focusedLineColor: Int = ColorConstants.ylw_input_focusColor
    
    let defaultLineColor_black: Int = ColorConstants.ylw_grayA

    var longPressedFinger: UIImage = UIImage(named: "double_click_finger")!
    var longPressedFingerAlpha:CGFloat = 0.5
    var longPressFingerHeightWidth = DimenConstants.long_press_finger_base_height * Utils.getScale()
    
    var clickListener: YLWClickListener?
    var longPressedListener: YLWLongPressedListener?
    //internal var showMenuInterface: YLWShowKeyboardInterface?
    //Added two variables
    internal var showKeyboardInterface: YLWShowKeyboardInterface?
    internal var ylwControlIconClickInterface: YlwControlIconClickInterface?
    internal var miscComponentInterface: YlwMiscComponentInterface?
    
    var visibilityUpdater: VisibilityUpdater?
    
    fileprivate var visible: Bool = true
    fileprivate var isChangeCancel: Bool = false
    var isUserHidden: Bool = false
    var isHighlighted = false
    var highlightedBorder = YLWColorUtils.changeHexToUIColor(ColorConstants.demo_highlight,opacity: 1)
    
    internal var ControlKey: String = ""
    internal var isRequired: Bool = false
    internal var isReadOnly: Bool = false
    internal var IsHidden: Bool = false
    
    //New properties
    var scanAutoMove: Bool?
    var controlWidth: CGFloat?
    var controlHeight: CGFloat?
    var bgColor: UIColor?
    var readOnlyIcon: UIImage?
    var dataAlign: Int = 0 //0 or no value -> Right(Default), 1 -> Left -- NEW_PAD_DESIGN
    var buttonType: Int = 0 //0 -> primary, 1 -> secondary, 2-> tertiary -- NEW_PAD_DESIGN
    var emaphasis: Bool = false
    var dataDirection: Direction = .vertical // Caption-Value alignment 1: Vertical, 2: Horizontal
    
    var isFloatBoxInPad: Bool = false
    
    func setDataObject(_ obj: YLWFormControlObject) {
        
        setTitle(obj.getTitle());
        setLabelTitle(obj.getLabelTitle());
        setTextFieldValue(obj.getTextFieldValue());
        setControlSeq(obj.getControlSeq());
        setParentSeq(obj.getParentSeq());
        setControlType(obj.getControlType());
        setControlName(obj.getControlName());
        setControlCaption(obj.getControlCaption());
        setDataBlock(obj.getDataBlock());
        setDataFieldName(obj.getDataFieldName());
        setDataFieldCd(obj.getDataFieldCd());
        setDataKey(obj.getDataKey());
        setControlKey(obj.getControlKey());
        setCodeHelpConst(obj.getCodeHelpConst());
        setCodeHelpDefaultValue(obj.getCodeHelpDefaultValue());
        setMaxLength(obj.getMaxLength());
        setDecLength(obj.getDecLength());
        setDefaultValue(obj.getDefaultValue());
        setTabIndex(obj.getTabIndex());
        setCodeHelpDefault(obj.getCodeHelpDefault());
        setCodeHelpParams(obj.getCodeHelpParams());
        setPropertyParams(obj.getPropertyParams());
        setUseComma(obj.getUseComma());
        setContentAlignmant(obj.getContentAlignmant());
        setIsMultiCode(obj.getIsMultiCode());
        setDataExists(obj.isDataExists());
        setFormEventType(obj.getFormEventType());
        setEventTitle(obj.getEventTitle());
        setFixedLayout(obj.isFixedLayout());
        setCombo(obj.isCombo());
        setMaskAndCaption(obj.getMaskAndCaption());
        setSeqOrder(obj.getSeqOrder());
        setColWeight(2 * obj.getWidthWeight());
        setIsOnSameLine(obj.getIsOnSameLine());
        setControlOrder(obj.getControlOrder());
        setIsMobileHidden(obj.getIsMobileHidden());
        setIsInputScanner(obj.getIsInputScanner());
        setMoveToNextScanner(moveToNextScanner: obj.getIsMoveToNextScanner())
    }
    
    func setVisibility(_ visible: Bool) {
        self.visible = visible;
        if (visible) {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
        if visibilityUpdater != nil {
            visibilityUpdater?.adjustLayoutHeight(visible)
        }
    }
    func isVisible()->Bool {
        return self.visible
    }
    
    func getIsChangeCancel()->Bool {
        return isChangeCancel;
    }
    
    func isChangeCancelSetter(_ isChangedCancel: Bool) {
        self.isChangeCancel = isChangedCancel;
    }
    
    func setYLWClickListener(_ listener: YLWClickListener?) {
        self.clickListener = listener!
    }
    
    func setYLWLongPressedListener(_ listener: YLWLongPressedListener) {
        self.longPressedListener = listener
        setNeedsDisplay()
    }
    func setIsChangeCancel(_ isChanged: Bool) {
        self.isChangeCancel = isChanged;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(longPressedListener == nil){
            return
        }
        
        if !NSString(string: getControlKey()).contains(DIS) {
            longPressedFingerAlpha = 1
            self.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(longPressedListener == nil){
            return
        }
        
        if !NSString(string: getControlKey()).contains(DIS) {
            longPressedFingerAlpha = 0.5
            self.setNeedsDisplay()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(longPressedListener == nil){
            return
        }
        
        if !NSString(string: getControlKey()).contains(DIS) {
            longPressedFingerAlpha = 0.5
            self.setNeedsDisplay()
        }
    }
    
    func addLongPressListener(_ view: UIView){
        let longPressRec = UILongPressGestureRecognizer(target: self, action: #selector(YLWComponent.handleLongPress(_:)))
        view.addGestureRecognizer(longPressRec)
    }
    
    func handleTap(_ sender: AnyObject){
        let component = sender as! YLWComponent
        if component is YLWImageControl {
            let imageControl = component as! YLWImageControl
            if (imageControl.isIsLoading()) {
                showToast(message: "Image is Loading")
            } else if !(imageControl.isIsReadOnly() && imageControl.getImage() == nil) {
                showKeyboardInterface?.showKeyboard(self)
                showKeyboardInterface?.scrollToComponent(self.getControlSeq())
            }
        } else if component is YLWSignControl {
            let signControl = component as! YLWSignControl
            if !(signControl.isIsReadOnly() && signControl.getImage() == nil) {
                showKeyboardInterface?.showKeyboard(self)
                showKeyboardInterface?.scrollToComponent(self.getControlSeq())
            }
        }
        else if (!NSString(string: component.getControlKey()).contains(DIS) || component.getControlType() == 33) && !(sender is YLWButton || sender is YLWCheckBox) {
            showKeyboardInterface?.showKeyboard(self)
            if !component.isFloatBoxInPad {
                showKeyboardInterface?.scrollToComponent(self.getControlSeq())
            }
        }
        
        if clickListener == nil {
            if sender is YLWCheckBox && !getControlKey().contains(DIS) {
                //showMenuInterface?.usingAction_CheckBox_withoutClickEvent(self)
                ylwControlIconClickInterface?.usingAction_CheckBox_withoutClickEvent(self)
            }
            return
        }
        if !NSString(string: getControlKey()).contains(DIS) && (sender is YLWButton || sender is YLWCheckBox) {
            clickListener!.clicked(self)
        }
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer){
        if(longPressedListener == nil){
            return
        }
       
        if !NSString(string: getControlKey()).contains(DIS) {
            longPressedFingerAlpha = 1
            self.setNeedsDisplay()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
             if sender.state == UIGestureRecognizer.State.ended {
            longPressedListener?.longPressed(self)
            longPressedFingerAlpha = 0.5
            self.setNeedsDisplay()
                    }
        }

    }
    
    func setVisibilityUpdater(_ visibilityUpdater:VisibilityUpdater) {
        self.visibilityUpdater = visibilityUpdater;
    }
    
    
    func getVisibilityUpdater()->VisibilityUpdater {
        return self.visibilityUpdater!
    }
    // *****************************************************************************************************************************
    // *****************************************************************************************************************************
    // ****************************************Form Control Object Values*********************************************************/
    
    /** The title. */
    fileprivate var title: String = ""
    
    /** The label title. */
    fileprivate var labelTitle: String = ""
    
    /** The text field value. */
    fileprivate var textFieldValue: String = ""
    
    /** The control seq. */
    fileprivate var controlSeq: Int = 0
    
    /** The parent seq. */
    fileprivate var parentSeq: Int = 0
    
    /** The control type. */
    fileprivate var controlType: Int = 0
    
    /** The control name. */
    fileprivate var controlName: String = ""
    
    /** The control caption. */
    fileprivate var controlCaption: String = ""
    
    /** The data block. */
    fileprivate var dataBlock: String = ""
    
    /** The data field name. */
    fileprivate var dataFieldName: String = ""
    
    /** The data field cd. */
    fileprivate var dataFieldCd: String?
    
    /** The data key. */
    fileprivate var dataKey: String = ""
    
    /** The code help const. */
    fileprivate var codeHelpConst: String = ""
    
    /** The code help default value. */
    fileprivate var codeHelpDefaultValue: String = ""
    
    /** The max length. */
    fileprivate var maxLength: Int = 0
    
    /** The dec length. */
    fileprivate var decLength: Int = 0
    
    /** The default value. */
    fileprivate var defaultValue: String = ""
    
    /** The tab index. */
    fileprivate var tabIndex: Int = 0
    
    /** The is combo. */
    fileprivate var combo: Bool = false
    
    /** The Code help default. */
    fileprivate var CodeHelpDefault: String = ""
    
    /** The Code help params. */
    fileprivate var CodeHelpParams: String = ""
    
    /** The Property params. */
    fileprivate var PropertyParams: String = ""
    
    /** The use comma. */
    fileprivate var useComma: Int = 0
    
    /** The content alignmant. */
    fileprivate var contentAlignmant: Int = 0
    
    /** The is multi code. */
    fileprivate var isMultiCode: String = ""
    
    /** The data exists. */
    fileprivate var dataExists: Bool = false
    
    /** The form event type. */
    fileprivate var formEventType: Int = 0
    
    /** The event title. */
    fileprivate var eventTitle: String = ""
    
    /** The mask and caption */
    fileprivate var maskAndCaption: String = ""
    
    fileprivate var fixedLayout: Bool = false
    
    fileprivate var originX: Int = 0
    fileprivate var originY: Int = 0
    
    fileprivate var unChangedValue: String = ""
    
    fileprivate var colWeight: Int = 0
    fileprivate var seqOrder: Int = 0
    fileprivate var isOnSameLine: Int = 0
    fileprivate var controlOrder: Int = 0
    fileprivate var isMobileHidden: Int = 0
    fileprivate var isInputScanner: Int = 0
    fileprivate var comboAddTotal:Bool = false
    fileprivate var pgmSeq: String = ""
    fileprivate var isMoveToNextScanner = false
    
    func getUnChangedValue()->String {
        return unChangedValue;
    }
    
    func setUnChangedValue(_ unChangedValue: String) {
        self.unChangedValue = unChangedValue;
    }
    
    /**
    * Gets the form event type.
    *
    * @return the form event type
    */
    func getFormEventType()->Int {
        return formEventType;
    }
    
    /**
    * Sets the form event type.
    *
    * @param formEventType
    *            the new form event type
    */
    func setFormEventType(_ formEventType: Int) {
        self.formEventType = formEventType;
    }
    
    /** The data list. */
    fileprivate var dataList: Array<YLWFormControlObject> = []
    
    /**
    * Gets the title.
    *
    * @return the title
    */
    func getTitle()->String {
        return title;
    }
    
    /**
    * Sets the title.
    *
    * @param title
    *            the new title
    */
    func setTitle(_ title: String) {
        self.title = title;
    }
    
    /**
    * Gets the label title.
    *
    * @return the label title
    */
    func getLabelTitle()->String {
        return labelTitle;
    }
    
    /**
    * Sets the label title.
    *
    * @param labelTitle
    *            the new label title
    */
    func setLabelTitle(_ labelTitle: String) {
        self.labelTitle = labelTitle;
    }
    
    /**
    * Gets the text field value.
    *
    * @return the text field value
    */
    func getTextFieldValue() -> String{
        return textFieldValue;
    }
    
    /**
    * Sets the text field value.
    *
    * @param textFieldValue
    *            the new text field value
    */
    func setTextFieldValue(_ textFieldValue: String) {
        self.textFieldValue = textFieldValue;
    }
    
    /**
    * Gets the control seq.
    *
    * @return the control seq
    */
    func getControlSeq()->Int {
        return controlSeq;
    }
    
    /**
    * Sets the control seq.
    *
    * @param controlSeq
    *            the new control seq
    */
    func setControlSeq(_ controlSeq: Int) {
        self.controlSeq = controlSeq;
    }
    
    /**
    * Gets the parent seq.
    *
    * @return the parent seq
    */
    func getParentSeq()->Int {
        return parentSeq;
    }
    
    /**
    * Sets the parent seq.
    *
    * @param parentSeq
    *            the new parent seq
    */
    func setParentSeq(_ parentSeq: Int) {
        self.parentSeq = parentSeq;
    }
    
    /**
    * Gets the control type.
    *
    * @return the control type
    */
    func getControlType()->Int {
        return controlType;
    }
    
    /**
    * Sets the control type.
    *
    * @param controlType
    *            the new control type
    */
    func setControlType(_ controlType: Int) {
        self.controlType = controlType;
    }
    
    /**
    * Gets the control name.
    *
    * @return the control name
    */
    func getControlName()->String {
        return controlName;
    }
    
    /**
    * Sets the control name.
    *
    * @param controlName
    *            the new control name
    */
    func setControlName(_ controlName:String) {
        self.controlName = controlName;
    }
    
    /**
    * Gets the control caption.
    *
    * @return the control caption
    */
    func getControlCaption()->String {
        return controlCaption
    }
    
    /**
    * Sets the control caption.
    *
    * @param controlCaption
    *            the new control caption
    */
    func setControlCaption(_ controlCaption:String) {
        self.controlCaption = controlCaption;
        setCaption(controlCaption);
    }
    
    func setCaption(_ controlCaption: String) {
        self.controlCaption = controlCaption;
    }
    
    func getCaption() -> String {
        return controlCaption;
    }
    
    /**
    * Gets the data block.
    *
    * @return the data block
    */
    func getDataBlock()->String {
        return dataBlock;
    }
    
    /**
    * Sets the data block.
    *
    * @param dataBlock
    *            the new data block
    */
    func setDataBlock(_ dataBlock:String) {
        self.dataBlock = dataBlock;
    }
    
    /**
    * Gets the data field name.
    *
    * @return the data field name
    */
    func getDataFieldName() -> String{
        return dataFieldName;
    }
    
    /**
    * Sets the data field name.
    *
    * @param dataFieldName
    *            the new data field name
    */
    func setDataFieldName(_ dataFieldName:String) {
        self.dataFieldName = dataFieldName;
    }
    
    /**
    * Gets the data field cd.
    *
    * @return the data field cd
    */
    func getDataFieldCd()->String? {
        return dataFieldCd;
    }
    
    /**
    * Sets the data field cd.
    *
    * @param dataFieldCd
    *            the new data field cd
    */
    func setDataFieldCd(_ dataFieldCd:String) {
        self.dataFieldCd = dataFieldCd;
    }
    
    /**
    * Gets the data key.
    *
    * @return the data key
    */
    func getDataKey()->String {
        return dataKey;
    }
    
    /**
    * Sets the data key.
    *
    * @param dataKey
    *            the new data key
    */
    func setDataKey(_ dataKey: String) {
        self.dataKey = dataKey;
    }
    
    /**
    * Gets the code help const.
    *
    * @return the code help const
    */
    func getCodeHelpConst() -> String {
        return codeHelpConst;
    }
    
    /**
    * Sets the code help const.
    *
    * @param codeHelpConst
    *            the new code help const
    */
    func setCodeHelpConst(_ codeHelpConst: String) {
        self.codeHelpConst = codeHelpConst;
    }
    
    /**
    * Gets the code help default value.
    *
    * @return the code help default value
    */
    func getCodeHelpDefaultValue() -> String {
        return codeHelpDefaultValue;
    }
    
    /**
    * Sets the code help default value.
    *
    * @param codeHelpDefaultValue
    *            the new code help default value
    */
    func setCodeHelpDefaultValue(_ codeHelpDefaultValue: String) {
        self.codeHelpDefaultValue = codeHelpDefaultValue;
    }
    
    /**
    * Gets the max length.
    *
    * @return the max length
    */
    func getMaxLength() -> Int{
        return maxLength;
    }
    
    /**
    * Sets the max length.
    *
    * @param maxLength
    *            the new max length
    */
    func setMaxLength(_ maxLength: Int) {
        self.maxLength = maxLength;
    }
    
    /**
    * Gets the dec length.
    *
    * @return the dec length
    */
    func getDecLength() -> Int{
        return decLength;
    }
    
    /**
    * Sets the dec length.
    *
    * @param decLength
    *            the new dec length
    */
    func setDecLength(_ decLength:Int) {
        self.decLength = decLength;
    }
    
    /**
    * Gets the default value.
    *
    * @return the default value
    */
    func getDefaultValue() -> String {
        return defaultValue;
    }
    
    /**
    * Sets the default value.
    *
    * @param defaultValue
    *            the new default value
    */
    func setDefaultValue(_ defaultValue: String) {
        self.defaultValue = defaultValue;
    }
    
    /**
    * Gets the tab index.
    *
    * @return the tab index
    */
    func getTabIndex() -> Int{
        return tabIndex;
    }
    
    /**
    * Sets the tab index.
    *
    * @param tabIndex
    *            the new tab index
    */
    func setTabIndex(_ tabIndex: Int) {
        self.tabIndex = tabIndex;
    }
    
    /**
    * Sets the combo.
    *
    * @param combo
    *            the new combo
    */
    func setCombo(_ combo:Bool) {
        self.combo = combo;
    }
    
    func isCombo() -> Bool{
        return self.combo;
    }
    /**
    * Gets the code help default.
    *
    * @return the code help default
    */
    func getCodeHelpDefault() -> String{
        return CodeHelpDefault;
    }
    
    /**
    * Sets the code help default.
    *
    * @param codeHelpDefault
    *            the new code help default
    */
    func setCodeHelpDefault(_ codeHelpDefault: String) {
        CodeHelpDefault = codeHelpDefault;
    }
    
    /**
    * Gets the code help params.
    *
    * @return the code help params
    */
    func getCodeHelpParams() -> String{
        return CodeHelpParams;
    }
    
    /**
    * Sets the code help params.
    *
    * @param codeHelpParams
    *            the new code help params
    */
    func setCodeHelpParams(_ codeHelpParams: String) {
        CodeHelpParams = codeHelpParams;
    }
    
    /**
    * Gets the property params.
    *
    * @return the property params
    */
    func getPropertyParams() -> String {
        return PropertyParams;
    }
    
    /**
    * Sets the property params.
    *
    * @param propertyParams
    *            the new property params
    */
    func setPropertyParams(_ propertyParams: String) {
        PropertyParams = propertyParams;
    }
    
    /**
    * Gets the use comma.
    *
    * @return the use comma
    */
    func getUseComma() -> Int{
        return useComma;
    }
    
    /**
    * Sets the use comma.
    *
    * @param useComma
    *            the new use comma
    */
    func setUseComma(_ useComma: Int) {
        self.useComma = useComma;
    }
    
    /**
    * Gets the content alignmant.
    *
    * @return the content alignmant
    */
    func getContentAlignmant() -> Int {
        return contentAlignmant;
    }
    
    /**
    * Sets the content alignmant.
    *
    * @param contentAlignmant
    *            the new content alignmant
    */
    func setContentAlignmant(_ contentAlignmant: Int) {
        self.contentAlignmant = contentAlignmant;
    }
    
    /**
    * Gets the checks if is multi code.
    *
    * @return the checks if is multi code
    */
    func getIsMultiCode() -> String{
        return isMultiCode;
    }
    
    /**
    * Sets the checks if is multi code.
    *
    * @param isMultiCode
    *            the new checks if is multi code
    */
    func setIsMultiCode(_ isMultiCode: String) {
        self.isMultiCode = isMultiCode;
    }
    
    /**
    * Checks if is data exists.
    *
    * @return true, if is data exists
    */
    func isDataExists() -> Bool{
        return dataExists;
    }
    
    /**
    * Sets the data exists.
    *
    * @param dataExists
    *            the new data exists
    */
    func setDataExists(_ dataExists: Bool) {
        self.dataExists = dataExists;
    }
    
    /**
    * Gets the event title.
    *
    * @return the event title
    */
    func getEventTitle() -> String {
        return eventTitle;
    }
    
    /**
    * Sets the event title.
    *
    * @param eventTitle
    *            the new event title
    */
    func setEventTitle(_ eventTitle: String) {
        self.eventTitle = eventTitle;
    }
    
    
    func setComboAddTotal(_ isComboAddTotal:Bool) {
        self.comboAddTotal = isComboAddTotal
    }
    
    func isComboAddTotal()->Bool{
        return self.comboAddTotal
    }
    /**
    * Gets the data list.
    *
    * @return the data list
    */
    func getDataList() -> Array<YLWFormControlObject> {
        return dataList;
    }
    
    /**
    * Sets the data list.
    *
    * @param dataList
    *            the new data list
    */
    func setDataList(_ dataList:Array<YLWFormControlObject>) {
        self.dataList = dataList;
    }
    
    func isFixedLayout()->Bool {
        return fixedLayout;
    }
    
    func setFixedLayout(_ fixedLayout: Bool) {
        self.fixedLayout = fixedLayout;
    }
    
    func getOriginX() -> Int {
        return originX;
    }
    
    func setOriginX(_ originX: Int){
        self.originX = originX;
    }
    
    func getOriginY() -> Int{
        return originY;
    }
    
    func setOriginY(_ originY:Int) {
        self.originY = originY;
    }
    
    /**
    * @return the maskAndCaption
    */
    func getMaskAndCaption() -> String{
        return maskAndCaption;
    }
    
    /**
    * @param maskAndCaption
    *            the maskAndCaption to set
    */
    func setMaskAndCaption(_ maskAndCaption: String) {
        self.maskAndCaption = maskAndCaption;
    }
    
    func setMask(_ mask:String){
        setMaskAndCaption(mask)
    }
    
    func setUserHidden(_ userHidden:Bool){
        self.isUserHidden = userHidden;
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /************************************************************************
    ************************* ABSTRACT METHOD ******************************
    *************************************************************************/
    
    func setUIValue(_ text: String) {
        
    }
    
    func getUIValue()->String {
        return ""
    }
    
    func setDBValue(_ text: String) {
        
    }
    
    func getDBValue()->String? {
        return ""
    }
    
    func setDBValueName(_ text: String) {
        
    }
    
    func getDBValueName()->String {
        return ""
    }
    
    func initialize(_ keyboardDelegate:YLWShowKeyboardInterface){
        showKeyboardInterface = keyboardDelegate
    }
    
    func setYlwControlIconInterface(_ interface: YlwControlIconClickInterface) {
        self.ylwControlIconClickInterface = interface
    }
    
    func setYlwMiscComponentInterface(_ interface: YlwMiscComponentInterface) {
        self.miscComponentInterface = interface
    }
    
    func removeFocus() {
        lineWidth = defaultLineWidth;
        lineColor = defaultLineColor;
        setNeedsDisplay()
        visibilityUpdater?.removeFocus()
    }
    
    func showFocus(){
        lineWidth = focusedLineWidth;
        lineColor = focusedLineColor;
        setNeedsDisplay();
        visibilityUpdater?.showFocus(self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
    }
    
    func setValue(_ value: AnyObject) {
        
    }
    func getValue()->String {
        return ""
    }
    
    func setText(_ text: AnyObject) {
        
    }
    func getText()->String {
      return ""
    }
    
    /**
    * Gets the control key.
    *
    * @return the control key
    */
    func getControlKey()->String {
        return ControlKey
    }
    
    /**
    * Sets the control key.
    *
    * @param controlKey
    *            the new control key
    */
    func setControlKey(_ controlKey:String) {
        ControlKey = controlKey
        isRequired = isISRequired()
        isHiddenSetter(controlKeyContainsHID())
        isReadOnly = NSString(string: getControlKey()).contains(DIS)
        setNeedsDisplay()
    }
    
    func isIsReadOnly() -> Bool {
        return isReadOnly
    }
    
    func isISRequired() -> Bool {
        return NSString(string: ControlKey).contains(NOS) || NSString(string: ControlKey).contains(NOQ) || NSString(string: ControlKey).contains(NON)
    }
    
    func isHiddenSetter(_ isHidden: Bool) {
        IsHidden = isHidden || (getIsMobileHidden() == 1 && !(isRequired && !hasDefault()))
        if isHidden && !(NSString(string: ControlKey).contains(HID)) {
//            ControlKey = ControlKey + "HID;";
        } else if !isHidden && NSString(string: ControlKey).contains(HID) {
//            ControlKey = ControlKey.replacingOccurrences(of: "HID;", with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        if (visibilityUpdater != nil && !isUserHidden) {
            visibilityUpdater!.processComponentVisibility(self)
        }
    }
    
    func hasDefault() -> Bool {
        return !getDefaultValue().isEmpty
    }
    
    func getSeqOrder()->Int {
        return seqOrder;
    }
    
    func setSeqOrder(_ seqOrder:Int) {
        self.seqOrder = seqOrder;
    }
    
    func getColWeight()->Int {
        return colWeight;
    }
    
    func setColWeight(_ colWeight: Int) {
        //We are doubling default ColWeight from 3 to 6, along with total distribution column count from 6 to 12 for Mobile and from 12 to 24 for iPad, because we want make sure colWight value always stays as Integer although ControlWidthFactor from editor is as less as 0.5 (half of default width) or multiple of 0.5 which we then multiply to default colWeight to get the resulting control colWeight. E.g: 0.5 (width factor) * 6 (default colWeight) = 3 (Resulting colWeight)
        self.colWeight = colWeight;
    }
    
    func getIsOnSameLine()->Int {
        return isOnSameLine;
    }
    
    func setIsOnSameLine(_ isOnSameLine:Int) {
        self.isOnSameLine = isOnSameLine;
    }
    
    func getControlOrder()->Int {
        return controlOrder;
    }
    
    func setControlOrder(_ controlOrder:Int) {
        self.controlOrder = controlOrder;
    }
    
    func getIsMobileHidden()->Int {
        return isMobileHidden;
    }
    
    func setIsMobileHidden(_ isMobileHidden:Int) {
        self.isMobileHidden = isMobileHidden;
    }
    
    func getIsInputScanner()->Int {
        return isInputScanner;
    }
    
    func setIsInputScanner(_ isInputScanner:Int) {
        self.isInputScanner = isInputScanner;
    }
    
    func getIsMoveToNextScanner() -> Bool {
        return isMoveToNextScanner
    }
    
    func setMoveToNextScanner(moveToNextScanner: Bool) {
        self.isMoveToNextScanner = moveToNextScanner
    }
    
    func getTextCd() ->String{
        return ""
    }
    
    func setTextCd(_ textCd: String){
        
    }
    
    func setPgmSeq(_ pgmSeq: String) {
        self.pgmSeq = pgmSeq
    }
    
    func getPgmSeq() -> String {
        return pgmSeq
    }
    
    func setHighlighted(_ highlighted:Bool){
        self.isHighlighted = highlighted
        if highlighted {
            visibilityUpdater?.showHighlight(self)
        }else {
            visibilityUpdater?.removeHighlight(self)
        }
    }
    
    func setCaptionObj(_ captionObj: String){
        
    }
    
    func getTextName() -> String {
        return ""
    }
    
    func setCodeHelp(_ codeHelp: String) {
        
    }
    
    func getCodeHelp() -> String {
        return ""
    }
    
    //17.02.19 script error
    func setCaptionCtlForeground(_ color:Int) {
        
    }
    
    func getPGetDataActiveNode() -> DataSet {
        return DataSet()
    }
    
    func setPMoveToSelectedItem(_ yn: Bool) {
        
    }
    
    func getCaptionObj() -> NSObject {
        return NSObject()
    }
    
    func setForeground(_ colorCode: Int){
        
    }
    
    //180327 hwon.kim 솔고바이오메디칼 손익계산서비교조회 5386
    func setDataSource(_ dataSet: AnyObject?) {
        
    }
    
    func setTextObj(_ value:AnyObject?) {
        
    }
    
    func getTextObj () -> AnyObject?{
        return "" as AnyObject
    }
    
    func controlKeyContainsHID() -> Bool {
        NSString(string: ControlKey).contains(HID) && !NSString(string: ControlKey).contains(XMHID)
    }
    
    //180717 hwon.kim
    //m_Form1.Background = GetBrush('#fff');
    //❌ Error in Javascript: Optional(TypeError: aKEditLabel890.setBackground is not a function. (In 'aKEditLabel890.setBackground(GetBrush(-1379875))', 'aKEditLabel890.setBackground' is undefined))
    func setBackground(_ value:Int) {
//        self.backgroundColor = YLWColorUtils.changeHexToUIColor(value, opacity: 1)
    }
    
    func setdataCtlForeground(_ color: Int) {
        textColor = color
        setNeedsDisplay()
    }

    func setdataCtlBackground(_ color: Int) {
        self.backgroundColor = YLWColorUtils.changeHexToUIColor(color, opacity: 1.0)
        setNeedsDisplay()
    }
    
    
    func setCustomPropsFromJSON(currCompMap: Dictionary<String, Any>?) {
        if controlKeyContainsHID() { return }
        
        setIsMobileHidden(currCompMap?[CustomPropertyConstants.IS_HIDDEN] as? Int ?? 0)
        scanAutoMove = currCompMap?[CustomPropertyConstants.SCAN_AUTO_MOVE] as? Int == 1
        setIsOnSameLine(currCompMap?[CustomPropertyConstants.IS_ON_SAME_LINE] as? Int ?? 0)
        setIsInputScanner(currCompMap?[CustomPropertyConstants.IS_INPUT_SCANNER] as? Int ?? 0)
        setMoveToNextScanner(moveToNextScanner: currCompMap?[CustomPropertyConstants.IS_INPUT_SCANNER] as? Int == 1)
        
        setControlOrder(currCompMap?[CustomPropertyConstants.CONTROL_ORDER] as? Int ?? 0)
        controlWidth = currCompMap?[CustomPropertyConstants.CONTROL_WIDTH] as? CGFloat ?? 1
        setCaption(ComponentGenerator.getCaptionForLanguage(map: currCompMap?[CustomPropertyConstants.CONTROL_CAPTION]) ?? getControlCaption())
        
        if let defValue = currCompMap?[CustomPropertyConstants.DEFAULT_VALUE] as? String, !defValue.isEmpty {
            setDefaultValue(defValue)
        }
        if let colorHexString = currCompMap?[CustomPropertyConstants.BACKGROUND_COLOR] as? String, !colorHexString.isEmpty {
            if colorHexString == CustomPropertyConstants.CLEAR {
                bgColor = .clear
            } else {
                bgColor = YLWColorUtils.changeHexToUIColor(YLWColorUtils.changeHexStringToInt(hex: colorHexString), opacity: 1.0)
            }
        }
        
//        if let txtColorString = currCompMap?[CustomPropertyConstants.TEXT_COLOR] as? String, !txtColorString.isEmpty {
//            textColor_readOnly = YLWColorUtils.changeHexStringToInt(hex: txtColorString)
//        }
        
        readOnlyIcon = UIImage(named: currCompMap?[CustomPropertyConstants.ICON] as? String ?? "")
        
        //IS_NEW_PAD_DESIGN
        controlHeight = currCompMap?[CustomPropertyConstants.CONTROL_HEIGHT_FACTOR] as? CGFloat ?? 1
        buttonType = currCompMap?[CustomPropertyConstants.BUTTON_TYPE] as? Int ?? 0
        emaphasis = currCompMap?[CustomPropertyConstants.EMPHASIS] as? Int == 1
        dataAlign = currCompMap?[CustomPropertyConstants.DATA_ALIGN] as? Int ?? 0
        if let direc = currCompMap?[CustomPropertyConstants.DATA_DIRECTION] as? Int {
            dataDirection = (direc == 2) ? Direction.horizontal : Direction.vertical
        }
        
        isFloatBoxInPad = currCompMap?[CustomPropertyConstants.ISNUMPERPADKEYBOARD] as? Int == 1
    }
    
    func getParentLayout() -> YLWLayout {
        var parent = superview
        while !(parent is YLWLayout) {
            parent = parent!.superview
        }
        return parent as! YLWLayout
    }
}

enum Direction: Int {
    case vertical = 1, horizontal = 2
}

//Derived CustomComponent class for UI draw operations
class YLWComponentDrawUI: YLWComponent {
    var Caption: String = ""
    var valuetoDisplay: String = ""
    
    var prevTextLength: Int = 0
    var readOnlyImageView: UIImageView?
    var isDisabled: Bool = false
    
    var icon: UIImage?
    
    var bigCaptionLabel: UILabel?
    var smallCaptionLabel: UILabel?
    let bigIcon_ratio: CGFloat = 3
    let smallIcon_ratio: CGFloat = 4.5
    
    //For YLWEditText
    var apiSeq: Int = 0
    var apiBtn: UIButton?
    
    //For YLWCodeHelp
    var selectedValues: [[String]] = []
    
    lazy var isReadOnly_and_fullWidth = controlWidth == 2 && (readOnlyIcon != nil || bgColor != nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        //Setting Background color
        if isDisabled {
            var color = YLWColorUtils.changeHexToUIColor(background_readOnly, opacity: 1)
            if bgColor != nil {
                color = bgColor!
            }
            let rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height)
            let path = UIBezierPath(rect: rect)
            color.setFill()
            path.fill()
        } else if longPressedListener != nil {
            longPressedFinger = ImageUtils.resizeImage(longPressedFinger, targetSize: CGSize(width: longPressFingerHeightWidth, height: longPressFingerHeightWidth))
            longPressedFinger.draw(in: CGRect(x: rect.width / 2 - longPressedFinger.size.width / 2, y: rect.height / 2 - longPressedFinger.size.height / 2, width: longPressFingerHeightWidth, height: longPressFingerHeightWidth), blendMode: .normal, alpha: longPressedFingerAlpha)
        }
        
        if lineColor == defaultLineColor {
            //Drawing border
            if !isDisabled {
                let offset = lineWidth/2
                let rectPath = UIBezierPath(rect: bounds.inset(by: UIEdgeInsets.init(top: offset, left: offset, bottom: offset, right: offset)))
                rectPath.lineWidth = lineWidth
                
                let color = emaphasis ? YLWColorUtils.getNewPadDesignThemeColor() : YLWColorUtils.changeHexToUIColor(lineColor, opacity: 0.5)
                color.setStroke()
                rectPath.stroke()
            }
        }
        
        //Center-Y point in component
        let centerY = rect.height/2 + 2
        //This is the rectangle for text which should be drawn, ie. UIValue or Text
        let textHeight = rect.height/2
        var textRect: CGRect = CGRect.zero
        if self is YLWEditText && apiSeq > 0 {
            //For YLWEditText
            textRect = CGRect(x: padding, y: centerY, width: rect.width - (2 * padding) - iconSize, height: textHeight)
        } else if icon != nil && !isDisabled {
            // For YLWDateField
            textRect = CGRect(x: padding, y: centerY, width: rect.width - iconSize - (1.5 * padding), height: textHeight)
        } else {
            textRect = CGRect(x: padding, y: centerY, width: rect.width - (2 * padding), height: textHeight)
        }
        
        if readOnlyIcon != nil && isDisabled && readOnlyImageView == nil {
            readOnlyImageView = UIImageView()
            readOnlyImageView!.image = readOnlyIcon
            readOnlyImageView!.contentMode = .scaleAspectFit
            addSubview(readOnlyImageView!)
        }
        
        //This is the rectangle for caption when there is no UIValue.
        let captionHeight: CGFloat = 20.0
        var bigCaption_Rect = CGRect(x: padding, y: centerY - captionHeight/2, width: 2 * rect.width/3, height: captionHeight)
        //This is the rectangle for caption when there is UIValue
        var smallCaption_Rect = CGRect(x: padding, y: centerY - padding/2 - captionHeight, width: rect.width - padding, height: captionHeight)
        
        //For YLWDateField
        if icon != nil && !isDisabled { //Control icon is not drawn in disabled field
            bigCaption_Rect.size.width = rect.width - iconSize - (1.5 * padding)
            //This is the rectangle for caption when there is UIValue
            smallCaption_Rect.size.width = rect.width - iconSize - (1.5 * padding)
        }
        
        //Condition check for components with the icons at the trailing
        if icon != nil && !isDisabled && readOnlyImageView == nil { //Control icon is not drawn in disabled field
            if dataDirection == .horizontal {
                //Draw componenet icon at the center-Y
                icon!.draw(in: CGRect(x: rect.width - iconSize - DimenConstants.standard_margin/2, y: (rect.height - icon!.size.height)/2, width: iconSize, height: iconSize))
            } else {
                if Caption.isEmpty {
                    //Draw componenet icon at center-Y
                    icon!.draw(in: CGRect(x: rect.width - iconSize - DimenConstants.standard_margin/2, y: (rect.height - icon!.size.height)/2, width: iconSize, height: iconSize))
                } else {
                    //Draw componenet icon little lower than center-Y
                    icon!.draw(in: CGRect(x: rect.width - iconSize - DimenConstants.standard_margin/2, y: textRect.minY - DimenConstants.standard_margin, width: iconSize, height: iconSize))
                }
            }
        }
        
        let iconPadding = self.readOnlyImageView == nil ? 0 : iconPadding_default
//        if valuetoDisplay != "" && Caption != "" {
//            //If control width is equal to 2 (i.e. full width) then draw big icon and caption otherwise draw small
//            if isReadOnly_and_fullWidth || dataDirection == .horizontal { //If caption-value alignment horizontal, draw BigCaption straight ahead
//                textRect.origin.y = bigCaption_Rect.origin.y + (bigCaption_Rect.height - textRect.height)/2
//                drawbigcaption(bigCaption_Rect)
//            } else {
//                drawcaption(smallCaption_Rect)
//            }
//        } else if (valuetoDisplay == "" && Caption != "") {
//            drawbigcaption(bigCaption_Rect)
//        } else {
//            drawcaption(smallCaption_Rect)
//        }
        
        if !Caption.isEmpty {
            drawbigcaption(bigCaption_Rect)
            drawcaption(smallCaption_Rect)
        }
        
        if dataDirection == .horizontal {
            self.bigCaptionLabel?.alpha = 1
            self.smallCaptionLabel?.alpha = 0
            self.bigCaptionLabel?.frame.origin = CGPoint(x: (self.readOnlyImageView?.frame.maxX ?? bigCaption_Rect.origin.x) + iconPadding, y: bigCaption_Rect.origin.y)
            self.readOnlyImageView?.center.y = bigCaption_Rect.height/2 + bigCaption_Rect.minY
        } else {
            self.bigCaptionLabel?.alpha = 0
            self.smallCaptionLabel?.alpha = 1

            self.bigCaptionLabel?.frame.origin = smallCaption_Rect.origin
            
            self.smallCaptionLabel?.frame.origin = CGPoint(x: (self.readOnlyImageView?.frame.maxX ?? smallCaption_Rect.origin.x) + iconPadding, y: smallCaption_Rect.origin.y)
            self.readOnlyImageView?.center.y = smallCaption_Rect.height/2 + smallCaption_Rect.minY
        }
        
        if valuetoDisplay.isEmpty && selectedValues.count == 0 { //selectedValues for YLWCodeHelp, and whose count is zero because its non-existent for other components. Also, keep bigCaptionLabel to centerY only when data direction value is 2
//            if prevTextLength != 0 {
//                if isRequired && !isDisabled {
//                    smallCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_essentialSmall, opacity: 1)
//                } else {
//                    if isDisabled {
//                        smallCaptionLabel?.textColor = .black //YLWColorUtils.changeHexToUIColor(textColor_readOnly, opacity: 1)
//                    } else{
//                        smallCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_normalSmall, opacity: 1)
//                    }
//                }
//
////                UIView.animate(withDuration: 0.5, animations: {
////                    self.smallCaptionLabel?.frame.origin = CGPoint(x: textRect.origin.x + (self.readOnlyImageView?.frame.maxX ?? 0.0) + iconPadding, y: textRect.origin.y)
////                    self.smallCaptionLabel?.alpha = 0
////
////                    self.bigCaptionLabel?.frame.origin = CGPoint(x: bigCaption_Rect.origin.x + (self.readOnlyImageView?.frame.maxX ?? 0.0) + iconPadding, y: bigCaption_Rect.origin.y)
////                    self.readOnlyImageView?.center.y = self.bigCaptionLabel!.center.y
////                    self.bigCaptionLabel?.alpha = 1
////                })
//            }
            prevTextLength = 0
            
            //2021/03/19 - previously 'bigCaptionLabel' textColor setting code was present, later added 'smallCaptionLabel' textColor setting code inside all conditions, also commented above 'smallCaptionLabel' textColor setting codes
            if isRequired && !isDisabled {
                bigCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_essentialBig, opacity: 1)
                smallCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_essentialSmall, opacity: 1)
            }else{
                if isDisabled {
                    bigCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(textColor_readOnly, opacity: 1)
                    smallCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(textColor_readOnly, opacity: 1)
                } else{
                    bigCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_normalBig, opacity: 1)
                    smallCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_normalSmall, opacity: 1)
                }
            }
        } else {
//            if prevTextLength == 0 {
//                if isRequired && !isDisabled {
//                    bigCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_essentialBig, opacity: 1)
//                } else {
//                    if isDisabled {
//                        bigCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(textColor_readOnly, opacity: 1)
//                    } else {
//                        bigCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_normalBig, opacity: 1)
//                    }
//                }
//
////                if dataDirection == .horizontal {
////                    self.bigCaptionLabel?.frame.origin = CGPoint(x: bigCaption_Rect.origin.x + (self.readOnlyImageView?.frame.maxX ?? 0.0) + iconPadding, y: bigCaption_Rect.origin.y)
////                    self.readOnlyImageView?.center.y = bigCaption_Rect.height/2 + bigCaption_Rect.minY
////                    textRect.origin.y = bigCaption_Rect.origin.y + (bigCaption_Rect.height - textRect.height)/2
////                } else {
////                    self.smallCaptionLabel?.frame.origin = textRect.origin
////                    self.bigCaptionLabel?.frame.origin = textRect.origin
////
//////                    UIView.animate(withDuration: 0.5, animations: {
////                        self.bigCaptionLabel?.frame.origin = smallCaption_Rect.origin
////                        self.bigCaptionLabel?.alpha = 0
////
////                        self.smallCaptionLabel?.frame.origin = CGPoint(x: smallCaption_Rect.origin.x + (self.readOnlyImageView?.frame.maxX ?? 0.0) + iconPadding, y: smallCaption_Rect.origin.y)
////                        self.readOnlyImageView?.center.y = smallCaption_Rect.height/2 + smallCaption_Rect.minY
////                        self.smallCaptionLabel?.alpha = 1
//////                    })
////                }
//            }
            
            //2021/03/19 - previously 'smallCaptionLabel' textColor setting code was present, later added 'bigCaptionLabel' textColor setting code inside all conditions, also commented above 'bigCaptionLabel' textColor setting codes
            if isRequired && !isDisabled {
                smallCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_essentialSmall, opacity: 1)
                bigCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_essentialBig, opacity: 1)
            } else{
                if isDisabled {
                    smallCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(textColor_readOnly, opacity: 1)
                    bigCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(textColor_readOnly, opacity: 1)
                } else{
                    smallCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_normalSmall, opacity: 1)
                    bigCaptionLabel?.textColor = YLWColorUtils.changeHexToUIColor(captionColor_normalBig, opacity: 1)
                }
            }
            
            //Finally, drawing value text for component
            if self is YLWCodeHelp {
                var drawValue = ""
                if selectedValues.count == 0 {
                    drawValue = valuetoDisplay
                }else if selectedValues.count > 1 {
                    drawValue = "\(selectedValues.count) items selected"
                }else {
                    drawValue = selectedValues[0][0]
                }
                
                if isDisabled {
                    drawText(textRect, text: drawValue, color: textColor ?? textColor_readOnly)
                }else{
                    drawText(textRect, text: drawValue, color: textColor ?? purpleTheme)
                }
            } else if self is YLWComboBox {
                var comboVal = ""
                if selectedValues.count > 1 {
                    comboVal = "\(selectedValues.count) Value selected"
                }else if selectedValues.count == 1 {
                    comboVal = selectedValues[0][1]
                }else {
                    comboVal = valuetoDisplay
                }
                if isDisabled {
                    if !comboVal.isEmpty {
                        drawText(textRect, text: comboVal, color: textColor ?? textColor_readOnly)
                    }else {
                        drawText(textRect, text: "", color: textColor ?? textColor_readOnly)
                    }
                }else{
                    if !comboVal.isEmpty {
                        drawText(textRect, text: comboVal, color: textColor ?? purpleTheme)
                    }else {
                        drawText(textRect, text: "", color: textColor ?? purpleTheme)
                    }
                }
                prevTextLength = comboVal.count
            } else {
                if isDisabled {
                    drawText(textRect, text: valuetoDisplay, color: textColor ?? textColor_readOnly)
                } else{
                    drawText(textRect, text: valuetoDisplay, color: textColor ?? purpleTheme)
                }
            }
            prevTextLength = valuetoDisplay.count
        }
        
        if apiBtn != nil {
            apiBtn!.frame = CGRect(x: self.frame.width - padding - iconSize, y: (self.frame.height - iconSize) / 2, width: iconSize, height: iconSize)
        }
    }
    
    func drawbigcaption(_ rect: CGRect){
        let iconPadding = readOnlyImageView == nil ? 0 : iconPadding_default
        readOnlyImageView?.frame = CGRect(x: rect.origin.x - 2, y: rect.origin.y, width: customIconSize, height: customIconSize)
        if bigCaptionLabel == nil {
            // set the font to Helvetica Neue 18
            let fieldFont = UIFont(name: "Helvetica Neue", size: DimenConstants.Component_BigCaptionTextSize * Utils.getScale())
            
            bigCaptionLabel = UILabel(frame: CGRect(x: (readOnlyImageView?.frame.maxX ?? rect.origin.x) + iconPadding, y: rect.origin.y, width: rect.width - ((readOnlyImageView?.frame.maxX ?? 0) + iconPadding), height: rect.height))
            bigCaptionLabel!.text = Caption
            bigCaptionLabel!.font = fieldFont
            bigCaptionLabel!.lineBreakMode = .byTruncatingTail
            self.addSubview(bigCaptionLabel!)
        }
        readOnlyImageView?.center.y = bigCaptionLabel!.center.y
    }
    
    func drawcaption(_ rect: CGRect){
        let iconPadding = readOnlyImageView == nil ? 0 : iconPadding_default
        readOnlyImageView?.frame = CGRect(x: rect.origin.x - 2, y: rect.origin.y, width: customIconSize, height: customIconSize)
        if smallCaptionLabel == nil {
            // set the font to Helvetica Neue 18
            let fieldFont = UIFont(name: "Helvetica Neue", size: DimenConstants.Component_CaptionTextSize * Utils.getScale())
            
            smallCaptionLabel = UILabel(frame: CGRect(x: (readOnlyImageView?.frame.maxX ?? rect.origin.x) + iconPadding, y: rect.origin.y, width: rect.width - ((readOnlyImageView?.frame.maxX ?? 0) + iconPadding), height: rect.height))
            smallCaptionLabel!.text = Caption
            smallCaptionLabel!.font = fieldFont
            smallCaptionLabel!.lineBreakMode = .byTruncatingTail
            self.addSubview(smallCaptionLabel!)
        }
        readOnlyImageView?.center.y = smallCaptionLabel!.center.y
    }
    
    func drawText(_ rect: CGRect, text: String, color: Int){
        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Helvetica Neue", size: DimenConstants.Component_TextSize * Utils.getScale())
        
        var s: NSString = text as NSString
        if self is YLWPasswordField {
            s = String(text.map({ _ in "●" })) as NSString
        }
        
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        textLabel.text = s as String
        textLabel.font = fieldFont
        let bounds = textLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), limitedToNumberOfLines: 1)
       
        // set the text color
        var fieldColor = YLWColorUtils.changeHexToUIColor(color, opacity: 1)
        
        //If NEW_PAD_DESIGN Enabled, change value-text color on the basis of Emphasis property
        if !isDisabled && emaphasis {
            fieldColor = YLWColorUtils.getNewPadDesignThemeColor()
        }
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        if (lineColor == focusedLineColor) && !(self is YLWComboBox) {
            paraStyle.lineBreakMode = NSLineBreakMode.byTruncatingHead
        }else{
            paraStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        }
        
        // set the Obliqueness to 0.0
        let skew = 0.0
        let attributes: NSDictionary = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): fieldColor,
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paraStyle,
            convertFromNSAttributedStringKey(NSAttributedString.Key.obliqueness): skew,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): fieldFont!,
        ]
        
        if dataDirection == .horizontal {
            //If data direction value is 2 draw value text at the end before component icon
            var xCoordinate: CGFloat = 0
            //Saving previous BigCaption height because sizeToFit() is called on it which changes the height and width of caption label to actual, but we're keeping just the actual width and reverting height to previous
            let prevHeight = bigCaptionLabel?.frame.height ?? 0
            bigCaptionLabel?.sizeToFit()
            bigCaptionLabel?.frame.size.height = prevHeight
            let trailingIcon_spacing = (icon != nil && !isDisabled ? (iconSize + padding) : 0)
            
            if dataAlign == 1 {
                //Data align left
                xCoordinate = (bigCaptionLabel?.frame.maxX ?? 0) + padding
            }  else {
                //Data align right (default)
                xCoordinate = frame.width - bounds.width - padding - trailingIcon_spacing
                let minXcheck = (bigCaptionLabel?.frame.maxX ?? 0) + padding
                if xCoordinate < minXcheck {
                    xCoordinate = minXcheck
                }
            }
            
            let rectToDraw = CGRect(x: xCoordinate, y: (frame.height - bounds.height)/2, width: frame.width - xCoordinate - trailingIcon_spacing, height: rect.height)
            s.draw(in: rectToDraw, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(attributes as? [String : AnyObject]))
        } else {
//            if isReadOnly_and_fullWidth || self is YLWFloatBox {
//                var xCoordinate = padding
//                if frame.width - bounds.width - padding > padding {
//                    xCoordinate = frame.width - bounds.width - padding
//                }
//                let rectToDraw = CGRect(x: xCoordinate, y: rect.origin.y, width: bounds.width, height: rect.height)
//                s.draw(in: rectToDraw, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(attributes as? [String : AnyObject]))
//            } else {
                //Data direction VERTICAL
                var rectToDraw = rect
                if Caption.isEmpty {
                rectToDraw.origin.y = (frame.height - bounds.height)/2
                }
                s.draw(in: rectToDraw, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(attributes as? [String : AnyObject]))
//            }
        }
    }
}

