<script>
export default {
  props: {
    label: {
      type: String,
      default: "",
    },
    required: {
      type: Boolean,
      default: false,
    },
    type: {
      type: String,
      default: "text",
    },
    placeholder: {
      type: String,
      default: "",
    },
    value: {
      required: true,
    },
    className: {
      required: false
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },

  data() {
    return {
      input_value: null,
    };
  },

  methods: {
    focus() {
      this.$refs["input"].focus();
    },

    onChange(event) {
      this.$emit("change", event);
    },
  },

  watch: {
    value() {
      if (this.value != this.input_value) {
        this.input_value = this.value;
      }
    },

    input_value() {
      this.$emit("input", this.input_value);
    },
  },
};
</script>

<template>
  <b-form-group :label="label">
    <b-form-input
      :required="required"
      :type="type"
      :disabled="disabled"
      ref="input"
      :class="className"
      @change="onChange"
      v-model="input_value"
      :placeholder="placeholder"
    >
    </b-form-input>
  </b-form-group>
</template>
