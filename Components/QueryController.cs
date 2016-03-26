using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.Script.Serialization;
//using DotNetNuke.Data;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Modules.SGDataModelling.Data;

namespace DotNetNuke.Modules.SGDataModelling.Components
{
    public class QueryController
    {
        public static QueryResult GetAgeAvg(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetAgeAvg(userId));
        }

        public static QueryResult GetNumberFriends(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberFriends(userId));
        }

        public static QueryResult GetNumberFollowers(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberFollowers(userId));
        }

        public static QueryResult GetNumberFriendsOver18(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberFriendsOver18(userId));
        }

        public static QueryResult GetNumberFollowersOver18(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberFollowersOver18(userId));
        }

        public static QueryResult GetUserCommunityPostsCount(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetUserCommunityPostsCount(userId));
        }

        public static QueryResult GetUserForumPostsCount(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetUserForumPostsCount(userId));
        }
        /*
        // TODO: Get Reply Counts for friends needs a little work on its stored procedures. Mainly to handle the issue of pending friends 
        // TODO: right now they will show as friends instead of non connected as they should be, this is just how pending friends handles by defaults (marked as friend with status pending)
        */
        public static QueryResult GetCountRepliesFromFriends(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetCountRepliesFromFriends(userId));
        }

        public static QueryResult GetCountRepliesFromFollowers(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetCountRepliesFromFollowers(userId));
        }

        public static QueryResult GetCountRepliesFromNonConnected(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetCountRepliesFromNonConnected(userId));
        }

        public static QueryResult GetNumberUsers()
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberUsers());
        }

        public static QueryResult GetNumberUsersOver18()
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberUsersOver18());
        }

        public static string GetDevGenreTrend(int userId)
        {

            var genreData = CBO.FillObject<GenreStats>(DataProvider.Instance().GetDevGenreTrend(userId));

            var jSer = new JavaScriptSerializer();
            return jSer.Serialize(genreData.GenreData);
        }

        public static string GetUserGenreTrend(int userId)
        {

            var genreData = CBO.FillObject<GenreStats>(DataProvider.Instance().GetUserGenreTrend(userId));

            var jSer = new JavaScriptSerializer();
            return jSer.Serialize(genreData.GenreData);
        }

        public static string GetAllUsersGenreTrend()
        {

            var genreData = CBO.FillObject<GenreStats>(DataProvider.Instance().GetAllUsersGenreTrend());

            var jSer = new JavaScriptSerializer();
            return jSer.Serialize(genreData.GenreData);
        }

        public static string GetDevMonthlyDownloads(int userId)
        {

            var annualData = CBO.FillCollection<AnnualStats>(DataProvider.Instance().GetDevMonthlyDownloads(userId));
            // Converting data to pass as JSON for us in javascript. Passes Name (Label Info for data) and array of counts for each month in previous year Jan - Dec
            var jsData = annualData.ToDictionary(element => element.Name, element => element.MonthData);
            var jSer = new JavaScriptSerializer();
            return jSer.Serialize(jsData);
        }

        public static string GetNetworkData()
        {
            
            var networkData = CBO.FillCollection<NetworkData>(DataProvider.Instance().GetRelationshipUsers());
            // Converted using link - Loops through network data and fills dictionary testData with key/value for each NetworkData element
            var testData = networkData.ToDictionary(element => element.Key, element => element.Value);

            var jSer = new JavaScriptSerializer();
            return jSer.Serialize(testData);
        }

        public static string GetRelationshipLinks()
        {

            var relationshipLinks = CBO.FillCollection<RelationshipLinks>(DataProvider.Instance().GetRelationshipLinks());
            // Converted using link - Loops through network data and fills dictionary testData with key/value for each NetworkData element
            // TODO: Handle relationship type i.e Friend / Follower
            var testData = relationshipLinks.ToDictionary(element => element.UserRelationshipId, element => element.UserId + "," + element.RelatedUserId + "," + element.Relationship + "," + element.Status);

            var jSer = new JavaScriptSerializer();
            return jSer.Serialize(testData);
        }
        /*

         {
                    {"1", "Keivn"},
                    {"2", "Shane"},
                    {"3", "Cian"},
                    {"4", "JJ"},
                    {"5", "Cian Eile" }
                };
        public static int GetDateOfBirth(int userId)
        {
            return Convert.ToInt32(DataProvider.Instance().GetDateOfBirth(userId));
        }
        */
    }
}