String[] queueToString(ArrayList<StitchObj> q) {
  String[] result = new String[0];
  for (StitchObj obj : q) {
    result = (String[]) append(result,obj.toString());
  }
  return result;
}

void saveQueue(ArrayList<StitchObj> q,String path) {
  String[] s = queueToString(q);
  saveStrings(projectTxtFolder+path,s);
  saveStchs(q);
}
