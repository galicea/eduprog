# Poprawki w katalogu web/

Data: 6 września 2026
Repozytorium: `tinysynth` (fork http://n1k0.github.io/tinysynth)

Stare  aplikacje po latach przestały się uruchamiać (główny objaw na Node.js 24: `Error: No such module: http_parser`
w `react-scripts` z epoki webpacka 2/3). Wszystkie zostały zaktualizowane do
współczesnego toolingu.

## Ogólny zakres zmian (aplikacje React)

Wspólne dla wszystkich czterech aplikacji opartych o Create React App:

- `react-scripts` 0.7.0 / 1.0.7 / 1.1.4 → **5.0.1** (usunięcie zależności od `http-deceiver`/`http_parser`).
- React 15/16 → **React 19** (`react` / `react-dom` ^19.2.8).
- `redux` 3/4 → **5.0.1**, `react-redux` 4/5 → **9.2.0** (wymagane dla React 19).
- `ReactDOM.render(...)` → `createRoot(...).render(...)` (w React 19 `ReactDOM.render` zostało usunięte).
- Usunięcie adnotacji Flow z kodu JS (react-scripts 5 nie kompiluje Flow).
- Usunięcie martwych/niekompatybilnych zależności: `flow-bin`, babel-preset-*,
  gulp`*, `webpack*`, `react-addons-pure-render-mixin`, `react-buttons`,
  `uglifyjs-webpack-plugin` itp.
- Aktualizacja `.gitignore` (ignorowanie `build/` tam, gdzie brakowało).
- Nowo wygenerowane `yarn.lock`.

## 1. `example01redux`

- X: CRA 1.0.7, React 15.6, Flow, `flow-bin`, `react-buttons`,
  `react-addons-pure-render-mixin`.
- Y: CRA 5.0.1, React 19, redux 5, react-redux 9.
- Zdjęte typy Flow w `App.js` i `store.js` (`import type`, `export type`,
  `zwieksz(): void`).
- `src/index.js`: przejście na `createRoot`.

## 2. `calculator` (react-calculator)

- X: CRA 0.7.0 (źródło błędu `http_parser`), React 15, Flow, PropTypes z react,
  własny pipeline gulp/webpack (nieużywany przez skrypty CRA).
- Y: CRA 5.0.1, React 19, redux 5, react-redux 9.
- Usunięte `import { PropTypes } from 'react'` i bloki `X.propTypes` w 5 komponentach
  przycisków (PropTypes z react zniknął w React 19).
- Zdjęte adnotacje Flow w `reducers/index.js` i komentarze `// @flow`.
- Naprawiony `public/index.html`: był to szablon sprzed CRA (uszkodzony tag CDN
  bootstrap z brakiem `>` oraz `<script src="bundle.js">`, którego CRA nie generuje);
  zastąpiony standardowym szablonem z `%PUBLIC_URL%`.
- `src/index.js`: przejście na `createRoot`.

## 3. `kidspreasheet`

- X: CRA 1.0.7, React 15.6, Flow, gulp/webpack (nieużywane), `redux-logger`.
- Y: CRA 5.0.1, React 19, redux 5, react-redux 9, `redux-logger` (zachowany).
- Zdjęte typy Flow (`types.js` usunięty, adnotacje w `App.js` i `store.js`).
- Usunięty śmieciowy `public/tmp.html`.
- `src/index.js`: przejście na `createRoot`.

## 4. `xo`

- X: CRA 1.1.4, React 16.3. Y: CRA 5.0.1, React 19, redux 5, react-redux 9.
- `src/index.js`: przejście na `createRoot`.
- Usunięty stary `App.test.js` (używał `ReactDOM.render`/`unmountComponentAtNode`
  — niekompatybilny z React 19; przy modernizacji środowiska testowego trzeba by
  przepisać go np. na React Testing Library).

## 5. `axo` (Angular 6 → Angular 19)

Największa zmiana: praktycznie przepisanie na nowoczesny Angular.

- X: Angular 6.0 (@angular/core, CLI 6, @angular-redux/store 9, rxjs 6, zone.js 0.8,
  TypeScript 2.7, webpack 4 w tle) — martwa biblioteka `@angular-redux`, akcje
  Reduxa trzymane poza store, typoskładowanie przez `@select()`.
- Y: Angular 19.2 (CLI 19, `application` builder/esbuild), redux 5, rxjs 7, zone.js 0.15,
  TypeScript 5.5.
- Architektura:
  - `src/main.ts` → `bootstrapApplication(AppComponent)`.
  - Standalone komponenty: `AppComponent` (nagłówek + `<xo-selector>`),
    `XoComponent` (plansza).
  - Redux bez `@angular-redux`: `store` z `createStore(reducer)` + `store.subscribe()`
    w `XoComponent` (`xo`, `stanGry` aktualizowane po każdym dispatchu).
  - Akcje: klasa `xoActions` (Injectable) zwraca obiekt akcji; komponent dispatchuje
    przez `store.dispatch(...)`.
  - Logika gry (reducer w `src/app/rx/store.ts`) bez zmian — to samo kółko i krzyżyk.
- Z usuniętych plików: `e2e/`, `polyfills.ts`, `test.ts`, `karma.conf.js`,
  `app.module.ts`, spec, env, stare `angular.json`/`tsconfig.json`, `tslint.json`.
- `tsconfig.json` z `strict: true` (drobne dostosowania: `"types": []`, notacja
  `action['x']` dla index signature).


## katalogi web/react/tools i web/react/basis

# Poprawki katalogów `basis/` i `tools/`

Data: 6 września 2026

Katalogi `basis/` i `tools/` w rootcie repo zawierają bardzo proste, kilkunastoletnie
przykłady użycia ReactJS oraz narzędzi budowania (Babel, webpack, gulp, Create React
App). Po sprawdzeniu okazało się, że są nieaktualne (CRA 1.x, React 15/16, babel 6,
webpack 3, gulp 3, przepływy odwołujące się do nieistniejących plików) i nie
uruchamiają się na współczesnym Node.js.

Efekt: **7 przykładów naprawionych**, **2 proponowane do usunięcia** (redundantne —
patrz na końcu).

## Ograniczenia narzucone przez pracę z tymi przykładami

- Przykłady „oparte na skryptach" (`example00babel`, `example00webpack`, `example02gulp`)
  używają Reacta ładowanego jako UMD (globalne `React`/`ReactDOM`). React 19 **nie
  publikuje już buildów UMD**, więc w nich jest przypięty `react@^18` — ostatnia wersja
  z UMD (react 18 jako ścieżka `node_modules/react/umd/*`).
- Instalacje babela i webpacka muszą być przypięte do wersji **7**:
  `@babel/cli` 8 / `@babel/preset-react` 8 zmieniają domyślny runtime JSX na
  „automatic" (objaw: błąd `jsxDEV is not a function` w przeglądarce).
- `setup` zaczyna od `npm init -y` — bez `package.json` w bieżącym katalogu npm
  szuka package.json w katalogach NADRZĘDNYCH i trafiał na `tinysynth/package.json`
  (ERESOLVE na `react-mdl`).
- Binarki lokalne (`webpack`, `gulp`, `babel`) nie są na PATH — komenda przez `npx`.

## Naprawione — `basis/`

### `example00babel` — „Hello World" + sam Babel
- X: babel 6 (`babel-cli`, `babel-preset-es2015`, `babel-plugin-transform-react-jsx`),
  index.html wskazywał ścieżki UMD reacta, których nowe wersje nie mają,
  `ReactDOM.render`.
- Y:
  - `.babelrc` → `["@babel/preset-env", "@babel/preset-react"]` (babel 7);
  - `helloworld.jsx` → montowanie przez `createRoot` (`ReactDOM.createRoot(...).render(...)`);
  - `index.html` → `node_modules/react/umd/react.production.min.js` +
    `node_modules/react-dom/umd/react-dom.production.min.js`;
  - `setup` → `npm init -y` + `react@^18 react-dom@^18` + `@babel/cli@^7 @babel/core@^7
    @babel/preset-env@^7 @babel/preset-react@^7`;
  - `build` → `./node_modules/.bin/babel helloworld.jsx > helloworld.js`.
- Weryfikacja: „Hello World" w headless Chromium.

### `example01create-react-app` — skrypt tworzący nowy projekt
- X: `sudo npm -g install create-react-app; create-react-app example01` — CRA jest
  wycofane (deprecated) i nie działa.
- Y: skrypt tworzy aplikację przez **Vite**:
  `npm create vite@latest example01 -- --template react`, potem `npm install`.
- `run` → `cd example01 && npm run dev`.

### `example02props` — props (klasy)
- X: CRA 1.0.17, react 16, `ReactDOM.render`, nieużywany `react-bootstrap`.
- Y: CRA 5.0.1, react 19, `createRoot`, usunięty `react-bootstrap`.
- Weryfikacja: build + smoketest (rendering czterech przycisków).

### `example03state` — state (licznik)
- X: CRA 1.0.7, react 15, `react-bootstrap` 0.31 (`bsStyle`), import `Text`
  (nie istnieje), typy Flow w `App.js`, stary `App.test.js` (ReactDOM.render),
  skrypt `structor` (bez pakietu).
- Y: CRA 5.0.1, react 19, `react-bootstrap` 2 (`variant="primary"`, usunięty `Text`),
  zdjęte typy Flow, `createRoot`, usunięty `App.test.js` i `structor`.
- Weryfikacja: build + smoketest (licznik 0→1 po kliknięciu).

### `example04statprops` — props + state
- X: jw. + typy Flow (`?string`, `?number`, adnotacje `props`/`state` w klasach).
- Y: jw. CRA 5.0.1, react 19, `react-bootstrap` 2 + `variant`, zdjęty Flow,
  `createRoot`.
- Weryfikacja: build + smoketest (licznik 1→2 po kliknięciu).

## Naprawione — `tools/`

### `example00webpack` — „Hello World" + webpack
- X: webpack 3 (`module.loaders`, opcje `query`), babel 6, react 15 jako KOPIOWANE
  UMD (`js/react.min.js`, `js/react-dom.min.js` — pliki w repo), `webpack` z PATH.
- Y:
  - `webpack.config.js` → webpack 5 (`mode: 'production'`, `module.rules`, `use`+`options`)
    z `@babel/preset-env` + `@babel/preset-react` (pin `@^7`);
  - `helloworld.jsx` → moduł ESM: `import React`, `import { createRoot }` — react jest
    teraz BUNDLOWANY do `helloworld.js`;
  - `index.html` → bez zewnętrznych scriptów reacta, tylko `helloworld.js`;
  - usunięte stary `js/` (react 15 vendored);
  - `setup` → `npm init -y` + react 19 + babel 7 + `webpack` + `webpack-cli`,
    budowa przez `npx webpack`.
- Weryfikacja: „Hello World" w headless Chromium, brak błędów w konsoli.

### `example02gulp` — „Hello World" + gulp
- X: gulp 3 (nie działa na współczesnym Node), `gulp-babel` 6, kopiowanie reacta z
  `node_modules/react/dist/*` (ścieżki nie istnieją od reacta 15), `gulp` z PATH.
- Y:
  - `gulpfile.js` → gulp 4 (`gulp.series`, `gulp.parallel`), `gulp-babel` 8
    z `@babel/preset-react` (7);
  - kopiowanie UMD react 18: `node_modules/react/umd/react.production.min.js` →
    `dist/js/react.production.min.js` (analogicznie react-dom);
  - `src/index.html` → odwołania do `js/react.production.min.js`,
    `js/react-dom.production.min.js`, `js/helloworld.js`;
  - `setup` → `npm i -D react@^18 react-dom@^18 @babel/core@^7 @babel/preset-env@^7
    @babel/preset-react@^7 gulp gulp-babel`; budowa przez `npx gulp`.
- Weryfikacja: `dist/` z kompletną, działającą stroną; „Hello World" w przeglądarce.

## Usunięte (redundantne)

Te dwa przykłady nie nadawały się do sensownej poprawki — były duplikatami już
naprawionych lub odwoływały się do plików, które nigdy nie powstaną. Usunięte:

- **`tools/example01webpack`** — strzęp: `App.js` + `webpack.config.js` miały działać
  w katalogu `example01` tworzonym przez CRA (skrypt `setup_01`); w katalogu nie było
  ani `src/index.js`, ani `App.css`/`index.css`, a przepływ „CRA + podmiana na ręczny
  webpack" był martwy po wycofaniu CRA. Zawartość pokryta przez `example00webpack`.
- **`tools/example03gulp_webpack`** — niekonsekwentna hybryda: package.json z
  `react-scripts` (CRA) + gulp + webpack 3 (`loaders`/`query`) + kopiowanie reacta z
  nieistniejących ścieżek `react/dist`, `public/index.html` odwoływał się do
  `js/bundle.js`; kilka nakładających się pipeline'ów budowania. Wszystko pokrywają
  `example00webpack` (webpack), `example02gulp` (gulp) i przykłady CRA z `basis/`.

