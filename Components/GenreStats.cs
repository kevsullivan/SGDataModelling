using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Content;

namespace DotNetNuke.Modules.SGDataModelling.Components
{
    public class GenreStats:ContentItem
    {
        private readonly string[] _genres = { "FPS", "Action", "Adventure", "Indie", "Massive Multiplayer", "Racing", "RPG", "Sim", "Sports", "Strategy" };
        public Dictionary<string, int> GenreData { get; set; }

        //TODO: Update with dictionary usage its late and brain is taking easy route
        public override void Fill(IDataReader dr)
        {
            GenreData = new Dictionary<string, int>();
            for (int i = 0; i < _genres.Length; i++)
            {
                GenreData.Add(_genres[i], Null.SetNullInteger(dr[_genres[i]]));
            }
        }
    }
}