package importtable{
import fl.managers.FocusManager;
import fl.controls.TextInput;
import fl.controls.ScrollBar;
import fl.controls.ScrollBarDirection;
import fl.controls.Button;
import fl.events.ScrollEvent;
import flash.display.Stage;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.text.Font;
import flash.text.FontType;
import flash.text.AntiAliasType;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.events.FocusEvent;
import flash.ui.Keyboard;
import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.display.Graphics;
//import flash.xml.XMLDocument;

public class ImportTable extends MovieClip
{
	//declare global variables
    private var xml_file:XML;
	private var xml:XMLList;
	private var row_num:Number;
	private var max_col_num:Number;
	private var table_width:Number;
	private var col_width:Number;
	private const MAX_CHAR:Number = 30;
	private const TABLE_WIDTH_VAL:Number = 400;
	private const BG_COLOR_VAL:uint = 0xffffff;
	private const BG_ALPHA_VAL:Number = 1;
	private const BORDER_COLOR_VAL:uint = 0x000000;
	private const BORDER_ALPHA_VAL:Number = 1;
	private const BORDER_SIZE_VAL:Number = 1;
	private const CELLSPACING_VAL:Number = 2;
	private const CELLPADDING_VAL:Number = 1;
	private const FONTSIZE_VAL:Number = 12;
	//private const FONTFACE_VAL:String = new Kyrgyz_embed().fontName;
	private const FONTFACE_VAL:String = "Arial";
	private const FONTCOLOR_VAL:uint = 0x000000;
	private const FONTWEIGHT_VAL:String = "normal";
	private const ALIGN_VAL:String = "left";
	private const TYPE_VAL:String = "dynamic";
	private const WIDTH:String = "width";
	private const BGCOLOR:String = "bgcolor";
	private const BGALPHA:String = "bgalpha";
	private const BORDERCOLOR:String = "bordercolor";
	private const BORDERALPHA:String = "borderalpha";
	private const BORDERSIZE:String = "bordersize";
	private const CELLSPACING:String = "cellspacing";
	private const CELLPADDING:String = "cellpadding";
	private const COLSPAN:String = "colspan";
	private const ROWSPAN:String = "rowspan";
	private const ALIGN:String = "align";
	private const TYPE:String = "type";
	private const FONTSIZE:String = "fontsize";
	private const FONTFACE:String = "fontface";
	private const FONTCOLOR:String = "fontcolor";
	private const FONTWEIGHT:String = "fontweight";
	private const BLANKTEXT:String = "<your text>";
	private var main_clip:MovieClip;
	private var lesson_clip:MovieClip;
	private var textfield_array:Array;
	private var rows_height_array:Array;
	private var default_attributes:Array;
	private var table_attributes:Array;
	private var user_ans:Array;
	private var right_ans:Array;
	private const DASHCOLOR:uint = 0x999999;
	private const CORRECTCOLOR:uint = 0x00CC00;
	private const MISTAKECOLOR:uint = 0xFF0000;
	private const WINDOWHEIGHT:Number = 540;
	private const WINDOWWIDTH:Number = 750;
	private var focus_manager:FocusManager;
	private var scrollbar:ScrollBar;
	private var input_table:Boolean;
	
    public function ImportTable(mc:MovieClip, file:String) {
		xml_file = new XML();
		xml = new XMLList();
		textfield_array = new Array();
		rows_height_array = new Array();
		default_attributes = new Array();
		table_attributes = new Array();
		user_ans = new Array();
		right_ans = new Array();
		main_clip = mc;
		lesson_clip = new MovieClip();
		scrollbar = new ScrollBar();
		input_table = false;
		//focus_manager = new FocusManager(lesson_clip);
		//var f = new Kyrgyz_embed();
		//f.fontType = FontType.EMBEDDED;
		//trace(f.fontType);
		setXMLpath(file);
	}
	
	private function setXMLpath(file_path:String):void{
		var xml_url:URLRequest = new URLRequest(file_path);
		var loader:URLLoader = new URLLoader(xml_url);
		loader.addEventListener(Event.COMPLETE, xmlLoaded);
	}
	
	private function xmlLoaded(event:Event):void{
		xml_file = XML(event.target.data);
		xml_file.ignoreWhitespace = true;
		xml_file.ignoreComments = true;
		xml = xml_file.table;
		//trace("Data loaded.");
		startTable();
	}
	
	private function startTable():void{
		assignValues();
		storeText();
		buildTable();
		
		setMask();
		setScrollBar();
		main_clip.addChild(lesson_clip);
		/*var ti:TextInput = new TextInput();
		ti.setSize(300,22);
		ti.move(100,100);
		ti.tabEnabled = true;
		lesson_clip.addChild(ti);
		var ti1:TextInput = new TextInput();
		ti1.setSize(300,22);
		ti1.move(100,200);
		ti1.tabEnabled = true;
		
		lesson_clip.addChild(ti1);
		focus_manager.setFocus(ti);*/
	}
	
	private function maxColumns():Number{
		var array:Array = new Array;
		for(var i:int=0; i<row_num; i++){
			array.push(xml.tr[i].elements("*").length());
		}
		array.sort(Array.NUMERIC);
		return array[array.length-1];
	}
	
	private function assignValues():void{
		
		default_attributes[WIDTH] = TABLE_WIDTH_VAL;
		default_attributes[BGCOLOR] = BG_COLOR_VAL;
		default_attributes[BGALPHA] = BG_ALPHA_VAL;
		default_attributes[BORDERCOLOR] = BORDER_COLOR_VAL;
		default_attributes[BORDERALPHA] = BORDER_ALPHA_VAL;
		default_attributes[BORDERSIZE] = BORDER_SIZE_VAL;
		default_attributes[CELLSPACING] = CELLSPACING_VAL;
		default_attributes[CELLPADDING] = CELLPADDING_VAL;
		default_attributes[ALIGN] = ALIGN_VAL;
		default_attributes[TYPE] = TYPE_VAL;
		default_attributes[FONTSIZE] = FONTSIZE_VAL;
		default_attributes[FONTFACE] = FONTFACE_VAL;
		default_attributes[FONTCOLOR] = FONTCOLOR_VAL;
		default_attributes[FONTWEIGHT] = FONTWEIGHT_VAL;
		
		table_attributes[WIDTH] = setAttribute(xml.@[WIDTH], WIDTH, default_attributes);
		table_attributes[BGCOLOR] = setAttribute(xml.@[BGCOLOR], BGCOLOR, default_attributes);
		table_attributes[BGALPHA] = setAttribute(xml.@[BGALPHA], BGALPHA, default_attributes);
		table_attributes[BORDERCOLOR] = setAttribute(xml.@[BORDERCOLOR], BORDERCOLOR, default_attributes);
		table_attributes[BORDERALPHA] = setAttribute(xml.@[BORDERALPHA], BORDERALPHA, default_attributes);
		table_attributes[BORDERSIZE] = setAttribute(xml.@[BORDERSIZE], BORDERSIZE, default_attributes);
		table_attributes[CELLSPACING] = Number(setAttribute(xml.@[CELLSPACING], CELLSPACING, default_attributes));
		table_attributes[CELLPADDING] = setAttribute(xml.@[CELLPADDING], CELLPADDING, default_attributes);
		table_attributes[ALIGN] = setAttribute(xml.@[ALIGN], ALIGN, default_attributes);
		table_attributes[TYPE] = setAttribute(xml.@[TYPE], TYPE, default_attributes);
		table_attributes[FONTSIZE] = setAttribute(xml.@[FONTSIZE], FONTSIZE, default_attributes);
		table_attributes[FONTFACE] = setAttribute(xml.@[FONTFACE], FONTFACE, default_attributes);
		table_attributes[FONTCOLOR] = setAttribute(xml.@[FONTCOLOR], FONTCOLOR, default_attributes);
		table_attributes[FONTWEIGHT] = setAttribute(xml.@[FONTWEIGHT], FONTWEIGHT, default_attributes);
		
		row_num = xml.elements("*").length();
		max_col_num = maxColumns();
		col_width = (table_attributes[WIDTH]-(max_col_num+1)*table_attributes[CELLSPACING]) / max_col_num;
		/*trace("Rows",row_num);
		trace("Cols",max_col_num);
		trace("Table width",table_width);
		trace("Col width",col_width);
		*/
	}
	
	private function setAttribute(attribute, attr_name:String, array:Array){
		if(attribute != undefined /*|| attribute !=null || attribute != Number.NaN*/){
			return attribute;
		}else{
			return array[attr_name];
		}
	}
	
	private function storeText():void{

		var counter:int = 1;
		
		for(var i:int=0; i<row_num; i++){
			var td_num:Number = xml.tr[i].elements("*").length();
			var td_array:Array = new Array();
			var height_array:Array = new Array();
			for(var t:int=0; t<td_num; t++){
				var text_field:TextField = new TextField();
				var text_input:TextInput = new TextInput();
				var align:String = setAttribute(xml.tr[i].td[t].@[ALIGN], ALIGN, table_attributes);
				var type:String = setAttribute(xml.tr[i].td[t].@[TYPE], TYPE, table_attributes);
				var fontsize:Number = setAttribute(xml.tr[i].td[t].@[FONTSIZE], FONTSIZE, table_attributes);
				var fontcolor:uint = setAttribute(xml.tr[i].td[t].@[FONTCOLOR], FONTCOLOR, table_attributes);
				var fontface:String = setAttribute(xml.tr[i].td[t].@[FONTFACE], FONTFACE, table_attributes);
				var fontweight:String = setAttribute(xml.tr[i].td[t].@[FONTWEIGHT], FONTWEIGHT, table_attributes);
				//some redundancy
				var temp_width:Number = col_width;
				if(xml.tr[i].td[t].@colspan != undefined && t!=max_col_num-1){
					temp_width = col_width*xml.tr[i].td[t].@colspan;
				}
				text_field.type = type;
				text_field.background = false;
				text_field.autoSize = TextFieldAutoSize.LEFT;
				text_field.wordWrap = true;
				text_field.width = temp_width;
				text_field.border = false;
				
				var format:TextFormat = new TextFormat();
				
				
				//trace(format.font, fontface);
				format.color = fontcolor;
				format.align = align;
				format.size = fontsize;
				
				if(fontweight == "bold"){format.bold = true;}
				
				if(type != "input"){
					text_field.condenseWhite = true;
					text_field.multiline = true;
					text_field.htmlText = xml.tr[i].td[t];
					text_field.tabEnabled = false;
					text_field.selectable = false;
					//text_field.embedFonts = true;
					format.font = fontface;
					//text_field.antiAliasType = AntiAliasType.ADVANCED;
					//text_field.thickness = 200;
					//text_field.sharpness = 400;
				}
				else{
					/*text_input.tabIndex = counter++;
					text_input.addEventListener(KeyboardEvent.KEY_DOWN, textBoxEntered);
					text_input.addEventListener(FocusEvent.FOCUS_IN, textBoxEntered);
					text_input.textField.multiline = false;
					text_input.maxChars = MAX_CHAR;
					//text_field.border = true;
					//text_input.borderColor = DASHCOLOR;
					text_input.htmlText = "your text";
					text_input.textField.background = false;
					format.color = DASHCOLOR;
					user_ans.push(text_input);*/
					input_table = true;
					text_field.tabEnabled = true;
					text_field.selectable = true;
					text_field.tabIndex = counter++;
					
					text_field.multiline = false;
					text_field.maxChars = MAX_CHAR;
					//text_field.border = true;
					text_field.borderColor = DASHCOLOR;
					text_field.text = BLANKTEXT;
					format.color = DASHCOLOR;
					format.font = "Arial";
					user_ans.push(text_field);
					right_ans.push(xml.tr[i].td[t].toString());
					text_field.addEventListener(KeyboardEvent.KEY_DOWN, textBoxEntered);
					text_field.addEventListener(FocusEvent.FOCUS_IN, textBoxEntered);
					text_field.addEventListener(FocusEvent.FOCUS_OUT, textBoxEntered);
					//text_input.setTextFormat(format);
					//text_input.defaultTextFormat = format;
					//height_array.push(text_input.height);
					//td_array.push(text_input);
				}
				text_field.setTextFormat(format);
					text_field.defaultTextFormat = format;
					height_array.push(text_field.height);
					td_array.push(text_field);
			}
			rows_height_array.push(maxRowHeight(height_array));
			textfield_array.push(td_array);
		}
	}
	
	private function textBoxEntered(event:Event):void{
		var e:Object = event;
		var textBox = event.target;
		
		if(e.type == FocusEvent.FOCUS_IN){
			if(textBox.text == BLANKTEXT){
				textBox.text = "";
			}
			if(e is KeyboardEvent){
				if(e.keyCode == Keyboard.TAB){
					if(textBox.y > WINDOWHEIGHT-50){
						//trace(textBox.y);
						scrollbar.scrollPosition = textBox.y;
					}
				}else if(e.keyCode == Keyboard.ESCAPE){
					textBox.text = BLANKTEXT;
				}else if(e.keyCode == Keyboard.ENTER){
					
				}
			}
		}else if(e.type == FocusEvent.FOCUS_OUT){
			var pattern:RegExp = / /g;
			var user_text = textBox.text.replace(pattern, "");
			if(user_text == ""){
				textBox.text = BLANKTEXT;
			}
		}
	}
	
	private function buildTable():void{
		var bg_rect:MovieClip = new MovieClip();
		lesson_clip.addChild(bg_rect);
		var cor_y:Number = table_attributes[CELLSPACING];
		for(var i:int=0; i<row_num; i++){
			var td_num:Number = xml.tr[i].elements("*").length();
			var tr_height:Number = rows_height_array[i];
			var cor_x:Number = table_attributes[CELLSPACING];
			for(var t:int=0; t<td_num; t++){
				var cell:MovieClip = new MovieClip();
				var bgcolor:uint = setAttribute(xml.tr[i].td[t].@[BGCOLOR], BGCOLOR, table_attributes);
				var bgalpha:Number = setAttribute(xml.tr[i].td[t].@[BGALPHA], BGALPHA, table_attributes);
				var bordercolor:uint = setAttribute(xml.tr[i].td[t].@[BORDERCOLOR], BORDERCOLOR, table_attributes);
				var borderalpha:Number = setAttribute(xml.tr[i].td[t].@[BORDERALPHA], BORDERALPHA, table_attributes);
				var bordersize:Number = setAttribute(xml.tr[i].td[t].@[BORDERSIZE], BORDERSIZE, table_attributes);
				//some redundancy
				var temp_width:Number = col_width;
				if(xml.tr[i].td[t].@colspan != undefined && cor_x+col_width<table_attributes[WIDTH]){
					temp_width = col_width*xml.tr[i].td[t].@colspan+(xml.tr[i].td[t].@colspan-1)*table_attributes[CELLSPACING];
				}
				cell.x = cor_x/2;
				cell.y = cor_y/2;
				drawRect(cell, temp_width, tr_height, bgcolor, bgalpha, bordersize, bordercolor, borderalpha);
				lesson_clip.addChild(cell);
				cell.tabEnabled = false;
				
				if(textfield_array[i][t].type == TextFieldType.INPUT){
					var dashed:MovieClip = new MovieClip();
					dashed.x = cor_x/2;
					dashed.y = cor_y/2;
					drawDashedLine(dashed, temp_width, tr_height);
					lesson_clip.addChild(dashed);
				}
				textfield_array[i][t].x = cor_x;
				textfield_array[i][t].y = cor_y;
				//textfield_array[i][t].width = temp_width;
				lesson_clip.addChild(textfield_array[i][t]);
				cor_x += temp_width+table_attributes[CELLSPACING];
				//trace(cor_x);
			}
			cor_y += tr_height+table_attributes[CELLSPACING];
		}
		if(input_table){setButtons();};
		drawRect(bg_rect, table_attributes[WIDTH],lesson_clip.height+10, table_attributes[BGCOLOR], table_attributes[BGALPHA], table_attributes[BORDERSIZE], table_attributes[BORDERCOLOR], table_attributes[BORDERALPHA]);
		
	}
	
	private function setButtons():void{
		var check_button:Button = new Button();
		check_button.x = table_attributes[WIDTH] - 150;
		check_button.y = lesson_clip.height + 50;
		check_button.label = "Check answers";
		check_button.addEventListener(MouseEvent.CLICK, checkAnswers);
		lesson_clip.addChild(check_button);
		var answer_rect:MovieClip = new MovieClip();
		answer_rect.graphics.beginFill(CORRECTCOLOR);
		answer_rect.graphics.drawRoundRect(0, 0, 100, 20, 20, 20);
		answer_rect.graphics.beginFill(MISTAKECOLOR);
		answer_rect.graphics.drawRoundRect(300, 0, 100, 20, 20, 20);
		answer_rect.graphics.endFill();
		var true_text:TextField = new TextField();
		true_text.text = "TRUE";
		true_text.x = 30;
		answer_rect.addChild(true_text);
		var false_text:TextField = new TextField();
		false_text.text = "FALSE";
		false_text.x = 330;
		answer_rect.addChild(false_text);
		answer_rect.x = 100;
		answer_rect.y = check_button.y;
		lesson_clip.addChild(answer_rect);
	}
	
	private function setMask():void{
		var mask_rect:MovieClip = new MovieClip();
		mask_rect.graphics.beginFill(table_attributes[BGCOLOR]);
		mask_rect.graphics.drawRoundRect(-1, 0, WINDOWWIDTH+2, WINDOWHEIGHT, 20, 20);
		mask_rect.graphics.endFill();
		main_clip.addChild(mask_rect);
		lesson_clip.mask = mask_rect;
	}
	
	private function setScrollBar():void{
		
		scrollbar.direction = ScrollBarDirection.VERTICAL;
		scrollbar.move(WINDOWWIDTH+4, 0);
		scrollbar.setSize(5, WINDOWHEIGHT);
		scrollbar.maxScrollPosition = lesson_clip.height-WINDOWHEIGHT-2;
		scrollbar.minScrollPosition = 0;
		scrollbar.lineScrollSize = 10;
		
		scrollbar.addEventListener(ScrollEvent.SCROLL, scrollClip);
		scrollbar.addEventListener(MouseEvent.MOUSE_WHEEL, scrollClip);
		lesson_clip.addEventListener(MouseEvent.MOUSE_WHEEL, scrollClip);
		main_clip.addChild(scrollbar);
	}
	
	private function scrollClip(event:Event):void{
		var e:Object = event;
		if(event is MouseEvent){
			lesson_clip.y = -(scrollbar.scrollPosition -= (e.delta * scrollbar.lineScrollSize));
			if(lesson_clip.y > 0){
				lesson_clip.y = 0;
			}else if(lesson_clip.y < -(scrollbar.maxScrollPosition)){
				lesson_clip.y = -(scrollbar.maxScrollPosition);
			}
		}else{
			lesson_clip.y = -(scrollbar.scrollPosition);
		}
	}
	
	private function maxRowHeight(height_array:Array):Number{
		height_array.sort(Array.NUMERIC);
		return height_array[height_array.length-1];
	}
	
	private function drawDashedLine(mc:MovieClip, temp_width:Number, tr_height:Number):void{
		mc.graphics.lineStyle(1, DASHCOLOR);
		for(var d:Number = mc.x; d+10<mc.x+temp_width; d+=2){
			mc.graphics.moveTo(d, mc.y+tr_height-2);
			mc.graphics.lineTo(d+=10, mc.y+tr_height-2);
		}
	}
	
	private function drawRect(mc:MovieClip, mcwidth:Number, mcheight:Number, bgcolor:Number, bgalpha:Number, bordersize:Number, bordercolor:Number, borderalpha:Number):void{
		mc.graphics.beginFill(bgcolor, bgalpha);
        mc.graphics.drawRect(mc.x, mc.y , mcwidth, mcheight);
        mc.graphics.endFill();
		mc.graphics.lineStyle(bordersize, bordercolor, borderalpha);
		mc.graphics.drawRect(mc.x, mc.y, mcwidth, mcheight);
	}
	
	private function checkAnswers(event:Event):void{
		for(var i:int=0; i<user_ans.length; i++){
			var pattern:RegExp = / /g;
			
			var user_answer:String = user_ans[i].text.replace(pattern, "");
			var right_answer:String = right_ans[i].replace(pattern, "");
			
			/*trace(right_answer, user_answer);
			trace(i,right_ans[i].charCodeAt(0), "-",user_answer.charCodeAt(0), user_answer.length);
			trace(i,right_ans[i].charCodeAt(1), "-",user_answer.charCodeAt(1));
			trace(i,right_ans[i].charCodeAt(2), "-",user_answer.charCodeAt(2));
			trace(i,right_ans[i].charCodeAt(3), "-",user_answer.charCodeAt(3));
			trace(i,right_ans[i].charCodeAt(4), "-",user_answer.charCodeAt(4));*/
			var format:TextFormat = new TextFormat();
			if(!compareAnswers(user_answer, right_answer)){
				//trace("entered");
				user_ans[i].borderColor = MISTAKECOLOR;
				format.color = MISTAKECOLOR;
			}else{
				user_ans[i].borderColor = CORRECTCOLOR;
				format.color = CORRECTCOLOR;
			}
			user_ans[i].setTextFormat(format);
		}
	}
	
	private function compareAnswers(user_answer:String, right_answer:String):Boolean{
		if(user_answer.length > right_answer.length){
			return false;
		}
		for(var i:int=0; i<right_answer.length; i++){
			var user_code:int = user_answer.charCodeAt(i);
			var right_code:int = right_answer.charCodeAt(i);
			
			if(user_code==1187){
			   if(user_code-996 != right_code){return false;}
			}else if(user_code==1199){
				if(user_code-1013 != right_code){return false;}
			}else if(user_code==1257){
				if(user_code-904 != right_code){return false;}
			}else if(user_code-848 != right_code){
				return false;
			}
		}
		return true;
	}
	
	
}
}