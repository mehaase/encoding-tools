<script>
    let script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "https://www.googletagmanager.com/gtag/js?id=G-HD5WSRFT6N";
    document.body.appendChild(script);

    window.dataLayer = window.dataLayer || [];
    window.gtag = () => {
        dataLayer.push(arguments);
    };
    window.gtag("js", new Date());
    window.gtag("config", "G-HD5WSRFT6N", { send_page_view: false });
</script>

<div class="tracker" />

<style>
    .tracker {
        display: none;
    }
</style>
