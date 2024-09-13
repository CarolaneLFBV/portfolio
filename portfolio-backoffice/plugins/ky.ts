import ky from 'ky';

export default defineNuxtPlugin(() => {
    // Configurer l'instance Ky avec votre URL d'API de base
    const api = ky.create({
        prefixUrl: process.env.NUXT_PUBLIC_API_BASE,
        retry: {
            limit: 2 // Nombre de tentatives en cas d'échec
        }
    });

    return {
        provide: {
            api
        }
    };
});
