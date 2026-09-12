#lang pollen
 
◊(define inner 2)
◊(define edge (* inner 2))
◊(define color "gray")
◊(define multiplier 1.3)
◊(define normal 1.0)
 
body {
    margin: ◊|edge|em;
    /* border: ◊|inner|em double ◊|color|; */
    padding: ◊|inner|em;
    font-size: ◊|normal|em;
    line-height: ◊|normal|;
}
 
h1 {
    font-size: ◊|multiplier|em;
}
 
#prev, #next {
    position: fixed;
    top: ◊|(/ edge 2)|em;
}
 
#prev {
    left: ◊|edge|em;
}
 
#next {
    right: ◊|edge|em;
}

figure {
  display: flex;
  flex-direction: column;
  align-items: center;   /* centre horizontalement le contenu (image + légende) */
  width: fit-content;    /* la figure ne prend que la largeur nécessaire */
  margin: 2rem auto;     /* centre la figure elle-même sur la page */
  text-align: center;
}

figure img {
  display: block;
  max-width: 100%;
  height: auto;
}

figcaption {
  margin-top: 0.5rem;
  font-size: 1.2rem;
  font-weight: bold;
  color: #555;
}