'From Cuis 4.2 of 25 July 2013 [latest update: #2243] on 19 April 2015 at 8:17:18.841865 pm'!
'Description Color Editor/Picker'!
!provides: 'Morphic-ColorEditor' 1 15!
!requires: 'Cuis-Base' 42 2198 nil!
!requires: 'CSS3-NamedColors' 1 0 nil!
!requires: 'Morphic-Misc1' 1 15 nil!
!requires: 'Graphics-Files-Additional' 1 nil nil!
!classDefinition: #ColorEditorModel category: #'Morphic-ColorEditor'!
Object subclass: #ColorEditorModel
	instanceVariableNames: 'color'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-ColorEditor'!
!classDefinition: 'ColorEditorModel class' category: #'Morphic-ColorEditor'!
ColorEditorModel class
	instanceVariableNames: ''!

!classDefinition: #ColorEditorPanel category: #'Morphic-ColorEditor'!
Panel subclass: #ColorEditorPanel
	instanceVariableNames: 'colorPane colorSwatch sliderColumn closeColorSwatch closeColorLabel closestRGB radioSelection rgbRadio hsvRadio closestColordictColor rgbString'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-ColorEditor'!
!classDefinition: 'ColorEditorPanel class' category: #'Morphic-ColorEditor'!
ColorEditorPanel class
	instanceVariableNames: ''!

!classDefinition: #ColorPallet category: #'Morphic-ColorEditor'!
ImagePallet subclass: #ColorPallet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-ColorEditor'!
!classDefinition: 'ColorPallet class' category: #'Morphic-ColorEditor'!
ColorPallet class
	instanceVariableNames: ''!

!classDefinition: #ColorPaneMorph category: #'Morphic-ColorEditor'!
ImageMorph subclass: #ColorPaneMorph
	instanceVariableNames: 'zeroPlaneForm zIndex zValue colorPoint focusMorph'
	classVariableNames: 'BlueIndex BrightnessForm BrightnessIndex BrightnessOverlay GBForm GreenIndex HueIndex HueOverlay RBForm RGForm RedIndex SaturationForm SaturationIndex SaturationOverlay'
	poolDictionaries: ''
	category: 'Morphic-ColorEditor'!
!classDefinition: 'ColorPaneMorph class' category: #'Morphic-ColorEditor'!
ColorPaneMorph class
	instanceVariableNames: ''!

!classDefinition: #ColorSliderMorph category: #'Morphic-ColorEditor'!
ImageMorph subclass: #ColorSliderMorph
	instanceVariableNames: 'colorPane sliderMorph maxZValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-ColorEditor'!
!classDefinition: 'ColorSliderMorph class' category: #'Morphic-ColorEditor'!
ColorSliderMorph class
	instanceVariableNames: ''!


!ColorEditorModel commentStamp: '<historical>' prior: 0!
I am the model (state holder) for a ColorEditor.!

!ColorEditorPanel commentStamp: '<historical>' prior: 0!
I present the ColorEditor UI

Usage: 
	ColorEditorPanel open.
	ColorEditorPanel openColor: Color forestGreen.!

!ColorPallet commentStamp: '<historical>' prior: 0!
I am just a way to get a Color pallet.  See my class side.!

!ColorPaneMorph commentStamp: '<historical>' prior: 0!
I present a plane in a color cube.

The x and y selectors map to a 256 x 256 plane (slice of a 3d cube) with a constant z.
	o-------> X
	|
	|				X and Y coordinates are as per Smalltalk view coordinates 
	v                    (y increasing downward)
	Y
