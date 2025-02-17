export default function () {
    const config = useRuntimeConfig();
    const apiBaseUrl = config.public.apiBaseUrl;

    function getLogo(logo: string | undefined) {
        return logo ? `${apiBaseUrl}/images/${logo}` : '/okeep.png';
    }

    return {
        getLogo
    }
}