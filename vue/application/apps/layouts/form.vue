<script>
export default {
};
</script>
<template>
  <div class="card border">
    <div class="card-body bg-light">
      <div class="form-row">
        <div class="col-12 col-md-8 offset-md-2">
          <div class="card border">
            <div class="card-body">
              <slot></slot>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
