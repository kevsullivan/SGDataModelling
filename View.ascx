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
<asp:TextBox ID="txtNumberFriendsUnder18" runat="server"></asp:TextBox>
<asp:TextBox ID="txtNumberFollowersUnder18" runat="server"></asp:TextBox>
<asp:TextBox ID="txtNumberUsersUnder18" runat="server"></asp:TextBox>
<asp:TextBox ID="txtNumberFriendsOver18" runat="server"></asp:TextBox>
<asp:TextBox ID="txtNumberFollowersOver18" runat="server"></asp:TextBox>
<asp:TextBox ID="txtNumberUsersOver18" runat="server"></asp:TextBox>
<asp:TextBox ID="txtUserId" runat="server"></asp:TextBox>

<!-- Construct overall container of graphs here - Design Area -->
<div class="accordion">
    <div class="accordion-section">
        <a id="networkContainer" class="accordion-section-title" href="#accordion-1">User Data</a>
        <div id="accordion-1" class="accordion-section-content">
            <input id="networkButton" type="button" value="Center User Network"/>
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
    <div class="accordion-section">
        <a class="accordion-section-title" href="#accordion-3">Developer Data</a>
        <div id="accordion-3" class="accordion-section-content">
            
            <div style="height: 400px; width: 50%">
                <canvas id="annualData"width="500" height="350"></canvas>
            </div>
             <div style="height: 400px; width: 50%">
                <canvas id="prefData" width="500" height="350"></canvas>
            </div>
            
            <div>
                <canvas id="filler2" width="50" height="50"></canvas>
            </div>
        </div><!--end .accordion-section-content-->
    </div><!--end .accordion-section-->
</div><!--end .accordion-->

<!-- Script to get stats on developers catalog downloads of the last year -->
<script>
    var annualDataDict = $.parseJSON('<%= QueryController.GetDevMonthlyDownloads(Convert.ToInt32(txtUserId.Text))%>');
    
    if ((Object.keys(annualDataDict).length === 0 && JSON.stringify(annualDataDict) === JSON.stringify({}))) 
    {
        //No games have been developed by this user let the know
        var canvas = document.getElementById('annualData');
        var context = canvas.getContext('2d');
        context.font = "30px Arial";
        context.fillStyle = "blue";
        context.textAlign = "center";
        context.fillText("Publish Games to see data!", canvas.width/2, canvas.height/2);

    } 
    else
    {
        //Using this to generate variant in graph plot colors.
        // Gives current month as an index i.e Jan=0, Feb=1 etc. Actually need it in numeric format for splice later.
        var curMonth = new Date().getMonth() + 1;
        //var userId = <%= Convert.ToInt32(txtUserId.Text)%>;
        //var index = 0;
        var dataValues = [];
    
        for (var key in annualDataDict) {
            var hue = (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256));
            var theData = annualDataDict[key];
            var altData = theData.splice(curMonth);
            var devNumbers = altData.concat(theData);
            dataValues.push(
            {
                label: key,
                fillColor: "rgba(" + hue + ",0.2)",
                strokeColor: "rgba(" + hue + ",1)",
                pointColor: "rgba(" + hue + ",1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(" + hue + ",1)",
                data: devNumbers
            
            });
        } 

    
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var altLabels = months.splice(curMonth);
        var sortedMonths = altLabels.concat(months);
        var gameData = {
            //TODO: Get Current Month to front of list of labels and line up data accordingly
            labels: sortedMonths,
            datasets: dataValues
        };
        var annualData = document.getElementById('annualData').getContext('2d');
        var options = {};
        new Chart(annualData).Line(gameData, options);
    }
    

    //Take a list splice it on index push the spliced list onto the newly created one from said splicing and return result.
    function balanceTimeline(arr, idx) {
        var cut = arr.splice(idx);
        cut.push(arr);
        return cut;
    }
</script>

<!-- Script to get stats genres the developer favors vs what users favor TODO: Handle what happens if no content has been genrated for dev + user = empty graph-->
<script>
    var genreDevDataDict = $.parseJSON('<%= QueryController.GetDevGenreTrend(Convert.ToInt32(txtUserId.Text))%>');
    var genreUsersDataDict = $.parseJSON('<%= QueryController.GetAllUsersGenreTrend()%>');
    if (
            (Object.keys(genreDevDataDict).length === 0 && JSON.stringify(genreDevDataDict) === JSON.stringify({})) &&
            (Object.keys(genreUsersDataDict).length === 0 && JSON.stringify(genreUsersDataDict) === JSON.stringify({}))
       ) 
    {
        //No Dev or User Data Found so show feedback.
        var canvas = document.getElementById('prefData');
        var context = canvas.getContext('2d');
        context.font = "30px Arial";
        context.fillStyle = "blue";
        context.textAlign = "center";
        context.fillText("No Gerne Stats Data Found", canvas.width/2, canvas.height/2);
    } 
    else 
    {
        var genres = [], devData = [], userData = [];
        for (var key in genreDevDataDict) {
            genres.push(key);
            devData.push(genreDevDataDict[key]);
            userData.push(genreUsersDataDict[key]);
        }
        var data = {
            labels: genres,
            datasets: [
                {
                    label: "Your Top Dev Genre",
                    fillColor: "rgba(22,25,18,0.2)",
                    strokeColor: "rgba(22,25,18,1)",
                    pointColor: "rgba(22,25,18,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(22,25,18,1)",
                    data: devData
                },
                {
                    label: "Users Favourite Genres",
                    fillColor: "rgba(151,187,205,0.2)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: userData
                }
            ]
        };
        var options = {}
        var preferences = document.getElementById('prefData').getContext('2d');
        new Chart(preferences).Radar(data, options);
    }
    
