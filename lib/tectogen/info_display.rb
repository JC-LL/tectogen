module InfoDisplay
  TURN="|-"
  def info level,str="",display=true
    if level==0
      ret="[+] "+str
    else
      prev=info(level-1,"",false)
      index_plus=prev.index("+")
      ret=" "*index_plus+TURN+"[+] "+str
    end
    puts ret if display
    ret
  end
end

#
# include InfoDisplay
#
# info 0,"essai"
# info 1,"A"
# info 2,"1"
# info 2,"2"
# info 3,"a"
# info 3,"b"
# info 1,"B"
