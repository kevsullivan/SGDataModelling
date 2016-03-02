<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="DotNetNuke.Modules.SGDataModelling.View" %>
<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>
<script src="http://kevinosullivan.info/portfolio/wp-content/uploads/2016/03/Chart.js"></script>

<br/>
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
<br/>
<br />
<br />
<canvas id="relationship" width="500" height="400"></canvas>
<%-- ReSharper disable once PossiblyUnassignedProperty .Bar --%>

<script>
    var relationshipData = {
        labels: ["Users", "Friends", "Followers"],
        datasets: [
            {
                label: 'Over 18 #',
                fillColor: '#382765',
                data: [<%= Convert.ToInt32(txtNumberUsers.Text) %>, <%= Convert.ToInt32(txtNumberFriends.Text) %>, <%= Convert.ToInt32(txtNumberFollowers.Text) %>]
            },
            {
                label: 'Under 18 #',
                fillColor: '#7BC225',
                data: [<%= Convert.ToInt32(txtNumberUsers.Text) %>, <%= Convert.ToInt32(txtNumberFriends.Text) %>, <%= Convert.ToInt32(txtNumberFollowers.Text) %>]
            }
        ]
    }
    var relationships = document.getElementById('relationship').getContext('2d');
    new Chart(relationships).Bar(relationshipData);
</script>

<button id="test" Text="Refresh Graph"onclick="refresh_graph()"></button>

<script>
    refresh_graph = new function()
    {
        var relationshipData = {
        labels: ["Users", "Friends", "Followers"],
        datasets: [
            {
                label: 'Over 18 #',
                fillColor: '#382765',
                data: [<%= Convert.ToInt32(txtNumberUsers.Text) %>, <%= Convert.ToInt32(txtNumberFriends.Text) %>, <%= Convert.ToInt32(txtNumberFollowers.Text) %>]
            },
            {
                label: 'Under 18 #',
                fillColor: '#7BC225',
                data: [<%= Convert.ToInt32(txtNumberUsers.Text) %>, <%= Convert.ToInt32(txtNumberFriends.Text) %>, <%= Convert.ToInt32(txtNumberFollowers.Text) %>]
            }
        ]
    }
    var relationships = document.getElementById('relationship').getContext('2d');
    new Chart(relationships).Bar(relationshipData);
    }
</script>
