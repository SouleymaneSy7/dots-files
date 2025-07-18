-- Colors (hex, rgb, hsl, etc.) highlighter for neovim

return {
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {},
	},
}
