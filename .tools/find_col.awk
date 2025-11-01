
BEGIN{FS="</th>"; idx=0; found=-1; inthead=0}
/<thead>/{inthead=1}
/<\/thead>/{inthead=0}
{
  if(inthead){
    n=split($0,a,/<th[^>]*>/)
    for(i=2;i<=n;i++){
      idx++
      s=a[i]
      sub(/<\/th>.*/, "", s)
      gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", s)
      if(s==exam){ found=idx; break }
    }
  }
}
END{ print found }
