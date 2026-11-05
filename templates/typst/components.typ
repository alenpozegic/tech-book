#import "component-styles.typ": component-style

// Pretvorba imena avtorja iz Typstove vsebine v besedilo metapodatkov.
#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let page-header(title, version, gitrev) = context {
  if page.numbering != none {
    let position = if calc.odd(here().page()) { right } else { left }
    align(position, [#title, Release #version (#gitrev)])
    line(length: 100%, stroke: 0.5pt)
  }
}

// Sode fizične strani: številka levo. Lihe: desno. Naslovnica brez številke.
#let page-footer() = context {
  if page.numbering != none {

    set text(
      size: component-style.footer.size,
      weight: component-style.footer.weight,
      fill: component-style.footer.color,
    )

    let position = if calc.odd(here().page()) { right } else { left }

    line(length: 100%, stroke: 0.5pt)
    align(position, counter(page).display(page.numbering))
  }
}

// Naslovnica
#let cover-page(title, version, gitrev, publisher, date) = {
  page(numbering: none)[
    #line(length: 100%, stroke: component-style.cover.rule-stroke)

    #v(12pt)

    #align(right)[
      #image(
        component-style.cover.image,
        width: component-style.cover.image-width,
      )
    ]

    #v(1fr)

    #align(center)[
      #text(
        size: component-style.cover.title-size,
        weight: component-style.cover.title-weight,
      )[#title]\
      #text(
      )[Release #version (#gitrev)]
    ]

    #v(2.5fr)

    #align(center)[
      #text(
        size:component-style.cover.details-size,
        )[#publisher]

    ]

    #align(center)[
      #text(
        size: component-style.cover.details-size,
        )[#date]
    ]

    #line(length: 100%, stroke: component-style.cover.rule-stroke)
    #line(length: 100%, stroke: component-style.cover.thin-rule-stroke)
  ]
}

// Skupni prikaz vnosa kazala.
#let toc-entry(entry) = {
  show link: set text(
    fill: component-style.toc.entries-color
  )

  set text(fill: component-style.toc.entries-color)

  let inner = [
    #entry.body()
    #h(0.5em)
    #box(width: 1fr, entry.fill)
    #h(0.5em)
    #text(fill: component-style.toc.pages-color)[#entry.page()]
  ]

  link(
    entry.element.location(),
    entry.indented(entry.prefix(), inner),
  )
}

// Kazalo vsebine
#let main-toc() = {
  show heading: set block(
    above: 0pt,
    below: component-style.toc.title-spacing,
  )

  show heading: set text(
    fill: component-style.toc.title-color,
  )

  v(component-style.toc.top-spacing, weak: false)

  show outline.entry.where(level: 1): set text(
    weight: component-style.toc.chapter-weight,
  )

  show outline.entry.where(level: 1): set block(
    above: component-style.toc.chapter-spacing,
  )

show outline.entry: set text(
  size: component-style.toc.entries-size,
)

show outline.entry: toc-entry

  outline(
    title: component-style.toc.title,
    target: heading.where(level: 1).or(heading.where(level:2)
    ),
    depth: component-style.toc.depth,
    indent: component-style.toc.indent,
  )
  pagebreak()
}


//Kazalo slik -- uporabi skupne sloge kazal
#let figures-toc() = {
  show heading: set block(
    above: 0pt,
    below: component-style.toc.title-spacing,
  )

  show heading: set text(
    fill: component-style.toc.title-color,
  )

  show outline.entry: set text(
    size: component-style.toc.entries-size,
  )

  show outline.entry: toc-entry

  v(component-style.toc.top-spacing, weak: false)

  outline(
    title: component-style.figures-toc.title,
    target: figure.where(kind: image),
    indent: component-style.toc.indent,
  )
  pagebreak()
}

//Kazalo tabel -- uporabi skupne sloge kazal
#let tables-toc() = {
  show heading: set block(
    above: 0pt,
    below: component-style.toc.title-spacing,
  )

  show heading: set text(
    fill: component-style.toc.title-color
  )

  show outline.entry: set text(
    size: component-style.toc.entries-size
  )

  show outline.entry: toc-entry

  v(component-style.toc.top-spacing,weak: false)

  outline(
    title: component-style.tables-toc.title,
    target: figure.where(kind: table),
    indent: component-style.toc.indent,
  )

  pagebreak()
}

// Mini kazalo pri L1 poglavju; vsebuje pripadajoče L2 do naslednjega L1.
#let chapter-toc(chapter) = {
  if chapter.level == 1 and chapter.outlined {
    context {
      let following = selector(
        heading.where(outlined: true)
      ).after(chapter.location(), inclusive: false)

      let boundaries = query(following).filter(h => h.level <= 1)
      let target = following

      if boundaries.len() > 0 {
        target = target.before(
          boundaries.first().location(),
          inclusive: false,
        )
      }

      // Poglavja brez naslovov L2 ne dobijo mini kazala ali dodatnega preloma.
      if query(target).any(h => h.level == 2) {
        block(
          above: component-style.mini-toc.top-spacing,
          below: component-style.mini-toc.bottom-spacing,
        )[
          #show outline.entry : set text(
            weight: component-style.mini-toc.weight
          )
          #show outline.entry: set text(
            size: component-style.mini-toc.entries-size,
          )
          #show outline.entry: toc-entry
          #outline(
            title: none,
            target: target,
            depth: component-style.mini-toc.depth,
            indent: component-style.mini-toc.indent,
          )
        ]

        pagebreak(weak: true)
      }
    }
  }
}

// Pravila veljajo samo za vsebino ki je za naslovnico in glavnim kazalom
#let chapter-content(doc) = {
  show heading: chapter => {
    if chapter.level <= 2 {
      pagebreak(weak: true)
    }
    chapter
    chapter-toc(chapter)
  }

  show bibliography: references => {
    pagebreak(weak: true)
    references
  }



  doc
}

// Vstopna funkcija, ki jo pokliče template1.typ.
#let custom-conf(
  title: none,
  subtitle: none,
  version: none,
  gitrev: none,
  authors: (),
  keywords: (),
  date: none,
  publisher: none,
  abstract: none,
  cols: 1,
  margin: component-style.page.margin,
  paper: "a4",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 11pt,
  sectionnumbering: none,
  pagenumbering: "1",
  doc,
) = {
  set document(
    title: title,
    author: authors.map(author => content-to-string(author.name)),
    keywords: keywords,
  )
  set page(
    paper: paper,
    binding: component-style.page.binding,
    margin: margin,
    numbering: pagenumbering,
    header: page-header(title, version, gitrev),
    footer: page-footer(),
    columns: cols,
  )
  set par(justify: component-style.paragraph.justify)
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
  )
set heading(numbering: (..numbers) => {
  let parts = numbers.pos()

  if parts.len() <= 2 {
    // L1: 1, 2 …; L2: 1.1, 1.2 …
    numbering(sectionnumbering, ..parts)
  } else {
    // Od L3 naprej uporabimo simbole
    let symbols = component-style.heading.symbols
    let index = calc.min(parts.len() - 3, symbols.len() -1)

    symbols.at(index)
  }
})

  set table(
  stroke: component-style.table.stroke,
  fill: (_, y) => if y == 0 {
    component-style.table.header-fill
  } else {
    component-style.table.body-fill
  }
)

  show link: set text(
    fill: component-style.links.color,
  )

  cover-page(title, version, gitrev, publisher, date)
  main-toc()
  figures-toc()
  tables-toc()
  chapter-content(doc)
}
