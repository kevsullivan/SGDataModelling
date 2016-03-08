<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="DotNetNuke.Modules.SGDataModelling.View" %>
<%@ Import Namespace="DotNetNuke.Modules.SGDataModelling.Components" %>
<script src="http://kevinosullivan.info/portfolio/wp-content/uploads/2016/03/Chart.js"></script>
<script src="http://kevinosullivan.info/portfolio/wp-content/uploads/2016/03/d3.js"></script>
<script src="http://kevinosullivan.info/portfolio/wp-content/uploads/2016/03/vis.js"></script>
<script src="http://demos.inspirationalpixels.com/Accordion-with-HTML-CSS-&-jQuery/accordion.js"></script>
<!-- This import of jquery is causing a conflict with DNN standard version when module is loaded to a page - its not site breaking just means admin controls require entering new page first
    the main problem is without this the accordian doesn't work as is. So need to implement different handling for the accordian. -->
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<!--
<asp:TextBox ID="txtAgeAvg" runat="server"></asp:TextBox>
<asp:TextBox ID="txtNumberFriends" runat="server"></asp:TextBox>
<asp:TextBox ID="txtNumberFollowers" runat="server"></asp:TextBox>
<asp:TextBox ID="txtNumberUsers" runat="server"></asp:TextBox>
<asp:TextBox ID="txtUserId" runat="server"></asp:TextBox>

<!-- Construct overall container of graphs here - Design Area -->
<div class="accordion">
    <div class="accordion-section">
        <a id="networkContainer" class="accordion-section-title" href="#accordion-1">User Data</a>
        <div id="accordion-1" class="accordion-section-content">
            <input id="networkButton" type="button" value="Center Node Network"/>
            <label style="color: green">Friend Links</label>
            <label style="color: red">Follower Links</label>
            <div style="height: 400px; width: 50%" id="networks">
                <canvas id="networksCanvas" width="500" height="350"></canvas>
            </div>
            <div style="height: 400px; width: 50%">
                <canvas id="relationship" width="500" height="350"></canvas>
            </div>
            
            <div>
                <canvas id="filler" width="50" height="50"></canvas>
            </div>
        </div><!--end .accordion-section-content-->
    </div><!--end .accordion-section-->
    <div class="accordion-section">
        <a class="accordion-section-title" href="#accordion-2">Content Data</a>
        <div id="accordion-2" class="accordion-section-content">
            
            <div style="height: 400px; width: 50%">
                <canvas id="replyData"width="500" height="350"></canvas>
            </div>
            <div id="js-legend1" ></div>
             <div style="height: 400px; width: 50%">
                <canvas id="postsData" width="500" height="350"></canvas>
            </div>
            <div id="js-legend2"></div>

        </div><!--end .accordion-section-content-->
    </div><!--end .accordion-section-->
</div><!--end .accordion-->


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

<!-- Script to show reply data for your posts/activity on the platform broken into friends, followers and non connection -->
<script>
    //TODO: Right Now the counts on replies could possibly return duplicated values if a users is both friend and follower - this is something minor to address both work and precedence wise.
    //TODO: Another issue is if I'm following someone but they aren't following back its being tracked as same thing on graph. Perhaps two sections on graph one for each version of following (to/from) is better
    var replyInfo = [
        {
            value: <%= QueryController.GetCountRepliesFromFriends(Convert.ToInt32(txtUserId.Text)).QueryValue%>,
            color: '#109DE2',
            highlight: '#1FADE2',
            label: 'Replies From Friends'
            
        },
        {
            value: <%= QueryController.GetCountRepliesFromFollowers(Convert.ToInt32(txtUserId.Text)).QueryValue%>,
            label: 'Replies From Followers',
            color: '#CBCBCB',
            highlight: '#CDCCDC'
        },
        {
            value: <%= QueryController.GetCountRepliesFromNonConnected(Convert.ToInt32(txtUserId.Text)).QueryValue%>,
            label: 'Replies from non connections',
            color: '#F7464A',
            highlight: "#FF5A5E"
        }
    ];
    var options = {
        segmentShowStroke: false,
        animateRotate: true,
        animateScale: false,
        percentageInnerCutout: 50,
        tooltipTemplate : "Total: <" + "%= value%>"
    }
    var replies = document.getElementById('replyData').getContext('2d');
    var replyChart = new Chart(replies).Doughnut(replyInfo, options);
    document.getElementById('js-legend1').innerHTML = replyChart.generateLegend();
