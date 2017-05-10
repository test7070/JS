<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title></title>
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
		<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC4lkDc9H0JanDkP8MUpO-mzXRtmugbiI8&signed_in=true&libraries=drawing&callback=initMap" async defer></script>
		<script type="text/javascript">
            q_tables = 's';
            var q_name = "addr2";
            var q_readonly = [];
            var bbmNum = [];
            var bbmMask = [];
            var bbsNum = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'noa';
            brwCount2 = 20;
            q_xchg = 1;
            q_copy = 1;
            aPop = new Array(['txtCarno_', 'btnCarno_', 'car2', 'a.noa,driverno,driver', 'txtCarno_', 'car2_b.aspx'], ['txtCustno', 'lblCustno', 'addr3', 'noa,namea', 'txtCustno', 'addr3_b.aspx'], ['txtAddrno_', 'btnAddr_', 'addr2', 'noa,addr,address,lat,lng', 'txtAddrno_,txtAddr_,txtAddress_,txtLat_,txtLng_', 'addr2_b.aspx']);
            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
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
                document.title = '運送地點';
                $('#txtNoa').change(function(e) {
                    $(this).val($.trim($(this).val()).toUpperCase());
                    if ($(this).val().length > 0) {
                        t_where = "where=^^ noa='" + $(this).val() + "'^^";
                        q_gt('addr2', t_where, 0, 0, 0, "chkNoa_change", r_accy);
                    }
                });
                
                $('#btnShowDirection').click(function(e){
                	if( $('#txtDirection').val().length==0)
                		return;
                	initMap();
                	refreshMarker();
                	
                	var location = $('#txtDirection').val().split('|');
                	for(var i=0;i<location.length;i++){
                		poly.getPath().push(new google.maps.LatLng(parseFloat(location[i].split(',')[0]),parseFloat(location[i].split(',')[1])));
                	}
                	
                });

                $('#btnRun').click(function(e) {
                    var address = $.trim($('#txtAddress').val());
                    if (address.length == 0) {
                        alert('請輸入地址!');
                        return;
                    }
                    geocoder = new google.maps.Geocoder();
                    geocoder.geocode({
                        address : address
                    }, function(results, status) {

                        //檢查執行結果
                        if (status == google.maps.GeocoderStatus.OK) {
                            var loc = results[0].geometry.location;

                            $('#txtLat').val(getLatLngString(results[0].geometry.location.lat()));
                            $('#txtLng').val(getLatLngString(results[0].geometry.location.lng()));
                            //執行成功
                        } else {
                            //執行失敗
                            alert('Error!');
                        }
                    });

                });

                $('#btnIns').before($('#btnIns').clone().attr('id', 'btnMap').attr('value', '地圖'));
                $('#btnMap').click(function() {
                    $('#mapForm').toggle();
                    if($('#mapForm').is(':visible')){
                    	initMap();
                    	refreshMarker();	
                    }
                });
                $('#mapStatus').mousedown(function(e) {
					console.log(e.button);
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
                //window.onload = addListeners;
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

            function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                case q_name + '_js_s':
                    q_boxClose2(s2);
                    break;
                }
            }

            function q_gtPost(t_name) {
                switch (t_name) {
                case 'chkNoa_change':
                    var as = _q_appendData("addr2", "", true);
                    if (as[0] != undefined) {
                        alert('已存在 ' + as[0].noa + ' ' + as[0].product);
                    }
                    break;
                case 'chkNoa_btnOk':
                    var as = _q_appendData("addr2", "", true);
                    if (as[0] != undefined) {
                        alert('已存在 ' + as[0].noa + ' ' + as[0].product);
                        Unlock(1);
                        return;
                    } else {
                        getDirection($('#txtNoa').val());
                    }
                    break;
                case q_name:
                    if (q_cur == 4)
                        q_Seek_gtPost();
                    break;
                }
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;
                q_box(q_name + '_js_s.aspx', q_name + '_js_s', "500px", "400px", q_getMsg("popSeek"));
            }

            function btnIns() {
                $('#btnXchg').click();
                _btnIns();
                refreshBbm();
                $('#txtNoa').focus();
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                refreshBbm();
            }

            function btnPrint() {
                //q_box('z_ucc_js.aspx', '', "95%", "95%", q_getMsg("popPrint"));
            }

            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                Unlock();
            }

            function q_popPost(id) {
                switch(id) {
                case 'txtAddrno_':
                    refreshMarker();
                    break;
                default:
                    break;
                }
            }

            function btnOk() {
                Lock(1, {
                    opacity : 0
                });
                $('#txtNoa').val($.trim($('#txtNoa').val()));
                $('#txtWorker').val(r_name);

                if ($('#txtNoa').val().length == 0) {
                    alert('請輸入編號!');
                    Unlock(1);
                    return;
                }

                if (q_cur == 1) {
                    t_where = "where=^^ noa='" + $('#txtNoa').val() + "'^^";
                    q_gt('addr2', t_where, 0, 0, 0, "chkNoa_btnOk", r_accy);
                } else {
                    getDirection($('#txtNoa').val());
                }
            }
			function getDirection(noa){
				wrServer(noa);
				return;
				//暫時不用
				$('#txtDirection').val('');
				//指定路徑
				if(q_bbsCount<=0){
					wrServer(noa);
				}
				else{
					var waypts = [];
					for(var i=1;i<q_bbsCount;i++){
						waypts.push({
                            location : new google.maps.LatLng(q_float('txtLat_'+i),q_float('txtLng_'+i)),
                            stopover : true
                        });
					}
					directionsService.route({
	                    origin : new google.maps.LatLng(parseFloat($('#txtLat_0').val()),parseFloat($('#txtLng_0').val())),
	                    destination : new google.maps.LatLng(parseFloat($('#txtLat').val()),parseFloat($('#txtLng').val())),
	                    waypoints : waypts,
	                    //optimizeWaypoints : true,
	                    travelMode : google.maps.TravelMode.DRIVING
	                }, function(response, status) {
	                    if (status === google.maps.DirectionsStatus.OK) {
	                        console.log(response);
	                        try{
	                        	var path = "";
	                        	for(var i=0;i<response.routes[0].overview_path.length;i++){
	                        		path += (path.length==0?'':'|') + response.routes[0].overview_path[i].lat()+','+response.routes[0].overview_path[i].lng();
	                        	}
	                        }catch(e){
	                        	console.log(e);
	                        }
	                        console.log(path);
	                        $('#txtDirection').val(path);
	                    } else {
	                        alert('Directions request failed due to ' + status);
	                    }
	                    wrServer(noa);
	                });
				}
			}
			
            function wrServer(key_value) {
                var i;

                xmlSql = '';
                if (q_cur == 2)
                    xmlSql = q_preXml();

                $('#txtNoa').val(key_value);
                _btnOk(key_value, bbmKey[0], '', '', 2);
            }

            function refresh(recno) {
                _refresh(recno);
                refreshBbm();
                if($('#mapForm').is(':visible')){
                	initMap();
                	refreshMarker();	
                }
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                if (t_para) {
                    $('#btnRun').attr('disabled', 'disabled');
                } else {
                    $('#btnRun').removeAttr('disabled');
                }
            }

            function refreshBbm() {
                if (q_cur == 1) {
                    $('#txtNoa').css('color', 'black').css('background', 'white').removeAttr('readonly');
                } else {
                    $('#txtNoa').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
            }

            function bbsAssign() {
                for (var i = 0; i < q_bbsCount; i++) {
                    $('#lblNo_' + i).text(i + 1);
                    if ($('#btnMinus_' + i).hasClass('isAssign'))
                        continue;
                    $('#txtCarno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/, '$2');
                        $('#btnCarno_' + n).click();
                    });
                    $('#txtAddrno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/, '$2');
                        $('#btnAddr_' + n).click();
                    });
                    $('#txtLat_' + i).change(function(e) {
                        refreshBbm();
                    });
                    $('#txtLng_' + i).change(function(e) {
                        refreshBbm();
                    });
                }
                _bbsAssign();

            }

            function bbsSave(as) {
                if (!as['lat']) {
                    as[bbsKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }

            function btnMinus(id) {
                _btnMinus(id);
                var n = id.replace(/^(.*)_(\d+)$/, '$2');
                if(markers[n]!=null){
					markers[n].setMap(null);
					markers[n] = null;
				}
				$('#btnMinus_'+n).data('infowindow_address','');
                refreshMarker();
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

            function getLatLngString(tmp) {
                var patt = /^(\d*)\.(\d{0,7})(\d*)$/g;
                tmp = tmp + '';
                switch(tmp.replace(patt,'$2').length) {
                case 0:
                    tmp = tmp.replace(patt, '$1.$2') + '.0000000';
                    break;
                case 1:
                    tmp = tmp.replace(patt, '$1.$2') + '.000000';
                    break;
                case 2:
                    tmp = tmp.replace(patt, '$1.$2') + '00000';
                    break;
                case 3:
                    tmp = tmp.replace(patt, '$1.$2') + '0000';
                    break;
                case 4:
                    tmp = tmp.replace(patt, '$1.$2') + '000';
                    break;
                case 5:
                    tmp = tmp.replace(patt, '$1.$2') + '00';
                    break;
                case 6:
                    tmp = tmp.replace(patt, '$1.$2') + '0';
                    break;
                case 7:
                    tmp = tmp.replace(patt, '$1.$2');
                    break;
                default:
                    break;
                }
                return tmp;
            }

            //MAP
            var map,
                directionsService,
                directionsDisplay,
                poly;
            var markers = [],infowindow;
            function initMap() {
                map = new google.maps.Map(document.getElementById('map'));
                map.setZoom(13);
                map.setCenter({
                    lat : 24.8013848,
                    lng : 120.9494774
                });
                directionsService = new google.maps.DirectionsService();
                directionsDisplay = new google.maps.DirectionsRenderer({draggable : true});
                
                poly = new google.maps.Polyline({
				    strokeColor: '#000000',
				    strokeOpacity: 1.0,
				    strokeWeight: 3
				  });
				  poly.setMap(map);
				  
  
                map.setOptions({draggableCursor: 'default'
                	,draggingCursor:'default'
                	,fullscreenControl: true});
				markers = [];
                //滑鼠左鍵 新增地點
                map.addListener('click', function(e) {
                    if (!(q_cur == 1 || q_cur == 2)) {
                        alert('新增、修改狀態才能新增地點');
                        return;
                    }
                    addMarker(e.latLng.lat(),e.latLng.lng());
                });
                infowindow = new google.maps.InfoWindow({content: ''});
            }
			
			function addMarker(lat,lng){
				//加到BBS去
                var n = -1;//對應到哪筆BBS
				for (var i = q_bbsCount - 1; i >= 0; i--) {
                    if ($('#txtLat_' + i).val().length > 0) {
                        break;
                    }
                    n = i;
                }
                if (n == -1) {
                    n = q_bbsCount;
                    $('#btnPlus').click();
                }
				$('#txtLat_' + n).val(getLatLngString(lat));
                $('#txtLng_' + n).val(getLatLngString(lng));
                refreshMarker();
			}
            function refreshMarker(){
            	if(!$('#mapForm').is(':visible'))
            		return;
        		if(q_xchg==1)
        			$('#btnXchg').click();
            	//initMap();
            	//reset marker
            	for(var i=0;i<markers.length;i++){
            		if(markers[i]!=null){
						markers[i].setMap(null);
						markers[i] = null;
					}
            	}
            	markers = [];
            	var first = -1, last=-1;
            	for(var i=0;i<q_bbsCount;i++){
            		//經度有值的才算,   起點
            		if ($('#txtLat_' + i).val().length > 0){
            			first = i;
            			break;
            		}
               	}
            	/*  終點抓BBM上的
            	for(var i=q_bbsCount-1;i>=0;i--){
            		//經度有值的才算,   終點
            		if ($('#txtLat_' + i).val().length > 0){
            			last = i;
            			break;
            		}    
               	}*/
               	var marker,n=0;
               	var t_lat = [],t_lng=[];
            	for(var i=0;i<q_bbsCount;i++){
            		//經度有值的才算
            		if ($('#txtLat_' + i).val().length == 0){
            			marker = null ;
            		}else{
            			t_lat.push(parseFloat($('#txtLat_' + i).val()));
            			t_lng.push(parseFloat($('#txtLng_' + i).val()));
            			marker = new google.maps.Marker({
	                        position : new google.maps.LatLng(parseFloat($('#txtLat_'+i).val()), parseFloat($('#txtLng_'+i).val())),
	                        opacity : 0.6,
	                        map : map
	                    });
	                    marker.addListener('click', function(e) {
	                    	var n = -1;
	                    	for(var i=0;i<markers.length;i++){
	                    		if(markers[i] === this){
									n = i ;
									break;	                    			
	                    		}
	                    	}
	                    	var addr = $('#txtAddr_'+n).val().length>0?$('#txtAddr_'+n).val():this.label.text;
		                    var contentString = '<div id="__infowindow" style="width:200px;height:150px;"><a>名稱：</a><a>' + addr + '</a><br><a>地址：</a><a class="address"></a><br><br><input type="button" class="remove" value="移除" memo="' + n + '" style="display:none;"/></div>';
		                    infowindow.close();
			                infowindow.setContent(contentString);
			                infowindow.open(map,markers[n]);
		                    infowindow.addListener('domready',infowindowReady(n));
		                });
	                    n++;
            		}
            		if(first==i){
            			//起點
            			marker.setIcon(pinSymbol('green'));
            			marker.setLabel({
                            text : '起點',
                            color : "black",
                            fontSize : "16px",
                            fontFamily : "微軟正黑體"
                       	});
                       	//map.setCenter(marker.position);
            		}else if(last==i){
            			//終點
            			marker.setIcon(pinSymbol('blue'));
            			marker.setLabel({
                            text : '終點',
                            color : "black",
                            fontSize : "16px",
                            fontFamily : "微軟正黑體"
                       	});
            		}else{
            			if(marker!=null){
            				marker.setIcon(pinSymbol('red'));
	            			marker.setLabel({
	                            text : (n-1)+'',
	                            color : "darkred",
	                            fontSize : "16px",
	                            fontFamily : "微軟正黑體"
	                       	});
            			}
            		}
            		if(marker!=null){marker.setMap(map);}
                	markers.push(marker);
            	}
            	//終點改抓BBM
            	if($('#txtLat').val().length > 0){
            		t_lat.push(parseFloat($('#txtLat').val()));
            		t_lng.push(parseFloat($('#txtLng').val()));
            		marker = new google.maps.Marker({
                        position : new google.maps.LatLng(parseFloat($('#txtLat').val()), parseFloat($('#txtLng').val())),
                        opacity : 0.6,
                        label : {
	                            text : '終點',
	                            color : "black",
	                            fontSize : "16px",
	                            fontFamily : "微軟正黑體"
	                       	},
                       	icon : pinSymbol('blue'),
                        map : map
                    });
                    marker.addListener('click', function(e) {
                    	var n = -1;
                    	for(var i=0;i<markers.length;i++){
                    		if(markers[i] === this){
								n = i ;
								break;	                    			
                    		}
                    	}
	                    var contentString = '<div id="__infowindow" style="width:200px;height:150px;"><a>名稱：</a><a>' + $('#txtAddr').val() + '</a><br><a>地址：</a><a class="address"></a><br><br><input type="button" class="remove" value="移除" memo="-1" style="display:none;"/></div>';
	                    infowindow.close();
		                infowindow.setContent(contentString);
		                infowindow.open(map,markers[n]);
	                    infowindow.addListener('domready',infowindowReady(-1));
	                });
	                markers.push(marker);
            	}
            	//地圖中心點
            	if(t_lat.length>0){
            		var lat = 0, lng = 0;
            		for(var i=0;i<t_lat.length;i++)
            			lat += t_lat[i];
        			for(var i=0;i<t_lng.length;i++)
            			lng += t_lng[i];
            		lat = lat/t_lat.length;
            		lng = lng/t_lng.length;
            		console.log(lat+','+lng);
            		map.setCenter(new google.maps.LatLng(lat,lng));
            	}
            }
            function infowindowReady(n){
            	$('#__infowindow').find('.remove').click(function(e) {
                    if (!(q_cur == 1 || q_cur == 2)) {
                        alert('新增、修改狀態才能移除');
                        return;
                    }
                    var n = parseInt($(this).attr('memo'));
                    if(n=="-1"){
                    	markers[markers.length].setMap(null);
						markers[markers.length] = null;
                    }else{
                    	$('#btnMinus_'+n).click();
                    }
                });
                if(n==-1){
                	//不顯示移除按鍵
                	$('#__infowindow').find('.address').text($('#txtAddress').val());
                }else if($('#btnMinus_'+n).data('infowindow_address')!=undefined && $('#btnMinus_'+n).data('infowindow_address').length>0){
                	$('#__infowindow').find('.remove').show();
                	$('#__infowindow').find('.address').text($('#btnMinus_'+n).data('infowindow_address'));	
               		//console.log(n+':'+$('#btnMinus_'+n).data('infowindow_address'));
                }else{
                	$('#__infowindow').find('.remove').show();
                	var geocoder = new google.maps.Geocoder();
	                // 傳入 latLng 資訊至 geocoder.geocode
	                geocoder.geocode({
	                    'latLng' : infowindow.position
	                }, geocoderBackCall(n));
                }
            }
            function geocoderBackCall(n){
            	return function(results, status) {
                    if (status === google.maps.GeocoderStatus.OK) {
                        // 如果有資料就會回傳
                        if (results) {
                        	$('#btnMinus_'+n).data('infowindow_address',results[0].formatted_address);
                            $('#__infowindow').find('.address').text(results[0].formatted_address);
                        }
                    }
                    // 經緯度資訊錯誤
                    else {
                    	$('#btnMinus_'+n).data('infowindow_address','');
                        alert("Reverse Geocoding failed because: " + status);
                    }
               };
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
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 100%;
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
                width: 550px;
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
                width: 20%;
            }
            .tbbm .tdZ {
                width: 2%;
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
                width: 800px;
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
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain'>
			<div class="dview" id="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:100px; color:black;"><a>編號</a></td>
						<td align="center" style="width:150px; color:black;"><a>地點</a></td>
						<td align="center" style="width:400px; color:black;"><a>地址</a></td>
						<td align="center" style="width:80px; color:black;"><a>經度</a></td>
						<td align="center" style="width:80px; color:black;"><a>緯度</a></td>
						<td align="center" style="width:100px; color:black;"><a>聯絡人</a></td>
						<td align="center" style="width:100px; color:black;"><a>聯絡電話</a></td>
						<tr>
							<td >
							<input id="chkBrow.*" type="checkbox"/>
							</td>
							<td id='noa' style="text-align: left;">~noa</td>
							<td id='addr' style="text-align:left;">~addr</td>
							<td id='address' style="text-align:left;">~address</td>
							<td id='lat' style="text-align:center;">~lat</td>
							<td id='lng' style="text-align:center;">~lng</td>
							<td id='conn' style="text-align:left;">~conn</td>
							<td id='tel' style="text-align:left;">~tel</td>
						</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr style="height:1px;">
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td class="tdZ"></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">編號</a></td>
						<td>
						<input id="txtNoa"  type="text"  class="txt c1"/>
						</td>
						<td><span> </span><a class="lbl" id="lblCustno">集團</a></td>
						<td>
						<input id="txtCustno" type="text"  class="txt c1"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">地點</a></td>
						<td>
						<input id="txtAddr" type="text"  class="txt c1"/>
						</td>
						<td></td>
						<td>
						<input id="btnRun" type="button" class="c1" value="取得經、緯度"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">地址</a></td>
						<td colspan="3">
						<input id="txtAddress" type="text"  class="txt c1"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">經度</a></td>
						<td>
						<input id="txtLat" type="text"  class="txt c1"/>
						</td>
						<td><span> </span><a class="lbl">緯度</a></td>
						<td>
						<input id="txtLng" type="text"  class="txt c1"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">聯絡人</a></td>
						<td colspan="3">
						<input id="txtConn" type="text" class="txt c1"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">電話</a></td>
						<td colspan="3">
						<input id="txtTel" type="text" class="txt c1"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl">注意事項</a></td>
						<td colspan="3"><textarea id="txtMemo" class="txt c1" style="height:50px;"> </textarea></td>
					</tr>
					<tr style="display:none;">
						<td><span> </span><a class="lbl">路徑</a><input type="button" id="btnShowDirection" value="SHOW"></td>
						<td colspan="3"><textarea id="txtDirection" class="txt c1" style="height:50px;"> </textarea></td>
					</tr>
				</table>
			</div>
		</div>
		<!--2017/2/2  改由集團控制可進廠之車輛 -->
		<div class='dbbs'>
			<table id="tbbs" class='tbbs'>
				<tr style='color:white; background:#003366;' >
					<td  align="center" style="width:30px;">
					<input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
					</td>
					<td align="center" style="width:20px;"></td>
					<td align="center" style="width:150px;"><a>地點</a></td>
					<td align="center" style="width:150px;"><a>經緯</a></td>
					<td align="center" style="width:200px;"><a>備註</a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td align="center">
					<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
					<input id="txtNoq.*" type="text" style="display: none;" />
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td>
					<input type="text" id="txtAddrno.*" style="float:left;width:40%;" />
					<input type="text" id="txtAddr.*" style="float:left;width:55%;" />
					<input type="button" id="btnAddr.*" style="display:none;"/>
					</td>
					<td>
					<input type="text" id="txtAddress.*" style="display:none;" />
					<input type="text" id="txtLat.*" style="float:left;width:45%;" />
					<input type="text" id="txtLng.*" style="float:left;width:45%;" />
					</td>
					<td>
					<input type="text" id="txtMemo.*" style="float:left;width:95%;" />
					</td>
				</tr>
			</table>
		</div>
		<div id="mapForm" style="width:820px;height:650px;position: absolute;top:50px;left:600px;border-width: 0px;z-index: 80; background-color:pink;display:none;">
			<div id="mapStatus" style="width:820px;height:20px;position: relative; top:0px;left:0px; background-color:darkblue;color:white;">滑鼠右鍵拖曳</div>
			<div id="map" style="width:800px;height:600px;position: relative; top:5px;left:10px; "> </div>
		</div>

		<!--<div class='dbbs'>
		<table id="tbbs" class='tbbs'>
		<tr style='color:white; background:#003366;' >
		<td  align="center" style="width:30px;">
		<input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
		</td>
		<td align="center" style="width:20px;"> </td>
		<td align="center" style="width:100px;"><a>可進廠車牌</a></td>
		</tr>
		<tr  style='background:#cad3ff;'>
		<td align="center">
		<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
		<input id="txtNoq.*" type="text" style="display: none;" />
		</td>
		<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
		<td>
		<input type="text" id="txtCarno.*" style="width:95%;" />
		<input type="button" id="btnCarno.*" style="display:none;"/>
		</td>
		</tr>
		</table>
		</div>-->
		<input id="q_sys" type="hidden" />
	</body>
</html>
