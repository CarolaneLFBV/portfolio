import axios from "axios";

export default function () {
  const API_URL = import.meta.env.VITE_API_URL;

  const getApps = async () => {
    try {
      const response = await axios.get(`${API_URL}/projects`);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la récupération des apps:', error);
      throw error;
    }
  }

  return {
    getApps,
  }
}
