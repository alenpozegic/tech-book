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
    inset: 6pt,
  ),

  //Videz tankih črt
  thin-rule: (
    length: 100%,
    stroke: (
      paint: rgb("#8b8b8b"),
      thickness: 0.5pt,
    ),
  ),

    // Oblikovne lastnosti naslovnice
  cover: (
    // Razmik naslovnice
    image-top-spacing: 12pt,
    title-top-spacing: 1fr,
    title-bottom-spacing: 2.5fr,
    //Poravnava naslovnice
    image-align: right,
    title-align: center,
    details-align: center,
    image: "../../content/img1.png",
    image-width: 2cm,
    title-size: 24pt,
    title-weight: "bold",
    title-color: black,
    details-size: 10pt,
    details-weight: "regular",
    details-color: black,
    //Besedilo pod naslovom
    placeholder-size: 12pt,
    placeholder-weight: "regular",
    placeholder-color: black,
    rule-stroke: 2pt,
  ),

  // Oblikovanje naslovov vseh nivojev
  heading: (
    level1: (
      size: 24pt,
      weight: "bold",
      color: black,
      above: 0pt,
      below: 1em,
    ),
    level2: (
      size: 18pt,
      weight: "bold",
      color: black,
      above: 0pt,
      below: 1em,
    ),
    deeper: (
      size: 14pt,
      weight: "bold",
      color: black,
      above: 1.5em,
      below: 0.5em,
    ),
    symbols: ("✚", "◆", "☆", "↘"),
  ),

  // Nastavitve prikaza kazal
  toc: (
    title: [Content:],
    depth: 2,
    top-spacing: 1cm,
    title-spacing: 1cm,
    indent: 2em,
    title-size: 18pt,
    title-weight: "bold",
    title-color: rgb("#000000"),
    chapter-weight: "bold",
    chapter-spacing: 1em,
    entries-color: rgb("#084b63"),
    entries-size: 12pt,
    pages-color: rgb("#070707"),
    filler-spacing: 0.5em,
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

  header: (
    ascent: 0.75cm,
  ),

  footer: (
    size: 10pt,
    weight: "regular",
    color: rgb("#070707"),
    descent: 0.75cm,
    rule-spacing: 6pt,
  ),
)
