
BEGIN{FS="</td>"; intbody=0; row=0}
/<tbody>/{intbody=1}
/<\/tbody>/{intbody=0}
{
  if(intbody){
    n=split($0,cell,/<td[^>]*>/)
    if(n>1){
      row++
      val=cell[col+1]
      gsub(/<[^>]*>/,"",val)
      gsub(/^[ \t\r\n]+|[ \t\r\n]+$/,"",val)
      if(val !~ /^$|^[0-9]+([.,][0-9]+)?%?$/){ print row }
    }
  }
}
