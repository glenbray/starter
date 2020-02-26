module.exports = {
  theme: {
    extend: {
      boxShadow: {
        'thick-sm': '2px 2px 0px 0px rgba(0,0,0,.1), 0 4px 6px -2px rgba(0,0,0,.05)',
        'thick-md': '4px 4px 0px 0px rgba(0,0,0,.1), 0 4px 6px -2px rgba(0,0,0,.05)',
        'thick-lg': '7px 7px 0px 0px rgba(0,0,0,.1), 0 4px 6px -2px rgba(0,0,0,.05)',
        'thick-xl': '10px 10px 0px 0px rgba(0,0,0,.1), 0 4px 6px -2px rgba(0,0,0,.05)',
      },
    },
  },
  variants: {
    backgroundColor: ['responsive', 'hover', 'focus', 'active'],
  },
  plugins: [
    require('@tailwindcss/custom-forms')
  ]
}
