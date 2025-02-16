<script lang="ts" setup>
import {ref, watch} from "vue";
import {useI18n} from "vue-i18n";

const {t} = useI18n();

const props = defineProps({
  images: Array as () => File[]
});
const emit = defineEmits(["update:images"]);
const imagesRef = ref<File[] | null>(props.images || null);

const uploadImages = (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (!target.files) return;
  imagesRef.value = Array.from(target.files);
  emit("update:images", imagesRef.value);
};

watch(() => props.images, (newImages) => {
  imagesRef.value = newImages || [];
});

</script>

<template>
  <div class="mb-4">
    <Label for="imageUpload">{{ t("app.images") }}</Label>
    <Input id="imageUpload" accept="image/*" multiple type="file" @change="uploadImages"/>
  </div>
</template>
