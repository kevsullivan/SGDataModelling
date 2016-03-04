using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Content;

namespace DotNetNuke.Modules.SGDataModelling.Components
{
    public class RelationshipLinks:ContentItem
    {
        public string UserRelationshipId { get; set; }
        public string UserId { get; set; }
        public string RelatedUserId { get; set; }
        public string Relationship { get; set; }

        public override void Fill(IDataReader dr)
        {
            UserRelationshipId = Null.SetNullString(dr["UserRelationshipId"]);
            UserId = Null.SetNullString(dr["UserId"]);
            RelatedUserId = Null.SetNullString(dr["RelatedUserId"]);
            Relationship = Null.SetNullInteger(dr["RelationShipId"]) == 1 ? "Friend" : "Follower";
        }
    }
}