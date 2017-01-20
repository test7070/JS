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
		<script type="text/javascript">

			var q_name = "ucc";
			var q_readonly = ['txtWorker'];
			var bbmNum = [];
			var bbmMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'noa';
			brwCount2 = 20;
			//q_xchg = 1;
			$(document).ready(function() {
				bbmKey = ['noa'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1);
			});
			function sum(){
				cuft = round(0.0000353 * q_float('txtLengthb')* q_float('txtWidth')* q_float('txtHeight'),2); 
				$('#txtStkmount').val(cuft);
				if(q_float('txtTvolume')==0)
					$('#txtTvolume').val(Math.ceil(cuft));
			}
			
			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(0);
			}

			function mainPost() {
				q_mask(bbmMask);
				
				$('#txtNoa').change(function(e) {
					$(this).val($.trim($(this).val()).toUpperCase());
					if ($(this).val().length > 0){
						t_where = "where=^^ noa='" + $(this).val() + "'^^";
						q_gt('ucc', t_where, 0, 0, 0, "chkNoa_change", r_accy);
					}
				});
				$('#txtLengthb').change(function(e){sum();});
				$('#txtWidth').change(function(e){sum();});
				$('#txtHeight').change(function(e){sum();});
			}

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
						var as = _q_appendData("ucc", "", true);
						if (as[0] != undefined) {
							alert('已存在 ' + as[0].noa + ' ' + as[0].product);
						}
						break;
					case 'chkNoa_btnOk':
						var as = _q_appendData("ucc", "", true);
						if (as[0] != undefined) {
							alert('已存在 ' + as[0].noa + ' ' + as[0].product);
							Unlock(1);
							return;
						} else {
							wrServer($('#txtNoa').val());
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
				q_box(q_name + '_js_s.aspx', q_name + '_js_s', "500px", "300px", q_getMsg("popSeek"));
			}

			function btnIns() {
				_btnIns();
				refreshBbm();
				$('#txtNoa').focus();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				sum();
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

			function btnOk() {
				Lock(1, {
                    opacity : 0
                });
				$('#txtNoa').val($.trim($('#txtNoa').val()));
				$('#txtWorker').val(r_name);
				sum();
				if($('#txtNoa').val().length == 0){
					alert('請輸入品號!');
					Unlock(1);
					return;
				}
				if (q_cur == 1) {
					t_where = "where=^^ noa='" + $('#txtNoa').val() + "'^^";
					q_gt('ucc', t_where, 0, 0, 0, "chkNoa_btnOk", r_accy);
				} else {
					wrServer($('#txtNoa').val());
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
			}
			
			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}
			
			function refreshBbm() {
				if (q_cur == 1) {
					$('#txtNoa').css('color', 'black').css('background', 'white').removeAttr('readonly');
				} else {
					$('#txtNoa').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
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
		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 450px;
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
				width: 9%;
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
			.tbbs input[type="text"] {
				width: 98%;
			}
			.tbbs a {
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			.bbs {
				float: left;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
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
						<td align="center" style="width:120px; color:black;"><a>品號</a></td>
						<td align="center" style="width:200px; color:black;"><a>品名</a></td>
						<td align="center" style="width:60px; color:black;"><a id='vewUnit'> </a></td>
						<td align="center" style="width:60px; color:black;"><a id='vewUweight'>單位重</a></td>
						<td align="center" style="width:60px; color:black;"><a id='vewStkmount'>材積</a></td>
					<tr>
						<td ><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td id='noa' style="text-align: left;">~noa</td>
						<td id='product' style="text-align:left;">~product</td>
						<td id='unit' style="text-align:center;">~unit</td>
						<td id='uweight' style="text-align:right;">~uweight</td>
						<td id='stkmount' style="text-align:right;">~stkmount</td>
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
						<td><span> </span><a class="lbl">品號</a></td>
						<td><input id="txtNoa"  type="text"  class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">品名</a></td>
						<td colspan="3"><input id="txtProduct" type="text"  class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblUnit' class="lbl">單位</a></td>
						<td><input id="txtUnit" type="text"  class="txt c1"/></td>
					</tr>
					
					<tr>
						<td><span> </span><a id='lblUweight' class="lbl">單位重</a></td>
						<td><input id="txtUweight" type="text"  class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">長</a></td>
						<td><input id="txtLengthb" type="text" class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">寬</a></td>
						<td><input id="txtWidth" type="text" class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">高</a></td>
						<td><input id="txtHeight" type="text" class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblStkmount' class="lbl">材積</a></td>
						<td><input id="txtStkmount" type="text"  class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">運送需耗高度</a></td>
						<td><input id="txtTheight" type="text" class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">運送需耗材積</a></td>
						<td><input id="txtTvolume" type="text" class="txt c1 num"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl">備註</a></td>
						<td colspan="3">
							<textarea id="txtMemo" class="txt c1" style="height:50px;"> </textarea>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl">製單人</a></td>
						<td><input id="txtWorker" type="text" class="txt c1" /></td>
					</tr>
				</table>
			</div>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