The z value is "mixed in" to give a (x,y,z) color plane. [see #refreshForm]

The selected color point (x,y) is visually noted by a focusMorph "ring".
One may click on the pane to update the colorPoint.
Click and hold to pick up a color swatch.
The z value corresponds to the slider/scroller position mapped to the range:
	R/G/B       0..255
	Hue          0..360 (degrees)
	Sat/Bright 0..100 (%).

Note that RGB are additive colors.   
  E.g. for (x,y)=(red,blue);z=green 
  The "background" varies over r&b and a fixed g overlay is added.
HSV is more complex
  Basically an alpha is used to blend background and overlay.

See ColorPaneMorph>>refreshForm and 
	ColorPaneMorph class>>make*Form  and 
	>>make*Overlay  methods for details!

!ColorSliderMorph commentStamp: '<historical>' prior: 0!
I am a slider (a kind of ScrollBar) which shows a color range as a background.

The associated ColorPane has a Focus Color (x,y) at constant z.
This pane shows the range of color of z at the focus point -- constant (x,y)
!

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/22/2013 20:53'!
blue
	"Answer my blue component 0..255"

	^ (self color blue * 255) rounded! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 16:42'!
blue: zeroTo255

	self setColor: (Color 
		r: self color red
		g: self color green
		b: (zeroTo255 / 255) asFloat)! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/25/2013 18:52'!
blueFactor
	"Answer my blueness 0..1"

	^ self color blue! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/24/2013 19:05'!
blueFactor: zeroToOne

	self setColor: (Color 
		r: self color red
		g: self color green
		b: (zeroToOne * 255 / 255) asFloat)! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 16:44'!
brightness
	"Answer percent brightness"

	^ (self color brightness * 100) rounded! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 16:43'!
brightness: aPercent

	self setColor: (Color
		h: self color hue
		s: self color saturation
		v: (aPercent / 100) asFloat)! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/25/2013 18:53'!
brightnessFactor
	"Answer my brightness 0..1"

	^ self color brightness! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/24/2013 19:04'!
brightnessFactor: zeroToOne

	self setColor: (Color
		h: self color hue
		s: self color saturation
		v: zeroToOne asFloat)! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 15:54'!
color

	^ color! !

!ColorEditorModel methodsFor: 'initialization' stamp: 'KenD 11/19/2013 19:09'!
defaultColor

	^ Color teal
	! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/22/2013 20:53'!
green
	"Answer my green component 0..255"

	^ (self color green * 255) rounded! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 16:41'!
green: zeroTo255

	self setColor: (Color 
		r: self color red
		g: (zeroTo255 / 255) asFloat 
		b: self color blue)! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/25/2013 18:51'!
greenFactor
	"Answer my greenness 0..1"

	^ self color green! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/27/2013 20:09'!
greenFactor: zeroToOne

	self setColor: (Color 
		r: self color red
		g: (zeroToOne * 255 / 255) asFloat 
		b: self color blue)! !

!ColorEditorModel methodsFor: 'printing' stamp: 'jmv 2/13/2014 13:42'!
hexStringRGB
	"Answer my RGB as hex but with no 16r prefix"

"	^ (self red    printPaddedWith: $0 to: 2 base: 16) , 
	  (self green printPaddedWith: $0 to: 2 base: 16) , 
	  (self blue   printPaddedWith: $0 to: 2 base: 16)
	"
	^ self color hexStringRGB! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 16:44'!
hue
	"Answer my hue 0..360 (degrees)"

	^ self color hue rounded! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 16:40'!
hue: zeroTo360

	self setColor: (Color 
		h: zeroTo360
		s: (self color saturation) 
		v: (self color brightness) )! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/25/2013 18:55'!
hueFactor
	"Answer my hue 0..1"

	^ (self color hue / 360) asFloat! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/24/2013 19:02'!
hueFactor: zeroToOne

	self setColor: (Color 
		h: (zeroToOne * 360) asFloat
		s: (self color saturation) 
		v: (self color brightness) )! !

!ColorEditorModel methodsFor: 'initialization' stamp: 'KenD 11/23/2013 15:55'!
initialize

	super initialize.
	self setColor: self defaultColor.
	! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/22/2013 20:53'!
red
	"Answer my red component 0..255"

	^ (self color red * 255) rounded! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 16:42'!
red: zeroTo255

	self setColor: (Color 
		r: (zeroTo255 / 255) asFloat 
		g: self color green 
		b: self color blue)! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/25/2013 18:51'!
redFactor
	"Answer my redness 0..1"

	^ self color red! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/24/2013 19:06'!
redFactor: zeroToOne

	self setColor: (Color 
		r: (zeroToOne * 255 / 255) asFloat 
		g: self color green 
		b: self color blue)! !

!ColorEditorModel methodsFor: 'printing' stamp: 'jmv 2/13/2014 13:45'!
rgbValue
	"Answer my RGB as an integer"

	^ ( '16r',  self color hexStringRGB) asNumber! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 16:45'!
saturation
	"Answer my percent saturation"

	^ (self color saturation * 100) rounded! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 16:42'!
saturation: aPercent

	self setColor: (Color 
		h: (self color hue) 
		s: (aPercent / 100) asFloat
		v: (self color brightness) )! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/25/2013 18:56'!
saturationFactor
	"Answer my saturation 0..1"

	^ self color saturation ! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/24/2013 19:01'!
saturationFactor: zeroToOne

	self setColor: (Color 
		h: (self color hue) 
		s: zeroToOne asFloat
		v: (self color brightness) )! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 11/23/2013 20:59'!
setColor: aColor
	"Set my color and trigger #colorChanged passing me (the model)"
	
	(color == aColor) ifTrue: [ ^self ].
	color := aColor.
	self triggerEvent: #colorChanged with: self.
	^ self

! !

!ColorEditorModel methodsFor: 'accessing' stamp: 'KenD 12/2/2013 16:24'!
setRGBColorFromInteger: anInteger
	"Set my color from integer interpreted as RGB value"
	
	| aColor |
	aColor := Color 
					r: ((anInteger bitShift: -16) bitAnd: 255)	/ 255
					g: ((anInteger bitShift: -8) bitAnd: 255) / 255
					b: (anInteger bitAnd: 255) / 255.
			
	^ self setColor: aColor

! !

!ColorEditorModel class methodsFor: 'instance creation' stamp: 'KenD 11/23/2013 15:55'!
color: aColor

	^ self new setColor: aColor! !

!ColorEditorPanel methodsFor: 'GUI building' stamp: 'KenD 12/23/2013 13:20'!
buildColorPaneColumn

	| colorPaneColumn selector |
	selector := self defaultRadioSelector asLowercase asSymbol.
	colorPane := (ColorPaneMorph 
								zSelector: self defaultRadioSelector 
								zValue:  (self model perform: selector)
								colorPoint: 10@10).
	colorPane updateColorFromModel: self model;
		layoutSpec: (LayoutSpec fixedWidth: 256 
										fixedHeight: 256 
										minorDirectionPadding: #top).
	colorPane when: #colorChanged send: #updateColorFromPane to: self.
	colorPaneColumn := LayoutMorph newColumn.
	colorPaneColumn 
		separation: 6;
		addMorph: colorPane.
	
	^ colorPaneColumn ! !

!ColorEditorPanel methodsFor: 'GUI building' stamp: 'KenD 4/19/2015 19:39'!
buildMorphicWindow
	"Create a useful ColorEditor window"
	
	self layoutMorph beRow; " A row of columns"
		 separation: 2;
		 addMorph: self buildColorPaneColumn;
			 layoutSpec: (LayoutSpec 
							fixedWidth: 256 
							fixedHeight: 256 
							minorDirectionPadding: #top);
		 addMorph: self buildSliderColumn
			 layoutSpec: (LayoutSpec 
							fixedWidth: (AbstractFont default 
										widthOfString: 'brightness') "longest string"
							fixedHeight: 256 
							minorDirectionPadding: #left);
		 addMorph: self buildRadioButtonColumn
			 layoutSpec: (LayoutSpec 
							fixedWidth: 200
							proportionalHeight: 0.9
							minorDirectionPadding: #top);
		layoutSpec: (LayoutSpec keepMorphExtent).
		
	self model when: #colorChanged send: #refreshColor to: self.
	
	^ self
! !

!ColorEditorPanel methodsFor: 'GUI building' stamp: 'KenD 12/26/2013 11:39'!
buildRadioButtonColumn

	| radioCol setupEntryMorph valueEntryMorph hexDisplayLayout |
	rgbRadio := RadioGroup fromList: #(Red Green Blue).
	hsvRadio := RadioGroup fromList: #(Hue Saturation Brightness).
	rgbRadio when: #informRadioSelection send: #newRadioSelection: to: self.
	hsvRadio when: #informRadioSelection send: #newRadioSelection: to: self.
	setupEntryMorph := [ :sym :entryMorph | | selector |
		selector := sym asLowercase asSymbol.
		entryMorph valueAccessor: [ :myModel | myModel perform: selector ].
		entryMorph valueUpdator: [ :myValue | 
					self model perform: ( selector , ':' ) asSymbol with: myValue ].
		entryMorph refreshValueFrom: self model.
		self model when: #colorChanged 
			send: #refreshValueFrom: 
			to: entryMorph.
	].
	
	#(Red Green Blue) do: [ :sym | | entryMorph |
		entryMorph := SimpleNumberEntryMorph rgbOneOf.
		setupEntryMorph value: sym value: entryMorph.
		(rgbRadio rowFor: sym) addMorph: entryMorph.
	].
	valueEntryMorph := SimpleNumberEntryMorph circleDegreesExact.
	setupEntryMorph value: #Hue value: valueEntryMorph.
	(hsvRadio rowFor: #Hue) 
		addMorph: valueEntryMorph;
		addMorph: (StringMorph contents: ' deg')
			layoutSpec: (LayoutSpec 
							fixedWidth: 36 
							fixedHeight: 20
							minorDirectionPadding: #center).
.
	#(Saturation Brightness) do:  [ :sym | | entryMorph |
		entryMorph := SimpleNumberEntryMorph percentExact.
		setupEntryMorph value: sym value: entryMorph.
		(hsvRadio rowFor: sym) 
			addMorph: entryMorph;
			addMorph: (StringMorph contents: ' %') 
				layoutSpec: (LayoutSpec 
					fixedWidth: 20 
					fixedHeight: 20
					minorDirectionPadding: #center).
	].
	(rgbRadio buttonFor: self defaultRadioSelector) select.
	
	hexDisplayLayout := LayoutMorph newRow.
	hexDisplayLayout 
		addMorph: (StringMorph new contents: '16r') 
			layoutSpec: (LayoutSpec keepMorphExtent);
		addMorph: self rgbString 
			layoutSpec: (LayoutSpec keepMorphExtent);
		addMorph: (StringMorph new contents: ' hexRGB') 
			layoutSpec: (LayoutSpec keepMorphExtent).

	self rgbString 
		valueAccessor: [ :myModel | myModel rgbValue ];
		valueUpdator: [ :myValue | self model setRGBColorFromInteger: myValue ];
		refreshValueFrom: self model.
	self model when: #colorChanged send: #refreshValueFrom: to: rgbString.

	radioCol := LayoutMorph newColumn.
	^ radioCol 
		separation: 6;
		addMorph: rgbRadio;
		addMorph: hsvRadio;
		addMorph: self buildSwatchLayout
			layoutSpec: (LayoutSpec
						 proportionalWidth: 1
						 fixedHeight: 68
						 minorDirectionPadding: #top);
		addMorph: hexDisplayLayout;
		yourself
	! !

!ColorEditorPanel methodsFor: 'GUI building' stamp: 'KenD 12/5/2013 19:53'!
buildSliderColumn

	sliderColumn := LayoutMorph newColumn.
	self resetSliderColumn: self defaultRadioSelector.
	
	^ sliderColumn 

	! !

!ColorEditorPanel methodsFor: 'GUI building' stamp: 'KenD 4/19/2015 20:15'!
buildSwatchLayout
	"Display swatch of current color and closest named color"

	| swatchLayout subLayout simpleSpec |
	closeColorSwatch := DropColorMorph fromColor: model color.
	closeColorLabel   := StringMorph new contents: ''.
	simpleSpec := LayoutSpec keepMorphExtent.
	simpleSpec minorDirectionPadding: #left.
	subLayout := LayoutMorph newColumn.
	subLayout
		separation: 4;
		padding: #top;
		addMorph: closestRGB        layoutSpec: simpleSpec;
		addMorph: closeColorLabel layoutSpec: simpleSpec.

	swatchLayout := LayoutMorph newRow.
	^ swatchLayout 
"		setProperty: #allowsSubmorphDrag toValue: #allowsSubmorphDrag;"
		addMorph: self colorSwatch 
			layoutSpec: (LayoutSpec proportionalWidth: 0.4
							proportionalHeight:  0.9
							minorDirectionPadding: #bottom);
		addMorph: closeColorSwatch 
			layoutSpec: (LayoutSpec fixedWidth: 20
							proportionalHeight: 1.0
							minorDirectionPadding: #bottom);
		addMorph: subLayout 
			layoutSpec: (LayoutSpec proportionalWidth: 0.6
							proportionalHeight: 1.0
							minorDirectionPadding: #top);
		yourself
	! !

!ColorEditorPanel methodsFor: 'private' stamp: 'KenD 11/26/2013 21:27'!
colorPane

	^ colorPane ! !

!ColorEditorPanel methodsFor: 'private' stamp: 'KenD 11/19/2013 21:15'!
colorSwatch

	^ colorSwatch! !

!ColorEditorPanel methodsFor: 'initialization' stamp: 'KenD 11/23/2013 17:09'!
colorSwatchExtent

	^ 64 @ 64! !

!ColorEditorPanel methodsFor: 'initialization' stamp: 'KenD 12/24/2013 08:48'!
defaultExtent

	^ 570@330! !

!ColorEditorPanel methodsFor: 'initialization' stamp: 'KenD 11/24/2013 18:58'!
defaultRadioSelector

	^ #Green! !

!ColorEditorPanel methodsFor: 'private' stamp: 'KenD 11/19/2013 21:14'!
hsvRadio

	^ hsvRadio! !

!ColorEditorPanel methodsFor: 'initialization' stamp: 'KenD 12/24/2013 16:19'!
initialExtent

	^ self defaultExtent! !

!ColorEditorPanel methodsFor: 'initialization' stamp: 'KenD 12/25/2013 08:05'!
initialize

	super initialize.
	self
		color: Color white;
		addCloseBox;
		addCollapseBox.
	model          := ColorEditorModel new.
	colorSwatch := DropColorMorph fromColor: model color.
	rgbString     := SimpleNumberEntryMorph hexRGBEntry.
	closestRGB  := StringMorph new contents: ''.
	self refreshColorSwatch.

	! !

!ColorEditorPanel methodsFor: 'initialization' stamp: 'KenD 12/24/2013 08:36'!
minimumExtent

	^ 570@330! !

!ColorEditorPanel methodsFor: 'events-processing' stamp: 'KenD 11/27/2013 15:00'!
newRadioSelection: selectionSymbol

	"Only one radio group can be selected at a time"
	( #(Red, Green, Blue) includes: selectionSymbol ) 
		ifTrue: [ self hsvRadio unselectAll ].
	( #(Hue Saturation Brightness) includes: selectionSymbol ) 
		ifTrue: [ self rgbRadio unselectAll ].
		
	self resetSliderColumn: selectionSymbol.
	self colorPane fromModel: self model selector: selectionSymbol.
	self colorPane resetFocus.

	
	! !

!ColorEditorPanel methodsFor: 'initialization' stamp: 'KenD 12/24/2013 16:18'!
openInWorld: aWorld extent: extent
	"Open me in the current world"
	
	aWorld addMorph: self.
	self morphPosition: (RealEstateAgent initialFrameFor: self world: aWorld) 
		 	topLeft; morphExtent: extent.
	aWorld startSteppingSubmorphsOf: self.
! !

!ColorEditorPanel methodsFor: 'color updating' stamp: 'jmv 2/13/2014 13:43'!
refreshCloseColor
	"model color has changed.  Refresh my views."
	
	| closeAssoc closeColor |
	closeAssoc := self model color closestAssocFrom: Color css3ColorDictionary.
	closeColor := closeAssoc value.
	closeColorSwatch 
		image: (closeColor iconOrThumbnailOfSize: 32);
		color: closeColor.
	closeColorLabel 
		contents: closeAssoc key asString; 
		fitContents.
	closestRGB 
		contents: '16r', (closeColor hexStringRGB);
		fitContents! !

!ColorEditorPanel methodsFor: 'color updating' stamp: 'KenD 12/5/2013 21:57'!
refreshColor
	"model color has changed.  Refresh my views."
	
	self 
		refreshColorSwatch;
		refreshColorPane;
		refreshCloseColor! !

!ColorEditorPanel methodsFor: 'color updating' stamp: 'KenD 11/27/2013 14:43'!
refreshColorPane
	"When selector changes.."

	self colorPane updateColorFromModel: self model.! !

!ColorEditorPanel methodsFor: 'color updating' stamp: 'KenD 11/30/2013 19:38'!
refreshColorSwatch
	"When color changes"
	
	colorSwatch image: (model color iconOrThumbnailOfSize: self colorSwatchExtent).
	colorSwatch color: self model color! !

!ColorEditorPanel methodsFor: 'GUI building' stamp: 'KenD 12/24/2013 16:27'!
resetSliderColumn: sliderSym
	"Radio selector changed.."

	| scrollBar sliderLabel |
	"#(Red Green Blue Hue Saturation Brightness) inclides: sliderSym"
	scrollBar := ColorSliderMorph colorPane: self colorPane.
	
	(self sliderColumn submorphs 
					detect: [ :s | s class == ColorSliderMorph ] 
					ifNone: [ nil ]) 
		ifNotNil: [ :sb | self colorPane removeDependent: sb ].
		
	self colorPane when: #colorChanged send: #refreshColorFromModel to: scrollBar.
	self colorPane when: #resetFocus send: #redrawBackground to: scrollBar.

	sliderLabel := sliderSym asString.
	
	^self sliderColumn 
		removeAllMorphs;
		separation: 6;
		layoutSpec: (LayoutSpec 
						fixedWidth: 4 + (AbstractFont default 
												widthOfString: 'brightness') "longest string"
						fixedHeight: 256  
						minorDirectionPadding: #center);
		addMorph: scrollBar;
		addMorph: (LabelMorph contents: sliderLabel font: AbstractFont default)
			layoutSpec: (LayoutSpec keepMorphExtent);
		yourself
	! !

!ColorEditorPanel methodsFor: 'private' stamp: 'KenD 11/19/2013 21:14'!
rgbRadio

	^ rgbRadio! !

!ColorEditorPanel methodsFor: 'private' stamp: 'KenD 11/24/2013 08:48'!
rgbString
	"Answer my rgbString StringMorph"
	^ rgbString! !

!ColorEditorPanel methodsFor: 'initialization' stamp: 'KenD 11/24/2013 17:08'!
setColor: aColor

	self model setColor: aColor.
	self refreshColorSwatch.
"	self triggerEvent: #colorChange.  @@useful??@@"! !

!ColorEditorPanel methodsFor: 'private' stamp: 'KenD 11/25/2013 19:12'!
sliderColumn

	^ sliderColumn! !

!ColorEditorPanel methodsFor: 'events-processing' stamp: 'KenD 11/27/2013 16:02'!
updateColorFromPane
	"Someone changed color in colorPane.  Update my model"
	
	self model setColor: self colorPane focusColor! !

!ColorEditorPanel class methodsFor: 'initialization' stamp: 'KenD 12/24/2013 09:26'!
defaultColor

	^ Color  r: 16r40/255 g: 16rA5/255 b: 16rD0/255.! !

!ColorEditorPanel class methodsFor: 'initialization' stamp: 'KenD 12/24/2013 09:04'!
defaultExtent

	^ 570@330! !

!ColorEditorPanel class methodsFor: 'new-morph participation' stamp: 'KenD 12/6/2013 19:09'!
includeInNewMorphMenu
	"Return true for all classes that can be instantiated from the menu"
	
	^ true! !

!ColorEditorPanel class methodsFor: 'instance creation' stamp: 'KenD 12/6/2013 19:10'!
initializedInstance

	|  window |
	window _ self new.
	^ window
		model: (ColorEditorModel new);
		buildMorphicWindow;
		setLabel: 'Color Editor';
		setColor: self defaultColor ;
		morphExtent: self defaultExtent;
		yourself
! !

!ColorEditorPanel class methodsFor: 'instance creation' stamp: 'KenD 11/24/2013 16:47'!
open
"
	self open.
"	
	^ self openColor: self defaultColor! !

!ColorEditorPanel class methodsFor: 'instance creation' stamp: 'KenD 11/24/2013 09:21'!
openColor: aColor
"
	self openColor: Color purple.
	self openColor: Color forestGreen.
"	
	|  window |
	window _ self new.
	^ window
		model: (ColorEditorModel new);
		buildMorphicWindow;
		setLabel: 'Color Editor';
		setColor: aColor;
		openInWorld: self runningWorld extent: self defaultExtent;
		yourself
! !

!ColorPallet class methodsFor: 'new-morph participation' stamp: 'KenD 12/24/2013 17:55'!
includeInNewMorphMenu
	"Return true for all classes that can be instantiated from the menu"
	
	^ true! !

!ColorPallet class methodsFor: 'instance creation' stamp: 'KenD 12/24/2013 17:57'!
initializedInstance

	^ ImagePallet namedColors! !

!ColorPallet class methodsFor: 'color dictionary' stamp: 'KenD 12/24/2013 19:57'!
useCSS3ColorDict
"
	self useCSS3ColorDict.
"
	Feature require: 'CSS3-NamedColors'.
	Color setColorNamesDict: Color css3ColorDictionary.! !

!ColorPallet class methodsFor: 'color dictionary' stamp: 'KenD 12/24/2013 19:57'!
useNBSISCCColorDict
"
	self useNBSISCCColorDict.
"
	Feature require: 'NBSISCC-NamedColors'.
	Color setColorNamesDict: Color nbsisccColorDictionary.! !

!ColorPallet class methodsFor: 'color dictionary' stamp: 'KenD 12/24/2013 19:56'!
useSmallColorDict

	Color setColorNamesDict: Color defaultColorNamesDictionary.! !

!ColorPallet class methodsFor: 'color dictionary' stamp: 'KenD 12/24/2013 19:56'!
useXKCDColorDict
"
	self useXKCDColorDict.
"

	Feature require: 'XKCD-NamedColors'.
	Color setColorNamesDict: Color xkcdColorDictionary.! !

!ColorPallet class methodsFor: 'color dictionary' stamp: 'KenD 12/24/2013 19:59'!
useXKCDFirst48ColorDict
"
	self useXKCDFirst48ColorDict.
"

	Color setColorNamesDict: Color xkcdFirst48ColorNamesDictionary.! !

!ColorPaneMorph methodsFor: 'dropping/grabbing' stamp: 'KenD 11/30/2013 19:33'!
aboutToGrab: aMorph
	"submorph is being grabbed by a hand.
	Perform necessary adjustments (if any) and return the actual morph
	that should be added to the hand.
	Answer nil to reject the drag."

	^ DropColorMorph fromColor: self focusColor! !

!ColorPaneMorph methodsFor: 'dropping/grabbing' stamp: 'KenD 11/30/2013 19:35'!
allowsSubmorphDrag
	"Answer whether our morphs can just be grabbed with the hand, instead of requiring the use of the halo. Redefined to answer true."
	
	"Click and hold"

	^ true! !

!ColorPaneMorph methodsFor: 'private' stamp: 'KenD 12/5/2013 20:50'!
colorConstructors
	"Answer a closure which takes values from my (x,y,z) and answers a Color.
	The radio button value is Z which determines the 'slider'.
	X and Y range from 0 to 256.
	Z ranges 0 to 255 (rgb) 360 (hue) or 100 (sv).
	
	Hue scale is 0..360; all others are 0..1.0"

	"self colorConstructors at: self zIndex"
	^ {
		[ :x :y :z | Color r: z/255 g: x/255 b: y/255  ] . "Red"
		[ :x :y :z | Color r: x/255 g: z/255 b: y/255 ] . "Green"
		[ :x :y :z | Color r: x/255 g: y/255 b: z/255 ] . "Blue"
		[ :x :y :z | Color h: z s: x/255 v: y/255 ]. "Hue"
		[ :x :y :z | Color h: x/255*360 s: z/100 v: y/255 ]. "Saturation"
		[ :x :y :z | Color h: x/255*360 s: y/255 v: z/100]. "Brightness"
	}! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 11/27/2013 15:48'!
colorPoint

	^ colorPoint ! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 12/7/2013 15:17'!
colorPoint: aPoint

	(colorPoint = aPoint)
		ifFalse: [ 
			colorPoint := aPoint.
			self triggerEvent: #colorChanged with: self
		]! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 11/27/2013 14:58'!
colorSelector

	^ #(red green blue hue saturation brightness) at: self zIndex ! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 12/5/2013 20:20'!
focusColor
	"Answer my focus color"
	
	^ (self colorConstructors at: zIndex) value: colorPoint x value: colorPoint y value: zValue 

! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 11/26/2013 18:20'!
focusMorph

	^ focusMorph! !

!ColorPaneMorph methodsFor: 'initialization' stamp: 'KenD 11/26/2013 17:04'!
focusMorphDiameter
	
	^ 10! !

!ColorPaneMorph methodsFor: 'initialization' stamp: 'KenD 11/29/2013 14:35'!
fromModel: model selector: aSelector

	zIndex := self zIndexFromSelector: aSelector.
	self updateColorFromModel: model
! !

!ColorPaneMorph methodsFor: 'change processing' stamp: 'KenD 12/5/2013 17:13'!
hackHSVform
	"answer a base form for color plane over (x,y) with constant z.
	This is turtle slow, but accurate"

	| colorMaker displayForm |
	displayForm := Form extent: 256@256 depth: 32.
	colorMaker := self colorConstructors at: self zIndex.
	1 to: 256 do: [ :x |
		1 to: 256 do:  [ :y | 
			displayForm colorAt: x @ y put: (colorMaker value: x value: y value: self zValue)
		]
	].
	self image: displayForm

	! !

!ColorPaneMorph methodsFor: 'events' stamp: 'KenD 12/4/2013 21:52'!
handlesMouseDown: aMouseButtonEvent
	"Do I want to receive mouseDown events (mouseDown:, mouseMove:, mouseUp:)?"

	^ true! !

!ColorPaneMorph methodsFor: 'events' stamp: 'KenD 12/4/2013 21:52'!
handlesMouseOver: evt
	"Do I want to receive mouseEnter: and mouseLeave: when the button is up and the hand is empty?" 
	
	^ true! !

!ColorPaneMorph methodsFor: 'initialization' stamp: 'KenD 11/26/2013 18:43'!
initialize

	super initialize.
	self image: (Form extent: 256@256 depth: 32).
	self makeFocusMorph.! !

!ColorPaneMorph methodsFor: 'initialization' stamp: 'KenD 11/26/2013 18:43'!
makeFocusMorph

	focusMorph := EllipseMorph new. 
	focusMorph 
		morphExtent: self focusMorphDiameter @ self focusMorphDiameter;
		color: Color transparent;
		borderWidth: 2;
		borderColor: Color orange;
		morphPosition: 0@0.
		
	self addMorph: self focusMorph.! !

!ColorPaneMorph methodsFor: 'events-processing' stamp: 'KenD 11/29/2013 00:12'!
mouseButton1Up: aMouseButtonEvent localPosition: localEventPosition

	(self morphContainsPoint: localEventPosition)
		ifTrue: [ 
				self 
					colorPoint: localEventPosition;
					resetFocus;
					triggerEvent: #colorChanged
		]
! !

!ColorPaneMorph methodsFor: 'events-processing' stamp: 'KenD 11/27/2013 15:57'!
mouseEnter: event

	Cursor currentCursor: Cursor crossHair ! !

!ColorPaneMorph methodsFor: 'events-processing' stamp: 'KenD 11/27/2013 15:59'!
mouseLeave: event

	Cursor currentCursor: Cursor normal! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 11/28/2013 22:32'!
pureColorForm
	"Create form from current color"

	^ self focusColor iconOrThumbnailOfSize: 256@256

! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 11/28/2013 23:20'!
rORgORbForm
	"Answer a pureColorForm of my z component -- which must be Red, Green, or Blue"

	|  colorMaker |
	colorMaker := {
		[ Color r: self zValue / 256 g: 0 b: 0 ]. "Red"
		[ Color r: 0 g: self zValue / 256 b: 0 ]. "Green"
		[ Color r: 0 g: 0 b: self zValue / 256 ]. "Blue"
		[ nil ]. "Hue"
		[ nil ]. "Saturation"
		[ nil ]. "Brightness"
	}.

	^ (colorMaker at: self zIndex) value iconOrThumbnailOfSize: 256@256
	
! !

!ColorPaneMorph methodsFor: 'change processing' stamp: 'KenD 12/1/2013 18:15'!
refreshForm
	"Create color pane from x,y base blending in z"

	| formMaker |
	formMaker := {
		[  "Red"
				self image: (self class gbForm copy). "(x,y,0)"
				self form 
					copy: (0@0 corner: 256@256) 
					from: self rORgORbForm "(0,0,z)"
					to: 0@0 
					rule: 20. "rgbAdd (x,y,0) to (0,0,z)"
		].
		[  "Green"
				self image: (self class rbForm copy). "(x,y,0)"
				self form 
					copy: (0@0 corner: 256@256) 
					from: self rORgORbForm "(0,0,z)"
					to: 0@0 
					rule: 20. "rgbAdd (x,y,0) to (0,0,z)"
		]. 
		[  "Blue"
				self image: (self class rgForm copy). "(x,y,0)"
				self form 
					copy: (0@0 corner: 256@256) 
					from: self rORgORbForm "(0,0,z)"
					to: 0@0 
					rule: 20. "rgbAdd (x,y,0) to (0,0,z)"
		]. 
		[  "Hue"
			self image: ((Color h: zValue s:1 v: 1) iconOrThumbnailOfSize: 256@256). 
			self form 
				copy: (0@0 corner: 256@256) 
				from: self class hueOverlay copy
				to: 0@0 
				rule: Form blend.		
		].
		[  "Saturation"
			self image: self class saturationForm copy.
			self form 
				copyBits: self class saturationOverlay 
				at: 0@0 
				translucent: (100 - zValue  / 100) asFloat
		].
		[  "Brightness"
			self image: self class brightnessForm copy.
			self form 
				copyBits:  (Color black iconOrThumbnailOfSize: 256@256)
				at: 0@0 
				translucent: (100 - zValue / 100) asFloat
		].
	}.
	(formMaker at: zIndex) value
	! !

!ColorPaneMorph methodsFor: 'change processing' stamp: 'KenD 12/5/2013 19:41'!
resetFocus

	self focusMorph morphPosition: (colorPoint - (self focusMorphDiameter / 2)).
	self focusMorph borderColor: self focusColor negated. "Show up against background"
	self triggerEvent: #resetFocus.
	! !

!ColorPaneMorph methodsFor: 'events-processing' stamp: 'KenD 11/29/2013 00:08'!
updateColorFromModel: model
	"No selector change, but color changed"
	
	|  updateFuns |
	updateFuns := {
		[ zValue := model red. colorPoint := model green @ model blue ].
		[ zValue := model green. colorPoint := model red @ model blue ].
		[ zValue := model blue. colorPoint := model red @ model green ].
		[ zValue := model hue.
			colorPoint := (255* (model saturationFactor)) rounded 
				@ (255* (model brightnessFactor)) rounded ].
		[ zValue := model saturation. 
			colorPoint := (255* (model hueFactor)) rounded
				@ (255* (model brightnessFactor)) rounded ].
		[ zValue := model brightness. 
			colorPoint := (255* (model hueFactor)) rounded 
				@ (255* (model saturationFactor)) rounded ].
	}.

	(updateFuns at: self zIndex) value.
	self refreshForm.
	self resetFocus.
! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 11/26/2013 18:27'!
zIndex

	^ zIndex
! !

!ColorPaneMorph methodsFor: 'initialization' stamp: 'KenD 12/8/2013 08:07'!
zIndex: oneTo6 zValue: anInteger colorPoint: aPoint

	zIndex := oneTo6.
	zValue := anInteger.
	colorPoint := aPoint.
	self focusMorph morphPosition: (aPoint - (self focusMorphDiameter / 2)).
	self refreshForm;
		 triggerEvent: #colorChanged
! !

!ColorPaneMorph methodsFor: 'initialization' stamp: 'KenD 11/27/2013 09:21'!
zIndexFromSelector: aSelector

	^ #(red green blue hue saturation brightness) 
			indexOf: aSelector asLowercase asSymbol
			ifAbsent: [ self error: 'Invalid selector' , aSelector asString ]! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 11/26/2013 13:29'!
zValue

	^ zValue ! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 12/7/2013 15:16'!
zValue: zeroTo255 "or ..100 or ..360"

	(zValue = zeroTo255)
		ifFalse: [ 
			zValue := zeroTo255.  "Does NOT change colorPoint"
			self triggerEvent: #colorChanged with: self.
		]
! !

!ColorPaneMorph methodsFor: 'accessing' stamp: 'KenD 11/26/2013 17:48'!
zeroPlaneForm

	^ zeroPlaneForm! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/26/2013 14:33'!
blueIndex

	^ BlueIndex ! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/28/2013 23:12'!
brightnessForm

	^ BrightnessForm! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/26/2013 14:34'!
brightnessIndex

	^ BrightnessIndex ! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/28/2013 23:13'!
brightnessOverlay

	^ BrightnessOverlay ! !

!ColorPaneMorph class methodsFor: 'initialization' stamp: 'KenD 12/3/2013 21:28'!
defaultColor

	^ Color transparent! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/28/2013 22:59'!
gbForm

	^ GBForm! !

!ColorPaneMorph class methodsFor: 'examples' stamp: 'KenD 11/26/2013 18:22'!
greenExample
	"RGB with Color Teal: r=2,g=147,b=134"
	"123"
"
	self greenExample.
"
	(self 
		zSelector: #Green
		zValue: 147 
		colorPoint: 2@134) openInWorld! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/26/2013 14:33'!
greenIndex

	^ GreenIndex ! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/26/2013 14:33'!
hueIndex

	^ HueIndex ! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/28/2013 23:11'!
hueOverlay

	^ HueOverlay! !

!ColorPaneMorph class methodsFor: 'new-morph participation' stamp: 'KenD 12/6/2013 19:05'!
includeInNewMorphMenu
	"Return true for all classes that can be instantiated from the menu"
	
	^ false! !

!ColorPaneMorph class methodsFor: 'class initialization' stamp: 'KenD 12/1/2013 16:13'!
initialize
"	
	self initialize.
"
	
	"This is the index of the z dimension -- the selected slider"
	RedIndex := 1. 
	GreenIndex := 2.
	BlueIndex := 3.
	HueIndex := 4.
	SaturationIndex := 5.
	BrightnessIndex := 6.
	
	SaturationForm := self makeSaturationForm.
	SaturationOverlay := self makeSaturationOverlay.
	BrightnessForm := self makeBrightnessForm.
	RBForm := self makeRBForm.
	RGForm := self makeRGForm.
	GBForm := self makeGBForm.
	HueOverlay := self makeHueOverlay.
	! !

!ColorPaneMorph class methodsFor: 'class initialization' stamp: 'KenD 12/1/2013 16:12'!
makeBrightnessForm
	"Briightness is the slider; This is a background/base slice of hue and value"

	| hueFactor briteForm |
	hueFactor := 256 / 360.
	briteForm := Form extent: 256@256 depth:  32.
	1 to: 256 do: [ :x |
		1 to: 256 do:  [ :y | 
			briteForm colorAt: x @ y put: (Color h: (x / hueFactor) s: (y / 256) v: 1.0)
		]
	].

	^ briteForm
! !

!ColorPaneMorph class methodsFor: 'class initialization' stamp: 'KenD 12/1/2013 18:28'!
makeGBForm
	"(x,y)=(g,b), slider value adds z=red"
"
	(ImageMorph new image: ColorPaneMorph makeGBForm) openInWorld.
"
	| rbForm |
	rbForm := Form extent: 256@256 depth:  32.
	0 to: 256 do: [ :x |
		0 to: 256 do:  [ :y | 
			rbForm colorAt: x @ y put: (Color r: 0 g: x/256 b: y/256)
		]
	].

	^ rbForm
! !

!ColorPaneMorph class methodsFor: 'class initialization' stamp: 'KenD 12/1/2013 18:29'!
makeHueOverlay
	"This is a combination of Saturation+Brightness which is mixed with a Hue"
"
	(ImageMorph new image: ColorPaneMorph makeHueOverlay) openInWorld.
"
	| hueForm valForm satForm |
	"Brightness (Value) component [y] from Black to White"
	valForm := Form extent: 256@256 depth:  32.
	0 to: 256 do: [ :x |
		0 to: 256 do:  [ :y | 
			valForm colorAt: x @ y put: ((Color h: 0 s: 0 v: (y/256)) alpha: (256-y)/256)
		]
	].
	"Saturation component [x] white mixed in from full to none"
	satForm := Form extent: 256@256 depth:  32.
	1 to: 256 do: [ :x |
		1 to: 256 do:  [ :y |
			satForm colorAt: x @ y put: (Color white alpha: (256-x)/256)
		]
	].
	hueForm := satForm.
	hueForm 
		copy: (0@0 corner: 256@256) 
		from: valForm 
		to: 0@0
		rule: Form blend.  "Mix S and V"
	
	^ hueForm
! !

!ColorPaneMorph class methodsFor: 'class initialization' stamp: 'KenD 12/1/2013 18:29'!
makeRBForm
	"(x,y)=(r,b), slider value adds z=green"
"
	(ImageMorph new image: ColorPaneMorph makeRBForm) openInWorld.
"
	| rbForm |
	rbForm := Form extent: 256@256 depth:  32.
	0 to: 256 do: [ :x |
		0 to: 256 do:  [ :y | 
			rbForm colorAt: x @ y put: (Color r: x/256 g: 0 b: y/256)
		]
	].

	^ rbForm
! !

!ColorPaneMorph class methodsFor: 'class initialization' stamp: 'KenD 12/1/2013 18:29'!
makeRGForm
	"(x,y)=(r,g), slider value adds z=blue"
"
	(ImageMorph new image: ColorPaneMorph makeRGForm) openInWorld.
"
	| rbForm |
	rbForm := Form extent: 256@256 depth:  32.
	0 to: 256 do: [ :x |
		0 to: 256 do:  [ :y | 
			rbForm colorAt: x @ y put: (Color r: x/256 g: y/256 b: 0)
		]
	].

	^ rbForm
! !

!ColorPaneMorph class methodsFor: 'class initialization' stamp: 'KenD 12/1/2013 18:29'!
makeSaturationForm
	"Saturation is the slider.  Hue is the base and Brightness/Value the overlay"
"
	(ImageMorph new image: ColorPaneMorph makeSaturationForm) openInWorld.
"
	| hueFactor satForm |
	hueFactor := 256 / 360.
	satForm := Form extent: 256@256 depth:  32.
	0 to: 256 do: [ :x |
		0 to: 256 do:  [ :y | 
			satForm colorAt: x @ y put: (Color h: (x / hueFactor) s: 1.0 v: (y / 256))
		]
	].

	^ satForm
! !

!ColorPaneMorph class methodsFor: 'class initialization' stamp: 'KenD 12/1/2013 18:29'!
makeSaturationOverlay
	"Overlay is Value/Brightness"
"
	(ImageMorph new image: ColorPaneMorph makeSaturationOverlay) openInWorld.
"
	| satOverlay |
	satOverlay := Form extent: 256@256 depth:  32.
	0 to: 256 do: [ :x |
		0 to: 256 do:  [ :y | 
			satOverlay colorAt: x @ y put: (Color h: 0 s: 0 v: (y / 256))
		]
	].

	^ satOverlay
! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/28/2013 22:59'!
rbForm

	^ RBForm! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/26/2013 14:33'!
redIndex

	^ RedIndex ! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/28/2013 22:59'!
rgForm

	^ RGForm! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/28/2013 23:12'!
saturationForm

	^ SaturationForm! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/26/2013 14:34'!
saturationIndex

	^ SaturationIndex ! !

!ColorPaneMorph class methodsFor: 'accessing' stamp: 'KenD 11/28/2013 23:13'!
saturationOverlay

	^ SaturationOverlay! !

!ColorPaneMorph class methodsFor: 'instance creation' stamp: 'KenD 11/26/2013 18:14'!
zSelector: aSymbol zValue: anInteger colorPoint: aPoint

	^ self new 
			zIndex: (#(Red Green Blue Hue Saturation Brightness) 
						 indexOf: aSymbol
						 ifAbsent: [ self error: 'Invalid selector' , aSymbol asString ])
			zValue: anInteger 
			colorPoint: aPoint! !

!ColorSliderMorph methodsFor: 'accessing' stamp: 'KenD 12/4/2013 22:03'!
colorPane

	^ colorPane ! !

!ColorSliderMorph methodsFor: 'initialization' stamp: 'KenD 12/5/2013 17:42'!
colorPane: aColorPaneMorph

	colorPane := aColorPaneMorph.
	self 
		refreshColorFromModel; 
		redrawBackground.! !

!ColorSliderMorph methodsFor: 'accessing' stamp: 'KenD 12/26/2013 13:08'!
deltaPoint
	"Offset for slider to center on bar"
	
	^ -4  @ -5! !

!ColorSliderMorph methodsFor: 'events' stamp: 'KenD 12/5/2013 17:52'!
handlesMouseDown: aMouseButtonEvent
	"Do I want to receive mouseDown events (mouseDown:, mouseMove:, mouseUp:)?"
	
	^ true! !

!ColorSliderMorph methodsFor: 'initialization' stamp: 'KenD 12/5/2013 19:11'!
initialize

	super initialize.
	sliderMorph := BorderedRectMorph new.
	sliderMorph 
		color: Color transparent;
		borderColor: Color black;
		borderWidth: 3;
		morphExtent:28@10;
		morphPosition: -4@5.
		
	maxZValue := 256. "Default"

	self 
		image: (Form extent: 20@256 depth: 32);
		layoutSpec: (LayoutSpec 
							fixedWidth: 28 
							fixedHeight: 256 
							minorDirectionPadding: #center);
		addMorph: sliderMorph.! !

!ColorSliderMorph methodsFor: 'accessing' stamp: 'KenD 12/5/2013 19:38'!
maxZValue

	^ maxZValue "100, 256, or 360"! !

!ColorSliderMorph methodsFor: 'events' stamp: 'KenD 12/5/2013 21:09'!
mouseButton1Down: aMouseButtonEvent localPosition: localEventPosition
	"Update visual feedback"

	super mouseButton1Down: aMouseButtonEvent localPosition: localEventPosition.
	self colorPane zValue: (self zValueFromY: localEventPosition y).
	self resetSliderPosition.! !

!ColorSliderMorph methodsFor: 'events' stamp: 'jmv 2/13/2014 14:20'!
mouseMove: aMouseMoveEvent localPosition: localEventPosition

	self colorPane zValue: (self zValueFromY: localEventPosition y).
	self resetSliderPosition.! !

!ColorSliderMorph methodsFor: 'event handling' stamp: 'KenD 12/5/2013 21:11'!
redrawBackground
	"Draw the color scale as background and set maxZValue"
	
	| colorMaker myForm pointX pointY scaleZ |
	"r g b h s v"
	maxZValue := #(255 255 255 359 100 100) at: self colorPane zIndex. 
	scaleZ := {
		[ :z | z ]. [ :z | z ]. [ :z | z ]. "r g b"
		[ :z | z / 255 * 360 ]. [ :z | z / 255 * 100 ]. [ :z | z / 255 * 100 ]. "h s v"
	} at: self colorPane zIndex.
	
	colorMaker := self colorPane colorConstructors at: self colorPane zIndex.
	pointX := self colorPane colorPoint x.
	pointY := self colorPane colorPoint y.
	myForm  := self form.
	1 to: 20 do: [ :x |
		0 to: 255 do:  [ :y | 
			myForm colorAt: x@y 
					    put: (colorMaker value: pointX 
											value: pointY 
											value: (scaleZ value: 255-y))
		]
	].
	self resetSliderPosition.
	self redrawNeeded.! !

!ColorSliderMorph methodsFor: 'event handling' stamp: 'KenD 12/5/2013 19:33'!
refreshColorFromModel

	self resetSliderPosition.

	! !

!ColorSliderMorph methodsFor: 'event handling' stamp: 'KenD 12/26/2013 13:06'!
resetSliderPosition
	"Center me over selected Z position"
	
	self sliderMorph morphPosition: self deltaPoint + (0 @ (self scaledZPosition)).! !

!ColorSliderMorph methodsFor: 'accessing' stamp: 'KenD 3/2/2015 15:23'!
scaledZPosition
	"Answer color Z value scaled to 0..256 as Y position (zero low .. 256 high)"
	"NB: must round result as coordinate cannot be a fraction"

	^ (256 - ((self colorPane zValue / self maxZValue) * 256))! !

!ColorSliderMorph methodsFor: 'accessing' stamp: 'KenD 12/4/2013 22:03'!
sliderMorph

	^ sliderMorph ! !

!ColorSliderMorph methodsFor: 'private' stamp: 'KenD 12/5/2013 21:17'!
zValueFromY: zeroTo255

	| newY |
	newY := (zeroTo255 min: 255 max: 0).

	^ ((255 - newY) / 255) * self maxZValue! !

!ColorSliderMorph class methodsFor: 'instance creation' stamp: 'KenD 12/5/2013 17:31'!
colorPane: aColorPaneMorph

	^ self new colorPane: aColorPaneMorph! !

!ColorSliderMorph class methodsFor: 'new-morph participation' stamp: 'KenD 12/6/2013 19:06'!
includeInNewMorphMenu
	"Return true for all classes that can be instantiated from the menu"
	
	^ false! !
ColorPaneMorph initialize!
