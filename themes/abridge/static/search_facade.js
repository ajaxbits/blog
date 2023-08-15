window.onload = function() {
    document.getElementById('searchinput').onclick = function() {
        var baseUrl = document.querySelector("meta[name='base']").getAttribute("content");
        if (baseUrl.slice(-1) == "/") {
            baseUrl = baseUrl.slice(0, -1);
        }
        var sha256='7f09a67047cc88c8cdaebd38a45941fe5d9ed6e634594815509950b8dcdd4e4e';
        var sha384='ecEaafLxSGfi9mz+HV7j981v48f5xhjpSnVQ5hd/qDaQEbZ31IjW2Vrmzxii5EtG';
        var loadSearch = document.createElement('script');
        loadSearch.src = baseUrl + '/search_bundle.min.js?h=' + sha256;
        loadSearch.setAttribute('integrity', 'sha384-' + sha384);
        document.head.appendChild(loadSearch);
        document.getElementById('searchinput').onclick = '';
    }
};
