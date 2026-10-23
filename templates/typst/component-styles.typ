// Setup videza - Osnove že definirane v metadata.yaml
#let component-style = (
  page: (
    margin: (
      inside: 3.5cm,
      outside: 3.5cm,
      top: 2.5cm,
      bottom: 2.5cm,
    ),
    // Stran vezave določa notranji in zunanji rob.
    binding: left,
    // footer-descent: 0.75cm, // Trenutno privzeti odmik Typsta.
  ),

  paragraph: (
    // Obojestranska poravnava odstavkov.
    justify: true,
  ),

    // Oblikovne lastnosti naslovnice
  cover: (
    image: "../../content/img1.png",
    image-width: 2cm,
    title-size: 24pt,
    title-weight: "bold",
    details-size: 10pt,
    rule-stroke: 2pt,
    thin-rule-stroke: (
      paint: rgb("#8b8b8b"),
      thickness: 0.5pt,
    ),
  ),

  heading: (
    symbols: ("✚", "◆", "☆", "↘"),
  ),

  // Nastavitve prikaza kazal
  toc: (
    title: [Content:],
    depth: 3,
    top-spacing: 1cm,
    title-spacing: 1cm,
    indent: 2em,
    chapter-weight: "bold",
    chapter-spacing: 1em,
    title-color: rgb("#000000"),
    entries-color: rgb("#084b63"),
    pages-color: rgb("#070707"),
  ),

  mini-toc: (
    depth: 3,
    top-spacing: 1em,
    bottom-spacing: 1em,
    indent: 0pt,
    weight: "regular",
  ),
)
