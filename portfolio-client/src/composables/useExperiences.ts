import axios from "axios";

export default function () {
  const API_URL = import.meta.env.VITE_API_URL;

  const getExperiences = async () => {
    try {
      const response = await axios.get(`${API_URL}/experiences`);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la récupération des experiences:', error);
      throw error;
    }
  }

  return {
    getExperiences,
  }
}
