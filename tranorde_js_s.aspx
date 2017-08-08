<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
        <link href="../qbox.css" rel="stylesheet" type="text/css" />
        <link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
			var q_name = "tranorde_js_s";
			
			aPop = new Array(
				['txtCustno', 'lblCustno', 'cust', 'noa,comp,nick', 'txtCustno', 'cust_b.aspx']);
				
			$(document).ready(function() {
				main();
			});
			/// end ready

			function main() {
				mainSeek();
				q_gf('', q_name);
			}

			function q_gfPost() {
				q_getFormat();
				q_langShow();

				bbmMask = [['txtBdate', r_picd], ['txtEdate', r_picd]];
				q_mask(bbmMask);
				$('#txtBdate').datepicker();
				$('#txtEdate').datepicker(); 
				$('#txtBdate1').datepicker();
				$('#txtEdate1').datepicker(); 
				$('#txtBdate2').datepicker();
				$('#txtEdate2').datepicker(); 
				$('#txtNoa').focus();
			}

			function q_seekStr() {
				t_bdate = $.trim($('#txtBdate').val());
				t_edate = $.trim($('#txtEdate').val());
				t_bdate1 = $.trim($('#txtBdate1').val());
				t_edate1 = $.trim($('#txtEdate1').val());
				t_bdate2 = $.trim($('#txtBdate2').val());
				t_edate2 = $.trim($('#txtEdate2').val());
				
				t_noa = $.trim($('#txtNoa').val());
				
				t_custno = $.trim($('#txtCustno').val());
				t_cust = $.trim($('#txtCust').val());
				
				var t_where = " 1=1 "
					+q_sqlPara2("datea", t_bdate, t_edate)
					+q_sqlPara2("noa", t_noa)
					+q_sqlPara2("custno", t_custno);
				if(t_cust.length>0)	
					t_where += " and charindex('"+t_cust+"',comp)>0";
					
				if(t_bdate1.length>0){
					t_bdate1 = "'"+t_bdate1+"'";
					t_edate1 = t_edate1.length==0?"char(255)":"'"+t_edate1+"'"; 
					t_where += " and ((date1 between "+t_bdate1+" and "+t_edate1+") or "
						+ "exists(select noa from view_tranordes"+r_accy+" where view_tranordes"+r_accy+".noa=view_tranorde"+r_accy+".noa and view_tranordes"+r_accy+".date1 between "+t_bdate1+" and "+t_edate1+"))";
				}
		       	if(t_bdate2.length>0){
					t_bdate2 = "'"+t_bdate2+"'";
					t_edate2 = t_edate2.length==0?"char(255)":"'"+t_edate2+"'"; 
					t_where += " and ((date1 between "+t_bdate2+" and "+t_edate2+") or "
						+ "exists(select noa from view_tranordes"+r_accy+" where view_tranordes"+r_accy+".noa=view_tranorde"+r_accy+".noa and view_tranordes"+r_accy+".date2 between "+t_bdate2+" and "+t_edate2+"))";
				}
				t_where = ' where=^^' + t_where + '^^ ';
				return t_where;
			}
		</script>
		<style type="text/css">
			.seek_tr {
				color: white;
				text-align: center;
				font-weight: bold;
				background-color: #76a2fe
			}
		</style>
	</head>
	<body>
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek"  border="1"   cellpadding='3' cellspacing='2' style='width:100%;' >
				<tr class='seek_tr'>
					<td style="width:35%;" ><a id='lblDatea'>登錄日期</a></td>
					<td style="width:65%;  ">
					<input class="txt" id="txtBdate" type="text" style="width:90px; font-size:medium;" />
					<span style="display:inline-block; vertical-align:middle">&sim;</span>
					<input class="txt" id="txtEdate" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td style="width:35%;" ><a id='lblDate1'>提貨日期</a></td>
					<td style="width:65%;  ">
					<input class="txt" id="txtBdate1" type="text" style="width:90px; font-size:medium;" />
					<span style="display:inline-block; vertical-align:middle">&sim;</span>
					<input class="txt" id="txtEdate1" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td style="width:35%;" ><a id='lblDate2'>卸貨日期</a></td>
					<td style="width:65%;  ">
					<input class="txt" id="txtBdate2" type="text" style="width:90px; font-size:medium;" />
					<span style="display:inline-block; vertical-align:middle">&sim;</span>
					<input class="txt" id="txtEdate2" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblNoa'>訂單號碼</a></td>
					<td><input class="txt" id="txtNoa" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblCustno'>客戶編號</a></td>
					<td><input class="txt" id="txtCustno" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblCust'>客戶名稱</a></td>
					<td><input class="txt" id="txtCust" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>
