using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TabNewsCSharpSDK;
using TabNewsCSharpSDK.Entities;

namespace TabNewsAPIExamples
{
    class Program
    {
        static void Main(string[] args)
        {
            TabNewsUserSession userSession = TabNewsApi.LoginUser("canalprogramadorraiz@gmail.com", "");

            Console.WriteLine("userSession.token: " + Environment.NewLine + userSession.token);
            Console.ReadKey();
            Console.Clear();

            TabNewsUser user = TabNewsApi.GetUser(userSession.token);

            Console.WriteLine("user.description: " + Environment.NewLine + user.description);
            Console.ReadKey();
            Console.Clear();

            TabNewsContent content = TabNewsApi.GetContent("programadorraiz", "apis-oficiais-da-supercell");

            Console.WriteLine("Conteudo do post: " + Environment.NewLine + content.body);
            Console.ReadKey();
            Console.Clear();

            TabNewsContentResponse contentResponse = TabNewsApi.GetContents("programadorraiz", 10, 1);
            foreach (var c in contentResponse.Contents)
            {
                Console.WriteLine("title: " + c.title + Environment.NewLine + Environment.NewLine);
                Console.WriteLine(c.body);
                Console.ReadKey();
                Console.Clear();
            }

            List<TabNewsContent> contents = TabNewsApi.Get10LastedPosts("programadorraiz", 10, 1);
            foreach (var c in contents)
            {
                Console.WriteLine("title: " + c.title + Environment.NewLine + Environment.NewLine);
                Console.WriteLine(c.body);
                Console.ReadKey();
                Console.Clear();
            }


            Console.WriteLine("saindo...");
            Console.ReadKey();
            Console.Clear();
        }
    }
}
