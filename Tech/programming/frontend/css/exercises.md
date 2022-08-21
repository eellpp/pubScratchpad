
Simple collapsible menu by only using css  
https://codeburst.io/how-to-make-a-collapsible-menu-using-only-css-a1cd805b1390    

```bash

.menu-content {
    font-family: 'Oswald', sans-serif; 
    padding: 0 0 0 50px;
}
.collapsible-menu {
    background-color: rgb(255, 255, 255);
    padding: 0px 30px;
    border-bottom: 3px solid #CDE700;
    box-shadow: 1px 2px 3px rgba(0,0,0,0.2);
}
.collapsible-menu ul {
    list-style-type: none;
    padding: 0;
}
.collapsible-menu a {
    display:block;
    padding: 10px;
    text-decoration: none;
}

.collapsible-menu label {
    font-family: 'Sedgwick Ave Display', cursive;
    font-size: 56px;
    display: block;
    cursor: pointer;
    background: url(menu.png) no-repeat left center;
    padding: 10px 0 10px 50px;
}
input#menu {
    display: none;
}

input:checked +label {
    background-image: url(close.png);
}

.menu-content {
    max-height: 0;
    overflow: hidden;
    font-family: 'Oswald', sans-serif; 
    padding: 0 0 0 50px;
}
/* Toggle Effect */
input:checked ~ label {
    background-image: url(close.png);
}
input:checked ~ .menu-content {
    max-height: 100%;
}

```

HTML  

```bash
<body>
        <div class="collapsible-menu">
            <input type="checkbox" id="menu">
            <label for="menu">Menu</label>
            <div class="menu-content">
                <ul>
                    <li><a href="#"></a>Home</li>
                    <li><a href="#"></a>Services</li>
                    <li><a href="#"></a>Projects</li>
                    <li><a href="#"></a>About</li>
                    <li><a href="#"></a>Blog</li>
                    <li><a href="#"></a>Contacts</li>
                </ul>
            </div>
        </div>
    </body>
```
