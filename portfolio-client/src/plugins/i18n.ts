import {createI18n} from 'vue-i18n'
import en from '@/locales/en.json'
const appLocale = import.meta.env.VITE_APP_I18N_LOCALE
export default createI18n({
  legacy: false,
  locale: appLocale,
  fallbackLocale: appLocale,
  messages: {
    en
  }
})
