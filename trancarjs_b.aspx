<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="Content-Language" content="en-us" />
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src="../script/qj2.js" type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src="../script/qj_mess.js" type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            var q_name = "trancarjs", t_content = "where=^^['')^^", bbsKey = ['carno'], as;
            var isBott = false;
            var txtfield = [], afield, t_data, t_htm, t_bbsTag = 'tbbs';
       		brwCount = -1;
			brwCount2 = -1;
            $(document).ready(function() {
                main();
            });
            /// end ready

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                var t_para = new Array();
	            try{
	            	t_para = JSON.parse(decodeURIComponent(q_getId()[5]));
	            	t_content = "where=^^['"+t_para.noa+"','"+t_para.date+"')^^";
	            	$('#textWeight').val(t_para.weight);
					$('#textVolume').val(t_para.volume);
	            }catch(e){
	            }    
                brwCount = -1;
                mainBrow(0, t_content);
            }
			function mainPost() {
				$('#btnTop').hide();
				$('#btnPrev').hide();
				$('#btnNext').hide();
				$('#btnBott').hide();
			}
            function q_gtPost(t_name) {
				switch (t_name) {
					case q_name:
						abbs = _q_appendData(q_name, "", true);
						//refresh();
						break;
				}
			}
			
			var maxAbbsCount = 0;
            function refresh() {
            	//ref ordest_b.aspx
				var w = window.parent;
				
				if (maxAbbsCount < abbs.length) {
					for (var i = (abbs.length - (abbs.length - maxAbbsCount)); i < abbs.length; i++) {
						for(var j=0;j<w.$('#_carno').children().length;j++){
							if(w.$('#_carno').children().eq(j).find('.carno').text()==abbs[i].carno){
								abbs[i]['sel'] = "true";
								$('#chkSel_' + abbs[i].rec).attr('checked', true);
							}
						}
					}
					maxAbbsCount = abbs.length;
				}
				abbs.sort(function(a,b){
					var x = (a.sel==true || a.sel=="true"?1:0);
					var y = (b.sel==true || b.sel=="true"?1:0);
					return y-x;
				});
				/*for(var i=0;i<abbs.length;i++){
					if(abbs[i].kind == ''){
						abbs.splice(i,1);
						i--;
					}
				}*/
				_refresh();
				q_bbsCount = abbs.length;
				
				$('#checkAllCheckbox').click(function() {
					$('input[type=checkbox][id^=chkSel]').each(function() {
						var t_id = $(this).attr('id').split('_')[1];
						if (!emp($('#txtCarno_' + t_id).val()))
							$(this).attr('checked', $('#checkAllCheckbox').is(':checked'));
					});
				});
				//----------------------------------
				/*t_weight = 0;
				t_volume = 0;
				for(var i=0;i<w.find('.bbsWeight').length;i++){
					t_weight += q_float(w.find('.bbsWeight').eq(i).attr('id'));
				}
				for(var i=0;i<w.find('.bbsVolume').length;i++){
					t_volume += q_float(w.find('.bbsVolume').eq(i).attr('id'));
				}
				$('#textWeight').val(t_weight);
				$('#textVolume').val(t_volume);
				*/
				for(var i=0;i<q_bbsCount;i++){
					$('#lblNo_'+i).text((i+1));
					$('#chkSel_'+i).click(function(e){
						t_weight = 0;
						t_volume = 0;
						for(var i=0;i<q_bbsCount;i++){
							t_weight += ($('#chkSel_'+i).prop('checked')?q_float('txtWeight_'+i):0);
							t_volume += ($('#chkSel_'+i).prop('checked')?q_float('txtVolume_'+i):0);
						}
						$('#textWeight2').val(t_weight);
						$('#textVolume2').val(t_volume);
						$('#textWeight3').val(q_float('textWeight')-q_float('textWeight2'));
						$('#textVolume3').val(q_float('textVolume')-q_float('textVolume2'));
					});
				}
				$('#checkAllCheckbox').click(function(e){
					t_weight = 0;
					t_volume = 0;
					for(var i=0;i<q_bbsCount;i++){
						t_weight += ($('#chkSel_'+i).prop('checked')?q_float('txtWeight_'+i):0);
						t_volume += ($('#chkSel_'+i).prop('checked')?q_float('txtVolume_'+i):0);
					}
					$('#textWeight2').val(t_weight);
					$('#textVolume2').val(t_volume);
					$('#textWeight3').val(q_float('textWeight')-q_float('textWeight2'));
					$('#textVolume3').val(q_float('textVolume')-q_float('textVolume2'));
				});
				
				t_weight = 0;
				t_volume = 0;
				for(var i=0;i<q_bbsCount;i++){
					t_weight += ($('#chkSel_'+i).prop('checked')?q_float('txtWeight_'+i):0);
					t_volume += ($('#chkSel_'+i).prop('checked')?q_float('txtVolume_'+i):0);
				}
				$('#textWeight2').val(t_weight);
				$('#textVolume2').val(t_volume);
				$('#textWeight3').val(q_float('textWeight')-q_float('textWeight2'));
				$('#textVolume3').val(q_float('textVolume')-q_float('textVolume2'));
				//_readonlys(true);
			}
		</script>
		<style type="text/css">
		</style>
	</head>
	<body>
		<div  id="dFixedTitle" style="overflow-y: scroll;">
			<table id="tFixedTitle" class='tFixedTitle'  border="2"  cellpadding='2' cellspacing='1' style='width:100%;'  >
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:25px" ><input type="checkbox" id="checkAllCheckbox"/></td>
					<td align="center" style="width:25px;"> </td>
					<td align="center" style="width:100px;"><a>車牌</a></td>
					<td align="center" style="width:150px;"><a>司機</a></td>
					<td align="center" style="width:80px;"><a>載重</a></td>
					<td align="center" style="width:80px;"><a>材積</a></td>
					<td align="center" style="width:80px;"><a>已運輸<BR>時間(分)</a></td>
					<td align="center" style="width:80px;"><a>已裝卸<BR>時間(分)</a></td>
					<td align="center" style="width:300px;"><a>已裝卸<BR>地點</a></td>
				</tr>
			</table>
		</div>
		<div id="dbbs" style="overflow: scroll;height:400px" >
			<table id="tbbs" class='tbbs' border="2" cellpadding='2' cellspacing='1' style='width:100%;' >
				<tr style="display:none;">
					<td align="center" style="width:25px;"> </td>
					<td align="center" style="width:25px;"> </td>
					<td align="center" style="width:100px;"><a> </a></td>
					<td align="center" style="width:150px;"><a> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td style="width:25px;"><input id="chkSel.*" type="checkbox"/></td>
					<td style="width:25px;"><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td style="width:100px;">
						<input id="txtCarno.*" type="text" style="float:left;width:95%;"  readonly="readonly" />
					</td>
					<td style="width:150px;">
						<input id="txtDriverno.*" type="text" style="float:left;width:45%;" readonly="readonly" />
						<input id="txtDriver.*" type="text" style="float:left;width:50%;" readonly="readonly" />
					</td>
					<td style="width:80px;">
						<input id="txtWeight.*" type="text" style="float:left;width:95%;text-align: right;" readonly="readonly" />
					</td>
					<td style="width:80px;">
						<input id="txtVolume.*" type="text" style="float:left;width:95%;text-align: right;" readonly="readonly" />
					</td>
					<td style="width:80px;">
						<input id="txtMins1.*" type="text" style="float:left;width:95%;text-align: right;" readonly="readonly" />
					</td>
					<td style="width:80px;">
						<input id="txtMins2.*" type="text" style="float:left;width:95%;text-align: right;" readonly="readonly" />
					</td>
					<td style="width:300px;">
						<input id="txtMemo.*" type="text" style="float:left;width:95%;" readonly="readonly" />
					</td>
				</tr>
			</table>
		</div>
		<div　style="width:100%;">
			<a style="float:left;">訂單重量：</a><input id="textWeight" style="float:left;width:100px;text-align: right;"/>
			<a style="float:left;width:100px;text-align: right;">訂單材積：</a><input id="textVolume" style="float:left;width:100px;text-align: right;"/>
			<a style="float:left;width:100px;float:left;display:none;">車輛總載重：</a><input id="textWeight2" style="float:left;width:100px;text-align: right;display:none;"/>
			<a style="float:left;width:100px;text-align: right;display:none;">車輛總材積：</a><input id="textVolume2" style="float:left;width:100px;text-align: right;display:none;"/>
			<a style="float:left;width:100px;float:left;">未承載重：</a><input id="textWeight3" style="float:left;width:100px;text-align: right;"/>
			<a style="float:left;width:100px;text-align: right;">未承載材積：</a><input id="textVolume3" style="float:left;width:100px;text-align: right;"/>
		</div>
		<!--#include file="../inc/pop_ctrl.inc"-->
	</body>
</html>

