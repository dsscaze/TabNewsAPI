using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using TabNewsCSharpSDK.Entities;

namespace TabNewsCSharpSDK
{
    public static class TabNewsApi
    {
        public const string BaseUrlApi = "https://www.tabnews.com.br/api/v1/";

        public static TabNewsUserSession LoginUser(string email, string password)
        {
            TabNewsUserSession userSession = new TabNewsUserSession();
            var options = new RestClientOptions(BaseUrlApi)
            {
                MaxTimeout = -1,
                FollowRedirects = false
            };

            var client = new RestClient(options);
            var request = new RestRequest("sessions", Method.Post);

            request.AddParameter("email", email);
            request.AddParameter("password", password);

            RestResponse response = client.Execute(request);
            userSession = JsonConvert.DeserializeObject<TabNewsUserSession>(response.Content);
            if (string.IsNullOrEmpty(userSession.token))
            {
                throw new TabNewsException(response.Content);
            }

            return userSession;
        }

        public static TabNewsUser GetUser(string sessionid)
        {
            TabNewsUser tabNewUser = new TabNewsUser();
            var options = new RestClientOptions(BaseUrlApi)
            {
                MaxTimeout = -1,
                FollowRedirects = false
            };

            var client = new RestClient(options);
            var request = new RestRequest("user", Method.Get);
            request.AddHeader("Cookie", "session_id=" + sessionid);

            RestResponse response = client.Execute(request);

            tabNewUser = JsonConvert.DeserializeObject<TabNewsUser>(response.Content);

            if (string.IsNullOrEmpty(tabNewUser.id))
            {
                throw new TabNewsException(response.Content);
            }

            return tabNewUser;
        }

        public static TabNewsContent GetContent(string owner_username, string slug)
        {
            TabNewsContent tabNewContent = new TabNewsContent();
            var options = new RestClientOptions(BaseUrlApi)
            {
                MaxTimeout = -1,
            };

            var client = new RestClient(options);
            var request = new RestRequest("contents/" + owner_username + "/" + slug, Method.Get);
            RestResponse response = client.Execute(request);

            tabNewContent = JsonConvert.DeserializeObject<TabNewsContent>(response.Content);
            if (string.IsNullOrEmpty(tabNewContent.id))
            {
                throw new TabNewsException(response.Content);
            }

            return tabNewContent;
        }

        public static TabNewsContentResponse GetContents(string owner_username, int per_page, int page, string strategy = "new")
        {
            TabNewsContentResponse tabNewsResponse = new TabNewsContentResponse();
            tabNewsResponse.Page = page;
            tabNewsResponse.PageSize = per_page;

            List<TabNewsContent> tabNewsContents = new List<TabNewsContent>();

            var options = new RestClientOptions(BaseUrlApi)
            {
                MaxTimeout = -1,
            };

            var client = new RestClient(options);
            var request = new RestRequest("contents/" + owner_username + "?page=" + page + "&per_page=" + per_page + "&strategy=" + strategy, Method.Get);
            RestResponse response = client.Execute(request);

            if (response.IsSuccessful)
            {
                object x_pagination_total_rows = response.Headers
                        .Where(x => x.get_Name() == "x-pagination-total-rows")
                        .FirstOrDefault()
                        .get_Value();

                tabNewsResponse.TotalPosts = Convert.ToInt32(x_pagination_total_rows);

                tabNewsContents = JsonConvert.DeserializeObject<List<TabNewsContent>>(response.Content);
                tabNewsResponse.Contents = tabNewsContents;
            }
            else
            {
                throw new TabNewsException(response.Content);
            }

            return tabNewsResponse;
        }
    }
}