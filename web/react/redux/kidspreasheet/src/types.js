export type Symbol = {
  src: string,
  count: number,
};

export type Cell = {
  color: string, // kolor komórki - aktualny
  color0: string, // kolor pierwotny
  left: number, // wartość lewa
  right: number, // wartość prawa
  lcolor: string, // kolor lewego rogu
  rcolor: string, // kolor prawego rogu
  value: number // docelowo [] - będzie lista ikon
};

export type Spreadsheet = {
  calc: Cell[],
};
