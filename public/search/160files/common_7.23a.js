$(function(){$(window).on("scroll",function(){$(this).scrollTop()>=356&&$(".function_bar").addClass('function_bar_fix'),$(this).scrollTop()<350&&$(".function_bar").removeClass('function_bar_fix');$(this).scrollTop()>=555&&$(".grade_week").addClass('function_bar_fix'),$(this).scrollTop()<554&&$(".grade_week").removeClass('function_bar_fix')});$('.hos_menu').find('li').hover(function(){$(this).addClass('hover');},function(){$(this).removeClass('hover');});$('.hos_doc_roll').hover(function(){$(this).find('.rolls-btn').fadeIn(100);},function(){$(this).find('.rolls-btn').fadeOut(100);});$(".doc_say_list").each(function(){$(this).find('div.doc_say_item:last').addClass('no_b');$(this).find('div.ds_rev li:last').addClass('no_b');});$(".class_item_ul > li").each(function(){$(".class_item_ul > li:last").css('background','none');if($(this).height()>38){$(this).addClass('get_h');$(this).find('label.b_open').show();}
$("label.b_open").click(function(){$(this).parent("li").removeClass('get_h');$(this).hide();$(this).parent("li").find('.b_close').show();});$("label.b_close").click(function(){$(this).parent("li").addClass('get_h');$(this).hide();$(this).parent("li").find('.b_open').show();});});$('.a_shear').click(function(){$(this).next('.share_fix').toggle();});$('.share_fix').hover(function(){$(this).show();},function(){$(this).hide();});$('#levelSPAN').each(function(){var spanClass=$(this).attr("class");var levelBig=$(this).children('.level_big');var reZ=$(this).parents(".content").css("z-index");$(this).hover(function(){levelBig.addClass(spanClass+'_big')
levelBig.fadeIn();$(this).parents(".content").css("z-index",reZ+1);},function(){levelBig.fadeOut();$(this).parents(".content").css("z-index",reZ);});});});function ShowPre(o){var that=this;this.box=$("#"+o["box"]);this.btnP=$("#"+o.Pre);this.btnN=$("#"+o.Next);this.v=o.v||1;this.c=0;var li_node="li";this.loop=o.loop||false;if(this.loop){this.li=this.box.find(li_node);this.box.append(this.li.eq(0).clone(true));};this.li=this.box.find(li_node);this.l=this.li.length;if(this.l<=this.v){this.btnP.hide();this.btnN.hide();};this.deInit=true;this.w=this.li.outerWidth(true);this.box.width(this.w*this.l);this.maxL=this.l-this.v;this.s=o.s||1;if(this.s>1){this.w=this.v*this.w;this.maxL=Math.floor(this.l/this.v);this.box.width(this.w*(this.maxL+1));var addNum=(this.maxL+1)*this.v-this.l;var addHtml="";for(var adN=0;adN<addNum;adN++){addHtml+="<li class='addBox'><div class='photo'></div><div class='text'></div></li>";};this.box.append(addHtml);};this.numIco=null;if(o.numIco){this.numIco=$("#"+o.numIco);var numHtml="";numL=this.loop?(this.l-1):this.l;for(var i=0;i<numL;i++){numHtml+="<a href='javascript:void(0);'>"+i+"</a>";};this.numIco.html(numHtml);this.numIcoLi=this.numIco.find("a");this.numIcoLi.bind("click",function(){if(that.c==$(this).html())return false;that.c=$(this).html();that.move();});};this.bigBox=null;this.loadNumBox=null;if(o.loadNumBox){this.loadNumBox=$("#"+o.loadNumBox);};this.allNumBox=null;if(o.loadNumBox){this.allNumBox=$("#"+o.allNumBox);if(o.bBox){var cAll=this.l<10?("0"+this.l):this.l;}else{var cAll=this.maxL<10?("0"+(this.maxL+1)):(this.maxL+1);};this.allNumBox.html(cAll);};if(o.bBox){this.bigBox=$("#"+o.bBox);this.li.each(function(n){$(this).attr("num",n);var cn=(n+1<10)?("0"+(n+1)):n+1;$(this).find(".text").html(cn);});this.loadNum=0;this.li.bind("click",function(){if(that.loadNum==$(this).attr("num"))return false;var test=null;if(that.loadNum>$(this).attr("num")){test="pre";};that.loadNum=$(this).attr("num");that.loadImg(test);});that.loadImg();if(o.bNext){that.bNext=$("#"+o.bNext);that.bNext.bind("click",function(){that.loadNum<that.l-1?that.loadNum++:that.loadNum=0;that.loadImg();});};if(o.bPre){that.bPre=$("#"+o.bPre);that.bPre.bind("click",function(){that.loadNum>0?that.loadNum--:that.loadNum=that.l-1;that.loadImg("pre");});};};if(this.loop){this.btnP.bind("click",function(){if(that.c<=0){that.c=that.l-1;that.box.css({left:-that.c*that.w});};that.c--;that.move(1);});this.btnN.bind("click",function(){if(that.c>=(that.l-1)){that.box.css({left:0});that.c=0;};that.c++;that.move(1);});}else{this.btnP.bind("click",function(){that.c>0?that.c--:that.c=that.maxL;that.move(1);});this.btnN.bind("click",function(){that.c<that.maxL?that.c++:that.c=0;that.move(1);});};that.timer=null;if(o.auto){that.box.bind("mouseover",function(){clearInterval(that.timer);});that.box.bind("mouseleave",function(){that.autoPlay();});that.autoPlay();};this.move();}
ShowPre.prototype={move:function(test){var that=this;var pos=this.c*this.w;if(test&&that.timer){clearInterval(that.timer);};if(that.numIco){that.numIcoLi.removeClass("on");var numC=that.c;if(that.loop&&(that.c==(this.l-1))){numC=0;};that.numIcoLi.eq(numC).addClass("on");};this.box.stop();this.box.animate({left:-pos},function(){if(test&&that.auto){that.autoPlay();};if(that.loop&&that.c==that.maxL){that.c=0;that.box.css({left:0})};});if(that.bigBox)return false;if(that.loadNumBox){var loadC=parseInt(that.c)+1;loadC=loadC<10?"0"+loadC:loadC;that.loadNumBox.html(loadC);};},loadImg:function(test){var that=this;var _src=this.li.eq(that.loadNum).attr("bsrc"),bigTh3=null,bigTh4=null,bigText=null;if(that.li.eq(that.loadNum).attr("data-h")){var bigTh3=$("#bigT h3");$("#bigT").hide();bigTh3.html("");};if(that.li.eq(that.loadNum).attr("data-m")){var bigTh4=$("#bigT h4");$("#bigT").hide();bigTh4.html("");};if(that.li.eq(that.loadNum).attr("data-text")){var bigText=$("#bigText");bigText.html("").hide();};var img=new Image();$(img).hide();if(that.deInit){var le=0;that.deInit=false;that.bigBox.html("<div class='loading'></div><div class='loading'></div>");}else{if(test!="pre"){var le=-1230;that.bigBox.append("<div class='loading'></div>");}else{var le=1230;that.bigBox.find(".loading").before("<div class='loading'></div>");that.bigBox.css({"margin-left":-1230});le=0;};};that.bigBox.animate({"margin-left":le},function(){$(img).bind("load",function(){if(test!="pre"){var n=1,oldN=0;}else{var n=0,oldN=1;};that.bigBox.find(".loading").eq(n).html(img);that.bigBox.find(".loading").eq(oldN).remove();that.bigBox.css({"margin-left":0});$(this).fadeIn(200,function(){if(bigTh3){$("#bigT").fadeIn()
bigTh3.html(that.li.eq(that.loadNum).attr("data-h"));};if(bigTh4){$("#bigT").fadeIn()
bigTh4.html(that.li.eq(that.loadNum).attr("data-m"));};if(bigText){bigText.html(that.li.eq(that.loadNum).attr("data-text")).fadeIn();};});});img.src=_src;});that.li.removeClass("on");that.li.eq(that.loadNum).addClass("on");if(that.loadNumBox){var loadC=parseInt(that.loadNum)+1;loadC=loadC<10?"0"+loadC:loadC;that.loadNumBox.html(loadC);};},autoPlay:function(){var that=this;that.timer=setInterval(function(){that.c<that.maxL?that.c++:that.c=0;that.move();},4000);}}
function indexTabs(thisObj,Num){if(thisObj.className=="cur")return;var tabObj=thisObj.parentNode.id;var tabList=document.getElementById(tabObj).getElementsByTagName("li");for(i=0;i<tabList.length;i++)
{if(i==Num)
{thisObj.className="cur";document.getElementById(tabObj+"_Content"+i).style.display="block";}else{tabList[i].className="";document.getElementById(tabObj+"_Content"+i).style.display="none";}}}
function show_sch_info(o,msg,yuyue_max,yuyue_num,guahao_amt){$('#popover_1').text(msg);$('#popover_2').text(yuyue_max);$('#popover_3').text(yuyue_num);$('#popover_4').text(guahao_amt);var $popover=$('.popover');var $self=$(o);$popover.css({left:$self.offset().left,top:$self.offset().top+$self.outerHeight()}).show();}