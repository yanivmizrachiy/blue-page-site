
BEGIN{changed=0; inthead=0}
/<thead>/{inthead=1}
/<\/thead>/{inthead=0}
{
  if(inthead && !changed){
    line=$0
    gsub(/\r/, "", line)
    if ( line ~ /<th[^>]*>([^<]*אירוע[^<]*|[^<]*ציון[^<]*)<\/th>/ ) {
      sub(/<th[^>]*>[^<]*<\/th>/, "<th>" exam "</th>", line)
      print line
      changed=1
      next
    }
  }
  print
}
