import axios from "axios";

export default function () {
  const API_URL = import.meta.env.VITE_API_URL;

  const getSkills = async () => {
    try {
      const response = await axios.get(`${API_URL}/skills`);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la récupération des skills:', error);
      throw error;
    }
  }

  return {
    getSkills,
  }
}
