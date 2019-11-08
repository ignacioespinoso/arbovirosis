# Closures

Quando tenho alguma coisa assícrona, minha completion block será executada só no futuro e se essa completion block for uma CLOSURE, esta precisa ser @escaping, dizendo que a referência para a mesa escapa o escopo de onde é definida.

Logo por ser tudo assíncrono, passo tudo por closures. DAO -> SERVICES -> VIEWCONTROLLER.

Services será utilizado para, por exemplo, formar o CLLocation a partir dos dois números.

