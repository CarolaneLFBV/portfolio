export default function () {
    const config = useRuntimeConfig();
    const apiBaseUrl = config.public.apiBaseUrl;

    function getLogo(logo: string | undefined) {
        return logo ? `${apiBaseUrl}/images/${logo}` : '/okeep.png';
    }

    function getImages(images?: string[] | string) {
        return images ? `${apiBaseUrl}/images/${images}` : '/okeep.png';
    }

    return {
        getLogo
    }
}