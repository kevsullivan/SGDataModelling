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

        public static QueryResult GetNumberUsers()
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberUsers());
        }

        public static string GetNetworkData()
        {
            
            var networkData = CBO.FillCollection<NetworkData>(DataProvider.Instance().GetRelationshipUsers());
            // Converted using link - Loops through network data and fills dictionary testData with key/value for each NetworkData element
            var testData = networkData.ToDictionary(element => element.Key, element => element.Value);

            JavaScriptSerializer jSer = new JavaScriptSerializer();
            return jSer.Serialize(testData);
        }

        public static string GetRelationshipLinks()
        {

            var relationshipLinks = CBO.FillCollection<RelationshipLinks>(DataProvider.Instance().GetRelationshipLinks());
            // Converted using link - Loops through network data and fills dictionary testData with key/value for each NetworkData element
            // TODO: Handle relationship type i.e Friend / Follower
            var testData = relationshipLinks.ToDictionary(element => element.UserRelationshipId, element => element.UserId + "," + element.RelatedUserId + "," + element.Relationship);

            JavaScriptSerializer jSer = new JavaScriptSerializer();
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