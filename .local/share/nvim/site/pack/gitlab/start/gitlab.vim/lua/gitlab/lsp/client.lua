local notifier = require('gitlab.notifier')
local lspconfig = require('gitlab.lspconfig')
local validate = require('gitlab.config.validate')

-- Lua module: gitlab.lsp.client
local M = {}

function M.start(options)
  vim.validate({
    ['options.auth'] = { options.auth, 'table' },
    ['options.cmd'] = { options.cmd, validate.is_string_list },
    ['options.handlers'] = { options.handlers, validate.is_dict_of('function') },
    ['options.workspace'] = { options.workspace, 'table' },
  })

  local config = require('gitlab.config').current()
  local settings = vim.tbl_extend(
    'keep',
    options.workspace.configuration,
    config.language_server.workspace_settings
  )
  settings = vim.tbl_extend('force', settings, {
    baseUrl = options.auth.url(),
    token = options.auth.token(),
  })
  local client_id = lspconfig.setup({
    cmd = options.cmd,
    handlers = options.handlers,
    name = 'gitlab_code_suggestions',
    root_dir = vim.fn.getcwd(),
    settings = settings,
    on_init = function(client, _initialize_result)
      client.offset_encoding = config.code_suggestions.offset_encoding

      options.workspace.subscribe_client(client.id)
      options.workspace:change_configuration(settings)
    end,
  })

  return {
    client_id = client_id,
    stop = function()
      notifier.notify(
        'gitlab.vim: Stopping GitLab LSP client ' .. client_id .. '...',
        vim.lsp.log_levels.DEBUG
      )
      vim.lsp.stop_client(client_id)
    end,
    notify = function(self, ...)
      local client = vim.lsp.get_client_by_id(self.client_id)
      return client and client.notify(...)
    end,
    workspace = options.workspace,
  }
end

return M
