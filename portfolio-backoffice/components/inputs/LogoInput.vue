<script lang="ts" setup>
import {ref, watch} from "vue";
import {useI18n} from "vue-i18n";

const {t} = useI18n();

const props = defineProps({
  logo: File as () => File | null
});
const emit = defineEmits(["update:logo"]);

const logoRef = ref<File | null>(props.logo || null);


const uploadImage = (event: Event) => {
  const target = event.target as HTMLInputElement;
  const files = target.files;
  if (!files || !files[0]) return;
  logoRef.value = files[0];
  emit("update:logo", files[0]);
};

watch(() => props.logo, (newLogo) => {
  logoRef.value = newLogo || null;
});
</script>

<template>
  <div class="mb-4">
    <Label for="image">{{ t("app.logo") }}</Label>
    <Input id="file-input" accept="image/*" type="file" @change="uploadImage"/>
  </div>
</template>