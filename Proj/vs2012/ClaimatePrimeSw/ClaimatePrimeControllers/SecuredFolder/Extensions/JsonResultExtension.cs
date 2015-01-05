using System;
using System.Runtime.Serialization.Json;
using System.Web.Mvc;

namespace ClaimatePrimeControllers.SecuredFolder.Extensions
{
    /// <summary>
    /// http://stackoverflow.com/questions/6020889/asp-net-mvc-3-controller-json-method-serialization-doesnt-look-at-datamember-n
    /// </summary>
    [Serializable]
    public class JsonResultExtension : JsonResult
    {
        public override void ExecuteResult(ControllerContext context)
        {
            var response = context.HttpContext.Response;
            if (!string.IsNullOrWhiteSpace(ContentType))
            {
                response.ContentType = ContentType;
            }
            else
            {
                response.ContentType = "application/json";
            }
            if (ContentEncoding != null)
            {
                response.ContentEncoding = this.ContentEncoding;
            }
            if (Data != null)
            {
                var serializer = new DataContractJsonSerializer(Data.GetType());
                serializer.WriteObject(response.OutputStream, Data);
            }
        }
    }

}
