<script>
import DatePicker from "v-calendar/lib/components/date-picker.umd";

export default {
  components: { DatePicker },
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
    <date-picker
      v-model="input_value"
      :locale="date.vcDatepickerConfig()"
      :popover="{ visibility: 'focus' }"
    >
      <template v-slot="{ inputValue, inputEvents }">
        <input class="form-control" v-on="inputEvents" :value="inputValue" />
      </template>
    </date-picker>
  </b-form-group>
</template>
