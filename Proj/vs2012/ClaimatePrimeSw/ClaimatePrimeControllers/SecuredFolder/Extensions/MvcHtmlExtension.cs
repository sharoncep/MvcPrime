using System;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeConstants;
using ClaimatePrimeModels.SecuredFolder.Extensions;
using System.Collections.Generic;

namespace ClaimatePrimeControllers.SecuredFolder.Extensions
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public static class MvcHtmlExtension
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="htmlHelper"></param>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <returns></returns>
        public static MvcForm ArivaForm(this HtmlHelper htmlHelper, string pController)
        {
            return ArivaForm(htmlHelper, pController, "Search");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="htmlHelper"></param>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <returns></returns>
        public static MvcForm ArivaForm(this HtmlHelper htmlHelper, string pController, string pAction)
        {
            return ArivaForm(htmlHelper, pController, pAction, 0, 0);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="htmlHelper"></param>
        /// <param name="pController"></param>
        /// <param name="pVal1"></param>
        /// <param name="pVal2"></param>
        /// <returns></returns>
        public static MvcForm ArivaForm(this HtmlHelper htmlHelper, string pController, UInt32 pVal1, UInt32 pVal2)
        {
            return ArivaForm(htmlHelper, pController, "Search", pVal1, pVal2);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="htmlHelper"></param>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <param name="pVal1"></param>
        /// <param name="pVal2"></param>
        /// <returns></returns>
        public static MvcForm ArivaForm(this HtmlHelper htmlHelper, string pController, string pAction, UInt32 pVal1, UInt32 pVal2)
        {
            return FormExtensions.BeginRouteForm(htmlHelper, "Default", StaticClass.RouteValues(pController, pAction, pVal1, pVal2), FormMethod.Post, StaticClass.HtmlAttributes(new List<KeyValueModel<string, string>> { { new KeyValueModel<string, string>("class", "form-class") }, { new KeyValueModel<string, string>("enctype", "multipart/form-data") }, { new KeyValueModel<string, string>("id", "frmArivaForm") } }));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="htmlHelper"></param>
        /// <param name="pAction"></param>
        /// <returns></returns>
        public static MvcForm ArivaFormPre(this HtmlHelper htmlHelper, string pAction)
        {
            return FormExtensions.BeginRouteForm(htmlHelper, "Default", StaticClass.RouteValues("PreLogIn", pAction, 0, 0), FormMethod.Post, StaticClass.HtmlAttributes("form-class-pre"));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="TModel"></typeparam>
        /// <typeparam name="TProperty"></typeparam>
        /// <param name="helper"></param>
        /// <param name="partialViewName"></param>
        /// <param name="expression"></param>
        /// <returns></returns>
        public static MvcHtmlString PartialFor<TModel, TProperty>(this HtmlHelper<TModel> helper, string partialViewName, System.Linq.Expressions.Expression<Func<TModel, TProperty>> expression)
        {
            // http://stackoverflow.com/questions/1488890/asp-net-mvc-partial-views-input-name-prefixes

            string name = ExpressionHelper.GetExpressionText(expression);
            object model = ModelMetadata.FromLambdaExpression(expression, helper.ViewData).Model;
            var viewData = new ViewDataDictionary(helper.ViewData)
            {
                TemplateInfo = new System.Web.Mvc.TemplateInfo
                {
                    HtmlFieldPrefix = name
                }
            };

            return helper.Partial(partialViewName, model, viewData);
        }

        # region Study

        ///// <summary>
        ///// http://www.prideparrot.com/blog/archive/2012/7/securing_all_forms_using_antiforgerytoken
        ///// 
        ///// http://stackoverflow.com/questions/6202053/asp-net-mvc-extending-textboxfor-without-re-writing-the-method
        ///// </summary>
        ///// <param name="htmlHelper"></param>
        ///// <param name="pController"></param>
        ///// <param name="pAction"></param>
        ///// <param name="pVal1"></param>
        ///// <param name="pVal2"></param>
        ///// <returns></returns>
        //public static MvcForm ArivaForm(this HtmlHelper htmlHelper, string pController, string pAction, UInt32 pVal1, UInt32 pVal2)
        //{
        //    // http://www.prideparrot.com/blog/archive/2012/7/securing_all_forms_using_antiforgerytoken

        //    TagBuilder tagBuilder = new TagBuilder("form");

        //    tagBuilder.MergeAttribute("action", UrlHelper.GenerateUrl(null, pAction, pAction, StaticClass.RouteValues(pController, pAction, pVal1, pVal2), htmlHelper.RouteCollection, htmlHelper.ViewContext.RequestContext, true));
        //    tagBuilder.MergeAttribute("method", "POST", true);
        //    tagBuilder.MergeAttribute("enctype", "multipart/form-data", true);

        //    htmlHelper.ViewContext.Writer.Write(tagBuilder.ToString(TagRenderMode.StartTag));
        //    htmlHelper.ViewContext.Writer.Write(htmlHelper.AntiForgeryToken().ToHtmlString());
        //    var theForm = new MvcForm(htmlHelper.ViewContext);

        //    return theForm;
        //}

        //    // http://stackoverflow.com/questions/6202053/asp-net-mvc-extending-textboxfor-without-re-writing-the-method

        //    /// <summary>
        //    /// 
        //    /// </summary>
        //    public class MvcInputBuilder
        //    {
        //        public int Id { get; set; }

        //        public string Class { get; set; }
        //    }

        //    /// <summary>
        //    /// 
        //    /// </summary>
        //    /// <typeparam name="TModel"></typeparam>
        //    /// <typeparam name="TProp"></typeparam>
        //    /// <param name="htmlHelper"></param>
        //    /// <param name="expression"></param>
        //    /// <param name="propertySetters"></param>
        //    /// <returns></returns>
        //    public static MvcHtmlString TextBoxFor<TModel, TProp>(
        //this HtmlHelper<TModel> htmlHelper,
        //Expression<Func<TModel, TProp>> expression,
        //params Action<MvcInputBuilder>[] propertySetters)
        //    {
        //        MvcInputBuilder builder = new MvcInputBuilder();

        //        foreach (var propertySetter in propertySetters)
        //        {
        //            propertySetters.Invoke(builder);
        //        }

        //        var properties = new RouteValueDictionary(builder)
        //            .Select(kvp => kvp)
        //            .Where(kvp => kvp.Value != null)
        //            .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

        //        return htmlHelper.TextBoxFor(expression, properties);
        //    }


        //    @this.Html.TextBoxFor(
        //model => model.Name,
        //p => p.Id = 7,
        //p => p.Class = "my-class")

        # endregion
    }
}
