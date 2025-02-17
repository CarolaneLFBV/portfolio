export default function () {
  const apiBaseUrl = import.meta.env.VITE_API_URL || "http://localhost:3000/"

  function getLogo(logo: string | undefined) {
    return logo ? `${apiBaseUrl}/images/${logo}` : '/okeep.png';
  }

  return {
    getLogo
  }
}
