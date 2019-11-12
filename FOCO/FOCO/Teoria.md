# Closures

Quando tenho alguma coisa assícrona, minha completion block será executada só no futuro e se essa completion block for uma CLOSURE, esta precisa ser @escaping, dizendo que a referência para a mesa escapa o escopo de onde é definida.

Logo por ser tudo assíncrono, passo tudo por closures. DAO -> SERVICES -> VIEWCONTROLLER.


# Swift Lint
* trailing white space: qnd der ENTER, a próxima linha começa com um tab. Swift lint não gosta disso e tem como tirar automaticamente. 
* máximo espaço que pode dar entre uma coisa e outra é 1 enter.

TERMINAL
* swiftlint rules 
    mostra todas as regras
* swiftlint rules empty_parameters 
    mostra em detalhes o que trigger uma regra
    
    // swiftlint:disable <rule1> 

       YOUR CODE WHERE NO rule1 is applied

    // swiftlint:enable <rule1>

if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
