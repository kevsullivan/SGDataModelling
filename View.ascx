<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="DotNetNuke.Modules.SGDataModelling.View" %>
<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>
<%@ Import Namespace="DotNetNuke.Modules.SGDataModelling.Components" %>
<script src="http://kevinosullivan.info/portfolio/wp-content/uploads/2016/03/Chart.js"></script>
<script src="http://kevinosullivan.info/portfolio/wp-content/uploads/2016/03/d3.js"></script>
<script src="http://kevinosullivan.info/portfolio/wp-content/uploads/2016/03/vis.js"></script>
<br/>

<!--
<asp:label ID="lblAgeAvg" runat="server" Text="Your Age Rounded Up: "></asp:label>
<asp:TextBox ID="txtAgeAvg" runat="server"></asp:TextBox>
<br/>

<asp:label ID="lblNumberFriends" runat="server" Text="Amount of Friends You have: "></asp:label>
<asp:TextBox ID="txtNumberFriends" runat="server"></asp:TextBox>
<br/>

<asp:label ID="lblNumberFollowers" runat="server" Text="Number of Followers you have: "></asp:label>
<asp:TextBox ID="txtNumberFollowers" runat="server"></asp:TextBox>
<br/>
<asp:label ID="lblNumberUsers" runat="server" Text="Total Number Users on the site: "></asp:label>
<asp:TextBox ID="txtNumberUsers" runat="server"></asp:TextBox>
<br/>-->

<!-- Construct overall container of graphs here - Design Area -->
<div id ="UsersData">
    <div style="height: 400px; width: 50%"class="floatLeft" id="networks"><canvas id="networksCanvas" width="500" height="400"></canvas></div>
    
    <canvas id="relationship" width="500" height="400"></canvas>
    
    <canvas id="relationship2" width="500" height="400"></canvas>
    
    
</div>


<!-- Script to get high level data of total users, friends and followers on website -->
<script>
    var relationshipData = {
        labels: ["Users", "Friends", "Followers"],
        // Data set for users both over and under 18 years of age.
        datasets: [
            {
                label: 'Over 18 #',
                fillColor: '#382765',
                // Data is pulled from code behind.
                data: [<%= Convert.ToInt32(txtNumberUsers.Text) %>, <%= Convert.ToInt32(txtNumberFriends.Text) %>, <%= Convert.ToInt32(txtNumberFollowers.Text) %>]
            },
            {
                label: 'Under 18 #',
                fillColor: '#7BC225',
                // Data is pulled from code behind.
                data: [<%= QueryController.GetNumberUsers().QueryValue%>, <%= Convert.ToInt32(txtNumberFriends.Text) %>, <%= Convert.ToInt32(txtNumberFollowers.Text) %>]
            }
        ]
    }
    var relationships = document.getElementById('relationship').getContext('2d');
    new Chart(relationships).Bar(relationshipData);
</script>

<!-- Script to get high level data of total users, friends and followers on website Currently a placeholder for desgin vision -->
<script>
    var relationshipData = {
        labels: ["Users", "Friends", "Followers"],
        datasets: [
            {
                label: 'Over 18 #',
                fillColor: '#382765',
                // Data is pulled from code behind.
                data: [<%= Convert.ToInt32(txtNumberUsers.Text) %>, <%= Convert.ToInt32(txtNumberFriends.Text) %>, <%= Convert.ToInt32(txtNumberFollowers.Text) %>]
            },
            {
                label: 'Under 18 #',
                fillColor: '#7BC225',
                // Data is pulled from code behind.
                data: [<%= QueryController.GetNumberUsers().QueryValue%>, <%= Convert.ToInt32(txtNumberFriends.Text) %>, <%= Convert.ToInt32(txtNumberFollowers.Text) %>]
            }
        ]
    }
    var relationships = document.getElementById('relationship2').getContext('2d');
    new Chart(relationships).Bar(relationshipData);
</script>


<!-- Network graph script. This is where node/edges graph for connected users across the site is handled. Also handles click event by redirecting to profile of selected user. -->
<script>
    var nodeDict = $.parseJSON('<%= QueryController.GetNetworkData()%>');
    var nodes = new vis.DataSet({});

    for (var key in nodeDict) {
        nodes.add([
            { id: key, label: nodeDict[key] }
        ]);
    }
    var edgesDict = $.parseJSON('<%= QueryController.GetRelationshipLinks()%>');
    var edges = new vis.DataSet({});

    for (var key in edgesDict) {
        var details = edgesDict[key].split(",");
        // Edges colored Green for Friends and Red for followers. Followers also have an arrow pointing to show who is follower/folowee or both if that is the case.
        edges.add([
            { from: parseInt(details[0]), to: parseInt(details[1]), color: details[2].localeCompare("Friend") ? { color: 'green' } : { color: 'red' }, arrows: details[2].localeCompare("Follower") ? 'to' : '' }
        ]);
    }

    var container = document.getElementById('networks');
    var canvas = document.getElementById('networksCanvas');
    var context = canvas.getContext("2d");
    context.fillStyle = "blue";
    context.font = "bold 16px Arial";
    context.fillText("Zibri", 100, 100);
    var data = {
        nodes: nodes,
        edges: edges
    };
    var network = new vis.Network(container, data, {});
    network.on("click", function (params) {
        // Redirect to activity feed/profile page of selected user on click.
        if (params["nodes"].length > 0) {
            window.location.href = location.protocol + "//" + location.host + "/Activity-Feed/userId/" + params["nodes"][0];
        }
        }
    )

</script>