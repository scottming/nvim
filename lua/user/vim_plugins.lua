return {
	{ "vim-test/vim-test", event = "VeryLazy" },
	{ "tpope/vim-abolish", commit = "cb3dcb220262777082f63972298d57ef9e9455ec", event = "VeryLazy" },
	-- for highlight the pattern: search and so on
	{ "markonm/traces.vim", commit = "9663fcf84de5776bee71b6c816c25ccb6ea11d1a", event = "VeryLazy" },
	-- surround
	{ "tpope/vim-surround", commit = "3d188ed2113431cf8dac77be61b842acb64433d9", event = "VeryLazy" },
	-- projectionist better product code and test code
	{
		"tpope/vim-projectionist",
		commit = "e292c4e33b2c44074c47c06e8ce8b309fd8099bc",
		event = "VeryLazy",
		config = function()
			vim.g.projectionist_heuristics = {
				["*"] = {
					["lib/**/views/*_view.ex"] = {
						type = "view",
						alternate = "test/{dirname}/views/{basename}_view_test.exs",
						template = {
							"defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View do",
							"  use {dirname|camelcase|capitalize}, :view",
							"end",
						},
					},
					["test/**/views/*_view_test.exs"] = {
						alternate = "lib/{dirname}/views/{basename}_view.ex",
						type = "test",
						template = {
							"defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ViewTest do",
							"  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View",
							"",
							"  use ExUnit.Case, async: true",
							"end",
						},
					},
					["lib/**/controllers/*_controller.ex"] = {
						type = "controller",
						alternate = "test/{dirname}/controllers/{basename}_controller_test.exs",
						template = {
							"defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Controller do",
							"  use {dirname|camelcase|capitalize}, :controller",
							"end",
						},
					},
					["test/**/controllers/*_controller_test.exs"] = {
						alternate = "lib/{dirname}/controllers/{basename}_controller.ex",
						type = "test",
						template = {
							"defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ControllerTest do",
							"  use {dirname|camelcase|capitalize}.ConnCase, async: true",
							"end",
						},
					},
					["lib/**/channels/*_channel.ex"] = {
						type = "channel",
						alternate = "test/{dirname}/channels/{basename}_channel_test.exs",
						template = {
							"defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel do",
							"  use {dirname|camelcase|capitalize}, :channel",
							"end",
						},
					},
					["test/**/channels/*_channel_test.exs"] = {
						alternate = "lib/{dirname}/channels/{basename}_channel.ex",
						type = "test",
						template = {
							"defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ChannelTest do",
							"  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel",
							"",
							"  use {dirname|camelcase|capitalize}.ChannelCase, async: true",
							"end",
						},
					},
					["test/**/features/*_test.exs"] = {
						type = "feature",
						template = {
							"defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Test do",
							"  use {dirname|camelcase|capitalize}.FeatureCase, async: true",
							"end",
						},
					},
					["lib/*.ex"] = {
						alternate = "test/{}_test.exs",
						type = "source",
						template = { "defmodule {camelcase|capitalize|dot} do", "end" },
					},
					["test/*_test.exs"] = {
						alternate = "lib/{}.ex",
						type = "test",
						template = {
							"defmodule {camelcase|capitalize|dot}Test do",
							"  alias {camelcase|capitalize|dot}",
							"",
							"  use ExUnit.Case, async: true",
							"end",
						},
					},
				},
			}
		end,
	},
	-- bdelete, <leader>c
	{ "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56", event = "VeryLazy" },
	-- maximize the window by <leader>z
	{ "szw/vim-maximizer", commit = "2e54952fe91e140a2e69f35f22131219fcd9c5f1", event = "VeryLazy" },
	{ "mbbill/undotree", commit = "485f01efde4e22cb1ce547b9e8c9238f36566f21", event = "VeryLazy" },
}
