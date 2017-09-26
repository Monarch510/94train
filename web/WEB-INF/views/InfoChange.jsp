<%--
  Created by IntelliJ IDEA.
  User: Ezio
  Date: 2017/9/22
  Time: 11:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="common/IncludeTop.jsp"/>

<div id="template" class="hidden">
    <table>
        <thead>
        <tr>
            <th>#</th>
            <th>车站</th>
            <th>到达时间</th>
            <th>发车时间</th>
            <th>价格</th>
            <th>剩余票数</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <th scope="row" name="index">1</th>
            <td name="Station">Mark</td>
            <td name="ArrivalTime">Otto</td>
            <td name="DepartureTime">@mdo</td>
            <td name="Price"></td>
            <td name="Count"></td>
            <td name="Action">
                <a class="btn btn-link" href="#">修改</a>
                <a class="btn btn-link" href="#">删除</a>
            </td>
        </tr>
        </tbody>
    </table>

</div>
<div id="template2" class="hidden">
    <table>
        <thead>
        <tr>
            <th>#</th>
            <th>车站</th>
            <th>到达时间</th>
            <th>发车时间</th>
            <th>价格</th>
            <th>剩余票数</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <th scope="row" name="index">1</th>
            <td name="Station">
                <input name="Station" type="text">
            </td>
            <td name="ArrivalTime">
                <input name="ArrivalTime" type="text">
            </td>
            <td name="DepartureTime">
                <input name="DepartureTime" type="text">
            </td>
            <td name="Price">
                <input name="Price" type="text">
            </td>
            <td name="Count">
                <input name="Count" type="text">
            </td>
            <td name="Action">
                <a class="btn btn-link" href="#">保存</a>
                <a class="btn btn-link" href="#">删除</a>
            </td>
        </tr>
        </tbody>
    </table>

</div>
<div class="container">
    <div class="row">
        <div class="col-md-1"></div>
        <div class="col-md-10">
            <div>
    <table class="table table-striped table-hover" id="table">
        <thead>
        <tr>
            <th>#</th>
            <th>车站</th>
            <th>到达时间</th>
            <th>发车时间</th>
            <th>价格</th>
            <th>剩余票数</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="Mark">

        </tbody>
    </table>
</div>
        </div>
        <div class="col-md-1"></div>
    </div>
    <div class="row"  style="margin-bottom: 20px;">
        <div class="col-md-1"></div>
        <div class="col-md-10"><div>
            <div>
                <button class="btn btn-default" type="submit" id="Add">添加</button>
                <button  class="btn btn-success"type="submit" id="Save">保存</button>
                <a  class="btn btn-default" href="/Admin/Change.do">返回</a>
            </div>
        </div></div>
        <div class="col-md-1"></div>
    </div>
</div>

<jsp:include page="common/IncludeBottom.jsp"/>

<script>
    $(document).ready(
        function ()
        {
            ajax_json();
            $("#Add").click(function () {
                var mark = $('#Mark');
                var copy =$('#template2 table tbody tr').clone();
                mark.append(copy);
                var th = $("#table > tbody > tr > th");
                th.each(function(index,element) {
                    $(element).html(index+1);
                });
                var a = copy.find("[name='Action']").children("a").first();
                a.click(save);
                var b = copy.find("[name='Action']").children("a").last();
                b.click(function () {
                    $(this).parent().parent().remove();
                    var th = $("#table > tbody > tr > th");

                    th.each(function(index,element) {
                        $(element).html(index+1);
                    });
                })
            });
            $("#Save").click(ajax_save);
        }

    );

    function ajax_save() {
        $.post("/Admin/SaveTrainList.do",
            {"json":GetData(),"trainid":'${requestScope.get("TrainID")}',"index":$("#Mark").children().length,"seats":'${requestScope.get("seats")}'},
            function (response) {
                var obj = window.open("about:blank","_blank");
                obj.document.write(response);
            })
    }

    function GetData()
    {
        var body = $("#Mark");
        var json=new Array();;
        alert(body.children().length);
        for(var i=0;i<body.children().length;i++)
        {
            var temp = body.children().eq(i);
            var dic = {};
            for(var j = 1;j<6;j++)
            {
                dic[temp.children().eq(j).attr("name")] = temp.children().eq(j).html();
            }
            json.push(dic);
        }
        alert(JSON.stringify(json));
        return JSON.stringify(json);
    }

    function ajax_json(){
        $.getJSON("/Admin/TrainSectionList.do?TrainID=${requestScope.get("TrainID")}",
            function(data)
            {
                var demo = $('#template table tbody tr');
                var mark = $('#Mark');
                mark.empty();
                data.forEach(function(item,index)
                {
                    var temp = demo.clone();
                    temp.find("[name='index']").html(index+1);
                    temp.find("[name='Station']").html(item["startStation"]);
                    temp.find("[name='ArrivalTime']").html(item["arrivalTime"]);
                    temp.find("[name='DepartureTime']").html(item["departureTime"]);
                    temp.find("[name='Price']").html(item["price"]);
                    temp.find("[name='Count']").html(item["countLeft"]);

                    var a = temp.find("[name='Action']").children("a").first();
                    a.attr("href",a.attr("href")+item["trainID"]);
                    var b = temp.find("[name='Action']").children("a").last();
                    b.attr("href",b.attr("href")+item["trainID"]);

                    a.click(change);

                    b.click(function()
                    {
                        $(this).parent().parent().remove();
                        var th = $("#table > tbody > tr > th");

                        th.each(function(index,element) {
                            $(element).html(index+1);
                        });
                    });
                    mark.append(temp);
                });
            });
    }

    function change(){
        var c = $(this).parent().parent();
        var d = $('#template2 table tbody tr').clone();
        for(var i = 1;i<6;i++)
        {
            d.children().eq(i).children().first().attr("value",c.children().eq(i).html());
            c.children().eq(i).html(d.children().eq(i).html());
        }
        $(this).unbind();
        $(this).click(save)
        $(this).html("保存");
        return false;
    }

    function save(){
        var c = $(this).parent().parent();
        for(var i = 1;i<6;i++)
        {
            c.children().eq(i).html(c.children().eq(i).children().first().val());
        }
        $(this).unbind();
        $(this).click(change);
        $(this).html("修改");
        return false;
    }
</script>