<script>
export default {
  props: {
    readonly: {
      type: Boolean,
      default: false,
    },
    min: {
      type: Number,
      default: null,
    },
    max: {
      type: Number,
      default: null,
    },
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
      required: false,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    description: {
      type: String,
      default: null,
    },
  },

  data() {
    return {
      input_value: null,
    };
  },

  mounted() {
    this.input_value = this.value;
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
  <b-form-group :description="description">
    <template v-slot:label>
      {{ label }}
      <sup v-if="required" class="text-danger">*</sup>
    </template>
    <b-form-input
      :readonly="readonly"
      :min="min"
      :max="max"
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
