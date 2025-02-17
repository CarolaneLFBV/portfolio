import axios from "axios";

export default function useUser() {
  const API_URL = import.meta.env.VITE_API_URL;

  const getUserBySlug = async (slug: string) => {
    try {
      const response = await axios.get(`${API_URL}/users/${slug}`);
      return response.data;
    } catch (error) {
      console.error("Erreur lors de la récupération de l'utilisateur :", error);
      return null;
    }
  };

  return {
    getUserBySlug,
  };
}
