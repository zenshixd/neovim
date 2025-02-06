local colors = {
  black1 = '#2e3440',
  red1 = '#cb4f53',
  green1 = '#48a53d',
  yellow1 = '#ee5e25',
  blue1 = '#3879c5',
  purple1 = '#9f4aca',
  cyan1 = '#3ea1ad',
  white1 = '#e5e9f0',
  black2 = '#646a76',
  red2 = '#d16366',
  green2 = '#5f9e9d',
  yellow2 = '#ba793e',
  blue2 = '#1b40a6',
  purple2 = '#9665af',
  cyan2 = '#8fbcbb',
  white2 = '#eceff4',
}

return {
  normal = {
    a = { fg = colors.white1, bg = colors.blue1, gui = 'bold' },
    b = { fg = colors.blue1, bg = colors.white2, gui = 'bold' },
    c = { fg = colors.black1, bg = colors.white2 },
    x = { fg = colors.purple2, bg = colors.white2, gui = 'bold' },
    y = { fg = colors.blue1, bg = colors.white2 },
    z = { fg = colors.white1, bg = colors.blue1, gui = 'bold' },
  },
  insert = { a = { fg = colors.white1, bg = colors.cyan1, gui = 'bold' } },
  visual = { a = { fg = colors.white1, bg = colors.purple1, gui = 'bold' } },
  replace = { a = { fg = colors.white1, bg = colors.red1, gui = 'bold' } },
  command = { a = { fg = colors.white1, bg = colors.green1, gui = 'bold' } },
  inactive = {
    a = { fg = colors.black1, bg = colors.white1, gui = 'bold' },
    b = { fg = colors.blue1, bg = colors.white1 },
    c = { fg = colors.blue1, bg = colors.white1 },
  },
}