</script>

<!-- Script to show breakdown of posts by each area on the platform -->
<script>
    var postInfo = [
        {
            value: 42,
            color: '#F7464A',
            highlight: "#FF5A5E",
            label: 'Community Posts'
            
        },
        {
            value: 89,
            label: 'Personal Feed',
            color: '#46BFBD',
            highlight: "#5AD3D1"
        },
        {
            value: 50,
            label: 'Forum Posts',
            color: '#FDB45C',
            highlight: "#FFC870"
        }
    ];
    var options = {
        segmentShowStroke: false,
        animateRotate: true,
        animateScale: false,
        tooltipTemplate : "Total: <" + "%= value%>"
    }
    var posts = document.getElementById('postsData').getContext('2d');
    var postsChart = new Chart(posts).Pie(postInfo, options);
    document.getElementById('js-legend2').innerHTML = postsChart.generateLegend();
</script>

<!-- Network graph script. This is where node/edges graph for connected users across the site is handled. Also handles click event by redirecting to profile of selected user. 
     Also contains the javascript for handling acordion categories as there is a conflict with the node network graph and requires access in script to resolve.
    TODO: Have edges for followers have head and tails arrow if following goes both ways rather than current implementation that gives two seperate arrows    
-->
<script>
    var nodeDict = $.parseJSON('<%= QueryController.GetNetworkData()%>');
    var nodes = new vis.DataSet({});
    var curUserID = <%= txtUserId.Text %>;
    for (var key in nodeDict) {
        if (key == curUserID)
        {
            nodes.add([
                { id: key, label: "You", color: 'yellow' }
            ]);
        }
        else
        {
            nodes.add([
                { id: key, label: nodeDict[key], color: 'purple', font: '14px arial white'}
            ]);
        }

    };
    
    var edgesDict = $.parseJSON('<%= QueryController.GetRelationshipLinks()%>');
    var edges = new vis.DataSet({});

    for (var key in edgesDict) {
        var details = edgesDict[key].split(",");
        var tempdetails = details;
        // Edges colored Green for Friends and Red for followers. Followers also have an arrow pointing to show who is follower/folowee or both if that is the case.
        edges.add([
            { from: parseInt(details[0]), to: parseInt(details[1]), color: details[2] == "Friend" ? { color: 'green' } : { color: 'red' }, arrows: details[2] == "Follower" ? 'to' : '' }
        ]);
    }

    var container = document.getElementById('networks');
    var data = {
        nodes: nodes,
        edges: edges
    };
    var network = new vis.Network(container, data, {});
    document.getElementById("networkButton").onclick = function () { network.fit(); };
    //network.fit();
    var scaled = false;
    network.on("click", function (params) {
            // Redirect to activity feed/profile page of selected user on click.
            if (params["nodes"].length > 0) {
                window.location.href = location.protocol + "//" + location.host + "/Activity-Feed/userId/" + params["nodes"][0];
            }
        }
    )
    $(document).ready(function() {
        function close_accordion_section() {
            $('.accordion .accordion-section-title').removeClass('active');
            $('.accordion .accordion-section-content').slideUp(300).removeClass('open');
        }
 
        $('.accordion-section-title').click(function(e) {
            // Grab current anchor value
            var currentAttrValue = $(this).attr('href');
            if($(e.target).is('.active')) {
                close_accordion_section();
            }else {
                close_accordion_section();
 
                // Add active class to section title
                $(this).addClass('active');
                // Open up the hidden content panel
                $('.accordion ' + currentAttrValue).slideDown(300).addClass('open');
                network.fit();
            }
 
            e.preventDefault();
        });
    });
</script>