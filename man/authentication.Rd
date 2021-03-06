% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/f7Login.R
\name{f7Login}
\alias{f7Login}
\alias{f7LoginServer}
\alias{updateF7Login}
\title{Provide a template for authentication}
\usage{
f7Login(..., id, title, label = "Sign In", footer = NULL, startOpen = TRUE)

f7LoginServer(input, output, session, ignoreInit = FALSE)

updateF7Login(
  id,
  user = NULL,
  password = NULL,
  session = shiny::getDefaultReactiveDomain()
)
}
\arguments{
\item{...}{Slot for inputs like password, text, ...}

\item{id}{\link{f7Login} unique id.}

\item{title}{Login page title.}

\item{label}{Login confirm button label.}

\item{footer}{Optional footer.}

\item{startOpen}{Whether to open the login page at start. Default to TRUE. There
are some cases where it is interesting to set up to FALSE, for instance when you want
to have authentication only in a specific tab of your app (See example 2).}

\item{input}{Shiny input object.}

\item{output}{Shiny output object.}

\item{session}{Shiny session object.}

\item{ignoreInit}{If TRUE, then, when this observeEvent is first
created/initialized, ignore the handlerExpr (the second argument),
whether it is otherwise supposed to run or not. The default is FALSE.}

\item{user}{Value of the user input.}

\item{password}{Value of the password input.}
}
\description{
This function does not provide the backend features. You would
need to store credentials in a database for instance.
}
\note{
There is an input associated with the login status, namely input$login.
It is linked to an action button, which is 0 when the application starts. As soon
as the button is pressed, its value is incremented which might fire a
\link[shiny]{observeEvent} listening to it (See example below). Importantly,
the login page is closed only if the text and password inputs are filled. The
\link{f7LoginServer} contains a piece of server logic that does this work for you.
}
\examples{
if (interactive()) {
 # global authentication
 library(shiny)
 library(shinyMobile)
 shiny::shinyApp(
   ui = f7Page(
     title = "My app",
     f7SingleLayout(
       navbar = f7Navbar(
         title = "Login Example",
         hairline = FALSE,
         shadow = TRUE
       ),
       toolbar = f7Toolbar(
         position = "bottom",
         f7Link(label = "Link 1", src = "https://www.google.com"),
         f7Link(label = "Link 2", src = "https://www.google.com", external = TRUE)
       ),
       f7Login(id = "loginPage", title = "Welcome"),
       # main content
       f7BlockTitle(
         title = HTML(paste0("Welcome ", textOutput("userName"))),
         size = "large"
       ) \%>\% f7Align("center")
     )
   ),
   server = function(input, output, session) {

     f7LoginServer(input, output, session)

     output$userName <- renderText({
       req(input$login > 0)
       input$login_user
     })
   }
 )

 # section specific authentication
 library(shiny)
 library(shinyMobile)
 shiny::shinyApp(
   ui = f7Page(
     title = "My app",
     f7TabLayout(
       navbar = f7Navbar(
         title = "Login Example for Specific Section",
         hairline = FALSE,
         shadow = TRUE
       ),
       f7Tabs(
         id = "tabs",
         f7Tab(
           tabName = "Tab 1",
           "Without authentication"
         ),
         f7Tab(
           tabName = "Restricted",
           # main content
           f7BlockTitle(
             title = HTML(paste0("Welcome ", textOutput("userName"))),
             size = "large"
           ) \%>\% f7Align("center")
         )
       ),
       f7Login(id = "loginPage", title = "Welcome", startOpen = FALSE)
     )
   ),
   server = function(input, output, session) {

     # Authorization on the second tab
     # only run once to open the login page
     observeEvent(input$tabs, {
       if (input$tabs == "Restricted") {
         updateF7Login(id = "loginPage")
       }
     }, once = TRUE)

     # do not run first since the login page is not yet visible
     f7LoginServer(input, output, session, ignoreInit = TRUE)

     output$userName <- renderText({
       req(input$login > 0)
       input$login_user
     })
   }
 )
}
}
