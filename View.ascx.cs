/*
' Copyright (c) 2016  kevsullivan.com
'  All rights reserved.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
' TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
' THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
' CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.
' 
*/

using System;
using System.Collections.Generic;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Modules.SGDataModelling.Components;
using DotNetNuke.Services.Localization;

namespace DotNetNuke.Modules.SGDataModelling
{
    /// -----------------------------------------------------------------------------
    /// <summary>
    /// The View class displays the content
    /// 
    /// Typically your view control would be used to display content or functionality in your module.
    /// 
    /// View may be the only control you have in your project depending on the complexity of your module
    /// 
    /// Because the control inherits from SGDataModellingModuleBase you have access to any custom properties
    /// defined there, as well as properties from DNN such as PortalId, ModuleId, TabId, UserId and many more.
    /// 
    /// </summary>
    /// -----------------------------------------------------------------------------
    public partial class View : SGDataModellingModuleBase, IActionable
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //TODO Call all queries here and populate asp view html with date. This is also where JS libraries can be called for graphing.
                if (Page.IsPostBack) return;
                //TODO: if age hasn't been set in the profile yet then getting average age will fail - NOTE: Host doesn't have DOB enforced other users (Hosts) need be aware of this
                var avgAge = QueryController.GetAgeAvg(UserId).QueryValue;

                var numFollowers = QueryController.GetNumberFollowers(UserId).QueryValue;
                var numFriends = QueryController.GetNumberFriends(UserId).QueryValue;
                var numUsers = QueryController.GetNumberUsers().QueryValue;

                var numFollowersOver18 = QueryController.GetNumberFollowersOver18(UserId).QueryValue;
                var numFriendsOver18 = QueryController.GetNumberFriendsOver18(UserId).QueryValue;
                var numUsersOver18 = QueryController.GetNumberUsersOver18().QueryValue;


                var numFollowersUnder18 = numFollowers - numFollowersOver18;
                var numFriendsUnder18 = numFriends - numFriendsOver18;
                //TODO: Not counting the host in all users right now as it conflicts with other user data (friends/followers etc) 
                var numUsersUnder18 = numUsers - numUsersOver18;

                txtAgeAvg.Text = avgAge.ToString();

                txtNumberFollowers.Text = numFollowers.ToString();
                txtNumberFriends.Text = numFriends.ToString();
                txtNumberUsers.Text = numUsers.ToString();

                txtNumberFollowersUnder18.Text = numFollowersUnder18.ToString();
                txtNumberFriendsUnder18.Text = numFriendsUnder18.ToString();
                txtNumberUsersUnder18.Text = numUsersUnder18.ToString();

                txtNumberFollowersOver18.Text = numFollowersOver18.ToString();
                txtNumberFriendsOver18.Text = numFriendsOver18.ToString();
                txtNumberUsersOver18.Text = numUsersOver18.ToString();

                txtUserId.Text = UserId.ToString();


                /*
                var relationshipData = Relationships.Series["Relationships"];

                relationshipData.Points.AddXY("Total Users On Site", numUsers);
                relationshipData.Points.AddXY("Total Friends", numFriends);
                relationshipData.Points.AddXY("Total Follower", numFollowers);
                */
            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        public ModuleActionCollection ModuleActions
        {
            get
            {
                var actions = new ModuleActionCollection
                    {
                        {
                            GetNextActionID(), Localization.GetString("EditModule", LocalResourceFile), "", "", "",
                            EditUrl(), false, SecurityAccessLevel.Edit, true, false
                        }
                    };
                return actions;
            }
        }
    }
}