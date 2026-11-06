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


#let thin-rule() = {
  line(
    length: component-style.thin-rule.length,
    stroke: component-style.thin-rule.stroke,
  )
}

// Sode fizične strani: številka levo. Lihe: desno. Naslovnica brez številke. Tanka črta v nogi
#let page-header(title, version, gitrev) = context {
  if page.numbering != none {
    let position = if calc.odd(here().page()) { right } else { left }
    align(position, [#title, Release #version (#gitrev)])
  }

  thin-rule()
}

// Sode fizične strani: številka levo. Lihe: desno. Naslovnica brez številke.
#let page-footer() = context {
  thin-rule()
  if page.numbering != none {
    v(component-style.footer.rule-spacing)

    set text(
      size: component-style.footer.size,
      weight: component-style.footer.weight,
      fill: component-style.footer.color,
    )

    let position = if calc.odd(here().page()) { right } else { left }

    align(position, counter(page).display(page.numbering))
  }
}

// Naslovnica z verzijo in revizijo dokumenta.
#let cover-page(title, version, gitrev, publisher, date) = {
  if title != none {
    page(numbering: none, header: none, footer: none)[
      #line(length: 100%, stroke: component-style.cover.rule-stroke)

      #v(component-style.cover.image-top-spacing)

      #align(component-style.cover.image-align)[
        #image(
          component-style.cover.image,
          width: component-style.cover.image-width,
        )
      ]

      #v(component-style.cover.title-top-spacing)

      #align(component-style.cover.title-align)[
        #text(
          size: component-style.cover.title-size,
          weight: component-style.cover.title-weight,
          fill: component-style.cover.title-color,
        )[#title]\
        #text(
          size: component-style.cover.placeholder-size,
          weight: component-style.cover.placeholder-weight,
          fill: component-style.cover.placeholder-color,
        )[Release #version (#gitrev)]
      ]

      #v(component-style.cover.title-bottom-spacing)

      #align(component-style.cover.details-align)[
        #text(
          size: component-style.cover.details-size,
          weight: component-style.cover.details-weight,
          fill: component-style.cover.details-color,
        )[#publisher]
      ]

      #align(component-style.cover.details-align)[
        #text(
          size: component-style.cover.details-size,
          weight: component-style.cover.details-weight,
          fill: component-style.cover.details-color,
        )[#date]
      ]

      #line(length: 100%, stroke: component-style.cover.rule-stroke)
      #thin-rule()
    ]
  }
}

// Skupni prikaz vnosa kazala.
#let toc-entry(entry) = {
  show link: set text(
    fill: component-style.toc.entries-color
  )

  set text(fill: component-style.toc.entries-color)

  let inner = [
    #entry.body()
    #h(component-style.toc.filler-spacing)
    #box(width: 1fr, entry.fill)
    #h(component-style.toc.filler-spacing)
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
    size: component-style.toc.title-size,
    weight: component-style.toc.title-weight,
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
    size: component-style.toc.title-size,
    weight: component-style.toc.title-weight,
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
    size: component-style.toc.title-size,
    weight: component-style.toc.title-weight,
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

// Pravila veljajo samo za vsebino ki je za vsemi začetnimi kazali
#let chapter-content(doc) = {
  show heading.where(level: 1): set text(
    size: component-style.heading.level1.size,
    weight: component-style.heading.level1.weight,
    fill: component-style.heading.level1.color,
  )

  show heading.where(level: 1): set block(
    above: component-style.heading.level1.above,
    below: component-style.heading.level1.below,
  )

  show heading.where(level: 2): set text(
    size: component-style.heading.level2.size,
    weight: component-style.heading.level2.weight,
    fill: component-style.heading.level2.color,
  )

  show heading.where(level: 2): set block(
    above: component-style.heading.level2.above,
    below: component-style.heading.level2.below,
  )

  show heading: it => {
    if it.level >= 3 {
      set text(
        size: component-style.heading.deeper.size,
        weight: component-style.heading.deeper.weight,
        fill: component-style.heading.deeper.color,
      )
      set block(
        above: component-style.heading.deeper.above,
        below: component-style.heading.deeper.below,
      )
      it
    } else {
      it
    }
  }

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
    header-ascent: component-style.header.ascent,
    numbering: pagenumbering,
    header: page-header(title, version, gitrev),
    footer: page-footer(),
    footer-descent: component-style.footer.descent,
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
      // Od L3 naprej uporabimo simbole.
      let symbols = component-style.heading.symbols
      let index = calc.min(parts.len() - 3, symbols.len() - 1)

      symbols.at(index)
    }
  })

  set table(
    stroke: component-style.table.stroke,
    inset: component-style.table.inset,
    fill: (_, y) => if y == 0 {
      component-style.table.header-fill
    } else {
      component-style.table.body-fill
    },
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
