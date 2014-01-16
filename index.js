var eng = require('eengine');
eng.start();
eng.getStartPromise().then(function() {
    require('./test');
})
