<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title></title>
        <script src="../script/jquery.min.js" type="text/javascript"></script>
        <script src='../script/qj2.js' type="text/javascript"></script>
        <script src='qset.js' type="text/javascript"></script>
        <script src='../script/qj_mess.js' type="text/javascript"></script>
        <script src="../script/qbox.js" type="text/javascript"></script>
        <script src='../script/mask.js' type="text/javascript"></script>
        <link href="../qbox.css" rel="stylesheet" type="text/css" />
        <link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
        <script src="css/jquery/ui/jquery.ui.core.js"></script>
        <script src="css/jquery/ui/jquery.ui.widget.js"></script>
        <script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC4lkDc9H0JanDkP8MUpO-mzXRtmugbiI8&callback=initMap" async defer></script>
        <script type="text/javascript">
			$(document).ready(function() {
				_q_boxClose();
				q_getId();
				q_gf('', 'bandwidth');	
			});
			function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'bandwidth', options : []
				});
				q_popAssign();
				q_langShow();
				$('#container').css('display', 'none');
                $('.prt').children().children().css('display', 'none');
                $('#btnAuthority').css('display', '').offset({top:10,left:50});
                
                $('#btnRun').click(function(e){
                	var t_noa = $.trim($('#txtNoa').val());
                	var t_noq = $.trim($('#txtNoq').val());
 
                	if(t_noa.length==0){
                		alert('請輸入派車單號。');
                		return;
                	}
                	//select * from view_tranvcces where noa='BP1060519001' and noq='001'
                	q_gt('view_tranvcces', "where=^^noa='"+t_noa+"' and noq='"+t_noq+"' ^^", 0, 0, 0, JSON.stringify({action:"getAssignPath"}));
                	
                });
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
                    		if(t_para.action=="getAssignPath"){
                    			console.log('gtpost view_tranvcces');
                    			
                    			for(var i=0;i<markers.length;i++){
                    				markers[i].setMap(null);
                    			}
                    			markers = [];
                    			initMap();
                    			
                    			as = _q_appendData("view_tranvcces", "", true);
                    			if(as[0]!=undefined){
	                    			console.log(as);
	                    			var tmp = as[0].paths.split('|');
	                    			var positions = [];
	                    			for(var i=0;i<tmp.length;i++){
	                    				positions.push({
	                    					lat: parseFloat(tmp[i].split(',')[0])
	                    					,lng: parseFloat(tmp[i].split(',')[1])
	                    				});
	                    			}
	                    			//起點
	                    			var start = positions[0]; 
	                    			var marker = new google.maps.Marker({
										position: start,
										opacity : 0.6,
					                    label : {
					                            text : "起",
					                            color : "darkred",
					                            fontSize : "16px",
					                            fontWeight : "900",
					                            fontFamily : "微軟正黑體"
					                       	},
					                   	map : map});
									marker.setIcon(pinSymbol("#FE642E"));
									markers.push(marker);
									//終點
									var end = positions[positions.length-1]; 
                    				var marker = new google.maps.Marker({
										position: end,
										opacity : 0.6,
					                    label : {
					                            text : "迄",
					                            color : "darkred",
					                            fontSize : "16px",
					                            fontWeight : "900",
					                            fontFamily : "微軟正黑體"
					                       	},
					                   	map : map});
									marker.setIcon(pinSymbol("#58D3F7"));
									markers.push(marker);
									//default path
									for(var i=0;i<positions.length;i++){
				                		defaultPath.getPath().push(new google.maps.LatLng(positions[i].lat,positions[i].lng));
				                	}
                	
									map.setCenter(start);
									
									var t_carno = "MHD-2930";
									var t_datea = "2017/05/19";
									var t_where = "where=^^carno='"+t_carno+"' and datea='"+t_datea+"'^^ order=^^timea^^";
									q_gt('location', t_where , 0, 0, 0, JSON.stringify({action:"getGps",positions:positions}));
                    			}
                    			
                			}if(t_para.action=="getGps"){
                				console.log('gtpost getGps');
                				as = _q_appendData("location", "", true);
                				if(as[0]!=undefined){
                					//console.log(as);
                					
                					var gps = [];
                					for(var i=0;i<as.length;i++){
                						gps.push({
                							lat: parseFloat(as[i].latitude)
                							,lng: parseFloat(as[i].longitude)
                							,time: new Date(as[i].timea)
                						});
                					}
                					//比對 GPS路徑 與預設路徑
                					var defaultM =200;
                					try{
                						defaultM = parseFloat($('#txtMile').val());
                					}catch(e){}
                					
                					var n=0;
                					for(var i=0;i<gps.length;i++){
                						for(var j=n;j<t_para.positions.length;j++){
                							dis = calcDistance(gps[i],t_para.positions[j]);
                							if(dis<=defaultM){
                								gps[i].n = j;
                								gps[i].positions = t_para.positions[j];
                								n=j;
                								break;
                							}else{
            									gps[i].n = -1;
                								gps[i].positions = null;
                							}
                						}
                					}
                					/*for(var i=0;i<gps.length;i++){
                						for(var j=0;j<t_para.positions.length;j++){
                							dis = calcDistance(gps[i],t_para.positions[j]);
                							if(dis<=100){
                								gps[i].n = j;
                								gps[i].positions = t_para.positions[j];
                								n=j+1;
                								break;
                							}else{
            									gps[i].n = -1;
                								gps[i].positions = null;
                							}
                						}
                					}*/
                					
                					/*var aa = new google.maps.Polyline({
									    strokeColor: '#000000',
									    strokeOpacity: 1.0,
									    strokeWeight: 3
								    });
									aa.setMap(map);	    
                					for(var i=0;i<gps.length;i++){
                						console.log(gps[i].lat);
                						aa.getPath().push(new google.maps.LatLng(gps[i].lat,gps[i].lng));
                					}*/
                					
                					var isConn = $('#chkConn').prop('checked');
                					var isRed = false; // current
                					for(var i=0;i<gps.length;i++){
                						if(!isRed && gps[i].n == -1){
                							isRed = true;
                							gpsPath.push(new google.maps.Polyline({
											    strokeColor: '#DF0101',
											    strokeOpacity: 1.0,
											    strokeWeight: 3
										    }));
										    gpsPath[gpsPath.length-1].setMap(map);
										    
										    if(isConn && i>0)
										    	gpsPath[gpsPath.length-1].getPath().push(new google.maps.LatLng(gps[i-1].lat,gps[i-1].lng));
										    gpsPath[gpsPath.length-1].getPath().push(new google.maps.LatLng(gps[i].lat,gps[i].lng));
                							
                						}else if(isRed && gps[i].n == -1){
										    gpsPath[gpsPath.length-1].getPath().push(new google.maps.LatLng(gps[i].lat,gps[i].lng));
                						}else if(isRed && gps[i].n!=-1){
                							gpsPath.push(new google.maps.Polyline({
											    strokeColor: '#0040FF',
											    strokeOpacity: 1.0,
											    strokeWeight: 3
										    }));
										    gpsPath[gpsPath.length-1].setMap(map);
										    if(isConn && i>0)
										    	gpsPath[gpsPath.length-1].getPath().push(new google.maps.LatLng(gps[i-1].lat,gps[i-1].lng));
										    gpsPath[gpsPath.length-1].getPath().push(new google.maps.LatLng(gps[i].lat,gps[i].lng));
                							isRed = false;
                						}else if(!isRed && gps[i].n!=-1){
                							if(gpsPath.length==0){
                								gpsPath.push(new google.maps.Polyline({
												    strokeColor: '#0040FF',
												    strokeOpacity: 1.0,
												    strokeWeight: 3
											    }));
											    gpsPath[gpsPath.length-1].setMap(map);
                							}
										    gpsPath[gpsPath.length-1].getPath().push(new google.maps.LatLng(gps[i].lat,gps[i].lng));
                						}
                					}
				 
									console.log(gps);
                					//console.log(gps);
                					
                					//t_para.positions;
                					
                				}
            				}else {
                    			/*$('#txtWeight_'+n).val(0);
                				$('#txtVolume_'+n).val(0);
                				$('#txtTvolume_'+n).val(0);*/
							}
                		}catch(e){
                			console.log(e.lineNumber);
                    		console.log(e.message);
                    		
                    	}
                        break;
                }
			}
			function q_funcPost(t_func, result) {
			}
			function q_boxClose(t_name) {
			}
			//MAP
            var map,
                directionsService,
                directionsDisplay,
                defaultPath,
                gpsPath=[];
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
                
                defaultPath = new google.maps.Polyline({
				    strokeColor: '#58FA82',
				    strokeOpacity: 1.0,
				    strokeWeight: 3
				  });
				defaultPath.setMap(map);
				
				for(var i=0;i<gpsPath.length;i++){
					gpsPath[i].setMap(null); 
					gpsPath[i] = null;
				}
				gpsPath=[];
  
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
        </script>
    </head>
    <style> </style>
    <body>

        <div id="q_menu"></div>

        <div style="position: absolute;top: 10px;left:50px;z-index: 1;width:1200px;">
            <div id="container">
                <div id="q_report"></div>
            </div>
            <div class="prt" style="margin-left: -40px;">
                <!--#include file="../inc/print_ctrl.inc"-->
            </div>
        </div>
        
		<br>
        <a style="width:200px;">派車單號：</a>
        <input type="text" id="txtNoa" style="width:100px;" value="BP1060519001"/>
        <input type="text" id="txtNoq" style="width:50px;" value="001"/>
        <br>
        <a style="color:black;">允許偏移距離（M）：</a><input type="text" id="txtMile" style="width:50px;" value="200"/>
        <br>
        <a style="color:black;">連接路徑：</a><input type="checkbox" id="chkConn"/>
        <br>
        <br>
        <input type="button" id="btnRun" value="RUN" style="" />
        <br>
     	<br>
     	<a style="color:black;">預設路徑：</a><a style="color:#58FA82;font-weight: bolder;">－－</a>
     	<br>
     	<a style="color:black;">行駛路徑：</a><a style="color:#0040FF;font-weight: bolder;">－－</a>
     	<br>
     	<a style="color:black;">偏移路徑：</a><a style="color:#DF0101;font-weight: bolder;">－－</a>
        <div id="mapForm" style="width:1020px;height:650px;">
			<!--<div id="mapStatus" style="width:820px;height:20px;position: relative; top:0px;left:0px; background-color:darkblue;color:white;">滑鼠右鍵拖曳</div>-->
			<div id="map" style="width:1000px;height:600px;position: relative; top:5px;left:10px; "> </div>
		</div>
    </body>
</html>