---
title: Concrete syntax matters, actually
author: '[Slim Lim](https://slim.computer/)'
institute: | 
   | Notion
   | [PLAIT Lab](https://plait-lab.org/), UC Berkeley
date: December 2025
slideNumber: true
height: 850
width: 1150
transition: none
css: slim.css
navigationMode: "linear"
markdown: commonmark+attributes
abstract:
    Too many programming languages researchers dismiss concrete syntax as an afterthought—arbitrary, superficial, or distracting from matters of \"actual\" semantic importance. This received view ignores a critical factor: the human at the computer. Concrete syntax defines the principal interface through which programmers interact with the vast majority of programming languages. Moreover, this interface is hardly decoupled from semantics; even trivial-seeming differences in keywords, sigils, and indentation can affect how programmers utilize and reason about language behavior. Using examples from asynchronous control flow, gradual subtyping, first-class functions, and more, I will make a case for the importance of concrete syntax, why language designers often overlook it, and what this implies for those of us who care about the usability of abstractions. Finally, I will describe some preliminary work evaluating the role of lexical ambiguity in programmer comprehension of type system features.
---

# Wadler's Law?

## Wadler's Law (1996)

> In any language design, the total time spent discussing a feature in this list is proportional to two raised to the power of its position.
>
> 0. Semantics
> 1. Syntax
> 2. Lexical syntax
> 3. Lexical syntax of comments

<!-- <https://wiki.haskell.org/Wadler's_Law> -->

## Wadler's Law (1996)

> In any language design, the total time spent discussing a feature in this list is proportional to two raised to the power of its position.
>
> 0. Semantics
> 1. Syntax
> 2. **Lexical syntax**
> 3. Lexical syntax of comments

. . .

::: {.box style="position: absolute; left: 60%; top: 50%; width: 300px;"}
Also called: **concrete syntax**, surface syntax
:::

::: notes
audience for this talk is fairly interdisciplinary, so let's be a bit more precise about what we mean by each of these things
:::

## What's the difference?

::: notes
So the good news is that there's actually a very straightforward, foolproof way to tell the distinction, which is that semantics are presented in Greek, and syntax is presented in Latin. ez done thank you for coming to my talk
:::

. . .

- **Semantics**: Greek
    
    $$
    \frac{\delta, \delta'; \pi_{m + 2}(\Theta); \sigma \vdash {e}_i \Downarrow \theta_i \qquad \bar{{e}} = {e}_1, \ldots, {e}_n}{\delta, \delta '; \Theta; \sigma \vdash {e}(\bar{{e}}) \text{ FAIL}}
    $$

- **Syntax**: Latin

    ```hs
    data Expr = Let Name Expr Expr 
              | Fun Name Expr
              | App Exp Expr
    ```

. . .

Hope this helps!

## Ok but actually

Consider a simple program:

```hs {.huge}
let n = 3 in
  max n 0
```

::: notes
But really, to talk about the difference a bit more let's start with reference to an example program, which you can imagine is in some unspecified purely functional FP.
:::

## Semantics: example

<!-- ::: columns -->
<!-- ::: column -->
<!-- ```hs -->
<!-- let n = 3 in … -->
<!-- ``` -->
<!-- ::: -->
<!-- ::: column -->
$$
\boxed{\texttt{let $x$ = 2 + 2 in $N$}}
$$
<!-- ::: -->
<!-- ::: -->

- **Substitution**: replace occurrences of $x$ with $2 + 2$, or $4$?
  
  $$
  \texttt{let $x$ = $M$ in $N$} \;\longmapsto\; \underbrace{N[x := M]}_\text{substitution}
  $$

- **Environment**: partial function $\sigma$ maps name $x$ to $2 + 2$, or $4$?

  $$
  \langle \sigma, \, \texttt{let $x$ = $M$ in $N$} \rangle \;\longmapsto\; 
  \langle \underbrace{\sigma[x := M]}_\text{extend env}, \, N \rangle
  $$

## Semantics: finding meaning

- Many different genres:
    - **Denotational** (Scott, Strachey)
    - **Axiomatic** (Hoare triples, pre- and post-conditions)
    - **Operational** (reduction rules, evaluation contexts)
    - …

::: notes
- Denotational: domain theory, compositional, mathematical object, [[]]
- Axiomatic: Hoare logic, pre and post conditions, rule of consequence
- Operational: contextual, big/small step, etc.
:::

## Semantics

- They make the language what it is!
- But **not the point** of this talk

<!-- ## Concrete vs. abstract -->
<!--  -->
<!-- :::::: columns -->
<!-- ::: {.column width="40%"} -->
<!-- ```hs {data-id="code-1"} -->
<!-- let … = … in -->
<!--   … -->
<!-- ``` -->
<!-- ::: -->
<!-- ::: {.column width="60%"} -->
<!-- - Local **binding** -->
<!--   - … -->
<!--   - … -->
<!--   - … -->
<!-- ::: -->
<!-- :::::: -->
<!--  -->
<!-- ## Concrete vs. abstract -->
<!--  -->
<!-- :::::: columns -->
<!-- ::: {.column width="40%"} -->
<!-- ```hs {data-id="code-1"} -->
<!-- let n = … in -->
<!--   … -->
<!-- ``` -->
<!-- ::: -->
<!-- ::: {.column width="60%"} -->
<!-- - Local **binding** -->
<!--   - **Variable** `n`{.hs} -->
<!--   - … -->
<!--   - … -->
<!-- ::: -->
<!-- :::::: -->
<!--  -->
<!-- ## Concrete vs. abstract -->
<!--  -->
<!-- :::::: columns -->
<!-- ::: {.column width="40%"} -->
<!-- ```hs {data-id="code-1"} -->
<!-- let n = 3 in -->
<!--   … -->
<!-- ``` -->
<!-- ::: -->
<!-- ::: {.column width="60%"} -->
<!-- - Local **binding**  -->
<!--   - **Variable** `n`{.hs} -->
<!--   - Numeric **literal** `3`{.hs} -->
<!--   - … -->
<!-- ::: -->
<!-- :::::: -->

## Syntax: concrete vs. abstract

```hs {.huge}
let n = 3 in
  max n 0
```

## Syntax: concrete vs. abstract

:::::: columns
::: {.column width="40%"}
```hs {data-id="code-1"}
let n = 3 in
  max n 0
```
:::
::: {.column width="60%"}
- Local **binding**
  - **Variable** `n`{.hs}
  - Numeric **literal** `3`{.hs}
  - Function **application**
    - **Function** `max`{.hs}
    - **Variable** `n`{.hs}
    - Numeric **literal** `0`{.hs}
:::
::::::

## One AST, many concrete possibilities

:::::: columns
::: {.column width="60%"}
- Local **binding**
  - **Variable** `n`{.hs}
  - Numeric **literal** `3`{.hs}
  - Function **application**
    - **Function** `max`{.hs}
    - **Variable** `n`{.hs}
    - Numeric **literal** `0`{.hs}
:::
::: {.column width="40%"}
```hs {data-id="code-1"}
let n = 3 in
  max n 0
```
```scheme
(let ([n 3])
  (max n 0))
```
```js
const n = 3;
max(n, 0)
```
:::
::::::

## …*many* concrete possibilities

:::::: columns
::: {.column width="50%"}
```php
my $n = 3;
max($n, 0)
```
```mathematica
With[{n = 3},
  Max[n, 0]
]
```
```py
n ← 3
n ⌈ 0
```
:::
::: {.column width="50%"}
```hs
max n 0
  where n = 3
```
```scheme
(let ([n 3])
  (max n 0))
```
```js
const n = 3;
max(n, 0)
```
:::
::::::

<small>See also [The Next 700 Programming Languages](https://dl.acm.org/doi/pdf/10.1145/365230.365257) (Landin 1966)</small>

::: notes
Peter Landin
:::

## Concrete syntax: examples

::: columns
::: column
- **Keyword naming**
    - `const`, `let`, `var`, `my`
- **Sigils/operators**
    - `x = v`, `x := v`, `x ← v`
:::
::: column
- **Block demarcation**
    - `{`…`}`
    - `BEGIN`…`END`
    - Significant indentation
    - Parens
:::
:::

and more…

::: notes
- Prefix/infix/postfix
- Paired delimiters
- Whitespace conventions
- and more…
:::

## Wadler's Law, again

::: notes
however much time is spent discussing semantics, twice as much is spent on [abstract] syntax, twice as much on concrete, and so on

intended as tongue-in-cheek

allow me to boldly claim this implies an ordering
:::

> In any language design, the total time spent discussing a feature in this list is proportional to two raised to the power of its position.
>
> 0. Semantics
> 1. Syntax
> 2. Lexical syntax
> 3. Lexical syntax of comments

. . .

::: box
*Implication:* priority is **backwards**

i.e. concrete syntax **exponentially less important**
:::

## We often dismiss concrete syntax

- Sometimes it's explicit: **"it's *just* syntax"**
    - Others absorb and uncritically repeat this view
- Even when we care, we might **unconsciously devalue** it
    - "Apologies for bikeshedding, but…"

## Problems

Too often, concrete syntax decisionmaking is:

1. **Idiosyncratic**
2. **Under-documented**
3. **Under-researched**

*And that is a shame!*

## Why does this matter?

Concrete syntax is the **foremost user interface** for most programming languages.

. . .

also software libraries, mathematical theories (notation), etc.

# Programming languages have user interfaces

## Not a new idea

> [m]illions for compilers, but **hardly a penny for understanding human programming language use.** Now, programming languages are obviously symmetrical, the computer on one side, the human on the other. In an **appropriate science of computer languages**, one would expect that half the effort would be on the computer side, understanding how to translate the languages into executable form, and half on the human side, understanding how to design languages that are **easy or productive to use**.

<small>John Pane (1985), via Newell and Card, via Felleisen, emphasis mine</small>

## Not a new idea

- [Notation as a tool of thought](https://www.eecg.utoronto.ca/~jzhu/csc326/readings/iverson.pdf) (Iverson 1979)
- [Cognitive Dimensions of Notations](https://www.cl.cam.ac.uk/~afb21/CognitiveDimensions/papers/Green1989.pdf) (Green 1989)
- [Human Language Interface](https://felleisen.org/matthias/Presentations/Mexico.ppt) (Felleisen 2003)
- [Good Ideas, Through the Looking Glass](https://www.cl.cam.ac.uk/~afb21/CognitiveDimensions/papers/Green1989.pdf) (Wirth 2006)

## But little research on syntax itself

- Graphical user interfaces (GUIs)
    - **Visual languages** (Alice, Scratch, Max/MSP, Quartz Composer)
    - **GUI environments, IDE extensions** for textual programming languages
- Error messages

. . .

::: box
Both important, but **metatextual**!
:::

## What about everything else?

## Expanding our concept of UI

:::::: columns
::: {.column width="50%"}
```php
my $n = 3;
max($n, 0)
```
```mathematica
With[{n = 3},
  Max[n, 0]
]
```
```py
n ← 3
n ⌈ 0
```
:::
::: {.column width="50%"}
```hs
let n = 3 in
  max n 0
```
```scheme
(let ([n 3])
  (max n 0))
```
```js
const n = 3;
max(n, 0)
```
:::
::::::

## Expanding our concept of UI

- Text is here to stay
- Choosing concrete syntax is unavoidable
- **Legitimize thinking about the program itself as UI**

::: notes
If your language supports humans authoring text files, you have to pick what characters they input
:::

## Expanding our concept of UI

> By **relieving the brain** of all unnecessary work, a good notation sets it free to **concentrate on more advanced problems**, and in effect increases the mental power of the race.

<small>A. N. Whitehead, emphasis mine</small>

## Our focus

- **Textual**, **general-purpose** programming languages
- For **experienced users** (not exclusively, but at least)
- **Focus on the language itself**, not the programming environment
    - Basic affordances: syntax highlighting, LSP

## Caveats

- GUIs **no less valid**, just relatively better-studied!
- **Hard to decouple**: system = notation + environment (Green)

> If we have function keys to generate syntactic constructions, for example, **which is the ‘notation’**—the **keys we press**, or the **words we see**? Various factors will determine the user’s view, such as **prior experience**; the **units operated upon by the editor** [...] and whether a simple mapping can be perceived between [...] a **function key** [...] generating a simple **indivisible unit** of a few words.

<small>T.R.G. Green (1989), emphasis mine</small>

# Syntax mediates semantics

## Potentially counterintuitive

::: columns
::: column
### Syntactic
$$
\boxed{\vdash \varphi}
$$

"can be proved"
:::
::: {.column style="border-left: 2px solid black;"}
### Semantic
$$
\boxed{\models \varphi}
$$

"is modeled by"
:::
:::

## Example: Propositional logic

The following definition is **purely syntactic**:

$$
\begin{aligned}
\varphi &:= \ldots \\
&\mid \varphi_1 \land \varphi_2 \\
&\mid \varphi_1 \to \varphi_2  \\
&\mid \ldots
\end{aligned}
$$

. . .

"Just symbols," but if I went onto **define implication using $\land$**, you would probably hate me

## What does this operator mean?

```hs {.huge}
x >>= y
```

## What does this operator mean? 

- **Functional programmers**: monadic bind

    ```hs
    m >>= f >>= g >>= h
    ```

- **C-style programmers**: bitwise right shift assignment

    $$\llbracket \texttt{x >>= 1} \rrbracket \approx \llbracket \texttt{x = x >> 1} \rrbracket$$ 

    <super>$^\approx$</super> *assuming $\texttt{x}$ is scalar variable, no side effects, etc.*

- **JavaScript programmers**: maybe no idea?

## Human factors broach the divide

Despite best intentions, we are **pareidolic** creatures

- Prior background (both depth and nature)
- Other syntactic choices

::: notes
we are determined to find Jesus's face in our burnt toast, or implication in symbol soup
:::

## Question

If symbol perception is all relative, **why design concrete syntax**?

## Syntax mediates semantics

> It has become fashionable to regard notation as a secondary issue depending **purely on personal taste**. This could partly be true; yet the choice of notation **should not be considered arbitrary**. It has consequences and **reveals the language’s character**.

<small>Niklaus Wirth (2006), emphasis mine</small>

## Tales from the other side

1. Different kinds of sugar
2. Symbols and whitespace
3. Names matter

# Two kinds of syntactic sugar

## Syntactic sugar

- Coined by Landin in 1964
- Formalized through **macro extensibility** by Felleisen (1991)
- Describes **syntactic niceties** (e.g. `let`-binding) built on top of a smaller **core language** (e.g. applicative expressions)
    
::: columns
::: column
```hs
let x = v in …
```
:::
::: column
```hs
(\x -> …) v
```
:::
:::

::: notes
"The mechanical evaluation of expressions"
:::

## Example 1: Definitions in Scheme

## Top-level `define`

```scheme
(define x 1)
(define y (+ 4 x))

❯ (+ x y)
6
```

## Functions are just bound `lambda`s

```scheme
(define x 1)
(define y (+ 4 x))
(define f (lambda (n) (* n 2)))

❯ (f (+ x y))
12
```

## Sussman form shorthand

```scheme
(define f (lambda (n) …))
```
becomes
```scheme
(define (f n) …)
```

::: notes
Racketeers sometimes call this
- define with parameter list
- define binding a lambda
:::

## Sussman form shorthand

```scheme
(define f (lambda (n) (* n 2)))
```
becomes
```scheme
(define (f n) (* n 2))
```

## Sussman form shorthand

```scheme
(define fact
  (lambda (n)
    (if (zero? n) 1
        (* n (fact (- n 1))))))
```
becomes
```scheme
(define (fact n)
  (if (zero? n) 1
      (* n (fact (- n 1)))))
```

## Sussman form

- **Terser**, less nesting
- **Visually distinguishes** top-level function bindings
- But **hides the simplicity** of first-class functions
    - Easier to understand recursion without the sugar

## Example: JavaScript inheritance

## Example: JavaScript inheritance

- Pre-2015: **prototypal inheritance**

    ```js {.compact}
    function Parent() {}
    function Child() { Parent.call(this) }
    Child.prototype = Object.create(Parent.prototype)
    Child.prototype.constructor = Child
    ```
- Post-2015: **class-based inheritance**

    ```js {.compact}
    class Parent {}
    class Child extends Parent {
      constructor() { super() }
    }
    ```

## ES2015 `class` syntax

- Mostly engine-level syntactic sugar over prototypes
- **Intentionally obscures** prototypal semantics, **redirecting mental model** to classes
    - Don't need to understand prototypes to use `class`—you're often better off without!

## A tale of two sugars

::: columns
::: column
**"Mystifies" functions** for visual efficiency
```scheme {.compact}
(define (fact n)
  (if (zero? n) 1
      (* n 
         (fact (- n 1)))))
```
:::
::: column
**Redirects mental model** to classes
```js {.compact}
class Parent {}
class Child extends Parent {
  constructor() { 
    super() 
  }
}
```
:::
:::

## A tale of two sugars

Both **obscure the core language** (syntactic abstraction).

- Can permit **intentional redirection** of programmer mental model
- Or introduce **incidental opacity** or makes the language seem more complicated than it is
    - But could **still be worthwhile** on balance (e.g. terseness, visual distinction)

. . .

::: box
Worth considering when defining your own
:::

# Names matter

## TypeScript

- **Subtyping**: types form a lattice over $<:$ relation
    - $\top$ is the **universal supertype**

    $$
    \boxed{
    \bot \;<:\; \texttt{"hello"} \;<:\; \textsf{string}  \;<:\; \top
    }
    $$

- **Gradual typing**: typed-untyped codebase interaction
    - $\textsf{Dyn}$ is the **dynamic type**, an "escape hatch"

    $$
    \boxed{
    \bot \;<:>\; \textsf{Dyn} \;<:>\; \top
    }
    $$

## Question

How to express **any possible type**?

$$
\textrm{isString} : \mathrm{???} \to \textsf{boolean}
$$

## Question

How to express **any possible type**?

$$
\textrm{isString} : \red{\mathbf{\top}} \to \textsf{boolean}
$$

## Writing the program

How to express **any possible type**?

```ts
function isString(x: /* ?? */): boolean
```

## Writing the program

How to express **any possible type**?

```ts
function isString(x: any): boolean
```

. . .

::: {.box style="color: red; position: absolute; left: 50%; transform: translateX(-50%); top: 100%;"}
Problem: `any` is $\mathsf{Dyn}$, not $\top$!
:::

## $\mathsf{Dyn}$ vs. $\top$

$$
\boxed{
\bot \;<:>\; \textsf{Dyn} \;<:>\; \top
}
$$

**$\mathsf{Dyn}$ is unsound**: breaks typing guarantees, causes major incidents

## So how do we write $\top$ actually?

```ts
function isString(x: unknown): boolean
```

## Vernacular misconceptions

> **any** (adj.)
>
> 1. one or some indiscriminately of whatever kind
> […]
> 3. unmeasured or unlimited in amount, number, or extent

<small>source: [Merriam-Webster](https://www.merriam-webster.com/dictionary/any)</small>

## But wait, it gets worse

---

|  | Dynamic | Top |
| --- | --- | --- |
| **TypeScript** (JS), **Luau** (Lua) | `any` | `unknown` |
| **Flow** (JS) | `any` | `mixed` |
| **mypy, Pyre** (Python) | `Any` | `object` |
| **Sorbet** (Ruby) | `untyped` | `anything`[^1] |
| **Hack** (PHP) | `dynamic` | `mixed` |
| **Elixir** (Erlang) | `dynamic` | `any`[^2] |
| **Typed Racket** (Racket) | -[^4] | `Any` |
| **Scala, Kotlin** | - | `any` |
| **Swift** | - | `Any`[^3] |

<!-- | **Dart** | `dynamic` | `Object` | -->

[^1]: Uses `any` for union types
[^2]: Paper by Castagna et al. 2023 uses `term`, but the documentation uses `any`
[^3]: Not truly $\top$, but a type-erased existential box that requires casting or narrowing to use
[^4]: Uses module boundary system instead of creating a dynamic type

## Developers, developers, developers!

- **Half the languages** use `any` for $\mathsf{Dyn}$, and the **other half** for $\top$
    - First group includes JavaScript and Python-based
    - Second group includes Scala, Kotlin, Swift
- Languages that don't use `any` all have **different names for $\top$**
    - `unknown`, `mixed`, `object`, `anything`

## Researchers, researchers, researchers!

- **Modern, research-based PLs** like Luau (Roblox) are adopting the same names
    - Luau follows TypeScript's naming exactly, despite ~no linguistic heritage
- **Names change during implementation**: Elixir's paper uses `term` for $\top$, but the documentation uses `any`
    - Trivial-seeming changes can affect careful work

<small>Of note: Stefik & Siebert (2013), [An Empirical Investigation into Programming Language Syntax](https://www.vidarholen.net/~vidar/An_Empirical_Investigation_into_Programming_Language_Syntax.pdf)</small>

# Punctuation & whitespace matter

Or, how I became an $\eta$-expansion scrooge

## Background

- It's the early 2010s, and everyone is talking about **Node.js**, the new server-side JavaScript runtime
- JavaScript uses the **reactor pattern** to perform **non-blocking I/O**

## Async in JavaScript: abridged history

1. **Continuation-passing style** ("callback hell")
2. **`Promise`** chaining
3. **`async`/`await`** (today's world)

## Continuation-passing style

```js
runA(function (a) {
  runB(a, function (b) {
    runC(b, function (c) {
      …
    })
  })
})
```

## `Promise` chaining

```js
runA()
  .then(runB)
  .then(runC)
  .then(…)
```

## `async`/`await`

```js
const a = await runA()
const b = await runB(a)
const c = await runC(b)
…
```

## Evolution


::: {.columns style="gap: 0;"}
::: column
```js {.small}
runA(function (a) {
  runB(a, function (b) {
    runC(b, function (c) {
      …
    })
  })
})
```
:::
::: column
```js  {.small}
runA()
  .then(runB)
  .then(runC)
  .then(…)
```
:::
::: column
```js  {.small}
const a = await runA()
const b = await runB(a)
const c = await runC(b)
…
```
:::
:::

## Previous dataflow

```hs
    a        b        c
A ─────▶ B ─────▶ C ─────▶ …
```

## Alternate dataflow

<!-- TODO: Replace image -->

```hs
    a        b        c
A ─────▶ B ─────▶ C ─────▶ …
│                 ▲
└─────────────────┘
         a
```

## Callbacks and `async`/`await`

::: columns
::: column
```js {.compact}
runA(function (a) {
  runB(a, function (b) {
    runC(a, b, function (c) {
      …
    })
  })
})
```
:::
::: column
```js {.compact}
const a = await runA()
const b = await runB(a)
const c = await runC(b)
…
```
:::
:::

## `Promise` chaining

```js
runA()
  .then(runB)
  .then(b => runC(??, b)) // Missing `a`
  .then(…)
```

## `Promise` chaining

```js
runA()
  .then(runB)
  .then(runC)
  .then(…)
```

## `Promise` chaining

```js
runA()
  .then(a => [a, runB()])
  .then(([a, b]) => runC(a, b))
  .then(…)
```

## `Promise` chaining

```js
runA()
  // Must return Promise<…>
  .then(a => [a, runB()])
  .then(([a, b]) => runC(a, b))
  .then(…)
```

## `Promise` chaining

```js
runA()
  // Must return Promise<…>
  .then(a => Promise.all([a, runB()]))
  .then(([a, b]) => runC(a, b))
  .then(…)
```

## Add an extra call `D`

```hs
             b
         ┌──────▶ D
         │
    a    │   b        c
A ─────▶ B ─────▶ C ─────▶ …
│                 ▲
└─────────────────┘
         a
```

## `Promise` chaining

```js
runA()
  .then(a => Promise.all([a, runB()]))
  .then(([a, b]) => Promise.all(
    [runC(a, b), runD()]
  ))
  .then(([c, _] => …)
```

. . .

(This is my $\eta$ villain origin story btw)

## Issues with `Promise`-chaining

- Super fluent syntax for **linear dataflow**
- **Immediately falls apart** with the slightest branching
    - aka real world
- **Lost the ability to shadow** from earlier callbacks

## Nested scopes

::: columns
::: column
```js {.compact}
runA(function (a) {
  runB(a, function (b) {
    runC(a, b, function (c) {
      …
    })
  })
})
```
:::
::: column
```hs {.compact}
do
  a <- runA
  b <- runB a
  c <- runC a b
```
:::
:::

## So why did people hate callbacks?

## Indentation & closing delimiters

<div class="sourceCode" id="cb59"><pre class="sourceCode js"><code class="sourceCode javascript"><span id="cb59-1"><a href="#cb59-1" aria-hidden="true" tabindex="-1"></a><span class="fu">runA</span>(<span class="kw">function</span> (a) {</span>
<span id="cb59-2"><a href="#cb59-2" aria-hidden="true" tabindex="-1"></a><span class="span-code-highlight-indent">    </span><span class="fu">runB</span>(a<span class="op">,</span> <span class="kw">function</span> (b) {</span>
<span id="cb59-3"><a href="#cb59-3" aria-hidden="true" tabindex="-1"></a><span class="span-code-highlight-indent">        </span><span class="fu">runC</span>(a<span class="op">,</span> b<span class="op">,</span> <span class="kw">function</span> (c) {</span>
<span id="cb59-4"><a href="#cb59-4" aria-hidden="true" tabindex="-1"></a><span class="span-code-highlight-indent">            </span>…</span>
<span id="cb59-5"><a href="#cb59-5" aria-hidden="true" tabindex="-1"></a><span class="span-code-highlight-indent">        </span><span class="span-code-highlight">})</span></span>
<span id="cb59-6"><a href="#cb59-6" aria-hidden="true" tabindex="-1"></a><span class="span-code-highlight-indent">    </span><span class="span-code-highlight">})</span></span>
<span id="cb59-7"><a href="#cb59-7" aria-hidden="true" tabindex="-1"></a><span class="span-code-highlight">})</span></span></code></pre></div>

. . .

::: box
This is all **completely incidental**, yet resulted in a **loss of expressive fluency** in async-handling constructs!
:::

## Concrete vs. abstract syntax

::: columns
::: column
```js {.compact}
runA(function (a) {
  runB(a, function (b) {
    runC(a, b, function (c) {
      …
    })
  })
})
```
:::
::: column
```hs {.compact}
do
  a <- runA
  b <- runB a
  c <- runC a b
```
:::
:::

## Moral of the story

Languages can go through **tremendous semantic changes** based on **completely incidental** syntax

# What now?

## Problems

Too often, concrete syntax decisionmaking is:

1. **Idiosyncratic**
2. **Under-documented**
3. **Under-researched**

*And that is a shame!*

## First steps

1. **Idiosyncratic** → take these questions seriously (and rigorously)
2. **Under-documented** → document in archival/semi-archival media, including when decisions are unprincipled
3. **Under-researched** → we have tremendous opportunity to study these questions…more on this soon :)

## Conclusions

If we take seriously the idea of programming languages as user interfaces, then **concrete syntax matters just as much as semantics**.

Concrete syntax shapes the way people understand semantics, and in turn **shapes the semantics themselves**.

---

<!--

- Haskell used `:` for `cons` and `::` for type annotations because they thought Hindley–Milner type inference meant people wouldn't need to write stuff out.
- Mathematica apply
- Racket allows different paired delimiters
- Our whole discipline doesn't care about names: alpha-equivalence
    - x xs f g go
- ReasonML

-->
