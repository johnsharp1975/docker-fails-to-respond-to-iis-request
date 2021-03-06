using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebApplication1.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public string CustomResult1() => "TestCustomResult";
        public string FileContent() {
            using (var file = System.IO.File.OpenText(Server.MapPath("\\large.htm")))
            {
                return file.ReadToEnd();
            }
        }
    }
}