</script>

<!-- Script to get high level data of total users, friends and followers on website -->
<script>
    var relationshipData = {
        labels: ["Users", "Friends", "Followers"],
        // Data set for users both over and under 18 years of age.
        datasets: [
            {
                label: 'Total #',
                fillColor: '#b30000',
                // Data is pulled from code behind.
                data: [<%= Convert.ToInt32(txtNumberUsers.Text)%>, <%= Convert.ToInt32(txtNumberFriends.Text) %>, <%= Convert.ToInt32(txtNumberFollowers.Text) %>]
            },
            {
                label: 'Over 18 #',
                fillColor: '#382765',
                // Data is pulled from code behind.
                data: [<%= Convert.ToInt32(txtNumberUsersOver18.Text)%>, <%= Convert.ToInt32(txtNumberFriendsOver18.Text) %>, <%= Convert.ToInt32(txtNumberFollowersOver18.Text) %>]
            },
            {
                label: 'Under 18 #',
                fillColor: '#7BC225',
                // Data is pulled from code behind.
                data: [<%= Convert.ToInt32(txtNumberUsersUnder18.Text)%>, <%= Convert.ToInt32(txtNumberFriendsUnder18.Text) %>, <%= Convert.ToInt32(txtNumberFollowersUnder18.Text) %>]
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
    var friendValue = <%= QueryController.GetCountRepliesFromFriends(Convert.ToInt32(txtUserId.Text)).QueryValue%>;
    var folValue = <%= QueryController.GetCountRepliesFromFollowers(Convert.ToInt32(txtUserId.Text)).QueryValue%>;
    var nonConValue = <%= QueryController.GetCountRepliesFromNonConnected(Convert.ToInt32(txtUserId.Text)).QueryValue%>;
    if (friendValue == 0 && folValue == 0 && nonConValue == 0) 
    {
        //No games have been developed by this user let the know
        var canvas = document.getElementById('replyData');
        var context = canvas.getContext('2d');
        context.font = "30px Arial";
        context.fillStyle = "blue";
        context.textAlign = "center";
        context.fillText("You have no replies to content", canvas.width/2, canvas.height/2);
    } 
    else 
    {
        var replyInfo = [
            {
                value: friendValue,
                color: '#109DE2',
                highlight: '#1FADE2',
                label: 'Replies From Friends'
            
            },
            {
                value: folValue,
                label: 'Replies From Followers',
                color: '#CBCBCB',
                highlight: '#CDCCDC'
            },
            {
                value: nonConValue,
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
    }
    
</script>

<!-- Script to show breakdown of posts by each area on the platform 
    TODO: YOU FORGOT TO ACTUALLY FEED THIS ONE DATA ALSO THE SQL FOR FORUM POSTS ISNT DONE YET IT JUST CHECKS JOURNAL POSTS
-->
<script>
    var comPosts = <%= QueryController.GetUserCommunityPostsCount(Convert.ToInt32(txtUserId.Text)).QueryValue%>;
    var chatPosts = 0;
    var forumPosts = <%= QueryController.GetUserForumPostsCount(Convert.ToInt32(txtUserId.Text)).QueryValue%>;
    if (comPosts == 0 && chatPosts == 0 && forumPosts == 0) 
    {
        //No games have been developed by this user let the know
        var canvas = document.getElementById('postsData');
        var context = canvas.getContext('2d');
        context.font = "30px Arial";
        context.fillStyle = "blue";
        context.textAlign = "center";
        context.fillText("You havn't posted anything!", canvas.width/2, canvas.height/2);
    } 
    else 
    {
        var postInfo = [
            {
                value: comPosts,
                color: '#F7464A',
                highlight: "#FF5A5E",
                label: 'Community Posts'
            
            },
            {
                value: chatPosts,
                label: 'Chat Posts - TODO',
                color: '#46BFBD',
                highlight: "#5AD3D1"
            },
            {
                value: forumPosts,
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
    }
    
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
                { id: key, label: "You", color: '#3399ff' }
            ]);
        }
        else
        {
            nodes.add([
                { id: key, label: nodeDict[key], color: '#ffcc00', font: '14px arial black'}
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