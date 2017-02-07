<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="Content-Language" content="en-us" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src="../script/qj2.js" type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src="../script/qj_mess.js" type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            var q_name = 'conn', t_bbsTag = 'tbbs', t_content = " ", afilter = [], bbsKey = [], t_count = 0, as;
            var t_sqlname = 'conn_load';
            t_postname = q_name;
            var isBott = false;
            var afield, t_htm;
            var i, s1;
			brwCount2 = 0;
			brwCount = -1;			
            var decbbs = [];
            var decbbm = [];
            var q_readonly = [];
            var q_readonlys = [];
            var bbmNum = [];
            var bbsNum = [];
            var bbmMask = [];
            var bbsMask = [];
			aPop = new Array(['txtJob_', 'btnJob_', 'licence', 'noa,licence', 'txtJob_,txtNamea_', 'licence_b.aspx']);
            	
            $(document).ready(function() {
                bbmKey = [];
                bbsKey = ['noa', 'noq'];
                if (!q_paraChk())
                    return;

                main();
            });
            
            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainBrow(6, t_content, t_sqlname, t_postname);
				$('#btnTop').hide();
				$('#btnPrev').hide();
				$('#btnNext').hide();
				$('#btnBott').hide();
				
            }

            function bbsAssign() {/// 表身運算式
            	for (var i = 0; i < q_bbsCount; i++) {	
            		$('#lblNo_' + i).text(i + 1);
                    if ($('#btnMinus_' + i).hasClass('isAssign'))
                        continue;
            		$('#txtJob_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnJob_'+n).click();
                    });
				}
                _bbsAssign();
            }
			
            function btnOk() {
                sum();
                t_key = q_getHref();
                q_gt('conn', "where=^^noa='"+t_key[1]+"'^^", 0, 0, 0, "conn_maxnoq");
            }
            function Save(maxnoq){
            	for (var i = 0; i < q_bbsCount; i++) {
                	$('#txtTypea_'+i).val($.trim(t_key[3]));
                	if(emp($('#txtNoq_'+i).val())){
                		maxnoq=('000'+(dec(maxnoq)+1)).substr(-3);
                		$('#txtNoq_'+i).val(maxnoq);
                	}
                }
                _btnOk(t_key[1], bbsKey[0], bbsKey[1], '', 2);
            }
			
            function bbsSave(as) {
                if (!as['job']) {
                    as[bbsKey[0]] = '';
                    return;
                }
                q_getId2('', as);
                return true;

            }

            function btnModi() {
                var t_key = q_getHref();

                if (!t_key)
                    return;

                _btnModi(1);

                for ( i = 0; i < abbsDele.length; i++) {
                    abbsDele[i][bbsKey[0]] = t_key[1];
                }
                $('#btnPlus').click();
                
            }

            function boxStore() {

            }

            function refresh() {
                _refresh();
            }

            function sum() {
            }

            function q_gtPost(t_name) {  /// 資料下載後 ...
                switch (t_name) {
					case 'conn_maxnoq':
						var maxnoq = '000';
						var as = _q_appendData("conn", "", true);
						if (as[0] != undefined) {
							maxnoq=as[as.length-1].noq;
						}
						Save(maxnoq);
						break;
					default:
						break;
				}
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
            }

            function btnMinus(id) {
                _btnMinus(id);
                sum();
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
                if (q_tables == 's')
                    bbsAssign();
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
		<div  id="dFixedTitle" style="overflow-y: scroll;">
			<table id="tFixedTitle" class='tFixedTitle'  border="2"  cellpadding='2' cellspacing='1' style='width:100%;'  >
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;"  /></td>
					<td align="center" style="width:25px;"> </td>
					<td align="center" style="width:150px;"><a>證照代碼</a></td>
					<td align="center" style="width:400px;"><a>證照名稱</a></td>
				</tr>
			</table>
		</div>
		<div id="dbbs" style="overflow: scroll;height:400px;" >
			<table id="tbbs" class='tbbs' border="2" cellpadding='2' cellspacing='1' style='width:100%;' >
				<tr style="display:none;">
					<td align="center" style="width:40px;"> </td>
					<td align="center" style="width:25px;"> </td>
					<td align="center" style="width:150px;"><a> </a></td>
					<td align="center" style="width:400px;"><a> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td style="width:40px;" align="center"><input class="btn"  id="btnMinus.*" type="button" value='－' style="font-weight: bold;"  /></td>
					<td style="width:25px;"><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td style="width:150px;">
						<input id="txtJob.*" type="text" style="width:95%;" readonly="readonly"/>
						<input id="btnJob.*" type="button" style="display:none;"/>
					</td>
					<td style="width:400px;">
						<input id="txtNamea.*" type="text" style="float:left;width:95%;"  readonly="readonly" />
						<input type="text" id="txtNoq.*" style="display:none;"/>
					</td>
				</tr>
			</table>
		</div>
		<!--#include file="../inc/pop_modi.inc"-->
</html>
