window.onload = function() {
    document.getElementById('searchinput').onclick = function() {
        var baseUrl = document.querySelector("meta[name='base']").getAttribute("content");
        if (baseUrl.slice(-1) == "/") {
            baseUrl = baseUrl.slice(0, -1);
        }
        var sha256='f43856ab0a84a1db85524ac2dbc2dcc6afb9500e2117adeaebcf134b60c912a8';
        var sha384='8OedNG0k/7DN2exIOm8PBjcCpoZN3tuyqXNLY0kGKYqJDu2awmq2ErUpGb8XNgik';
        var loadSearch = document.createElement('script');
        loadSearch.src = baseUrl + '/search_bundle.min.js?h=' + sha256;
        loadSearch.setAttribute('integrity', 'sha384-' + sha384);
        document.head.appendChild(loadSearch);
        document.getElementById('searchinput').onclick = '';
    }
};
