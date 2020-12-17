export default {
    namespaced: true,
    state: {
        activeNav: '',       
    },
    getters: {
        get_activeNav(state) {
            return state.activeNav
        },
    },
    mutations: {
        set_activeNav(state, newNav) {
            state.activeNav = newNav
        }
    }
}