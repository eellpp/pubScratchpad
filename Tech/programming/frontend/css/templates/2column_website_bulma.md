

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hello Bulma!</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <style>

.sidebar {
  grid-area: sidebar;
}

.content {
  grid-area: content;
  position: relative;
}

.header {
  grid-area: header;
}

.footer {
  grid-area: footer;
}

.wrapper {
    display: grid;
    grid-template-columns: 0.25fr 1fr 1fr;
    grid-template-rows: 0.125fr 1fr 0.125fr ;
    grid-template-areas:
    "header  header  header"
    "sidebar content content"
    "footer  footer  footer";
    width: 100vw;
    height: 100vh;
  }

    </style>
  </head>
  <body>
    <div class="wrapper">
        <div class="header">
            <nav class="navbar" role="navigation" aria-label="main navigation">
        <div class="navbar-brand">
          <a class="navbar-item title is-bold" href="https://bulma.io" style="margin-bottom: 10px">
            BULMA
          </a>
      
          <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-target="navbarBasicExample">
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
          </a>
        </div>
      
        <div id="navbarBasicExample" class="navbar-menu">
          <div class="navbar-start">
            <a class="navbar-item">
              Home
            </a>
      
            <a class="navbar-item">
              Documentation
            </a>
      
            <div class="navbar-item has-dropdown is-hoverable">
              <a class="navbar-link">
                More
              </a>
      
              <div class="navbar-dropdown">
                <a class="navbar-item">
                  About
                </a>
                <a class="navbar-item">
                  Jobs
                </a>
                <a class="navbar-item">
                  Contact
                </a>
                <hr class="navbar-divider">
                <a class="navbar-item">
                  Report an issue
                </a>
              </div>
            </div>
          </div>
      
          <div class="navbar-end">
            <div class="navbar-item">
              <div class="buttons">
                <a class="button is-primary">
                  <strong>Sign up</strong>
                </a>
                <a class="button is-light">
                  Log in
                </a>
              </div>
            </div>
          </div>
        </div>
      </nav>

        </div>
        <div class="sidebar">Sidebar</div>
        <div class="content">
            <section class="section">
                <div class="container">
                  <h1 class="title">
                    Hello World1
                  </h1>
                  <p class="subtitle">
                    My first website with <strong>Bulma</strong>!
                  </p>
                </div>
              </section>
        </div>
        <div class="footer">Footer</div>
      </div>
    
    
  
  </body>
</html>
```
