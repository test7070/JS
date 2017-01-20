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
			
			var directionsService;
            var directionsDisplay;
 			var map;
			q_tables = 't';
			var q_name = "tranvcce";
			var q_readonly = ['txtNoa','txtWorker', 'txtWorker2'];
			var q_readonlys = ['txtOrdeno','txtNo2'];
			var bbsNum = new Array();
			var bbsMask = new Array();
			var bbtMask = new Array(); 
			var bbmNum = new Array();
			var bbmMask = new Array(['txtDatea', '999/99/99'],['txtTimea', '99:99']);
			var bbsMask = new Array();
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
				
				$('body').append('<div id="_orde" style="display:none"></div>');
				$('body').append('<div id="_carno" style="display:none"></div>');
				
				$('#btnOrde').click(function(e){
                	var t_where ='';
                	q_box("tranordejs_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({noa:$('#txtNoa').val(),chk1:$('#chkChk1').prop('checked')?1:0,chk2:$('#chkChk2').prop('checked')?1:0}), "tranorde_tranvcce", "95%", "95%", '');
                });
                $('#btnCar').click(function(e){
                	var t_where ='',t_addrno='';
                	for(var i=0;i<q_bbsCount;i++){
                		if($('#txtAddrno_'+i).val().length>0)
                			t_addrno=(t_addrno.length>0?',':'')+$('#txtAddrno_'+i).val();
                	}
                	
                	q_box("trancarjs_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({noa:$('#txtNoa').val(),addrno:t_addrno}), "car_tranvcce", "95%", "95%", '');
                });
                
				$('#btnRun').click(function() {
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
	                    });
	                }
	              	//有指定車輛的先
	              	for(var i=0;i<data_orde.length;i++){
	              		//提貨不用管車輛
	                	if(data_orde[i].chk2==1 && data_orde[i].allowcar.length==0)
	                		continue;
	                	if(data_orde[i].emount<=0)
	                		continue;
	                	for(var j=0;j<data_car.length;j++){
	                		if(data_orde[i].emount<=0)
	                			break;
	                		if(data_orde[i].allowcar.indexOf(data_car[j].carno)<0)
	                			continue;
	                		if(data_car[j].eweight<=0 || data_car[j].evolume<=0)
	                			continue;	
	                		//訂單重,材積
	                		t_mount = data_orde[i].emount;
	                		t_weight = round(data_orde[i].uweight * t_mount,2);
	                		t_cuft = round(0.0000353*t_mount*data_orde[i].lengthb*data_orde[i].width*data_orde[i].height,0);
	                		
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
	                		}else{ 
	                			t_mount--;
	                			while(t_mount>=0){
	                				t_weight = round(data_orde[i].uweight * t_mount,2);
	                				t_cuft = round(0.0000353*t_mount*data_orde[i].lengthb*data_orde[i].width*data_orde[i].height,0);
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
	                		}
	                	}
	                }
	              	//沒指定車輛
	                for(var i=0;i<data_orde.length;i++){
	                	if(data_orde[i].chk2==1 && data_orde[i].allowcar.length>0)
	                		continue;
	                	if(data_orde[i].emount<=0)
	                		continue;
	                	for(var j=0;j<data_car.length;j++){
	                		if(data_orde[i].emount<=0)
	                			break;
	                		if(data_car[j].eweight<=0 || data_car[j].evolume<=0)
	                			continue;	
	                		//訂單重,材積
	                		t_mount = data_orde[i].emount;
	                		t_weight = round(data_orde[i].uweight * t_mount,2);
	                		t_cuft = round(0.0000353*t_mount*data_orde[i].lengthb*data_orde[i].width*data_orde[i].height,0);
	                		
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
	                		}else{ 
	                			t_mount--;
	                			while(t_mount>=0){
	                				t_weight = round(data_orde[i].uweight * t_mount,2);
	                				t_cuft = round(0.0000353*t_mount*data_orde[i].lengthb*data_orde[i].width*data_orde[i].height,0);
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
	                		}
	                	}
	                }
					if(data_orde.length==0)
						alert('無訂單');
					if(data_car.length==0)
						alert('無車輛');
					if(data_car.length>0 && data_orde.length>0){
						data_car_current = 0;
						for (var i = 0; i < q_bbtCount; i++) {
                        	$('#btnMinut__'+i).click();
                        }
						initMap();
						calculateAndDisplayRoute(directionsService, directionsDisplay, data_orde, data_car[data_car_current]);
					}
				});
			}

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
				}
				_bbsAssign();
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
                    if($('#btnMinus__' + i).hasClass('isAssign'))
                    	continue;
                }
                _bbtAssign();
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
				if (!as['addrno']) {
					as[bbtKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}

			function sum() {
				if (!(q_cur == 1 || q_cur == 2))
					return;
				for(var i=0;i<q_bbsCount;i++){
					cuft = round(0.0000353 * q_float('txtLengthb_'+i)* q_float('txtWidth_'+i)* q_float('txtHeight_'+i)* q_float('txtMount_'+i),2); 
					$('#txtVolume_'+i).val(cuft);
					if(q_float('txtTvolume_'+i)==0){
						$('#txtTvolume_'+i).val(Math.ceil(cuft));
					}	
				}
			}

			function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                	case 'tranorde_tranvcce':
                        if (b_ret != null) {
                        	as = b_ret;
                    		q_gridAddRow(bbsHtm, 'tbbs', 'txtTypea,txtOrdeno,txtNo2,txtCustno,txtCust,txtProductno,txtProduct,txtUweight,txtMount,txtWeight,txtVolume,txtAddrno,txtAddr,txtAddress,txtLat,txtLng,txtMemo,txtLengthb,txtWidth,txtHeight,txtTheight,txtTvolume,txtConn,txtTel,txtAllowcar,chkChk1,chkChk2,chkChk3'
                        	, as.length, as, 'typea,noa,noq,custno,cust,productno,product,uweight,emount,weight,volume,addrno,addr,address,lat,lng,memo,lengthb,width,height,theight,tvolume,conn,tel,allowcar,chk1,chk2,chk3', '','');
                        }else{
                        	Unlock(1);
                        }
                        break;
                    case 'car_tranvcce':
                        if (b_ret != null) {
                        	as = b_ret;
                        	$('#_carno').children().remove();
                        	for(var i=0;i<as.length;i++){
                        		$('#_carno').append('<div style="display:none">'
                        			+'<a class="carno">'+as[i].carno+'</a>'
                        			+'<a class="weight">'+as[i].weight+'</a>'
                        			+'<a class="volume">'+as[i].volume+'</a>'
                        			+'</div>');
                        	}
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
                    		}else {
                    			$('#txtWeight_'+n).val(0);
                				$('#txtVolume_'+n).val(0);
                				$('#txtTvolume_'+n).val(0);
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
                directionsService = new google.maps.DirectionsService();
                directionsDisplay = new google.maps.DirectionsRenderer();
                //directionsDisplay = new google.maps.DirectionsRenderer({suppressMarkers: true});
                map = new google.maps.Map(document.getElementById('map'), {
                    zoom : 14,
                    center : {
                        lat : 22.5682808,
                        lng : 120.325935
                    }
                });
                directionsDisplay.setMap(map);
                map.setOptions({styles: stylesArray});
            }

            function calculateAndDisplayRoute(directionsService, directionsDisplay, orde, car) {
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
                var waypts = [];
                for(var i=0;i<car.orde.length;i++){
                	for(var j=0;j<orde.length;j++){
                		if(car.orde[i].ordeno != orde[j].ordeno)
                			continue;
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
					   	calculateAndDisplayRoute(directionsService, directionsDisplay, data_orde, data_car[data_car_current]);
				    }
				    return;
                }
                
                directionsService.route({
                    origin : new google.maps.LatLng(q_float('txtLat'),q_float('txtLng')),
                    destination : new google.maps.LatLng(q_float('txtEndlat'),q_float('txtEndlng')),
                    waypoints : waypts,
                    optimizeWaypoints : true,
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
                        while(route.legs.length+strn_bbt>q_bbtCount){
                        	$('#btnPlut').click();
                        }
                        
                        for (var i = 0; i < route.legs.length; i++) {
                        	$('#txtCarno__'+(i+strn_bbt)).val(data_car[data_car_current].carno);
                        	
                        	if(i<route.legs.length-1){
                        		n = route.waypoint_order[i];
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
                        	}else{
                        		$('#txtAddrno__'+(i+strn_bbt)).val($('#txtEndaddrno').val());
                        		$('#txtAddr__'+(i+strn_bbt)).val($('#txtEndaddr').val());
                        		$('#txtAddress__'+(i+strn_bbt)).val($('#txtEndaddress').val());
                        	}
                        	$('#txtEndaddress__'+(i+strn_bbt)).val(route.legs[i].end_address);
                        	$('#txtLat__'+(i+strn_bbt)).val(getLatLngString(route.legs[i].end_location.lat()));
                            $('#txtLng__'+(i+strn_bbt)).val(getLatLngString(route.legs[i].end_location.lng()));
                        	$('#txtMins1__'+(i+strn_bbt)).val(Math.round(route.legs[i].duration.value/60));
                			$('#txtMemo__'+(i+strn_bbt)).val(route.legs[i].distance.text);
                			
                			date.setMinutes(date.getMinutes() + q_float('txtMins1__'+(i+strn_bbt)));
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
                        data_car_current++;
                        if(data_car_current<data_car.length){
						   	initMap();
						   	calculateAndDisplayRoute(directionsService, directionsDisplay, data_orde, data_car[data_car_current]);
					    }
                        /*var imgsrc = 'https://maps.googleapis.com/maps/api/staticmap?center='+$('#txtLat').val()+','+$('#txtLng').val()+'&size=300x300&maptype=roadmap';
                        imgsrc += '&markers=color:blue|label:S|'+$('#txtLat').val()+','+$('#txtLng').val();
                        
                       	var marker = new google.maps.Marker({
						    position: (new google.maps.LatLng(q_float('txtLat'),q_float('txtLng'))),
						    label: '起點',
						    map: map
					    });
				    	marker.setMap(map);  	
                        for (var i = 0; i < route.legs.length; i++) {
                        	if(i<route.legs.length-1){
                        		n = route.waypoint_order[i];
                        		$('#txtAddrno__'+i).val($('#txtAddrno_'+n).val());
                        		$('#txtAddr__'+i).val($('#txtAddr_'+n).val());
                        		$('#txtAddress__'+i).val($('#txtAddress_'+n).val());
                        		$('#txtMins2__'+i).val($('#txtMins_'+n).val());
                        		
                        		var marker = new google.maps.Marker({
								    position: route.legs[i].end_location,
								    label: (i+1)+'',
								    map: map
							    });
						    	marker.setMap(map);
						    	
                        		imgsrc += '&markers=color:red|label:'+(i+1)+'|'+$('#txtLat_'+n).val()+','+$('#txtLng_'+n).val();
                        	}else{
                        		$('#txtAddrno__'+i).val($('#txtAddrno').val());
                        		$('#txtAddr__'+i).val($('#txtAddr').val());
                        		$('#txtAddress__'+i).val($('#txtAddress').val());
                        	}
                        	$('#txtEndaddress__'+i).val(route.legs[i].end_address);
                        	$('#txtLat__'+i).val(getLatLngString(route.legs[i].end_location.lat()));
                            $('#txtLng__'+i).val(getLatLngString(route.legs[i].end_location.lng()));
                        	$('#txtMins1__'+i).val(Math.round(route.legs[i].duration.value/60));
                			$('#txtMemo__'+i).val(route.legs[i].distance.text);
                			
                			date.setMinutes(date.getMinutes() + q_float('txtMins1__'+i));
                			hour = '00'+date.getHours();
                			hour = hour.substring(hour.length-2,hour.length);
                			minute = '00'+date.getMinutes();
                			minute = minute.substring(minute.length-2,minute.length);
                			$('#txtTime1__'+i).val(hour+':'+minute);
                			
                			date.setMinutes(date.getMinutes() + q_float('txtMins2__'+i));
                			hour = '00'+date.getHours();
                			hour = hour.substring(hour.length-2,hour.length);
                			minute = '00'+date.getMinutes();
                			minute = minute.substring(minute.length-2,minute.length);
                			$('#txtTime2__'+i).val(hour+':'+minute);
                        }*/
                        //imgsrc+='&key=AIzaSyC4lkDc9H0JanDkP8MUpO-mzXRtmugbiI8';
                        //console.log(imgsrc);
                        //imgsrc = encodeURI(imgsrc);
                        //$('#img').attr('src',imgsrc);
                        //$('#txtImg').val(imgsrc);
                        //$('#img').attr('src',encodeURI(imgsrc));
                        //$('#txtImg').val(getBase64Image($('#img')[0]));
                    } else {
                        alert('Directions request failed due to ' + status);
                    }
                });
            }
           /* function getBase64Image(img) {
              Lock();
			  //var canvas = document.createElement('canvas');
			  var canvas = $('#canvas')[0];
			  canvas.width = img.width;
			  canvas.height = img.height;
			  var ctx = canvas.getContext("2d");
			  ctx.drawImage(img, 0, 0,img.width,img.height);
			  Unlock();
			  return canvas.toDataURL();
			  //var dataURL = canvas.toDataURL();  
			  //return dataURL.replace(/^data:image\/(png|jpg|jpeg|pdf);base64,/, "");
			}*/

            function getLatLngString(tmp){
            	var patt = /^(\d*)\.(\d{0,6})(\d*)$/g;
            	tmp = tmp + '';
            	switch(tmp.replace(patt,'$2').length){
               		case 0:
               			tmp = tmp.replace(patt,'$1.$2')+ '.000000';
               			break;
           			case 1:
               			tmp = tmp.replace(patt,'$1.$2')+ '00000';
               			break;
           			case 2:
               			tmp = tmp.replace(patt,'$1.$2')+ '0000';
               			break;
           			case 3:
               			tmp = tmp.replace(patt,'$1.$2')+ '000';
               			break;
           			case 4:
               			tmp = tmp.replace(patt,'$1.$2')+ '00';
               			break;
           			case 5:
               			tmp = tmp.replace(patt,'$1.$2')+ '0';
               			break;
           			case 6:
               			tmp = tmp.replace(patt,'$1.$2');
               			break;
           			default:
           				break;
               	}
               	return tmp;
            }
            
            var stylesArray = [{"featureType":"administrative","elementType":"all","stylers":[{"saturation":"-100"}]},{"featureType":"administrative.province","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"landscape","elementType":"all","stylers":[{"saturation":-100},{"lightness":65},{"visibility":"on"}]},{"featureType":"poi","elementType":"all","stylers":[{"saturation":-100},{"lightness":"50"},{"visibility":"simplified"}]},{"featureType":"road","elementType":"all","stylers":[{"saturation":"-100"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road.arterial","elementType":"all","stylers":[{"lightness":"30"}]},{"featureType":"road.local","elementType":"all","stylers":[{"lightness":"40"}]},{"featureType":"transit","elementType":"all","stylers":[{"saturation":-100},{"visibility":"simplified"}]},{"featureType":"water","elementType":"geometry","stylers":[{"hue":"#ffff00"},{"lightness":-25},{"saturation":-97}]},{"featureType":"water","elementType":"labels","stylers":[{"lightness":-25},{"saturation":-100}]}];
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
				width: 2300px;
			}
			.dbbt {
				width: 1600px;
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
						<td><input id="btnOrde" type="button" value="訂單匯入" style="width:100%;"/></td>
						<td><input id="btnCar" type="button" value="車輛選擇" style="width:100%;"/></td>
						<td>
							<input id="btnRun" type="button" value="排程" style="width:100%;"/>
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
					<td align="center" style="display:none;width:40px"><a>提貨</a></td>
					<td align="center" style="display:none;width:40px"><a>卸貨</a></td>
					<td align="center" style="display:none;width:40px"><a>空瓶</a></td>
					<td align="center" style="width:150px"><a>品名</a></td>
					<td align="center" style="width:70px"><a>數量</a></td>
					<td align="center" style="width:70px"><a>重量</a></td>
					<td align="center" style="width:70px"><a>長</a></td>
					<td align="center" style="width:70px"><a>寬</a></td>
					<td align="center" style="width:70px"><a>高</a></td>
					<td align="center" style="width:70px"><a>材積</a></td>
					<td align="center" style="width:70px"><a>運送需<br>耗高度</a></td>
					<td align="center" style="width:70px"><a>運送需<br>耗材積</a></td>
					<td align="center" style="width:70px"><a>裝卸貨<br>時間(分)</a></td>
					<td align="center" style="width:150px"><a>地點</a></td>
					<td align="center" style="width:300px"><a>地址</a></td>
					<td align="center" style="width:70px"><a>聯絡人</a></td>
					<td align="center" style="width:70px"><a>聯絡電話</a></td>
					<td align="center" style="width:100px"><a>注意事項</a></td>
					<td align="center" style="width:100px"><a>提貨完<br>工時間</a></td>
					<td align="center" style="width:100px"><a>卸貨完<br>工時間</a></td>
					<td align="center" style="width:100px"><a>空瓶完<br>工時間</a></td>
					<td align="center" style="width:120px"><a>訂單</a></td>
				</tr>
				<tr style='background:#cad3ff;'>
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
					<td style="display:none;"><input type="checkbox" id="chkChk1.*" /></td>
					<td style="display:none;"><input type="checkbox" id="chkChk2.*" /></td>
					<td style="display:none;"><input type="checkbox" id="chkChk3.*" /></td>
					<td>
						<input type="text" id="txtProductno.*" style="float:left;width:45%;"/>
						<input type="text" id="txtProduct.*" style="float:left;width:45%;"/>
						<input type="button" id="btnProduct.*" style="display:none;"/>
						<input type="text" id="txtUweight.*" style="display:none;"/>
					</td>
					<td><input type="text" id="txtMount.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtWeight.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtLengthb.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtWidth.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtHeight.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtVolume.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtTheight.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtTvolume.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtMins.*" class="num" style="width:95%;"/></td>
					<td>
						<input type="text" id="txtAddrno.*" style="float:left;width:45%;"/>
						<input type="text" id="txtAddr.*" style="float:left;width:45%;"/>
						<input type="button" id="btnAddr.*" style="display:none;"/>
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
				</tr>

			</table>
		</div>
		<div class='dbbt'>
			<table id="tbbt" class='tbbt'>
				<tr style="color:white; background:#003366;">
					<td align="center" style="width:25px"><input class="btn"  id="btnPlut" type="button" value='+' style="font-weight: bold;display:none;"  /></td>
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
					<td align="center" style="width:150px"><a>訂單</a></td>
					<td align="center" style="width:300px"><a>地址</a></td>
				</tr>
				<tr style='background:pink;'>
					<td align="center">
						<input class="btn"  id="btnMinut..*" type="button" value='-' style=" font-weight: bold; display:none;" />
						<input type="text" id="txtNoq..*" style="display:none;"/>
					</td>
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
					<td><input type="text" id="txtVolume..*" class="num" style="width:95%;"/></td>
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
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="map" style="width:1000px;height:600px;"> </div>
		<canvas id="canvas" style="display:none;"> </canvas>
	</body>
</html>
