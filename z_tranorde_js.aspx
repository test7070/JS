<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"> </script>
		<script src='../script/qj2.js' type="text/javascript"> </script>
		<script src='qset.js' type="text/javascript"> </script>
		<script src='../script/qj_mess.js' type="text/javascript"> </script>
		<script src="../script/qbox.js" type="text/javascript"> </script>
		<script src='../script/mask.js' type="text/javascript"> </script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
            $(document).ready(function() {
            	q_getId();
                q_gf('', 'z_tranorde_js');       
            });
            function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_tranorde_js',
					options : [{
						type : '0', //[1]
						name : 'path',
						value : location.protocol + '//' +location.hostname + location.pathname.toLowerCase().replace('z_tranorde_js.aspx','')
					},{
						type : '0', //[2]
						name : 'db',
						value : q_db
					},{
						type : '6', //[3]      1
						name : 'xnoa'
					}, {
						type : '1', //[4][5]   2
						name : 'xdate'
					}, {
						type : '1', //[6][7]   3
						name : 'xdate1'
					}, {
						type : '1', //[8][9]   4
						name : 'xdate2'
					}, {
						type : '2', //[10][11]   5
						name : 'xcust',
						dbf : 'cust',
						index : 'noa,comp',
						src : 'cust_b.aspx'
					}, {
						type : '2', //[12][13]    6
						name : 'xproduct',
						dbf : 'ucc',
						index : 'noa,product',
						src : 'ucc_b.aspx'
					}, {
						type : '2', //[14][15]   7
						name : 'xstraddr',
						dbf : 'addr2',
						index : 'noa,addr',
						src : 'addr2_b.aspx'
					}, {
						type : '2', //[16][17]  8
						name : 'xaddr',
						dbf : 'addr2',
						index : 'noa,addr',
						src : 'addr2_b.aspx'
					}, {
						type : '5', //[18]       9
						name : 'xchk1',
						value : [q_getPara('report.all')].concat(new Array('1@已提貨', '0@未提貨'))
					}, {
						type : '5', //[19]       10
						name : 'xchk2',
						value : [q_getPara('report.all')].concat(new Array('1@已卸貨', '0@未卸貨'))
					}, {
						type : '5', //[20]       11
						name : 'xenda',
						value : [q_getPara('report.all')].concat(new Array('1@已結案', '0@未結案'))
					}]
				});
				q_popAssign();

	            var t_para = new Array();
	            try{
	            	t_para = JSON.parse(q_getId()[3]);
	            }catch(e){
	            }    
	            if(t_para.length==0 || t_para.noa==undefined){
	            }else{
	            	$('#txtXnoa').val(t_para.noa);
	            }
	            
	            $('#txtXdate1').mask('999/99/99');
				$('#txtXdate1').datepicker();
				$('#txtXdate2').mask('999/99/99');
				$('#txtXdate2').datepicker();
				
				$('#txtXdate11').mask('999/99/99');
				$('#txtXdate11').datepicker();
				$('#txtXdate12').mask('999/99/99');
				$('#txtXdate12').datepicker();
				
				$('#txtXdate21').mask('999/99/99');
				$('#txtXdate21').datepicker();
				$('#txtXdate22').mask('999/99/99');
				$('#txtXdate22').datepicker();
            }

			function q_funcPost(t_func, result) {
                switch(t_func) {
                    default:
                        break;
                }
            }
			//function q_boxClose(s2) {}
			function q_gtPost(s2) {}
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div class="prt" style="margin-left: -40px;">			
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>
           
          