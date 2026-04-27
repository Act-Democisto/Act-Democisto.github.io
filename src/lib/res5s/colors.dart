import "package:color/color.dart";
import "package:jaspr/jaspr.dart" as j show Color;

typedef RgbTriple = ({
    int r,
    int g,
    int b,
    int? a});

enum DColors {
  /// 衆志インスパイアのターコイズ
  democisto(0x36, 0xc8, 0xb5),
  /// アナキズムと抵抗の黒
  anarchy(0x5, 0x04, 0x02),
  /// 左派の青
  leftist(0x00, 0x73, 0xbd),
  /// 香港品紅
  hk(235, 2, 107),
  /// 濃紫品紅
  hk2(155, 0, 85),
  /// ベビーピンク
  babyPink(253, 237, 228),
  /// Twitterカラー
  twitter(85, 172, 238),
  /// フェミニズムの紫
  feminism(0, 0, 0);

  final int r;
  final int g;
  final int b;

  const DColors(this.r, this.g, this.b);

  String get hexStr
    => "#${this.r}${this.g}${this.b}"
      .toLowerCase();
  Color get hex => HexColor(this.hexStr);
  Color get rgb
    => RgbColor(this.r, this.g, this.b);
  j.Color get jaspr
    => j.Color.rgb(this.r, this.g, this.b);
  j.Color jWithAlpha(int a)
    => j.Color.rgba(this.r, this.g, this.b, a);
  String get css => this.hexStr;
  String get cssVar => "var(--${this.name})";
  String get cssDef => "--${this.name}: ${this._hex};";

  static get RegExp reHex = RegExp(r"#?[0-9a-zA-Z]{6}[0-9a-zA-Z]{2}?");
  static get RegExp reRgb = RegExp(r"(rgb)?\(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(, ?([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])){2, 3}\)");
  
  static RgbTriple validate(String target) {
    if (Colors.reHex.hasMatch(target)) {
      String s = target
        .toLowerCase()
        .replaceAll("#", "");
      return switch(s.length) {
        6 => (
          r: int.parse(
            s.substring(0, 2),
              radix: 16),
          g: int.parse(
            s.substring(2, 4),
              radix: 16),
          b: int.parse(
            s.substring(4, 6),
              radix: 16),
          a: null),
        8 => (
          r: int.parse(
            s.substring(0, 2),
              radix: 16),
          g: int.parse(
            s.substring(2, 4),
              radix: 16),
          b: int.parse(
            s.substring(4, 6),
              radix: 16),
          a: int.parse(
            s.substring(6, 8),
              radix: 16)),
        _ => throw Error(),
      };
    } else if (Colors.reRgb.hasMatch(target)) {
      List<String> vals = target
        .replaceAll("rgb", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .split(RegExp(r", ?"))
        .map<int>((String s)
          => int.parse(s))
        .map<String>((int i)
          => i.toRadixString(16))
        .map<String>((String v)
          => v.padLeft(2, "0"))
        .toList();
      return switch(vals.length){
        3 => (r: vals[0], g: vals[1], b: vals[2], a: null),
        4 => (r: vals[0], g: vals[1], b: vals[2], a: vals[3]),
        _ => throw Error(),
      };
    } else {
      throw Error("");
    }
    
    static String validateHex(String target) {
      RgbTriple t = DColors.validate(target);
      String Function(int?) fn = (int? ce)
        => ce == null
          ? ""
          : ce.toRadixString(16)
              .toLowerCase()
              .padLeft(2, "0");
      return "#${fn(t.r)${fn(t.g)}${fn(t.b)${fn(t.a)}";
    }
    
    static Color validateColor(String target) {
      RgbTriple t = DColors.validate(target);
      return RgbColor(t.r, t.g, t.b);
    }
    
    static j.Color validateJaspr(String target) {
      RgbTriple t = DColors.validate(target);
      return t.a == null
        ? j.Color.rgb(t.r, t.g, t.b)
        : j.Color.rgba(t.r, t.g, t.b, t.a);
    }
  }
  
  static DColors get turquoise
    => Colors.democisto;
  static DColors get black
    => DColors.anarchy;
  static DColors get blue
    => DColors.leftist;
  static DColors get fuchsia
    => DColors.hk;
  static DColors get purple
    => DColors.feminism;
  static DColors get hashtag
    => DColors.twitter;
}