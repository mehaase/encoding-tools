<script>
    let script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "https://www.googletagmanager.com/gtag/js?id=G-V2KPTZELPW";
    document.body.appendChild(script);

    window.dataLayer = window.dataLayer || [];
    window.gtag = () => {
        dataLayer.push(arguments);
    };
    gtag("js", new Date());
    gtag("config", "G-V2KPTZELPW", { send_page_view: false });
</script>

<div class="tracker" />

<style>
    .tracker {
        display: none;
    }
</style>
