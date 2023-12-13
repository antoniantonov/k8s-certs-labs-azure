# Simply copy this file to the root directory of your Linux VM
# Or into the same directory of the .bashrc file. 

alias k='kubectl'
alias kg='k get -o wide'
alias kgp='kg pods'
alias kgn='kg nodes'
alias kgd='kg deploy'
alias kgev='kg events'
alias kgnp='kg networkpolicy' 

alias kd='k describe'
alias kdp='kd pod'
alias kdd='kd deploy'
alias kdsvc='kd svc'
alias kdpvc='kd pvc'
alias kdnp='kd networkpolicy'

alias kl='k logs'
alias kx='k delete $now'

alias kapp='k apply -f'
alias kappx='k delete $now -f'

alias kc='k create'

alias ke='k edit'
alias ked='ke deploy'
alias kep='ke pod'
alias kesvc='ke svc'


alias kexti='k exec -ti'
alias kexit='k exec -ti'
alias kex='k exec'

export now='--force=true --wait=false --grace-period=0'
export do='--dry-run=client -o yaml'
export yml='-o yaml'
export ksn='-n kube-system'
export sl='--show-labels'
