<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src="../script/qj2.js" type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src="../script/qj_mess.js" type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            var q_name = 'addr3',
                t_content = '',
                bbsKey = ['noa'],
                as;
            var isBott = false;
            var txtfield = [],
                afield,
                t_data,
                t_htm,
                t_bbsTag = 'tbbs';
            var i,
                s1;
            $(document).ready(function() {
                main();
            });

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainBrow(0, t_content);
            }

            function q_gtPost() {
            }

            function refresh() {
                _refresh();
            }
		</script>
		<style type="text/css">
            .tbbs {
                font-size: 12pt;
                color: blue;
                text-align: left;
                border: 1PX lightgrey solid;
                width: 100%;
                height: 100%;
            }
            .txt.c1 {
                width: 100%;
            }
		</style>
	</head>

	<body>
		<div  id="dbbs"  >
			<table id="tbbs"  border="2"  cellpadding='0' cellspacing='0' style='width:98%' >
				<tr>
					<th align="center" > </th>
					<th align="center" style='color:blue;' > <a id='lblNoa'>編號</a></th>
					<th align="center" style='color:blue;' > <a id='lblNamea'>集團</a></th>
				</tr>
				<tr>
					<td style="width:2%;">
					<input name="sel"  id="radSel.*" type="radio" />
					</td>
					<td style="width: 25%;">
					<input class="txt c1" id="txtNoa.*" type="text"   readonly="readonly" />
					</td>
					<td style="width: 40%;">
					<input class="txt c1" id="txtNamea.*" type="text"   readonly="readonly" />
					</td>
				</tr>
			</table>
			<!--#include file="../inc/brow_ctrl.inc"-->
		</div>
	</body>
</html>

