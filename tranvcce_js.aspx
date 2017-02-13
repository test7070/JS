<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC4lkDc9H0JanDkP8MUpO-mzXRtmugbiI8&signed_in=true&callback=initMap" async defer></script>
		<script type="text/javascript">
			var data_car=[],data_orde=[],data_car_current=-1;
			var waypts;
			var directionsService;
            var directionsDisplay;
            var direction;
 			var map;
 			var markers;
			var locations;
			var isRun = false;//執行carSchedule須等待,才能排路徑
			var infowindow;//訊息視窗
			
			q_tables = 't';
			var q_name = "tranvcce";
			var q_readonly = ['txtNoa','txtWorker', 'txtWorker2'];
			var q_readonlys = ['txtOrdeno','txtNo2'];
			var q_readonlyt = ['txtCust','txtAddrno','txtAddr','txtProduct'];
			var bbmNum = new Array();
			var bbmMask = new Array(['txtDatea', '999/99/99'],['txtTimea', '99:99']);
			var bbsNum = new Array();
			var bbsMask = new Array();
			var bbtNum  = new Array(); 
			var bbtMask = new Array(['txtTime1', '99:99'],['txtTime2', '99:99']);
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'noa';
			q_alias = '';
			q_desc = 1;
			//q_xchg = 1;
			brwCount2 = 7;
			aPop = new Array(['txtAddrno', 'lblAddr_js', 'addr2', 'noa,addr,address,lat,lng', 'txtAddrno,txtAddr,txtAddress,txtLat,txtLng', 'addr2_b.aspx']
				,['txtEndaddrno', 'lblEndaddr_js', 'addr2', 'noa,addr,address,lat,lng', 'txtEndaddrno,txtEndaddr,txtEndaddress,txtEndlat,txtEndlng', 'addr2_b.aspx']
				,['txtProductno_', 'btnProduct_', 'ucc', 'noa,product', 'txtProductno_,txtProduct_', 'ucc_b.aspx']
				,['txtAddrno_', 'btnAddr_', 'addr2', 'noa,addr,address,lat,lng', 'txtAddrno_,txtAddr_,txtAddress_,txtLat_,txtLng_', 'addr2_b.aspx']
				,['txtAddrno__', 'btnAddr__', 'addr2', 'noa,addr,address,lat,lng', 'txtAddrno__,txtAddr__,txtLat__,txtLng__', 'addr2_b.aspx']
				,['txtCarno_', 'btnCarno_', 'car2', 'a.noa,driverno,driver', 'txtCarno_', 'car2_b.aspx']
				,['txtCarno__', 'btnCarno__', 'car2', 'a.noa,driverno,driver', 'txtCarno__', 'car2_b.aspx']);

			function sum() {
				if (!(q_cur == 1 || q_cur == 2))
					return;
				var cuft=0;
				for(var i=0;i<q_bbsCount;i++){
					switch(q_getPara('sys.project').toUpperCase()){
						case 'JS':
							//只算面積  length*width
							cuft = q_float('txtMount_'+i) * Math.ceil(q_float('txtLengthb_'+i)* q_float('txtWidth_'+i));
							break;
						default:
							cuft = round(0.0000353 * q_float('txtLengthb_'+i)* q_float('txtWidth_'+i)* q_float('txtHeight_'+i)* q_float('txtMount_'+i),2); 
							break;
					}
					$('#txtVolume_'+i).val(cuft);
					$('#txtWeight_'+i).val(round(q_float('txtMount_'+i)*q_float('txtUweight_'+i),0));
					if(q_float('txtTvolume_'+i)==0){
						$('#txtTvolume_'+i).val(Math.ceil(cuft));
					}	
				}
				for(var i=0;i<q_bbtCount;i++){
					cuft = 0;
					t_weight = 0;
					for(var j=0;j<q_bbsCount;j++){
						if($('#txtOrdeno__'+i).val()==$('#txtOrdeno_'+j).val() && $('#txtNo2__'+i).val()==$('#txtNo2_'+j).val()){
							//只算面積  length*width
							//cuft = round(0.0000353 *q_float('txtMount__'+i)* q_float('txtLengthb_'+j)* q_float('txtWidth_'+j)* q_float('txtHeight_'+j),2); 
							cuft = q_float('txtMount__'+i)*Math.ceil(q_float('txtLengthb__'+i)* q_float('txtWidth__'+i));
							t_weight = round(q_float('txtMount__'+i)*q_float('txtUweight_'+j),0);
							break;
						}
					}
					$('#txtVolume__'+i).val(Math.ceil(cuft));
					$('#txtWeight__'+i).val(t_weight);	
				}
			}
			
			$(document).ready(function() {
				var t_where = '';
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				bbtKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
			});
			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(0);
				
			}

			function mainPost() {
				q_mask(bbmMask);
				
				switch(q_getPara('sys.project').toUpperCase()){
					case 'JS':
						$('.js_hide').hide();
						break;
					default:
						break;
				}
				
				$('#btnOrde').click(function(e){
                	var t_where ='';
                	q_box("tranordejs_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({project:q_getPara('sys.project').toUpperCase(),noa:$('#txtNoa').val(),chk1:$('#chkChk1').prop('checked')?1:0,chk2:$('#chkChk2').prop('checked')?1:0}), "tranorde_tranvcce", "95%", "95%", '');
                });
                $('#btnCar').click(function(e){
                	var t_where ='',t_date=$('#txtDatea').val();
                	var t_weight=0,t_volume=0;
                	//var t_ordeno='';//依訂單來顯示哪些車能夠跑
                	var t_addrno='';
                	for(var i=0;i<q_bbsCount;i++){
                		t_weight+=q_float('txtWeight_'+i);
                		t_volume+=q_float('txtTvolume_'+i);
                		if($('#txtAddrno_'+i).val().length>0){
                			t_addrno += (t_addrno.length>0?'@':'') + $('#txtAddrno_'+i).val(); 
                		}
                		/*if($('#txtOrdeno_'+i).val().length>0){
                			t_ordeno += (t_ordeno.length>0?'&':'') + $('#txtOrdeno_'+i).val()+'-'+$('#txtNo2_'+i).val(); 
                		}*/
                	}
                	q_box("trancarjs_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({noa:$('#txtNoa').val(),date:t_date,weight:t_weight,volume:t_volume,addrno:t_addrno}), "car_tranvcce", "95%", "95%", '');
                });
                
				$('#btnRun').click(function() {
					isRun = true;
					carSchedule();
				});
				$('#btnIns').before($('#btnIns').clone().attr('id', 'btnMap').attr('value', '地圖'));
                $('#btnMap').click(function() {
                    $('#mapForm').toggle();
                    if($('#mapForm').is(':visible')){
                    	initMap();
                    	//refreshMarker();	
                    }
                });
                //window.onload = addListeners;
				$('#mapStatus').mousedown(function(e) {
					if(e.button==2){			   		
						$(this).parent().data('xtop',parseInt($(this).parent().css('top')) - e.clientY);
						$(this).parent().data('xleft',parseInt($(this).parent().css('left')) - e.clientX);
					}
				}).mousemove(function(e) {
					if(e.button==2 && e.target.nodeName!='INPUT'){ 
						$(this).parent().css('top',$(this).parent().data('xtop')+e.clientY);
						$(this).parent().css('left',$(this).parent().data('xleft')+e.clientX);
					}
				}).bind('contextmenu', function(e) {
					if(e.target.nodeName!='INPUT')
						e.preventDefault();
				});
				$('#carStatus').mousedown(function(e) {
					if(e.button==2){			   		
						$(this).parent().data('xtop',parseInt($(this).parent().css('top')) - e.clientY);
						$(this).parent().data('xleft',parseInt($(this).parent().css('left')) - e.clientX);
					}
				}).mousemove(function(e) {
					if(e.button==2 && e.target.nodeName!='INPUT'){ 
						$(this).parent().css('top',$(this).parent().data('xtop')+e.clientY);
						$(this).parent().css('left',$(this).parent().data('xleft')+e.clientX);
					}
				}).bind('contextmenu', function(e) {
					if(e.target.nodeName!='INPUT')
						e.preventDefault();
				});
				
				$('#mapDirection').click(function(e){
					displayDirections();
				});
				$('#mapAll').click(function(e){
					displayAll();
				});
			}
			/*function addListeners() {
                document.getElementById('mapStatus').addEventListener('mousedown', mouseDown, false);
                window.addEventListener('mouseup', mouseUp, false);
            }

            function mouseUp() {
                window.removeEventListener('mousemove', divMove, true);
            }

            function mouseDown(e) {
                window.addEventListener('mousemove', divMove, true);
            }

            function divMove(e) {
                var div = document.getElementById('mapForm');
                div.style.position = 'absolute';
                div.style.top = e.clientY + 'px';
                div.style.left = e.clientX + 'px';
            }*/
            
			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					$('#lblNo_' + i).text(i + 1);
                    if($('#btnMinus_' + i).hasClass('isAssign'))
                    	continue;
                	$('#txtCarno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnCarno_'+n).click();
                    });
                    $('#txtProductno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnProduct_'+n).click();
                    });
                    $('#txtAddrno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnAddr_'+n).click();
                    });
                    $('#txtMount_' + i).change(function(e) {
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        refreshWV(n);
                    });
                    $('#txtLengthb_' + i).change(function(e) {
                        sum();
                    });
                    $('#txtWidth_' + i).change(function(e) {
                        sum();
                    });
                    $('#txtHeight_' + i).change(function(e) {
                        sum();
                    });
                    $('#btnLicence_'+i).click(function(e){
                    	var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                    	var t_addrno = $.trim($('#txtAddrno_'+n).val());
                    	//alert(t_addrno);
                    	if(t_addrno.length>0)
                    		q_gt('addr2', "where=^^noa='"+t_addrno+"'^^", 0, 0, 0, JSON.stringify({action:"getAddrno",n:n}));
                    });
				}
				_bbsAssign();
				$('#tbbs').find('tr.data').children().hover(function(e){
					$(this).parent().css('background','yellow');
				},function(e){
					$(this).parent().css('background','#cad3ff');
				});
			}
			function refreshWV(n){
				var t_productno = $.trim($('#txtProductno_'+n).val());
				if(t_productno.length==0){
					$('#txtWeight_'+n).val(0);
					$('#txtVolume_'+n).val(0);
					$('#txtTvolume_'+n).val(0);
				}else{
					q_gt('ucc', "where=^^noa='"+t_productno+"'^^", 0, 0, 0, JSON.stringify({action:"getUcc",n:n}));
				}
			}
			
			function bbtAssign() {
                for (var i = 0; i < q_bbtCount; i++) {
                    $('#lblNo__' + i).text(i + 1);
                    if($('#btnMinut__' + i).hasClass('isAssign'))
                    	continue;
                    $('#txtMount__' + i).change(function(e) {
                        sum();
                    });	
                    $('#btnMap__' + i).click(function(e) {
                    	var n = $(this).attr('id').replace(/^(.*)__(\d+)$/,'$2');
                    	if($('#txtCarno__'+n).val().length==0)
                    		return;
                    	$('#mapForm').show().offset({left:$(this).offset().left+250,top:$(this).offset().top});  
                		initMap();
                        displayRoute(directionsService, directionsDisplay,$('#txtCarno__'+n).val());
                    });	
                }
                _bbtAssign();
                $('#btnMap_close').click(function(e){
					$('#mapForm').hide();
				});
				$('#tbbt').find('tr.data').children().hover(function(e){
					$(this).parent().css('background','yellow');
				},function(e){
					$(this).parent().css('background','pink');
				});
            }

			function bbsSave(as) {
				if (!as['addrno']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}
			function bbtSave(as) {
				if (!as['addrno'] && !as['lat']) {
					as[bbtKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}
			function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                	case 'tranorde_tranvcce':
                        if (b_ret != null) {
                        	for(var i=0;i<q_bbsCount;i++)
                        		$('#btnMinus_'+i).click();
                        	as = b_ret;
                    		q_gridAddRow(bbsHtm, 'tbbs', 'txtTypea,txtOrdeno,txtNo2,txtCustno,txtCust,txtProductno,txtProduct,txtUweight,txtMount,txtWeight,txtVolume,txtAddrno,txtAddr,txtAddress,txtLat,txtLng,txtMemo,txtLengthb,txtWidth,txtHeight,txtTheight,txtTvolume,txtConn,txtTel,txtAllowcar,chkChk1,chkChk2,chkChk3'
                        	, as.length, as, 'typea,noa,noq,custno,cust,productno,product,uweight,emount,weight,volume,addrno,addr,address,lat,lng,memo,lengthb,width,height,theight,tvolume,conn,tel,allowcar,chk1,chk2,chk3', '','');
                       		carSchedule();
                        }else{
                        	Unlock(1);
                        }
                        break;
                    case 'car_tranvcce':
                        if (b_ret != null) {
                        	as = b_ret;
                        	$('#_carno').children().remove();
                        	for(var i=0;i<as.length;i++){
                        		$('#_carno').append('<div>'
                        			+'<a class="carno">'+as[i].carno+'</a>'
                        			+'<a style="display:none" class="weight">'+as[i].weight+'</a>'
                        			+'<a style="display:none" class="volume">'+as[i].volume+'</a>'
                        			+'</div>');
                        	}
                        	carSchedule();
                        }else{
                        	Unlock(1);
                        }
                        break;
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
                b_pop='';
            }
            function q_gtPost(t_name) {
                switch (t_name) {
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                    default:
                    	try{
                    		var t_para = JSON.parse(t_name);
                    		if(t_para.action=="getUcc"){
                    			var n = t_para.n;
                    			as = _q_appendData("ucc", "", true);
                    			if(as[0]!=undefined){
                    				$('#txtWeight_'+n).val(round(q_mul(q_float('txtMount_'+n),parseFloat(as[0].uweight)),3));
                    				$('#txtVolume_'+n).val(round(q_mul(q_float('txtMount_'+n),parseFloat(as[0].stkmount)),0));
                    				$('#txtTvolume_'+n).val(round(q_mul(q_float('txtMount_'+n),parseFloat(as[0].tvolume)),0));
                    			}else{
                    				$('#txtWeight_'+n).val(0);
                    				$('#txtVolume_'+n).val(0);
                    				$('#txtTvolume_'+n).val(0);
                    			}
                    		}else if(t_para.action=="getAssignPath"){
                				var n = t_para.n;
                				data_orde[n].assignpath = [];
                    			as = _q_appendData("addr2s", "", true);
                    			if(as[0]!=undefined){
	                    			for(var i=0;i<as.length;i++){
	                    				data_orde[n].assignpath.push({
	                    					addrno : as[i].addrno,
	                    					addr : as[i].addr,
	                    					address : as[i].address,
	                    					lat : parseFloat(as[i].lat),
	                    					lng : parseFloat(as[i].lng)
	                    				});
	                    			}
                    			}
                    			//終點就addr2的BBM
                    			data_orde[n].assignpath.push({
                					addrno : data_orde[n].addrno,
                					addr : data_orde[n].addr,
                					address : data_orde[n].address,
                					lat : parseFloat(data_orde[n].lat),
                					lng : parseFloat(data_orde[n].lng)
                				});
                    			getAssignPath(n+1);
                			}else if(t_para.action=="getAddrno"){
                				var n = t_para.n;
                    			as = _q_appendData("addr2", "", true);
                    			if(as[0]!=undefined){
                    				if(as[0].custno.length>0){
                    					q_box("addr3_js.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + as[0].custno + "';" + r_accy, 'addr3', "95%", "95%", q_getMsg("popAddr3"));
                    				}else{
                    					alert('無設定');
                    				}
                    			}else{
                    				alert('無地點');	
                    			}
                			}else if(t_para.action=="tranvccejs"){
                				var carno = t_para.carno;
                				as = _q_appendData("tranvccejs", "", true);
                    			if(as[0]!=undefined){
                    				markers = [];
                    				locations = [];
                    				for(var i=0;i<as.length;i++){
                    					if(parseFloat(as[i].mount)==0)
                    						continue;
                    					locations.push({
											lat : parseFloat(as[i].lat),
											lng : parseFloat(as[i].lng),
											ordeno : as[i].ordeno+'-'+as[i].no2,
											cust : as[i].cust,
											text : (i+1)+'',
											color : 'red',
											carvolume : as[i].carvolume,
											volume : as[i].volume,
											gvolume : as[i].gvolume,
											evolume : as[i].evolume,
											ratevolume : as[i].ratevolume,
											carweight : as[i].carweight,
											weight : as[i].weight,
											gweight : as[i].gweight,
											eweight : as[i].eweight,
											rateweight : as[i].rateweight
										});
                    				}
                    				for(var i=0;i<locations.length;i++){
										addMarkerWithTimeout2(i, 300);
									}
                    			}
                			}else {
                    			/*$('#txtWeight_'+n).val(0);
                				$('#txtVolume_'+n).val(0);
                				$('#txtTvolume_'+n).val(0);*/
							}
							sum();
                		}catch(e){
                    		Unlock(1);
                    	}
                        break;
                }
            }

		
			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('tranvcce_js_s.aspx', q_name + '_s', "500px", "600px", q_getMsg("popSeek"));
			}

			function btnIns() {
				_btnIns();
				$('#_orde').children().remove();
				$('#_carno').children().remove();
				$('#txtNoa').val('AUTO');
				$('#txtDatea').val(q_date());
				$('#chkEnda').prop('checked',false);
				$('#txtDatea').focus();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#_orde').children().remove();
				$('#_carno').children().remove();
				$('#txtDatea').focus();
			}

			function btnPrint() {
				//q_box('z_tranorde_js.aspx?' + r_userno + ";" + r_name + ";" + q_time + ";" + $('#txtNoa').val() + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
			}

			function btnOk() {
				$('#txtDatea').val($.trim($('#txtDatea').val()));
				if ($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())) {
                    alert(q_getMsg('lblDatea') + '錯誤。');
                    Unlock(1);
                    return;
                }
                /*for(vari=0;i<q_bbsCount;i++){
                	$('#chkChk1_'+i).prop('checked',$('#chkChk1').prop('checked'));
                	$('#chkChk2_'+i).prop('checked',$('#chkChk2').prop('checked'));
                }*/
                
				sum();
				if(q_cur ==1){
					$('#txtWorker').val(r_name);
				}else if(q_cur ==2){
					$('#txtWorker2').val(r_name);
				}else{
					alert("error: btnok!");
				}
				var t_noa = trim($('#txtNoa').val());
				var t_date = trim($('#txtDatea').val());
				if (t_noa.length == 0 || t_noa == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_tranvcce') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
				else
					wrServer(t_noa);
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], '', '', 2);
			}
			
			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
			}

			function refresh(recno) {
				_refresh(recno);
				$('#img').attr('src',$('#txtImg').val());
				$('#_carno').children().remove();
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if(t_para){
					$('#txtDatea').datepicker('destroy');
					$('#btnRun').attr('disabled','disabled');
					$('#btnOrde').attr('disabled','disabled');
					$('#btnCar').attr('disabled','disabled');
				}else{
					$('#txtDatea').datepicker();
					$('#btnRun').removeAttr('disabled');
					$('#btnOrde').removeAttr('disabled');
					$('#btnCar').removeAttr('disabled');
				}
			}

			function btnMinus(id) {
				_btnMinus(id);
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);

			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function btnTop() {
				_btnTop();
			}

			function btnPrev() {
				_btnPrev();
			}

			function btnPrevPage() {
				_btnPrevPage();
			}

			function btnNext() {
				_btnNext();
			}

			function btnNextPage() {
				_btnNextPage();
			}

			function btnBott() {
				_btnBott();
			}

			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}

			function btnDele() {
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}
			
			function q_funcPost(t_func, result) {
				switch(t_func) {
					default:
						break;
				}
			}
			function q_popPost(id) {
				switch(id){
					case 'txtProductno_':
						var n = b_seq;
						refreshWV(n);
						break;
					default:
						break;
				}
			}
			function initMap() {
				direction = null;
				
				if(markers!=undefined && markers.length>0)
					for(var i=0;i<markers.length;i++){
						markers[i].setMap(null);	
					}
				markers = [];
				
                directionsService = new google.maps.DirectionsService();
                //directionsDisplay = new google.maps.DirectionsRenderer();
                directionsDisplay = new google.maps.DirectionsRenderer({suppressMarkers: true});
                map = new google.maps.Map(document.getElementById('map'), {
                    zoom : 13,
                    center : {
                        lat : 24.8013848,
                    	lng : 120.9494774
                    }
                });
                directionsDisplay.setMap(map);
                
                infowindow = new google.maps.InfoWindow({content: ''});
            }

            function calculateAndDisplayRoute(directionsService, directionsDisplay, orde, car) {
               	//console.log('xx '+data_car_current+':'+car.isassign);
                /*var waypts = [];
                for(var i=0;i<q_bbsCount;i++){
                	$('#txtAddress_'+i).val($.trim($('#txtAddress_'+i).val()));	
                	if(q_float('txtLat_'+i)!=0 && q_float('txtLng_'+i)!=0){
                		waypts.push({
                            location : new google.maps.LatLng(q_float('txtLat_'+i),q_float('txtLng_'+i)),
                            stopover : true
                        });
                	}
                }*/
                waypts = [];
                var origin,destination;
                if(car.isassign==1){
                	if(car.orde[0].assignpath.length==0){
                		origin = new google.maps.LatLng(parseFloat(car.orde[0].lat),parseFloat(car.orde[0].lng));
                    	destination = new google.maps.LatLng(parseFloat(car.orde[0].lat),parseFloat(car.orde[0].lng));
                	}else{
                		origin = new google.maps.LatLng(car.orde[0].assignpath[0].lat,car.orde[0].assignpath[0].lng);
                		destination = new google.maps.LatLng(car.orde[0].assignpath[car.orde[0].assignpath.length-1].lat,car.orde[0].assignpath[car.orde[0].assignpath.length-1].lng);
                		for(var i=1;i<car.orde[0].assignpath.length-1;i++){
                			waypts.push({
		                        location : new google.maps.LatLng(car.orde[0].assignpath[i].lat,car.orde[0].assignpath[i].lng),
		                        stopover : true
		                    });
                		}
                	}
                }else{
                	origin = new google.maps.LatLng(parseFloat($('#txtLat').val()),parseFloat($('#txtLng').val()));
                    destination = new google.maps.LatLng(parseFloat($('#txtEndlat').val()),parseFloat($('#txtEndlng').val()));
                	for(var i=0;i<car.orde.length;i++){
	                	for(var j=0;j<orde.length;j++){
	                		if(car.orde[i].ordeno != orde[j].ordeno)
	                			continue;
	                		//console.log(car.carno+':'+i+'  '+orde[j].ordeno+'  '+orde[j].address);
	                		waypts.push({
		                        location : new google.maps.LatLng(orde[j].lat,orde[j].lng),
		                        stopover : true
		                    });
	                		break;
	                	}
	                }
	                if(waypts.length==0){
	                	data_car_current++;
	                    if(data_car_current<data_car.length){
						   	initMap();
						   //	console.log('func '+data_car_current+':'+data_car[data_car_current].isassign);
						   	calculateAndDisplayRoute(directionsService, directionsDisplay, data_orde, data_car[data_car_current]);
					    }
					    return;
	                }
                }
                /*console.log(car.carno);
                console.log(origin);
                console.log(destination);
                console.log(waypts);*/
                directionsService.route({
                    origin : origin,
                    destination : destination,
                    waypoints : waypts,
                    optimizeWaypoints : (data_car[data_car_current].isassign==1?false:true),//指定路徑就照原先所設定的
                    travelMode : google.maps.TravelMode.DRIVING
                }, function(response, status) {
                    if (status === google.maps.DirectionsStatus.OK) {
                        var date = new Date(parseInt($('#txtDatea').val().substring(0,3))+1911
                        	,$('#txtDatea').val().substring(4,6)
                        	,$('#txtDatea').val().substring(7,9)
                        	,$('#txtTimea').val().substring(0,2)
                        	,$('#txtTimea').val().substring(3,5));
                        	
                        directionsDisplay.setDirections(response);
                        var route = response.routes[0];
                        var strn_bbt=0;
                        for(var i=0;i<q_bbtCount;i++){
                        	if($('#txtCarno__'+i).val().length==0)
                        		break;
                        	strn_bbt++;	
                        }
                        
                        while(route.legs.length+strn_bbt+2>q_bbtCount)
                        	$('#btnPlut').click();
	                    
                        //var imgsrc = 'https://maps.googleapis.com/maps/api/staticmap?center='+$('#txtLat').val()+','+$('#txtLng').val()+'&size=300x300&maptype=roadmap';
                        var imgsrc = 'https://maps.googleapis.com/maps/api/staticmap?size=300x300&maptype=roadmap';
                        
                        imgsrc += '&markers=color:green|label:S|'+response.request.origin.lat()+','+response.request.origin.lng();
                        
                        var gvolume=0,evolume=data_car[data_car_current].volume;
                        var gweight=0,eweight=data_car[data_car_current].weight;
                        
                        for (var i = 0; i < route.legs.length; i++) {
                        	if(i<route.legs.length-1){
                        		n = route.waypoint_order[i];
                        		if(data_car[data_car_current].isassign==1){
                        			if(i==0){
                        				//起點也顯示到BBT,以便"圖"抓資料
				                        $('#txtCarno__'+(strn_bbt)).val(data_car[data_car_current].carno);
				                        $('#txtCarvolume__'+(strn_bbt)).val(data_car[data_car_current].volume);
				                        $('#txtGvolume__'+(strn_bbt)).val(gvolume);
				                        $('#txtEvolume__'+(strn_bbt)).val(evolume);
				                        $('#txtCarweight__'+(strn_bbt)).val(data_car[data_car_current].weight);
				                        $('#txtGweight__'+(strn_bbt)).val(gweight);
				                        $('#txtEweight__'+(strn_bbt)).val(eweight);
				                        
				                        ratevolume = data_car[data_car_current].volume==0?0:round(gvolume/data_car[data_car_current].volume*100,2);
				                        rateweight = data_car[data_car_current].weight==0?0:round(gweight/data_car[data_car_current].weight*100,2);
				                        $('#txtRatevolume__'+(strn_bbt)).val(ratevolume);
				                        $('#txtRateweight__'+(strn_bbt)).val(rateweight);
				                        
			                        	$('#txtAddrno__'+(strn_bbt)).val(data_car[data_car_current].orde[0].assignpath[0].addrno);
				                		$('#txtAddr__'+(strn_bbt)).val(data_car[data_car_current].orde[0].assignpath[0].addr);
				                		$('#txtAddress__'+(strn_bbt)).val(data_car[data_car_current].orde[0].assignpath[0].address);
				            		
				            			t_orde = data_car[data_car_current].orde[0].ordeno;
				                		$('#txtOrdeno__'+(strn_bbt)).val(t_orde.substring(0,t_orde.length-4));
				                		$('#txtNo2__'+(strn_bbt)).val(t_orde.substring(t_orde.length-3,t_orde.length));
				                	
				                		/*$('#txtCustno__'+(strn_bbt)).val(data_car[data_car_current].orde[0].custno);
				                		$('#txtCust__'+(strn_bbt)).val(data_car[data_car_current].orde[0].cust);
				                		$('#txtProductno__'+(strn_bbt)).val(data_car[data_car_current].orde[0].productno);
				                		$('#txtProduct__'+(strn_bbt)).val(data_car[data_car_current].orde[0].product);*/
			                        	
			                        	$('#txtLat__'+(strn_bbt)).val(getLatLngString(data_car[data_car_current].orde[0].assignpath[0].lat));
			                            $('#txtLng__'+(strn_bbt)).val(getLatLngString(data_car[data_car_current].orde[0].assignpath[0].lng));
			                        	$('#txtMins1__'+(strn_bbt)).val(0);
			                			$('#txtMemo__'+(strn_bbt)).val('起點');
			                			$('#txtTime2__'+(strn_bbt)).val($('#txtTimea').val());
				                        strn_bbt++;
                        			} 
                        			$('#txtCarno__'+(i+strn_bbt)).val(data_car[data_car_current].carno);
                        			$('#txtCarvolume__'+(i+strn_bbt)).val(data_car[data_car_current].volume);
                        			$('#txtGvolume__'+(i+strn_bbt)).val(gvolume);
			                        $('#txtEvolume__'+(i+strn_bbt)).val(evolume);
			                        $('#txtCarweight__'+(i+strn_bbt)).val(data_car[data_car_current].weight);
                        			$('#txtGweight__'+(i+strn_bbt)).val(gweight);
			                        $('#txtEweight__'+(i+strn_bbt)).val(eweight);
			                        
			                        ratevolume = data_car[data_car_current].volume==0?0:round(gvolume/data_car[data_car_current].volume*100,2);
			                        rateweight = data_car[data_car_current].weight==0?0:round(gweight/data_car[data_car_current].weight*100,2);
			                        $('#txtRatevolume__'+(i+strn_bbt)).val(ratevolume);
			                        $('#txtRateweight__'+(i+strn_bbt)).val(rateweight);
				                        
                        			$('#txtAddrno__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].assignpath[n+1].addrno);
	                        		$('#txtAddr__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].assignpath[n+1].addr);
	                        		$('#txtAddress__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].assignpath[n+1].address);
                        		
                        			t_orde = data_car[data_car_current].orde[0].ordeno;
	                        		$('#txtOrdeno__'+(i+strn_bbt)).val(t_orde.substring(0,t_orde.length-4));
	                        		$('#txtNo2__'+(i+strn_bbt)).val(t_orde.substring(t_orde.length-3,t_orde.length));
	                        	
	                        		$('#txtCustno__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].custno);
	                        		$('#txtCust__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].cust);
	                        		$('#txtProductno__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].productno);
	                        		$('#txtProduct__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].product);
                        		}else{
                        			if(i==0){
                        				//起點也顯示到BBT,以便"圖"抓資料
                        				$('#txtCarno__'+(strn_bbt)).val(data_car[data_car_current].carno);
                        				$('#txtCarvolume__'+(strn_bbt)).val(data_car[data_car_current].volume);
                        				$('#txtGvolume__'+(strn_bbt)).val(gvolume);
			                        	$('#txtEvolume__'+(strn_bbt)).val(evolume);
			                        	$('#txtCarweight__'+(strn_bbt)).val(data_car[data_car_current].weight);
                        				$('#txtGweight__'+(strn_bbt)).val(gweight);
			                        	$('#txtEweight__'+(strn_bbt)).val(eweight);
			                        	
			                        	ratevolume = data_car[data_car_current].volume==0?0:round(gvolume/data_car[data_car_current].volume*100,2);
				                        rateweight = data_car[data_car_current].weight==0?0:round(gweight/data_car[data_car_current].weight*100,2);
				                        $('#txtRatevolume__'+(strn_bbt)).val(ratevolume);
				                        $('#txtRateweight__'+(strn_bbt)).val(rateweight);
				                        
                        				$('#txtAddrno__'+(strn_bbt)).val($('#txtAddrno').val());
		                        		$('#txtAddr__'+(strn_bbt)).val($('#txtAddr').val());
		                        		$('#txtAddress__'+(strn_bbt)).val($('#txtAddress').val());
		                        		
		                        		$('#txtLat__'+(strn_bbt)).val($('#txtLat').val());
			                            $('#txtLng__'+(strn_bbt)).val($('#txtLng').val());
			                        	$('#txtMins1__'+(strn_bbt)).val(0);
			                			$('#txtMemo__'+(strn_bbt)).val('起點');
			                			$('#txtTime2__'+(strn_bbt)).val($('#txtTimea').val());
                        				strn_bbt++;
                        			}
                        			$('#txtCarno__'+(i+strn_bbt)).val(data_car[data_car_current].carno);
                        			$('#txtCarvolume__'+(i+strn_bbt)).val(data_car[data_car_current].volume);
                        			gvolume+=data_car[data_car_current].ordevolume[n];
                        			evolume-=data_car[data_car_current].ordevolume[n];
                        			$('#txtGvolume__'+(i+strn_bbt)).val(gvolume);
			                        $('#txtEvolume__'+(i+strn_bbt)).val(evolume);
                        			$('#txtCarweight__'+(i+strn_bbt)).val(data_car[data_car_current].weight);
                        			gweight+=data_car[data_car_current].ordeweight[n];
                        			eweight-=data_car[data_car_current].ordeweight[n];
                        			$('#txtGweight__'+(i+strn_bbt)).val(gweight);
			                        $('#txtEweight__'+(i+strn_bbt)).val(eweight);
                        			
                        			ratevolume = data_car[data_car_current].volume==0?0:round(gvolume/data_car[data_car_current].volume*100,2);
			                        rateweight = data_car[data_car_current].weight==0?0:round(gweight/data_car[data_car_current].weight*100,2);
			                        $('#txtRatevolume__'+(i+strn_bbt)).val(ratevolume);
			                        $('#txtRateweight__'+(i+strn_bbt)).val(rateweight);
				                        
                        			$('#txtAddrno__'+(i+strn_bbt)).val(data_car[data_car_current].orde[n].addrno);
	                        		$('#txtAddr__'+(i+strn_bbt)).val(data_car[data_car_current].orde[n].addr);
	                        		$('#txtAddress__'+(i+strn_bbt)).val(data_car[data_car_current].orde[n].address);
	                        		for(var j=0;j<q_bbsCount;j++){
	                        			if(data_car[data_car_current].orde[n].ordeno == $('#txtOrdeno_'+j).val()+'-'+$('#txtNo2_'+j).val()){
	                        				$('#txtMins2__'+(i+strn_bbt)).val($('#txtMins_'+j).val());
	                        			}
	                        		}
	                        		$('#txtMount__'+(i+strn_bbt)).val(data_car[data_car_current].ordemount[n]);
	                        		$('#txtVolume__'+(i+strn_bbt)).val(data_car[data_car_current].ordevolume[n]);
	                        		$('#txtWeight__'+(i+strn_bbt)).val(data_car[data_car_current].ordeweight[n]);
	                        		t_orde = data_car[data_car_current].orde[n].ordeno;
	                        		$('#txtOrdeno__'+(i+strn_bbt)).val(t_orde.substring(0,t_orde.length-4));
	                        		$('#txtNo2__'+(i+strn_bbt)).val(t_orde.substring(t_orde.length-3,t_orde.length));
	                        	
	                        		$('#txtCustno__'+(i+strn_bbt)).val(data_car[data_car_current].orde[n].custno);
	                        		$('#txtCust__'+(i+strn_bbt)).val(data_car[data_car_current].orde[n].cust);
	                        		$('#txtProductno__'+(i+strn_bbt)).val(data_car[data_car_current].orde[n].productno);
	                        		$('#txtProduct__'+(i+strn_bbt)).val(data_car[data_car_current].orde[n].product);
                        		}
                        		
                        		imgsrc += '&markers=color:red|label:'+(i+1)+'|'+getLatLngString(route.legs[i].end_location.lat())+','+getLatLngString(route.legs[i].end_location.lng());
                        	}else{
                        		
                        		//response.request.destination.lat()
                        		if(data_car[data_car_current].isassign==1){
                        			$('#txtCarno__'+(i+strn_bbt)).val(data_car[data_car_current].carno);
                        			$('#txtCarvolume__'+(i+strn_bbt)).val(data_car[data_car_current].volume);
                        			gvolume+=data_car[data_car_current].ordevolume[0];
                        			evolume-=data_car[data_car_current].ordevolume[0];
                        			$('#txtGvolume__'+(i+strn_bbt)).val(gvolume);
			                        $('#txtEvolume__'+(i+strn_bbt)).val(evolume);
                        			$('#txtCarweight__'+(i+strn_bbt)).val(data_car[data_car_current].weight);
                        			gweight+=data_car[data_car_current].ordeweight[0];
                        			eweight-=data_car[data_car_current].ordeweight[0];
                        			$('#txtGweight__'+(i+strn_bbt)).val(gweight);
			                        $('#txtEweight__'+(i+strn_bbt)).val(eweight);
                        			
                        			ratevolume = data_car[data_car_current].volume==0?0:round(gvolume/data_car[data_car_current].volume*100,2);
			                        rateweight = data_car[data_car_current].weight==0?0:round(gweight/data_car[data_car_current].weight*100,2);
			                        $('#txtRatevolume__'+(i+strn_bbt)).val(ratevolume);
			                        $('#txtRateweight__'+(i+strn_bbt)).val(rateweight);
				                        
                        			$('#txtAddrno__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].assignpath[data_car[data_car_current].orde[0].assignpath.length-1].addrno);
	                        		$('#txtAddr__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].assignpath[data_car[data_car_current].orde[0].assignpath.length-1].addr);
	                        		$('#txtAddress__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].assignpath[data_car[data_car_current].orde[0].assignpath.length-1].address);
                        			for(var j=0;j<q_bbsCount;j++){
	                        			if(data_car[data_car_current].orde[0].ordeno == $('#txtOrdeno_'+j).val()+'-'+$('#txtNo2_'+j).val()){
	                        				$('#txtMins2__'+(i+strn_bbt)).val($('#txtMins_'+j).val());
	                        			}
	                        		}
                        			$('#txtMount__'+(i+strn_bbt)).val(data_car[data_car_current].ordemount[0]);
	                        		$('#txtVolume__'+(i+strn_bbt)).val(data_car[data_car_current].ordevolume[0]);
	                        		$('#txtWeight__'+(i+strn_bbt)).val(data_car[data_car_current].ordeweight[0]);
	                        		t_orde = data_car[data_car_current].orde[0].ordeno;
	                        		$('#txtOrdeno__'+(i+strn_bbt)).val(t_orde.substring(0,t_orde.length-4));
	                        		$('#txtNo2__'+(i+strn_bbt)).val(t_orde.substring(t_orde.length-3,t_orde.length));
	                        	
	                        		$('#txtCustno__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].custno);
	                        		$('#txtCust__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].cust);
	                        		$('#txtProductno__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].productno);
	                        		$('#txtProduct__'+(i+strn_bbt)).val(data_car[data_car_current].orde[0].product);
                        		}else{
                        			$('#txtCarno__'+(i+strn_bbt)).val(data_car[data_car_current].carno);
                        			$('#txtCarvolume__'+(i+strn_bbt)).val(data_car[data_car_current].volume);
                        			$('#txtGvolume__'+(i+strn_bbt)).val(gvolume);
			                        $('#txtEvolume__'+(i+strn_bbt)).val(evolume);
                        			$('#txtCarweight__'+(i+strn_bbt)).val(data_car[data_car_current].weight);
                        			$('#txtGweight__'+(i+strn_bbt)).val(gweight);
			                        $('#txtEweight__'+(i+strn_bbt)).val(eweight);
                        			
                        			ratevolume = data_car[data_car_current].volume==0?0:round(gvolume/data_car[data_car_current].volume*100,2);
			                        rateweight = data_car[data_car_current].weight==0?0:round(gweight/data_car[data_car_current].weight*100,2);
			                        $('#txtRatevolume__'+(i+strn_bbt)).val(ratevolume);
			                        $('#txtRateweight__'+(i+strn_bbt)).val(rateweight);
				                        
                        			$('#txtAddrno__'+(i+strn_bbt)).val($('#txtEndaddrno').val());
	                        		$('#txtAddr__'+(i+strn_bbt)).val($('#txtEndaddr').val());
	                        		$('#txtAddress__'+(i+strn_bbt)).val($('#txtEndaddress').val());
                        		}
                        		imgsrc += '&markers=color:blue|label:E|'+getLatLngString(route.legs[i].end_location.lat())+','+getLatLngString(route.legs[i].end_location.lng());
                        	}
                        	$('#txtEndaddress__'+(i+strn_bbt)).val(route.legs[i].end_address);
                        	$('#txtLat__'+(i+strn_bbt)).val(getLatLngString(route.legs[i].end_location.lat()));
                            $('#txtLng__'+(i+strn_bbt)).val(getLatLngString(route.legs[i].end_location.lng()));
                        	$('#txtMemo__'+(i+strn_bbt)).val(route.legs[i].distance.text);
                        	//時間 +25%
                        	$('#txtMins1__'+(i+strn_bbt)).val(Math.round(route.legs[i].duration.value*1.25/60));
                			date.setMinutes(date.getMinutes() + round((q_float('txtMins1__'+(i+strn_bbt))),0));
                			hour = '00'+date.getHours();
                			hour = hour.substring(hour.length-2,hour.length);
                			minute = '00'+date.getMinutes();
                			minute = minute.substring(minute.length-2,minute.length);
                			$('#txtTime1__'+(i+strn_bbt)).val(hour+':'+minute);
                			
                			date.setMinutes(date.getMinutes() + q_float('txtMins2__'+(i+strn_bbt)));
                			hour = '00'+date.getHours();
                			hour = hour.substring(hour.length-2,hour.length);
                			minute = '00'+date.getMinutes();
                			minute = minute.substring(minute.length-2,minute.length);
                			$('#txtTime2__'+(i+strn_bbt)).val(hour+':'+minute);
                        }
                        //imgsrc += '&markers=color:green|label:E|'+$('#txtEndlat').val()+','+$('#txtEndlng').val();
                        imgsrc+='&key=AIzaSyC4lkDc9H0JanDkP8MUpO-mzXRtmugbiI8';
                        $('#pathImg').append('<img src="'+imgsrc+'" title="'+data_car[data_car_current].carno+'"> </img>');
                        data_car_current++;
                        if(data_car_current<data_car.length){
						   	initMap();
						   	//console.log('func2 '+data_car_current+':'+data_car[data_car_current].isassign);
						   	calculateAndDisplayRoute(directionsService, directionsDisplay, data_orde, data_car[data_car_current]);
					    }else{
					    	//done
					    }
                    } else {
                        alert('Directions request failed due to ' + status);
                    }
                });
            }
            
            function carSchedule(){
            	//原則上, 車輛應該都是符合訂單的要求, 因此就當做已選的車輛都可以跑這些訂單
            	$('#_orde').children().remove();
            	for(var i=0;i<q_bbsCount;i++){
            		if($('#txtAddrno_'+i).val().length==0)
            			continue;
            		if(q_float('txtMins_'+i)==0)
            			$('#txtMins_'+i).val(30);	
            		$('#_orde').append('<div style="display:none">'
            			+'<a class="ordeno">'+$('#txtOrdeno_'+i).val()+'-'+$('#txtNo2_'+i).val()+'</a>'
            			+'<a class="custno">'+$('#txtCustno_'+i).val()+'</a>'
            			+'<a class="cust">'+$('#txtCust_'+i).val()+'</a>'
            			+'<a class="addrno">'+$('#txtAddrno_'+i).val()+'</a>'
            			+'<a class="addr">'+$('#txtAddr_'+i).val()+'</a>'
            			+'<a class="address">'+$('#txtAddress_'+i).val()+'</a>'
            			+'<a class="weight">'+$('#txtWeight_'+i).val()+'</a>'
            			+'<a class="lat">'+$('#txtLat_'+i).val()+'</a>'
            			+'<a class="lng">'+$('#txtLng_'+i).val()+'</a>'
            			+'<a class="theight">'+$('#txtTheight_'+i).val()+'</a>'
            			+'<a class="tvolume">'+$('#txtTvolume_'+i).val()+'</a>'
            			+'<a class="date1">'+$('#txtDate1_'+i).val()+'</a>'
            			+'<a class="time1">'+$('#txtTime1_'+i).val()+'</a>'
            			+'<a class="date2">'+$('#txtDate2_'+i).val()+'</a>'
            			+'<a class="time2">'+$('#txtTime2_'+i).val()+'</a>'
            			+'<a class="productno">'+$('#txtProductno_'+i).val()+'</a>'
            			+'<a class="product">'+$('#txtProduct_'+i).val()+'</a>'
            			+'<a class="uweight">'+$('#txtUweight_'+i).val()+'</a>'
            			+'<a class="mount">'+$('#txtMount_'+i).val()+'</a>'
            			+'<a class="lengthb">'+$('#txtLengthb_'+i).val()+'</a>'
            			+'<a class="width">'+$('#txtWidth_'+i).val()+'</a>'
            			+'<a class="height">'+$('#txtHeight_'+i).val()+'</a>'
            			+'<a class="allowcar">'+$('#txtAllowcar_'+i).val()+'</a>'
            			+'<a class="chk1">'+$('#chkChk1_'+i).prop('checked')+'</a>'
            			+'<a class="chk2">'+$('#chkChk2_'+i).prop('checked')+'</a>'
            			+'<a class="chk3">'+$('#chkChk3_'+i).prop('checked')+'</a>'
            			+'<a class="isassign">'+$('#chkIsassign_'+i).prop('checked')+'</a>'
            			+'</div>');
            	}
            	
				var obj;
				data_car_current = -1;
                data_car = [];
                for(var i=0;i<$('#_carno').find('div').length;i++){
                	obj = $('#_carno').find('div').eq(i);
                	data_car.push({
            			carno:obj.find('.carno').eq(0).text()
            			,weight:parseFloat(obj.find('.weight').eq(0).text())
            			,volume:parseFloat(obj.find('.volume').eq(0).text())
            			,gweight:0
            			,gvolume:0
            			,eweight:parseFloat(obj.find('.weight').eq(0).text())
            			,evolume:parseFloat(obj.find('.volume').eq(0).text())
            			,orde:[]
            			,ordevolume:[]
            			,ordeweight:[]
            			,ordemount:[]
            			,isassign:0 //假如跑指定地點,那就只跑那一次
        			});
                }
                data_orde = [];
                for(var i=0;i<$('#_orde').find('div').length;i++){
                	obj = $('#_orde').find('div').eq(i);
                	data_orde.push({
                		ordeno:obj.find('.ordeno').eq(0).text()
                		,custno:obj.find('.custno').eq(0).text()
                		,cust:obj.find('.cust').eq(0).text()
            			,addrno:obj.find('.addrno').eq(0).text()
            			,addr:obj.find('.addr').eq(0).text()
            			,address:obj.find('.address').eq(0).text()
            			,lat:obj.find('.lat').eq(0).text()
            			,lng:obj.find('.lng').eq(0).text()
            			,weight:obj.find('.weight').eq(0).text()
            			,theight:obj.find('.theight').eq(0).text()
            			,tvolume:parseFloat(obj.find('.tvolume').eq(0).text())
            			,gmount:0
            			,emount:parseFloat(obj.find('.mount').eq(0).text())
            			,productno:obj.find('.productno').eq(0).text()
            			,product:obj.find('.product').eq(0).text()
            			,uweight:parseFloat(obj.find('.uweight').eq(0).text())
            			,mount:parseFloat(obj.find('.mount').eq(0).text())
            			,lengthb:parseFloat(obj.find('.lengthb').eq(0).text())
            			,width:parseFloat(obj.find('.width').eq(0).text())
            			,height:parseFloat(obj.find('.height').eq(0).text())
            			,allowcar:obj.find('.allowcar').eq(0).text()
            			,chk1:obj.find('.chk1').eq(0).text()=="true"?1:0
            			,chk2:obj.find('.chk2').eq(0).text()=="true"?1:0
            			,chk3:obj.find('.chk3').eq(0).text()=="true"?1:0
            			,isassign:obj.find('.isassign').eq(0).text()=="true"?1:0
            			,orderange : []
                    });
                }
                var str = {lat:parseFloat($('#txtLat').val()),lng:parseFloat($('#txtLng').val())};
                for(var i=0;i<data_orde.length;i++){
                	 //計算訂單與起點的距離
                	target = {lat:data_orde[i].lat,lng:data_orde[i].lng};
                	data_orde[i].range = round(calcDistance(str,target),0); 
                	 //計算訂單與其他訂單的距離
                	 for(var j=0;j<data_orde.length;j++){
                	 	if(data_orde[i].addrno==data_orde[j].addrno)
                	 		data_orde[i].orderange.push({ordeno:data_orde[j].ordeno,range:0});
                	 	else{
                	 		data_orde[i].orderange.push({ordeno:data_orde[j].ordeno,range:round(calcDistance({lat:data_orde[j].lat,lng:data_orde[j].lng},target),0)});
                	 	}
                	 }
                }
                //依訂單與起點的距離
                data_orde.sort(function(a, b) {
					if(a.range < b.range)
						return -1;
					else if(a.range == b.range)
						return 0;
					else
						return 1;
				});
				//依訂單彼此的距離排序
				for(var i=0;i<data_orde.length;i++){
					data_orde[i].orderange.sort(function(a, b) {
						if(a.range < b.range)
							return -1;
						else if(a.range == b.range)
							return 0;
						else
							return 1;
					});						
				}
				//載入指定路徑資料
				getAssignPath(0);
            }
            function getAssignPath(n){
            	if(n<data_orde.length){
            		if(data_orde[n].isassign == 1)
            			q_gt('addr2s', "where=^^noa='"+data_orde[n].addrno+"' order by noq^^", 0, 0, 0, JSON.stringify({action:"getAssignPath",n:n}));
            		else
            			getAssignPath(n+1);
            	}else{
            		//排程
					/*
					 * 指定路徑
					 * 原則上,一個地點能多台車跑,但跑該點的車輛就不再跑其他的地方
					 */
					for(var i=0;i<data_orde.length;i++){
						if(data_orde[i].isassign==0 || data_orde[i].emount<=0)
	                		continue;
	                	for(var j=0;j<data_car.length;j++){
	                		if(data_car[j].isassign==1)//有指定地點,就不再跑其他地方
								continue;
	                		if(data_car[j].eweight<=0 || data_car[j].evolume<=0)
	                			continue;
	                		t_mount = data_orde[i].emount;
	                		while(t_mount>=0){
	            				t_weight = round(data_orde[i].uweight * t_mount,2);
	            				//只算面積
	            				//t_cuft = round(0.0000353*t_mount*data_orde[i].lengthb*data_orde[i].width*data_orde[i].height,0);
	            				t_cuft = t_mount*Math.ceil(data_orde[i].lengthb*data_orde[i].width);
	            				if(t_mount>0 && data_car[j].eweight>=t_weight && data_car[j].evolume>=t_cuft){
	            					data_car[j].gvolume += t_cuft;
	                				data_car[j].evolume -= t_cuft;
	                				data_car[j].gweight += t_weight;
	        						data_car[j].eweight -= t_weight;
	                				data_orde[i].gmount += t_mount;
	                				data_orde[i].emount -= t_mount;
	                				data_car[j].orde.push(data_orde[i]);
	                				data_car[j].ordevolume.push(t_cuft);
	                				data_car[j].ordeweight.push(t_weight);
	                				data_car[j].ordemount.push(t_mount);
	                				data_car[j].isassign = 1; //有指定地點,就只跑那一趟
	            					break;
	            				}
	            				t_mount--;
	            			}
                		}	
                	}
					//無指定路徑
					for(var i=0;i<data_orde.length;i++){
						if(data_orde[i].isassign==1 || data_orde[i].emount<=0)
	                		continue;
						for(var j=0;j<data_car.length;j++){
							if(data_car[j].isassign==1)//有指定地點,就不再跑其他地方
								continue;
							if(data_car[j].eweight<=0 || data_car[j].evolume<=0)
	                			continue;
	                		t_mount = data_orde[i].emount;
	                		while(t_mount>=0){
	            				t_weight = round(data_orde[i].uweight * t_mount,2);
	            				//t_cuft = round(0.0000353*t_mount*data_orde[i].lengthb*data_orde[i].width*data_orde[i].height,0);
	            				t_cuft = t_mount*Math.ceil(data_orde[i].lengthb*data_orde[i].width);
	            				if(t_mount>0 && data_car[j].eweight>=t_weight && data_car[j].evolume>=t_cuft){
	            					data_car[j].gvolume += t_cuft;
	                				data_car[j].evolume -= t_cuft;
	                				data_car[j].gweight += t_weight;
	        						data_car[j].eweight -= t_weight;
	                				data_orde[i].gmount += t_mount;
	                				data_orde[i].emount -= t_mount;
	                				data_car[j].orde.push(data_orde[i]);
	                				data_car[j].ordevolume.push(t_cuft);
	                				data_car[j].ordeweight.push(t_weight);
	                				data_car[j].ordemount.push(t_mount);
	            					break;
	            				}
	            				t_mount--;
	            			}	
							//一次就把那台車排完
							for(var k;k<data_orde[i].orderange.length;k++){					
								t_nextOrdeno = data_orde[i].orderange[k].ordeno;
								for(var l=0;l<data_orde.length;l++){
									//先跑近的單子
									if(data_orde[l].ordeno != t_nextOrdeno)
										continue;
									if(data_orde[i].isassign==1 || data_orde[l].emount<=0)
	                					continue;
									t_mount = data_orde[l].emount;
			                		while(t_mount>=0){
		                				t_weight = round(data_orde[l].uweight * t_mount,2);
		                				//t_cuft = round(0.0000353*t_mount*data_orde[l].lengthb*data_orde[l].width*data_orde[l].height,0);
		                				t_cuft = t_mount*Math.ceil(data_orde[l].lengthb*data_orde[l].width);
		                				if(t_mount>0 && data_car[j].eweight>=t_weight && data_car[j].evolume>=t_cuft){
		                					data_car[j].gvolume += t_cuft;
			                				data_car[j].evolume -= t_cuft;
			                				data_car[j].gweight += t_weight;
		            						data_car[j].eweight -= t_weight;
			                				data_orde[l].gmount += t_mount;
			                				data_orde[l].emount -= t_mount;
			                				data_car[j].orde.push(data_orde[l]);
			                				data_car[j].ordevolume.push(t_cuft);
			                				data_car[j].ordeweight.push(t_weight);
			                				data_car[j].ordemount.push(t_mount);
		                					break;
		                				}
		                				t_mount--;
		                			}
								}
							}
						}	
					}
					
					if(data_orde.length>0 && data_car.length>0){
						//列出未派完的訂單
				    	data_orde.sort(function(a, b) {
							if(a.ordeno+a.no2 < b.ordeno+b.no2)
								return -1;
							else if(a.ordeno+a.no2 == b.ordeno+b.no2)
								return 0;
							else
								return 1;
						});
						var msg = '';
				    	for (var i=0;i<data_orde.length;i++){
				    		if(data_orde[i].emount>0){
				    			msg += (msg.length>0?'\n':'') + data_orde[i].ordeno+' '+data_orde[i].addr+'  數量:'+data_orde[i].mount+'  未派:'+data_orde[i].emount;
				    		}
				    	}
				    	if(msg.length>0){
				    		alert('未派完訂單:\n'+msg);
				    	}
					}
					//等全部資料都載入才執行路徑
					if(isRun){
	            		isRun = false;
	            		if(data_orde.length==0)
							alert('無訂單或訂單地點未設定');
						if(data_car.length==0)
							alert('無車輛');
						if(data_car.length>0 && data_orde.length>0){
							data_car_current = 0;
							for (var i = 0; i < q_bbtCount; i++) {
	                        	$('#btnMinut__'+i).click();
	                        }
	                        $('#pathImg').html('');
	                        $('#mapForm').hide();
							initMap();
							calculateAndDisplayRoute(directionsService, directionsDisplay, data_orde, data_car[data_car_current]);
						}
	            	}
            	}
            }

            function getLatLngString(tmp){
            	var patt = /^(\d*)\.(\d{0,7})(\d*)$/g;
            	tmp = tmp + '';
            	switch(tmp.replace(patt,'$2').length){
            		case 0:
               			tmp = tmp.replace(patt,'$1.$2')+ '.0000000';
               			break;
               		case 1:
               			tmp = tmp.replace(patt,'$1.$2')+ '.000000';
               			break;
           			case 2:
               			tmp = tmp.replace(patt,'$1.$2')+ '00000';
               			break;
           			case 3:
               			tmp = tmp.replace(patt,'$1.$2')+ '0000';
               			break;
           			case 4:
               			tmp = tmp.replace(patt,'$1.$2')+ '000';
               			break;
           			case 5:
               			tmp = tmp.replace(patt,'$1.$2')+ '00';
               			break;
           			case 6:
               			tmp = tmp.replace(patt,'$1.$2')+ '0';
               			break;
           			case 7:
               			tmp = tmp.replace(patt,'$1.$2');
               			break;
           			default:
           				break;
               	}
               	return tmp;
            }
             
        	function calcDistance(f,t){  
        		var FINAL = 6378137.0;//赤道半徑
	            var flat = f.lat*Math.PI/180.0;  
	            var flng = f.lng*Math.PI/180.0; 
	            var tlat = t.lat*Math.PI/180.0;  
	            var tlng = t.lng*Math.PI/180.0; 
	              
	            var result = Math.sin(flat)*Math.sin(tlat) ;  
	            result += Math.cos(flat)*Math.cos(tlat)*Math.cos(flng-tlng) ;  
	            return Math.acos(result)*FINAL ;  
	        }
           // var stylesArray = [{"featureType":"administrative","elementType":"all","stylers":[{"saturation":"-100"}]},{"featureType":"administrative.province","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"landscape","elementType":"all","stylers":[{"saturation":-100},{"lightness":65},{"visibility":"on"}]},{"featureType":"poi","elementType":"all","stylers":[{"saturation":-100},{"lightness":"50"},{"visibility":"simplified"}]},{"featureType":"road","elementType":"all","stylers":[{"saturation":"-100"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road.arterial","elementType":"all","stylers":[{"lightness":"30"}]},{"featureType":"road.local","elementType":"all","stylers":[{"lightness":"40"}]},{"featureType":"transit","elementType":"all","stylers":[{"saturation":-100},{"visibility":"simplified"}]},{"featureType":"water","elementType":"geometry","stylers":[{"hue":"#ffff00"},{"lightness":-25},{"saturation":-97}]},{"featureType":"water","elementType":"labels","stylers":[{"lightness":-25},{"saturation":-100}]}];
		
			function displayRoute(directionsService, directionsDisplay,carno) {
				$('#mapStatus').find('.carno').eq(0).text(carno);//記錄車牌,以便  當日全部  顯示用
				if($('#mapAll').prop('checked')){
					//顯示該車當日全部所跑過的點
					initMap();
					var carno = $('#mapStatus').find('.carno').eq(0).text();
					var date = $('#txtDatea').val();
					q_gt('tranvccejs', "where=^^['"+carno+"','"+date+"')^^", 0, 0, 0, JSON.stringify({action:"tranvccejs",carno:carno}));
					
					return;
				}
				locations = [];
                waypts = [];
                var begin=-1,end = -1;
                for(j=0;j<q_bbtCount;j++){
                	if($('#txtCarno__'+j).val()!=carno)
                		continue;
                	if(begin==-1)
                		begin = j;
                	end = j;
                }
                var n = 0;
                for(j=0;j<q_bbtCount;j++){
                	if($('#txtCarno__'+j).val()!=carno)
                		continue;
                	if(j==begin){
                		locations.push({
							lat : parseFloat($('#txtLat__'+j).val()),
							lng : parseFloat($('#txtLng__'+j).val()),
							text : 'S',
							color : 'green',
							carvolume : q_float('txtCarvolume__'+j),
							volume : q_float('txtVolume__'+j),
							gvolume : q_float('txtGvolume__'+j),
							evolume : q_float('txtEvolume__'+j),
							ratevolume : q_float('txtRatevolume__'+j),
							carweight : q_float('txtCarweight__'+j),
							weight : q_float('txtWeight__'+j),
							gweight : q_float('txtGweight__'+j),
							eweight : q_float('txtEweight__'+j),
							rateweight : q_float('txtRateweight__'+j)
						});
						origin = new google.maps.LatLng(parseFloat($('#txtLat__'+j).val()),parseFloat($('#txtLng__'+j).val()));
                	}else if(j==end){
                		locations.push({
							lat : parseFloat($('#txtLat__'+j).val()),
							lng : parseFloat($('#txtLng__'+j).val()),
							text : 'E',
							color : 'blue',
							carvolume : q_float('txtCarvolume__'+j),
							volume : q_float('txtVolume__'+j),
							gvolume : q_float('txtGvolume__'+j),
							evolume : q_float('txtEvolume__'+j),
							ratevolume : q_float('txtRatevolume__'+j),
							carweight : q_float('txtCarweight__'+j),
							weight : q_float('txtWeight__'+j),
							gweight : q_float('txtGweight__'+j),
							eweight : q_float('txtEweight__'+j),
							rateweight : q_float('txtRateweight__'+j)
						});
						destination = new google.maps.LatLng(parseFloat($('#txtLat__'+j).val()),parseFloat($('#txtLng__'+j).val()));
                	}else{
                		n++;
                		locations.push({
							lat : parseFloat($('#txtLat__'+j).val()),
							lng : parseFloat($('#txtLng__'+j).val()),
							text : (n)+'',
							color : 'red',
							carvolume : q_float('txtCarvolume__'+j),
							volume : q_float('txtVolume__'+j),
							gvolume : q_float('txtGvolume__'+j),
							evolume : q_float('txtEvolume__'+j),
							ratevolume : q_float('txtRatevolume__'+j),
							carweight : q_float('txtCarweight__'+j),
							weight : q_float('txtWeight__'+j),
							gweight : q_float('txtGweight__'+j),
							eweight : q_float('txtEweight__'+j),
							rateweight : q_float('txtRateweight__'+j)
						});
						waypts.push({
	                        location : new google.maps.LatLng(parseFloat($('#txtLat__'+j).val()),parseFloat($('#txtLng__'+j).val())),
	                        stopover : true
	                    });
                	}	
            		
                }     
                markers = []; 
				for(var i=0;i<locations.length;i++){
					addMarkerWithTimeout(i, 300);
				}
                directionsService.route({
                    origin : origin,
                    destination : destination,
                    waypoints : waypts,
                    //optimizeWaypoints : true,
                    travelMode : google.maps.TravelMode.DRIVING
                }, function(response, status) {
                    if (status === google.maps.DirectionsStatus.OK) {
                    	direction = response;
                        displayDirections();
                    } else {
                        alert('Directions request failed due to ' + status);
                    }
                });
            }
            function displayDirections(){
            	if($('#mapDirection').prop('checked')){
            		if(direction==null){
            			var carno=$('#mapStatus').find('.carno').eq(0).text();
						displayRoute(directionsService, directionsDisplay,carno);
            		}else{
            			directionsDisplay.setDirections(direction);
            		}
            	}
            	else
            		directionsDisplay.set('directions', null);
            }
            function displayAll(carno,date){
            	if($('#mapAll').prop('checked')){
            		$('#mapDirection').attr('disabled','disabled');
            		$('#mapDirection').prop('checked',false);
            	}
				else{
					$('#mapDirection').removeAttr('disabled');
					initMap();
				}
				var carno=$('#mapStatus').find('.carno').eq(0).text();
				displayRoute(directionsService, directionsDisplay,carno);
            }
            function addMarkerWithTimeout(i, timeout){
            	window.setTimeout(function() {
            		var marker = new google.maps.Marker({
						position: {lat:locations[i].lat,lng:locations[i].lng},
						opacity : 0.6,
                        label : {
	                            text : locations[i].text,
	                            color : "darkred",
	                            fontSize : "16px",
	                            fontWeight : "900",
	                            fontFamily : "微軟正黑體"
	                       	},
                       	map : map,
						animation: google.maps.Animation.DROP
						});
					marker.setIcon(pinSymbol(locations[i].color));
					marker.addListener('click', function(e) {
                    	var n = -1;
                    	for(var i=0;i<markers.length;i++){
                    		if(markers[i] === this){
								n = i ;
								break;	                    			
                    		}
                    	}
                    	//承載量、承載率、已承載、可承載
                    	var text = locations[i].text;
                    	var carvolume = locations[n].carvolume;
                    	var volume = locations[n].volume;
                    	var gvolume = locations[n].gvolume;
                    	var evolume = locations[n].evolume;
                    	var ratevolume = locations[n].ratevolume;
                    	var carweight = locations[n].carweight;
                    	var weight = locations[n].weight;
                    	var gweight = locations[n].gweight;
                    	var eweight = locations[n].eweight;
                    	var rateweight = locations[n].rateweight;
                    	var rate = locations[n].carvolume==0?'':round(locations[n].gvolume/locations[n].carvolume*100,2)+'%';
	                    var contentString = '<div id="infowindow" style="width:150px;height:180px;"><a>' + text + '</a><br><a>材積：</a><a>'+volume+'</a><br><a>已承載：</a><a>'+gvolume+'</a><br><a>承載率：</a><a>'+ratevolume+'%</a><br><a>可承載：</a><a>'+evolume+'</a><br><br><a>重量：</a><a>'+weight+'</a><br><a>已承載重量：</a><a>'+gweight+'</a><br><a>承載率：</a><a>'+rateweight+'%</a><br><a>可承載重量：</a><a>'+eweight+'</a></div>';
	                    infowindow.close();
		                infowindow.setContent(contentString);
		                infowindow.open(map,markers[n]);
	                });
	                markers.push(marker);
				}, timeout);
            }
           	function addMarkerWithTimeout2(i, timeout){
            	window.setTimeout(function() {
            		var marker = new google.maps.Marker({
						position: {lat:locations[i].lat,lng:locations[i].lng},
						opacity : 0.6,
                        label : {
	                            text : locations[i].text,
	                            color : "darkred",
	                            fontSize : "16px",
	                            fontWeight : "900",
	                            fontFamily : "微軟正黑體"
	                       	},
                       	map : map,
						animation: google.maps.Animation.DROP
						});
					marker.setIcon(pinSymbol(locations[i].color));
					marker.addListener('click', function(e) {
                    	var n = -1;
                    	for(var i=0;i<markers.length;i++){
                    		if(markers[i] === this){
								n = i ;
								break;	                    			
                    		}
                    	}
                    	//承載量、承載率、已承載、可承載
                    	var text = locations[i].text;
                    	var ordeno = locations[i].ordeno;
                    	var cust = locations[i].cust;
                    	var carvolume = locations[n].carvolume;
                    	var volume = locations[n].volume;
                    	var gvolume = locations[n].gvolume;
                    	var evolume = locations[n].evolume;
                    	var ratevolume = locations[n].ratevolume;
                    	var carweight = locations[n].carweight;
                    	var weight = locations[n].weight;
                    	var gweight = locations[n].gweight;
                    	var eweight = locations[n].eweight;
                    	var rateweight = locations[n].rateweight;
                    	var rate = locations[n].carvolume==0?'':round(locations[n].gvolume/locations[n].carvolume*100,2)+'%';
	                    var contentString = '<div id="infowindow" style="width:200px;height:230px;"><a>' + text + '</a><br><a>訂單：</a><a>'+ordeno+'</a><br><a>貨主：</a><a>'+cust+'</a><br><br><a>材積：</a><a>'+volume+'</a><br><a>已承載：</a><a>'+gvolume+'</a><br><a>承載率：</a><a>'+ratevolume+'%</a><br><a>可承載：</a><a>'+evolume+'</a><br><br><a>重量：</a><a>'+weight+'</a><br><a>已承載重量：</a><a>'+gweight+'</a><br><a>承載率：</a><a>'+rateweight+'%</a><br><a>可承載重量：</a><a>'+eweight+'</a></div>';
	                    infowindow.close();
		                infowindow.setContent(contentString);
		                infowindow.open(map,markers[n]);
	                });
	                markers.push(marker);
				}, timeout);
            }
			function pinSymbol(color) {
                return {
                    path : 'M 0,0 C -1,-10 -5,-11 -5,-15 A 5,5 0 1,1 5,-15 C 5,-11 1,-10 0,0 z',
                    fillColor : color,
                    fillOpacity : 1,
                    strokeColor : '#fff',
                    strokeWeight : 1,
                    scale : 2
                };
            }
		</script>
		
		<style type="text/css">
			#dmain {
				overflow: auto;
				width: 1600px;
			}
			.dview {
				float: left;
				width: 300px;
				border-width: 0px;
			}
			.tview {
				border: 5px solid gray;
				font-size: medium;
				background-color: black;
			}
			.tview tr {
				height: 30px;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border-width: 0px;
				background-color: #FFFF66;
				color: blue;
			}
			.dbbm {
				float: left;
				width: 600px;
				/*margin: -1px;
				 border: 1px black solid;*/
				border-radius: 5px;
			}
			.tbbm {
				padding: 0px;
				border: 1px white double;
				border-spacing: 0;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.tbbm tr {
				height: 35px;
			}
			.tbbm tr td {
				width: 12%;
			}
			.tbbm .tr2, .tbbm .tr3, .tbbm .tr4 {
				background-color: #FFEC8B;
			}
			.tbbm .tdZ {
				width: 1%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: blue;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 100%;
				float: left;
			}
			.txt.num {
				text-align: right;
			}
			.tbbm td {
				margin: 0 -1px;
				padding: 0;
			}
			.tbbm td input[type="text"] {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				float: left;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
			}
			.dbbs {
				width: 2400px;
			}
			.dbbt {
				width: 1800px;
			}
			.tbbs a {
				font-size: medium;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			select {
				font-size: medium;
			}
			
          /*  #tbbt {
                margin: 0;
                padding: 2px;
                border: 2px pink double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: pink;
                width: 100%;
            }
            #tbbt tr {
                height: 35px;
            }
            #tbbt tr td {
                text-align: center;
                border: 2px pink double;
            }*/
		</style>
	</head>
	<body 
	ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' >
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:80px; color:black;"><a>日期</a></td>
						<td align="center" style="width:150px; color:black;"><a>起點</a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox"/></td>
						<td id='datea' style="text-align: center;">~datea</td>
						<td id='addr' style="text-align: center;">~addr</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr class="tr0" style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td colspan="2"><input type="text" id="txtNoa" class="txt c1"/></td>
						<td><span> </span><a id="lblDatea_js" class="lbl">日期</a></td>
						<td><input type="text" id="txtDatea" class="txt c1"/></td>
						<td><span> </span><a id="lblTimea_js" class="lbl">時間</a></td>
						<td><input type="text" id="txtTimea" style="text-align: center;" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">提貨</a></td>
						<td><input type="checkbox" id="chkChk1" class="txt"/></td>
						<td> </td>
						<td><span> </span><a class="lbl">卸貨</a></td>
						<td><input type="checkbox" id="chkChk2" class="txt"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblAddr_js" class="lbl btn">起點</a></td>
						<td colspan="6">
							<input type="text" id="txtAddrno" class="txt" style="width:30%;float: left; " />
							<input type="text" id="txtAddr" class="txt" style="width:70%;float: left; " />
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblAddress_js" class="lbl btn">地址</a></td>
						<td colspan="6">
							<input type="text" id="txtAddress" class="txt c1"/>
							<input type="text" id="txtLat" style="float:left;width:40%;display:none;"/>
							<input type="text" id="txtLng" style="float:left;width:40%;display:none;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblEndaddr_js" class="lbl btn">終點</a></td>
						<td colspan="6">
							<input type="text" id="txtEndaddrno" class="txt" style="width:30%;float: left; " />
							<input type="text" id="txtEndaddr" class="txt" style="width:70%;float: left; " />
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblEndaddress_js" class="lbl btn">地址</a></td>
						<td colspan="6">
							<input type="text" id="txtEndaddress" class="txt c1"/>
							<input type="text" id="txtEndlat" style="float:left;width:40%;display:none;"/>
							<input type="text" id="txtEndlng" style="float:left;width:40%;display:none;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl"> </a></td>
						<td colspan="6">
							<textarea id="txtMemo" class="txt c1" style="height:75px;"> </textarea>
						</td>
					</tr>

					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text"  class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text"  class="txt c1"/></td>
						<td><input id="btnOrde" type="button" value="1.訂單匯入" style="width:100%;"/></td>
						<td><input id="btnCar" type="button" value="2.車輛選擇" style="width:100%;"/></td>
						<td>
							<input id="btnRun" type="button" value="3.排程" style="width:100%;"/>
							<input id="txtImg" type="text" style="display:none;"/>
						</td>
					</tr>
				</table>
			</div>
			<img id="img" crossorigin="anonymous" style="float:left;display:none;"/> 
		</div>
		<div class='dbbs' >
			<table id="tbbs" class='tbbs'>
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:25px"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:70px;display:none;"><a>車牌</a></td>
					<td align="center" style="width:70px"><a>類型</a></td>
					<td align="center" style="width:150px"><a>貨主</a></td>
					<td align="center" style="width:150px"><a>品名</a></td>
					<td align="center" style="width:70px"><a>數量</a></td>
					<td align="center" style="width:70px"><a>重量</a></td>
					<td align="center" style="width:70px"><a>長</a></td>
					<td align="center" style="width:70px"><a>寬</a></td>
					<td align="center" style="width:70px;" class="js_hide"><a>高</a></td>
					<td align="center" style="width:70px"><a>材積</a></td>
					<td align="center" style="width:70px"><a>運送需<br>耗高度</a></td>
					<td align="center" style="width:70px"><a>運送需<br>耗材積</a></td>
					<td align="center" style="width:70px"><a>裝卸貨<br>時間(分)</a></td>
					<td align="center" style="width:30px"><a>指<br>定</a></td>
					<td align="center" style="width:170px"><a>地點</a></td>
					<td align="center" style="width:300px"><a>地址</a></td>
					<td align="center" style="width:70px"><a>聯絡人</a></td>
					<td align="center" style="width:70px"><a>聯絡電話</a></td>
					<td align="center" style="width:100px"><a>注意事項</a></td>
					<td align="center" style="width:100px"><a>提貨完<br>工時間</a></td>
					<td align="center" style="width:100px"><a>卸貨完<br>工時間</a></td>
					<td align="center" style="width:100px"><a>空瓶完<br>工時間</a></td>
					<td align="center" style="width:200px"><a>訂單</a></td>
					<td align="center" style="width:30px"><a>提<br>貨</a></td>
					<td align="center" style="width:30px"><a>卸<br>貨</a></td>
					<td align="center" style="display:none;width:40px"><a>空瓶</a></td>
				</tr>
				<tr class="data" style='background:#cad3ff;'>
					<td align="center">
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input type="text" id="txtNoq.*" style="display:none;"/>
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td style="display:none;">
						<input type="text" id="txtCarno.*" style="width:95%;"/>
						<input type="button" id="btnCarno.*" style="display:none;"/>
					</td>
					<td><input type="text" id="txtTypea.*" style="width:95%;"/></td>
					<td>
						<input type="text" id="txtCustno.*" style="float:left;width:40%;"/>
						<input type="text" id="txtCust.*" style="float:left;width:45%;"/>
						<input type="button" id="btnCust.*" style="display:none;"/>
					</td>
					<td>
						<input type="text" id="txtProductno.*" style="float:left;width:45%;"/>
						<input type="text" id="txtProduct.*" style="float:left;width:45%;"/>
						<input type="button" id="btnProduct.*" style="display:none;"/>
						<input type="text" id="txtUweight.*" style="display:none;"/>
					</td>
					<td><input type="text" id="txtMount.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtWeight.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtLengthb.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtWidth.*" class="num bbsWeight" style="width:95%;"/></td>
					<td class="js_hide"><input type="text" id="txtHeight.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtVolume.*" class="num " style="width:95%;"/></td>
					<td><input type="text" id="txtTheight.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtTvolume.*" class="num bbsVolume" style="width:95%;"/></td>
					<td><input type="text" id="txtMins.*" class="num" style="width:95%;"/></td>
					<td align="center"><input type="checkbox" id="chkIsassign.*"/></td>
					<td>
						<input type="text" id="txtAddrno.*" style="float:left;width:40%;"/>
						<input type="text" id="txtAddr.*" style="float:left;width:40%;"/>
						<input type="button" id="btnAddr.*" style="display:none;"/>
						<input type="button" id="btnLicence.*" style="float:left;width:15%;" value="證"/>
					</td>
					<td>
						<input type="text" id="txtAddress.*" style="width:95%;"/>
						<input type="text" id="txtLat.*" style="float:left;width:40%;display:none;"/>
						<input type="text" id="txtLng.*" style="float:left;width:40%;display:none;"/>
						<input type="text" id="txtAllowcar.*" style="float:left;width:95%;display:none;"/>
					</td>
					<td><input type="text" id="txtConn.*" style="width:95%;"/></td>
					<td><input type="text" id="txtTel.*" style="width:95%;"/></td>
					<td><input type="text" id="txtMemo.*" style="width:95%;"/></td>
					<td><input type="text" id="txtTime1.*" style="width:95%;"/></td>
					<td><input type="text" id="txtTime2.*" style="width:95%;"/></td>
					<td><input type="text" id="txtTime3.*" style="width:95%;"/></td>
					<td>
						<input type="text" id="txtOrdeno.*" style="float:left;width:70%;"/>
						<input type="text" id="txtNo2.*" style="float:left;width:20%;"/>
					</td>
					<td align="center"><input type="checkbox" id="chkChk1.*"/></td>
					<td align="center"><input type="checkbox" id="chkChk2.*"/></td>
					<td style="display:none;"><input type="checkbox" id="chkChk3.*" /></td>
				</tr>

			</table>
		</div>
		<div class='dbbt'>
			<table id="tbbt" class='tbbt'>
				<tr style="color:white; background:#003366;">
					<td align="center" style="width:25px"><input class="btn"  id="btnPlut" type="button" value='+' style="font-weight: bold;display:noxne;"  /></td>
					<td align="center" style="width:20px;"><input id="btnMap_close" type="button" value='關閉' style="font-size: 8;white-space:'normal';width:50px;"/></td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:100px"><a>車牌</a></td>
					<td align="center" style="width:100px"><a>貨主</a></td>
					<td align="center" style="width:250px"><a>地點</a></td>
					<td align="center" style="width:120px"><a>品名</a></td>
					<td align="center" style="width:70px"><a>數量</a></td>
					<td align="center" style="width:70px"><a>材積</a></td>
					<td align="center" style="width:70px"><a>重量</a></td>
					<td align="center" style="width:70px"><a>運輸時間<br>(分)</a></td>
					<td align="center" style="width:70px"><a>到達時間</a></td>
					<td align="center" style="width:70px"><a>裝卸貨<br>時間(分)</a></td>
					<td align="center" style="width:70px"><a>完工時間</a></td>
					<td align="center" style="width:150px"><a>備註</a></td>
					<td align="center" style="width:200px"><a>訂單</a></td>
					<td align="center" style="width:300px"><a>地址</a></td>
					<td align="center" style="width:70px"><a>已承載<br>材積</a></td>
					<td align="center" style="width:70px"><a>可承載<br>材積</a></td>
					<td align="center" style="width:70px"><a>承載率%<br>(材積)</a></td>
					<td align="center" style="width:70px"><a>已承載<br>重量</a></td>
					<td align="center" style="width:70px"><a>可承載<br>重量</a></td>
					<td align="center" style="width:70px"><a>承載率%<br>(重量)</a></td>
				</tr>
				<tr class="data" style='background:pink;'>
					<td align="center">
						<input class="btn"  id="btnMinut..*" type="button" value='-' style=" font-weight: bold; display:noxne;" />
						<input type="text" id="txtNoq..*" style="display:none;"/>
					</td>
					<td><input type="button" id="btnMap..*" value="圖"/></td>
					<td><a id="lblNo..*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td>
						<input type="text" id="txtCarno..*" style="width:95%;"/>
						<input type="button" id="btnCarno..*" style="display:none;"/>
					</td>
					<td>
						<input type="text" id="txtCustno..*" style="width:95%;display:none;"/>
						<input type="text" id="txtCust..*" style="width:95%;"/>
					</td>
					<td>
						<input type="text" id="txtAddrno..*" style="float:left;width:40%;"/>
						<input type="text" id="txtAddr..*" style="float:left;width:50%;"/>
						<input type="button" id="btnAddr..*" style="display:none;"/>
					</td>
					<td>
						<input type="text" id="txtProductno..*" style="width:95%;display:none;"/>
						<input type="text" id="txtProduct..*" style="width:95%;"/>
					</td>
					<td><input type="text" id="txtMount..*" class="num" style="width:95%;"/></td>
					<td>
						<input type="text" id="txtVolume..*" class="num" style="width:95%;"/>
						<!--記錄車輛 承載量(材積)-->
						<input type="text" id="txtCarvolume..*" style="display:none;"/>
						<input type="text" id="txtCarweight..*" style="display:none;"/>
					</td>
					<td><input type="text" id="txtWeight..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtMins1..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtTime1..*" style="width:95%;text-align: center;" /></td>
					<td><input type="text" id="txtMins2..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtTime2..*" style="width:95%;text-align: center;" /></td>
					<td><input type="text" id="txtMemo..*" style="width:95%;" /></td>
					<td>
						<input type="text" id="txtOrdeno..*" style="float:left;width:70%;"/>
						<input type="text" id="txtNo2..*" style="float:left;width:20%;"/>
					</td>
					<td>
						<input type="text" id="txtAddress..*" style="width:95%;"/>
						<input type="text" id="txtEndaddress..*" style="float:left;width:40%;display:none;"/>
						<input type="text" id="txtLat..*" style="float:left;width:40%;display:none;"/>
						<input type="text" id="txtLng..*" style="float:left;width:40%;display:none;"/>
					</td>
					<td><input type="text" id="txtGvolume..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtEvolume..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtRatevolume..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtGweight..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtEweight..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtRateweight..*" class="num" style="width:95%;"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="pathImg"> </div>
		<div id="mapForm" style="width:820px;height:650px;position: absolute;top:50px;left:600px;border-width: 0px;z-index: 80; background-color:pink;display:none;">
			<div id="mapStatus" style="width:820px;height:20px;position: relative; top:0px;left:0px; background-color:darkblue;color:white;"><a style="float:left;">滑鼠右鍵拖曳</a>
				<span style="display:block;width:50px;height:1px;float:left;"> </span>
				<a class="carno" style="float:left;"> </a>
				<span style="display:block;width:50px;height:1px;float:left;"> </span>
				<a style="float:left;">路徑</a>
				<input type="checkbox" id="mapDirection" style="float:left;"/>
				<span style="display:block;width:50px;height:1px;float:left;"> </span>
				<a style="float:left;">當日全部</a>
				<input type="checkbox" id="mapAll" style="float:left;"/>
			</div>
			<div id="map" style="width:800px;height:600px;position: relative; top:5px;left:10px; "> </div>
		</div>
		<!--<div id="map" style="width:400px;height:400px;display:none;position: absolute;"> </div>-->
		<canvas id="canvas" style="display:none;"> </canvas>
		
		<div id="carForm" style="width:80px;position: absolute;top:40px;left:920px;border-width: 0px;z-index: 80; background-color:pink;">
			<div id="carStatus" style="width:80px;height:20px;position: relative; top:0px;left:0px; background-color:darkblue;color:white;">車輛</div>
			<div id="_carno" style="width:70px;position: relative; top:5px;left:5px;"> </div>
		</div>
		<div id="_orde" style="display:none"> </div>
	</body>
</html>
