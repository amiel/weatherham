document.createElement("canvas").getContext||function(){function Z(){return this.context_||(this.context_=new E(this))}function $(a,b){var c=Q.call(arguments,2);return function(){return a.apply(b,c.concat(Q.call(arguments)))}}function R(a){return String(a).replace(/&/g,"&amp;").replace(/"/g,"&quot;")}function S(a){a.namespaces.g_vml_||a.namespaces.add("g_vml_","urn:schemas-microsoft-com:vml","#default#VML");a.namespaces.g_o_||a.namespaces.add("g_o_","urn:schemas-microsoft-com:office:office","#default#VML");
if(!a.styleSheets.ex_canvas_){a=a.createStyleSheet();a.owningElement.id="ex_canvas_";a.cssText="canvas{display:inline-block;overflow:hidden;text-align:left;width:300px;height:150px}"}}function aa(a){var b=a.srcElement;switch(a.propertyName){case "width":b.getContext().clearRect();b.style.width=b.attributes.width.nodeValue+"px";b.firstChild.style.width=b.clientWidth+"px";break;case "height":b.getContext().clearRect();b.style.height=b.attributes.height.nodeValue+"px";b.firstChild.style.height=b.clientHeight+
"px";break}}function ba(a){a=a.srcElement;if(a.firstChild){a.firstChild.style.width=a.clientWidth+"px";a.firstChild.style.height=a.clientHeight+"px"}}function F(){return[[1,0,0],[0,1,0],[0,0,1]]}function w(a,b){for(var c=F(),d=0;d<3;d++)for(var e=0;e<3;e++){for(var i=0,f=0;f<3;f++)i+=a[d][f]*b[f][e];c[d][e]=i}return c}function T(a,b){b.fillStyle=a.fillStyle;b.lineCap=a.lineCap;b.lineJoin=a.lineJoin;b.lineWidth=a.lineWidth;b.miterLimit=a.miterLimit;b.shadowBlur=a.shadowBlur;b.shadowColor=a.shadowColor;
b.shadowOffsetX=a.shadowOffsetX;b.shadowOffsetY=a.shadowOffsetY;b.strokeStyle=a.strokeStyle;b.globalAlpha=a.globalAlpha;b.font=a.font;b.textAlign=a.textAlign;b.textBaseline=a.textBaseline;b.arcScaleX_=a.arcScaleX_;b.arcScaleY_=a.arcScaleY_;b.lineScale_=a.lineScale_}function U(a){var b=a.indexOf("(",3),c=a.indexOf(")",b+1);b=a.substring(b+1,c).split(",");if(b.length==4&&a.substr(3,1)=="a")alpha=Number(b[3]);else b[3]=1;return b}function G(a){return parseFloat(a)/100}function H(a,b,c){return Math.min(c,
Math.max(b,a))}function ca(a){var b,c;h=parseFloat(a[0])/360%360;h<0&&h++;s=H(G(a[1]),0,1);l=H(G(a[2]),0,1);if(s==0)a=b=c=l;else{c=l<0.5?l*(1+s):l+s-l*s;var d=2*l-c;a=I(d,c,h+1/3);b=I(d,c,h);c=I(d,c,h-1/3)}return"#"+x[Math.floor(a*255)]+x[Math.floor(b*255)]+x[Math.floor(c*255)]}function I(a,b,c){c<0&&c++;c>1&&c--;return 6*c<1?a+(b-a)*6*c:2*c<1?b:3*c<2?a+(b-a)*(2/3-c)*6:a}function J(a){var b=1;a=String(a);if(a.charAt(0)=="#")a=a;else if(/^rgb/.test(a)){b=U(a);a="#";for(var c,d=0;d<3;d++){c=b[d].indexOf("%")!=
-1?Math.floor(G(b[d])*255):Number(b[d]);a+=x[H(c,0,255)]}b=b[3]}else if(/^hsl/.test(a)){b=U(a);a=ca(b);b=b[3]}else a=da[a]||a;return{color:a,alpha:b}}function ea(a){if(K[a])return K[a];var b=document.createElement("div").style;try{b.font=a}catch(c){}return K[a]={style:b.fontStyle||y.style,variant:b.fontVariant||y.variant,weight:b.fontWeight||y.weight,size:b.fontSize||y.size,family:b.fontFamily||y.family}}function fa(a,b){var c={};for(var d in a)c[d]=a[d];b=parseFloat(b.currentStyle.fontSize);d=parseFloat(a.size);
c.size=typeof a.size=="number"?a.size:a.size.indexOf("px")!=-1?d:a.size.indexOf("em")!=-1?b*d:a.size.indexOf("%")!=-1?b/100*d:a.size.indexOf("pt")!=-1?d/0.75:b;c.size*=0.981;return c}function ga(a){return a.style+" "+a.variant+" "+a.weight+" "+a.size+"px "+a.family}function ha(a){switch(a){case "butt":return"flat";case "round":return"round";case "square":default:return"square"}}function E(a){this.m_=F();this.mStack_=[];this.aStack_=[];this.currentPath_=[];this.fillStyle=this.strokeStyle="#000";this.lineWidth=
1;this.lineJoin="miter";this.lineCap="butt";this.miterLimit=n*1;this.globalAlpha=1;this.font="10px sans-serif";this.textAlign="left";this.textBaseline="alphabetic";this.canvas=a;var b=a.ownerDocument.createElement("div");b.style.width=a.clientWidth+"px";b.style.height=a.clientHeight+"px";b.style.overflow="hidden";b.style.position="absolute";a.appendChild(b);this.element_=b;this.lineScale_=this.arcScaleY_=this.arcScaleX_=1}function V(a,b,c,d){a.currentPath_.push({type:"bezierCurveTo",cp1x:b.x,cp1y:b.y,
cp2x:c.x,cp2y:c.y,x:d.x,y:d.y});a.currentX_=d.x;a.currentY_=d.y}function W(a,b){var c=J(a.strokeStyle),d=c.color;c=c.alpha*a.globalAlpha;var e=a.lineScale_*a.lineWidth;if(e<1)c*=e;b.push("<g_vml_:stroke",' opacity="',c,'"',' joinstyle="',a.lineJoin,'"',' miterlimit="',a.miterLimit,'"',' endcap="',ha(a.lineCap),'"',' weight="',e,'px"',' color="',d,'" />')}function X(a,b,c,d){var e=a.fillStyle,i=a.arcScaleX_,f=a.arcScaleY_,k=d.x-c.x,o=d.y-c.y;if(e instanceof z){var m=0;d={x:0,y:0};var r=0,q=1;if(e.type_==
"gradient"){m=e.x1_/i;c=e.y1_/f;var p=a.getCoords_(e.x0_/i,e.y0_/f);m=a.getCoords_(m,c);m=Math.atan2(m.x-p.x,m.y-p.y)*180/Math.PI;if(m<0)m+=360;if(m<1.0E-6)m=0}else{p=a.getCoords_(e.x0_,e.y0_);d={x:(p.x-c.x)/k,y:(p.y-c.y)/o};k/=i*n;o/=f*n;q=t.max(k,o);r=2*e.r0_/q;q=2*e.r1_/q-r}i=e.colors_;i.sort(function(C,ia){return C.offset-ia.offset});f=i.length;p=i[0].color;c=i[f-1].color;k=i[0].alpha*a.globalAlpha;a=i[f-1].alpha*a.globalAlpha;o=[];for(var u=0;u<f;u++){var A=i[u];o.push(A.offset*q+r+" "+A.color)}b.push('<g_vml_:fill type="',
e.type_,'"',' method="none" focus="100%"',' color="',p,'"',' color2="',c,'"',' colors="',o.join(","),'"',' opacity="',a,'"',' g_o_:opacity2="',k,'"',' angle="',m,'"',' focusposition="',d.x,",",d.y,'" />')}else if(e instanceof L)k&&o&&b.push("<g_vml_:fill",' position="',-c.x/k*i*i,",",-c.y/o*f*f,'"',' type="tile"',' src="',e.src_,'" />');else{e=J(a.fillStyle);b.push('<g_vml_:fill color="',e.color,'" opacity="',e.alpha*a.globalAlpha,'" />')}}function ja(a){return isFinite(a[0][0])&&isFinite(a[0][1])&&
isFinite(a[1][0])&&isFinite(a[1][1])&&isFinite(a[2][0])&&isFinite(a[2][1])}function B(a,b,c){if(ja(b)){a.m_=b;if(c)a.lineScale_=ka(la(b[0][0]*b[1][1]-b[0][1]*b[1][0]))}}function z(a){this.type_=a;this.r1_=this.y1_=this.x1_=this.r0_=this.y0_=this.x0_=0;this.colors_=[]}function L(a,b){ma(a);switch(b){case "repeat":case null:case "":this.repetition_="repeat";break;case "repeat-x":case "repeat-y":case "no-repeat":this.repetition_=b;break;default:M("SYNTAX_ERR")}this.src_=a.src;this.width_=a.width;this.height_=
a.height}function M(a){throw new N(a);}function ma(a){if(!a||a.nodeType!=1||a.tagName!="IMG")M("TYPE_MISMATCH_ERR");a.readyState!="complete"&&M("INVALID_STATE_ERR")}function N(a){this.code=this[a];this.message=a+": DOM Exception "+this.code}var t=Math,j=t.round,O=t.sin,P=t.cos,la=t.abs,ka=t.sqrt,n=10,v=n/2,Q=Array.prototype.slice;S(document);var Y={init:function(a){if(/MSIE/.test(navigator.userAgent)&&!window.opera){a=a||document;a.createElement("canvas");a.attachEvent("onreadystatechange",$(this.init_,
this,a))}},init_:function(a){a=a.getElementsByTagName("canvas");for(var b=0;b<a.length;b++)this.initElement(a[b])},initElement:function(a){if(!a.getContext){a.getContext=Z;S(a.ownerDocument);a.innerHTML="";a.attachEvent("onpropertychange",aa);a.attachEvent("onresize",ba);var b=a.attributes;if(b.width&&b.width.specified)a.style.width=b.width.nodeValue+"px";else a.width=a.clientWidth;if(b.height&&b.height.specified)a.style.height=b.height.nodeValue+"px";else a.height=a.clientHeight}return a}};Y.init();
for(var x=[],g=0;g<16;g++)for(var D=0;D<16;D++)x[g*16+D]=g.toString(16)+D.toString(16);var da={aliceblue:"#F0F8FF",antiquewhite:"#FAEBD7",aquamarine:"#7FFFD4",azure:"#F0FFFF",beige:"#F5F5DC",bisque:"#FFE4C4",black:"#000000",blanchedalmond:"#FFEBCD",blueviolet:"#8A2BE2",brown:"#A52A2A",burlywood:"#DEB887",cadetblue:"#5F9EA0",chartreuse:"#7FFF00",chocolate:"#D2691E",coral:"#FF7F50",cornflowerblue:"#6495ED",cornsilk:"#FFF8DC",crimson:"#DC143C",cyan:"#00FFFF",darkblue:"#00008B",darkcyan:"#008B8B",darkgoldenrod:"#B8860B",
darkgray:"#A9A9A9",darkgreen:"#006400",darkgrey:"#A9A9A9",darkkhaki:"#BDB76B",darkmagenta:"#8B008B",darkolivegreen:"#556B2F",darkorange:"#FF8C00",darkorchid:"#9932CC",darkred:"#8B0000",darksalmon:"#E9967A",darkseagreen:"#8FBC8F",darkslateblue:"#483D8B",darkslategray:"#2F4F4F",darkslategrey:"#2F4F4F",darkturquoise:"#00CED1",darkviolet:"#9400D3",deeppink:"#FF1493",deepskyblue:"#00BFFF",dimgray:"#696969",dimgrey:"#696969",dodgerblue:"#1E90FF",firebrick:"#B22222",floralwhite:"#FFFAF0",forestgreen:"#228B22",
gainsboro:"#DCDCDC",ghostwhite:"#F8F8FF",gold:"#FFD700",goldenrod:"#DAA520",grey:"#808080",greenyellow:"#ADFF2F",honeydew:"#F0FFF0",hotpink:"#FF69B4",indianred:"#CD5C5C",indigo:"#4B0082",ivory:"#FFFFF0",khaki:"#F0E68C",lavender:"#E6E6FA",lavenderblush:"#FFF0F5",lawngreen:"#7CFC00",lemonchiffon:"#FFFACD",lightblue:"#ADD8E6",lightcoral:"#F08080",lightcyan:"#E0FFFF",lightgoldenrodyellow:"#FAFAD2",lightgreen:"#90EE90",lightgrey:"#D3D3D3",lightpink:"#FFB6C1",lightsalmon:"#FFA07A",lightseagreen:"#20B2AA",
lightskyblue:"#87CEFA",lightslategray:"#778899",lightslategrey:"#778899",lightsteelblue:"#B0C4DE",lightyellow:"#FFFFE0",limegreen:"#32CD32",linen:"#FAF0E6",magenta:"#FF00FF",mediumaquamarine:"#66CDAA",mediumblue:"#0000CD",mediumorchid:"#BA55D3",mediumpurple:"#9370DB",mediumseagreen:"#3CB371",mediumslateblue:"#7B68EE",mediumspringgreen:"#00FA9A",mediumturquoise:"#48D1CC",mediumvioletred:"#C71585",midnightblue:"#191970",mintcream:"#F5FFFA",mistyrose:"#FFE4E1",moccasin:"#FFE4B5",navajowhite:"#FFDEAD",
oldlace:"#FDF5E6",olivedrab:"#6B8E23",orange:"#FFA500",orangered:"#FF4500",orchid:"#DA70D6",palegoldenrod:"#EEE8AA",palegreen:"#98FB98",paleturquoise:"#AFEEEE",palevioletred:"#DB7093",papayawhip:"#FFEFD5",peachpuff:"#FFDAB9",peru:"#CD853F",pink:"#FFC0CB",plum:"#DDA0DD",powderblue:"#B0E0E6",rosybrown:"#BC8F8F",royalblue:"#4169E1",saddlebrown:"#8B4513",salmon:"#FA8072",sandybrown:"#F4A460",seagreen:"#2E8B57",seashell:"#FFF5EE",sienna:"#A0522D",skyblue:"#87CEEB",slateblue:"#6A5ACD",slategray:"#708090",
slategrey:"#708090",snow:"#FFFAFA",springgreen:"#00FF7F",steelblue:"#4682B4",tan:"#D2B48C",thistle:"#D8BFD8",tomato:"#FF6347",turquoise:"#40E0D0",violet:"#EE82EE",wheat:"#F5DEB3",whitesmoke:"#F5F5F5",yellowgreen:"#9ACD32"},y={style:"normal",variant:"normal",weight:"normal",size:10,family:"sans-serif"},K={};g=E.prototype;g.clearRect=function(){if(this.textMeasureEl_){this.textMeasureEl_.removeNode(true);this.textMeasureEl_=null}this.element_.innerHTML=""};g.beginPath=function(){this.currentPath_=[]};
g.moveTo=function(a,b){a=this.getCoords_(a,b);this.currentPath_.push({type:"moveTo",x:a.x,y:a.y});this.currentX_=a.x;this.currentY_=a.y};g.lineTo=function(a,b){a=this.getCoords_(a,b);this.currentPath_.push({type:"lineTo",x:a.x,y:a.y});this.currentX_=a.x;this.currentY_=a.y};g.bezierCurveTo=function(a,b,c,d,e,i){e=this.getCoords_(e,i);a=this.getCoords_(a,b);c=this.getCoords_(c,d);V(this,a,c,e)};g.quadraticCurveTo=function(a,b,c,d){a=this.getCoords_(a,b);c=this.getCoords_(c,d);d={x:this.currentX_+2/
3*(a.x-this.currentX_),y:this.currentY_+2/3*(a.y-this.currentY_)};V(this,d,{x:d.x+(c.x-this.currentX_)/3,y:d.y+(c.y-this.currentY_)/3},c)};g.arc=function(a,b,c,d,e,i){c*=n;var f=i?"at":"wa",k=a+P(d)*c-v,o=b+O(d)*c-v;d=a+P(e)*c-v;e=b+O(e)*c-v;if(k==d&&!i)k+=0.125;a=this.getCoords_(a,b);k=this.getCoords_(k,o);d=this.getCoords_(d,e);this.currentPath_.push({type:f,x:a.x,y:a.y,radius:c,xStart:k.x,yStart:k.y,xEnd:d.x,yEnd:d.y})};g.rect=function(a,b,c,d){this.moveTo(a,b);this.lineTo(a+c,b);this.lineTo(a+
c,b+d);this.lineTo(a,b+d);this.closePath()};g.strokeRect=function(a,b,c,d){var e=this.currentPath_;this.beginPath();this.moveTo(a,b);this.lineTo(a+c,b);this.lineTo(a+c,b+d);this.lineTo(a,b+d);this.closePath();this.stroke();this.currentPath_=e};g.fillRect=function(a,b,c,d){var e=this.currentPath_;this.beginPath();this.moveTo(a,b);this.lineTo(a+c,b);this.lineTo(a+c,b+d);this.lineTo(a,b+d);this.closePath();this.fill();this.currentPath_=e};g.createLinearGradient=function(a,b,c,d){var e=new z("gradient");
e.x0_=a;e.y0_=b;e.x1_=c;e.y1_=d;return e};g.createRadialGradient=function(a,b,c,d,e,i){var f=new z("gradientradial");f.x0_=a;f.y0_=b;f.r0_=c;f.x1_=d;f.y1_=e;f.r1_=i;return f};g.drawImage=function(a){var b,c,d,e,i,f,k,o;d=a.runtimeStyle.width;e=a.runtimeStyle.height;a.runtimeStyle.width="auto";a.runtimeStyle.height="auto";var m=a.width,r=a.height;a.runtimeStyle.width=d;a.runtimeStyle.height=e;if(arguments.length==3){b=arguments[1];c=arguments[2];i=f=0;k=d=m;o=e=r}else if(arguments.length==5){b=arguments[1];
c=arguments[2];d=arguments[3];e=arguments[4];i=f=0;k=m;o=r}else if(arguments.length==9){i=arguments[1];f=arguments[2];k=arguments[3];o=arguments[4];b=arguments[5];c=arguments[6];d=arguments[7];e=arguments[8]}else throw Error("Invalid number of arguments");var q=this.getCoords_(b,c),p=[];p.push(" <g_vml_:group",' coordsize="',n*10,",",n*10,'"',' coordorigin="0,0"',' style="width:',10,"px;height:",10,"px;position:absolute;");if(this.m_[0][0]!=1||this.m_[0][1]||this.m_[1][1]!=1||this.m_[1][0]){var u=
[];u.push("M11=",this.m_[0][0],",","M12=",this.m_[1][0],",","M21=",this.m_[0][1],",","M22=",this.m_[1][1],",","Dx=",j(q.x/n),",","Dy=",j(q.y/n),"");var A=this.getCoords_(b+d,c),C=this.getCoords_(b,c+e);b=this.getCoords_(b+d,c+e);q.x=t.max(q.x,A.x,C.x,b.x);q.y=t.max(q.y,A.y,C.y,b.y);p.push("padding:0 ",j(q.x/n),"px ",j(q.y/n),"px 0;filter:progid:DXImageTransform.Microsoft.Matrix(",u.join(""),", sizingmethod='clip');")}else p.push("top:",j(q.y/n),"px;left:",j(q.x/n),"px;");p.push(' ">','<g_vml_:image src="',
a.src,'"',' style="width:',n*d,"px;"," height:",n*e,'px"',' cropleft="',i/m,'"',' croptop="',f/r,'"',' cropright="',(m-i-k)/m,'"',' cropbottom="',(r-f-o)/r,'"'," />","</g_vml_:group>");this.element_.insertAdjacentHTML("BeforeEnd",p.join(""))};g.stroke=function(a){for(var b={x:null,y:null},c={x:null,y:null},d=0;d<this.currentPath_.length;d+=5E3){var e=[];e.push("<g_vml_:shape",' filled="',!!a,'"',' style="position:absolute;width:',10,"px;height:",10,'px;"',' coordorigin="0,0"',' coordsize="',n*10,
",",n*10,'"',' stroked="',!a,'"',' path="');for(var i=d;i<Math.min(d+5E3,this.currentPath_.length);i++){i%5E3==0&&i>0&&e.push(" m ",j(this.currentPath_[i-1].x),",",j(this.currentPath_[i-1].y));var f=this.currentPath_[i];switch(f.type){case "moveTo":e.push(" m ",j(f.x),",",j(f.y));break;case "lineTo":e.push(" l ",j(f.x),",",j(f.y));break;case "close":e.push(" x ");f=null;break;case "bezierCurveTo":e.push(" c ",j(f.cp1x),",",j(f.cp1y),",",j(f.cp2x),",",j(f.cp2y),",",j(f.x),",",j(f.y));break;case "at":case "wa":e.push(" ",
f.type," ",j(f.x-this.arcScaleX_*f.radius),",",j(f.y-this.arcScaleY_*f.radius)," ",j(f.x+this.arcScaleX_*f.radius),",",j(f.y+this.arcScaleY_*f.radius)," ",j(f.xStart),",",j(f.yStart)," ",j(f.xEnd),",",j(f.yEnd));break}if(f){if(b.x==null||f.x<b.x)b.x=f.x;if(c.x==null||f.x>c.x)c.x=f.x;if(b.y==null||f.y<b.y)b.y=f.y;if(c.y==null||f.y>c.y)c.y=f.y}}e.push(' ">');a?X(this,e,b,c):W(this,e);e.push("</g_vml_:shape>");this.element_.insertAdjacentHTML("beforeEnd",e.join(""))}};g.fill=function(){this.stroke(true)};
g.closePath=function(){this.currentPath_.push({type:"close"})};g.getCoords_=function(a,b){var c=this.m_;return{x:n*(a*c[0][0]+b*c[1][0]+c[2][0])-v,y:n*(a*c[0][1]+b*c[1][1]+c[2][1])-v}};g.save=function(){var a={};T(this,a);this.aStack_.push(a);this.mStack_.push(this.m_);this.m_=w(F(),this.m_)};g.restore=function(){if(this.aStack_.length){T(this.aStack_.pop(),this);this.m_=this.mStack_.pop()}};g.translate=function(a,b){B(this,w([[1,0,0],[0,1,0],[a,b,1]],this.m_),false)};g.rotate=function(a){var b=P(a);
a=O(a);B(this,w([[b,a,0],[-a,b,0],[0,0,1]],this.m_),false)};g.scale=function(a,b){this.arcScaleX_*=a;this.arcScaleY_*=b;B(this,w([[a,0,0],[0,b,0],[0,0,1]],this.m_),true)};g.transform=function(a,b,c,d,e,i){B(this,w([[a,b,0],[c,d,0],[e,i,1]],this.m_),true)};g.setTransform=function(a,b,c,d,e,i){B(this,[[a,b,0],[c,d,0],[e,i,1]],true)};g.drawText_=function(a,b,c,d,e){var i=this.m_;d=0;var f=1E3,k={x:0,y:0},o=[],m=fa(ea(this.font),this.element_),r=ga(m),q=this.element_.currentStyle,p=this.textAlign.toLowerCase();
switch(p){case "left":case "center":case "right":break;case "end":p=q.direction=="ltr"?"right":"left";break;case "start":p=q.direction=="rtl"?"right":"left";break;default:p="left"}switch(this.textBaseline){case "hanging":case "top":k.y=m.size/1.75;break;case "middle":break;default:case null:case "alphabetic":case "ideographic":case "bottom":k.y=-m.size/2.25;break}switch(p){case "right":d=1E3;f=0.05;break;case "center":d=f=500;break}b=this.getCoords_(b+k.x,c+k.y);o.push('<g_vml_:line from="',-d,' 0" to="',
f,' 0.05" ',' coordsize="100 100" coordorigin="0 0"',' filled="',!e,'" stroked="',!!e,'" style="position:absolute;width:1px;height:1px;">');e?W(this,o):X(this,o,{x:-d,y:0},{x:f,y:m.size});e=i[0][0].toFixed(3)+","+i[1][0].toFixed(3)+","+i[0][1].toFixed(3)+","+i[1][1].toFixed(3)+",0,0";b=j(b.x/n)+","+j(b.y/n);o.push('<g_vml_:skew on="t" matrix="',e,'" ',' offset="',b,'" origin="',d,' 0" />','<g_vml_:path textpathok="true" />','<g_vml_:textpath on="true" string="',R(a),'" style="v-text-align:',p,";font:",
R(r),'" /></g_vml_:line>');this.element_.insertAdjacentHTML("beforeEnd",o.join(""))};g.fillText=function(a,b,c,d){this.drawText_(a,b,c,d,false)};g.strokeText=function(a,b,c,d){this.drawText_(a,b,c,d,true)};g.measureText=function(a){if(!this.textMeasureEl_){this.element_.insertAdjacentHTML("beforeEnd",'<span style="position:absolute;top:-20000px;left:0;padding:0;margin:0;border:none;white-space:pre;"></span>');this.textMeasureEl_=this.element_.lastChild}var b=this.element_.ownerDocument;this.textMeasureEl_.innerHTML=
"";this.textMeasureEl_.style.font=this.font;this.textMeasureEl_.appendChild(b.createTextNode(a));return{width:this.textMeasureEl_.offsetWidth}};g.clip=function(){};g.arcTo=function(){};g.createPattern=function(a,b){return new L(a,b)};z.prototype.addColorStop=function(a,b){b=J(b);this.colors_.push({offset:a,color:b.color,alpha:b.alpha})};g=N.prototype=new Error;g.INDEX_SIZE_ERR=1;g.DOMSTRING_SIZE_ERR=2;g.HIERARCHY_REQUEST_ERR=3;g.WRONG_DOCUMENT_ERR=4;g.INVALID_CHARACTER_ERR=5;g.NO_DATA_ALLOWED_ERR=
6;g.NO_MODIFICATION_ALLOWED_ERR=7;g.NOT_FOUND_ERR=8;g.NOT_SUPPORTED_ERR=9;g.INUSE_ATTRIBUTE_ERR=10;g.INVALID_STATE_ERR=11;g.SYNTAX_ERR=12;g.INVALID_MODIFICATION_ERR=13;g.NAMESPACE_ERR=14;g.INVALID_ACCESS_ERR=15;g.VALIDATION_ERR=16;g.TYPE_MISMATCH_ERR=17;G_vmlCanvasManager=Y;CanvasRenderingContext2D=E;CanvasGradient=z;CanvasPattern=L;DOMException=N}();