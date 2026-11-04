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

    //Oblikovanje tabele
  table: (
    stroke: 1pt + black,
    header-fill: gray.lighten(30%),
    body-fill: gray.lighten(90%),
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
    depth: 2,
    top-spacing: 1cm,
    title-spacing: 1cm,
    indent: 2em,
    chapter-weight: "bold",
    chapter-spacing: 1em,
    title-color: rgb("#000000"),
    entries-color: rgb("#084b63"),
    entries-size: 12pt,
    pages-color: rgb("#070707"),
  ),

  //Kazalo slik
  figures-toc: (
    title: [Kazalo slik],
  ),

  //Kazalo tabel
  tables-toc: (
    title: [Kazalo tabel],
  ),

  //Mini kazala
  mini-toc: (
    depth: 2,
    top-spacing: 1em,
    bottom-spacing: 1em,
    indent: 0pt,
    weight: "regular",
    entries-size: 12pt,
  ),

  //Barve linkov

  links: (
    color: rgb("#0513da"),
  ),

  footer: (
    size: 10pt,
    weight: "regular",
    color: rgb("#070707")
  ),
)
