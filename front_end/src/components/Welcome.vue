<template>
    <div>
        <h2>Welcome {{ name }}!</h2>
    </div>
</template>

<script>
export default {
    data() {
        return {
            name: ''
        }
    },
    created() {
        this.name = this.$store.getters['user/get_username']
        console.log('created(): Welcome ', this.name, this.$store.state.user.username)
    },
    methods: {
        handleOpen(key, keyPath) {
            console.log(key, keyPath);
        },
        handleClose(key, keyPath) {
            console.log(key, keyPath);
        }
    }
}
</script>