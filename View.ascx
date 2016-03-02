<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="DotNetNuke.Modules.SGDataModelling.View" %>
<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>
<script src="./Chart.min.js"></script>

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
<script>
    var relationshipData = {
        labels: ["Users", "Friends", "Followers"],
        datasets: [
            {
                label: 'Over 18 #',
                fillColor: '#382765',
                data: [2500, 1902, 1041]
            },
        {
            label: 'Under 18 #',
            fillColor: '#7BC225',
            data: [3104, 1689, 1318]
        }
        ]
    }
    var relationships = document.getElementById('relationship').getContext('2d');
    new Chart(relationships).Bar(relationshipData);
</script>
<!--
<asp:Chart ID="chtRelationships" runat="server">
    <series>
        <asp:Series Name="Relationships" YValueType="Int32" ChartType="Column" ChartArea="MainChartArea">
        </asp:Series>
    </series>
    <chartareas>
        <asp:ChartArea Name="MainChartArea">
        </asp:ChartArea>
    </chartareas>
</asp:Chart>
    -->
