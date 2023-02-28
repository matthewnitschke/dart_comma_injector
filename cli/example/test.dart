void bar(void Function(String s) ss) {}
void zzs(String s, String ss) {}

void main() {
  bar((s) {
    zzs('a', 'b',);
  });
}