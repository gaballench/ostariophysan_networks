
ll = read.csv('logliks.csv')

write.table(x=ll[order(ll$negploglik, ll$filename),], file='logliks_sorted.csv', sep=',', row.names=FALSE)