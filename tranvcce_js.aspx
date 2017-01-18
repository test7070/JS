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
			var directionsService;
            var directionsDisplay;
 			var map;
			q_tables = 't';
			var q_name = "tranvcce";
			var q_readonly = ['txtNoa','txtWorker', 'txtWorker2'];
			var q_readonlys = [];
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
			brwCount2 = 5;
			aPop = new Array(['txtAddrno', 'lblAddr_js', 'addr2', 'noa,addr,address,lat,lng', 'txtAddrno,txtAddr,txtAddress,txtLat,txtLng', 'addr2_b.aspx']
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
				$('#btnOrde').click(function(e){
                	var t_where ='';
                	q_box("tranordejs_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({noa:$('#txtNoa').val()}), "tranorde_tranvcce", "95%", "95%", '');
                });
			}

			function mainPost() {
				q_mask(bbmMask);
				$('#btnRun').click(function() {
					calculateAndDisplayRoute(directionsService, directionsDisplay);
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
				}
				_bbsAssign();
			}
			function refreshWV(n){
				var t_productno = $.trim($('#txtProductno_'+n).val());
				if(t_productno.length==0){
					$('#txtWeight_'+n).val(0);
					$('#txtVolume_'+n).val(0);
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
			}

			function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                	case 'tranorde_tranvcce':
                        if (b_ret != null) {
                        	as = b_ret;
                    		q_gridAddRow(bbsHtm, 'tbbs', 'txtOrdeno,txtNo2,txtProductno,txtProduct,txtMount,txtWeight,txtVolume,txtAddrno,txtAddr,txtAddress,txtLat,txtLng,txtMemo'
                        	, as.length, as, 'noa,noq,productno,product,emount,weight,volume,addrno,addr,address,lat,lng,memo', '','');
                        }else{
                        	Unlock(1);
                        }
                        break;
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
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
                    			}else{
                    				$('#txtWeight_'+n).val(0);
                    				$('#txtVolume_'+n).val(0);
                    			}
                    		}else {
                    			$('#txtWeight_'+n).val(0);
                				$('#txtVolume_'+n).val(0);
							}
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
				$('#txtNoa').val('AUTO');
				$('#txtDatea').val(q_date());
				$('#chkEnda').prop('checked',false);
				$('#txtDatea').focus();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
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
				}else{
					$('#txtDatea').datepicker();
					$('#btnRun').removeAttr('disabled');
					$('#btnOrde').removeAttr('disabled');
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
            }

            function calculateAndDisplayRoute(directionsService, directionsDisplay) {
                var waypts = [];
           		
                for(var i=0;i<q_bbsCount;i++){
                	$('#txtAddress_'+i).val($.trim($('#txtAddress_'+i).val()));	
                	
                	if(q_float('txtLat_'+i)!=0 && q_float('txtLng_'+i)!=0){
                		waypts.push({
                            location : new google.maps.LatLng(q_float('txtLat_'+i),q_float('txtLng_'+i)),
                            stopover : true
                        });
                	}
                }
                directionsService.route({
                    origin : new google.maps.LatLng(q_float('txtLat'),q_float('txtLng')),
                    destination : new google.maps.LatLng(q_float('txtLat'),q_float('txtLng')),
                    waypoints : waypts,
                    optimizeWaypoints : true,
                    travelMode : google.maps.TravelMode.DRIVING
                }, function(response, status) {
                    if (status === google.maps.DirectionsStatus.OK) {
                        directionsDisplay.setDirections(response);
                        var route = response.routes[0];
                        for (var i = 0; i < q_bbtCount; i++) {
                        	$('#btnMinut__'+i).click();
                        }
                        while(route.legs.length>q_bbtCount)
                        	$('#btnPlut').click();

                        var date = new Date(parseInt($('#txtDatea').val().substring(0,3))+1911
                        	,$('#txtDatea').val().substring(4,6)
                        	,$('#txtDatea').val().substring(7,9)
                        	,$('#txtTimea').val().substring(0,2)
                        	,$('#txtTimea').val().substring(3,5));
                        
                        var imgsrc = 'https://maps.googleapis.com/maps/api/staticmap?center='+$('#txtLat').val()+','+$('#txtLng').val()+'&size=300x300&maptype=roadmap';
                        imgsrc += '&markers=color:blue|label:S|'+$('#txtLat').val()+','+$('#txtLng').val();
                        
                       	/*var marker = new google.maps.Marker({
						    position: (new google.maps.LatLng(q_float('txtLat'),q_float('txtLng'))),
						    label: '起點',
						    map: map
					    });
				    	marker.setMap(map);*/
						    	
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
                        }
                        imgsrc+='&key=AIzaSyC4lkDc9H0JanDkP8MUpO-mzXRtmugbiI8';
                        //console.log(imgsrc);
                        imgsrc = encodeURI(imgsrc);
                        $('#img').attr('src',imgsrc);
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
		</script>
		
		<style type="text/css">
			#dmain {
				overflow: auto;
				width: 1600px;
			}
			.dview {
				float: left;
				width: 400px;
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
				width: 1400px;
			}
			.dbbt {
				width: 1000px;
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
						<td align="center" style="width:120px; color:black;"><a>單號</a></td>
						<td align="center" style="width:120px; color:black;"><a>車號</a></td>
						<td align="center" style="width:80px; color:black;"><a>日期</a></td>
						<td align="center" style="width:80px; color:black;"><a>時間</a></td>
						<td align="center" style="width:80px; color:black;"><a>起點</a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox"/></td>
						<td id='noa' style="text-align: center;">~noa</td>
						<td id='carno' style="text-align: center;">~carno</td>
						<td id='datea' style="text-align: center;">~datea</td>
						<td id='timea' style="text-align: center;">~timea</td>
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
						<td> </td>
						<td><input id="btnOrde" type="button" value="訂單匯入" style="width:100%;"/></td>
						<td>
							<input id="btnRun" type="button" value="排程" style="width:100%;"/>
							<input id="txtImg" type="text" style="display:none;"/>
						</td>
					</tr>
				</table>
			</div>
			<img id="img" crossorigin="anonymous" style="float:left;"/> 
		</div>
		<div class='dbbs' >
			<table id="tbbs" class='tbbs'>
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:25px"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:70px"><a>車牌</a></td>
					<td align="center" style="width:150px"><a>品名</a></td>
					<td align="center" style="width:70px"><a>數量</a></td>
					<td align="center" style="width:70px"><a>重量</a></td>
					<td align="center" style="width:70px"><a>材積</a></td>
					<td align="center" style="width:70px"><a>裝卸貨<br>時間(分)</a></td>
					<td align="center" style="width:150px"><a>地點</a></td>
					<td align="center" style="width:300px"><a>地址</a></td>
					<td align="center" style="width:100px"><a>備註</a></td>
					<td align="center" style="width:120px"><a>訂單</a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center">
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input type="text" id="txtNoq.*" style="display:none;"/>
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td>
						<input type="text" id="txtCarno.*" style="width:95%;"/>
						<input type="button" id="btnCarno.*" style="display:none;"/>
					</td>
					<td>
						<input type="text" id="txtProductno.*" style="float:left;width:45%;"/>
						<input type="text" id="txtProduct.*" style="float:left;width:45%;"/>
						<input type="button" id="btnProduct.*" style="display:none;"/>
					</td>
					<td><input type="text" id="txtMount.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtWeight.*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtVolume.*" class="num" style="width:95%;"/></td>
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
					</td>
					<td><input type="text" id="txtMemo.*" style="width:95%;"/></td>
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
					<td align="center" style="width:70px"><a>車牌</a></td>
					<td align="center" style="width:150px"><a>地點</a></td>
					<td align="center" style="width:300px"><a>地址</a></td>
					<td align="center" style="width:70px"><a>運輸時間<br>(分)</a></td>
					<td align="center" style="width:70px"><a>到達時間</a></td>
					<td align="center" style="width:70px"><a>裝卸貨<br>時間(分)</a></td>
					<td align="center" style="width:70px"><a>完工時間</a></td>
					<td align="center" style="width:150px"><a>備註</a></td>
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
						<input type="text" id="txtAddrno..*" style="float:left;width:45%;"/>
						<input type="text" id="txtAddr..*" style="float:left;width:45%;"/>
						<input type="button" id="btnAddr..*" style="display:none;"/>
					</td>
					<td>
						<input type="text" id="txtAddress..*" style="width:95%;"/>
						<input type="text" id="txtEndaddress..*" style="float:left;width:40%;display:none;"/>
						<input type="text" id="txtLat..*" style="float:left;width:40%;display:none;"/>
						<input type="text" id="txtLng..*" style="float:left;width:40%;display:none;"/>
					</td>
					<td><input type="text" id="txtMins1..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtTime1..*" style="width:95%;text-align: center;" /></td>
					<td><input type="text" id="txtMins2..*" class="num" style="width:95%;"/></td>
					<td><input type="text" id="txtTime2..*" style="width:95%;text-align: center;" /></td>
					<td><input type="text" id="txtMemo..*" style="width:95%;" /></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="map" style="width:1000px;height:600px;"> </div>
		<canvas id="canvas" style="display:none;"> </canvas>
	</body>
</html>
