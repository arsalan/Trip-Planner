<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="indexTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Home Page
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%= Html.Encode(ViewData["Message"]) %></h2>
    <p>
        We know how hard it is to plan a road trip as a practicing Muslim. Where do you
        find areas to pray, halal food to eat, and how do you go about doing that!
    </p>
    <p> Well, we're here to help. Go ahead, plan your trip!</p>
</asp:Content>
