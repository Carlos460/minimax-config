-- "Launch from script" support for nvim-dap (ported from the old config): parse a
-- shell script that runs your program into a codelldb launch config.

local M = {}

-- Build a launch config from a shell script that runs your program, e.g.
--   #!/bin/sh
--   cd build
--   gdb --args ./my_app --config ../conf.yaml -n 5 "arg with spaces" 2>&1
-- The script's last command is treated as the program invocation (a leading
-- `gdb ... --args` / `lldb ... --` wrapper is dropped). Earlier lines (cd,
-- variable assignments, ...) are executed normally, from Neovim's cwd, so
-- quoting, $VARS, relative paths and `cd` behave just like running the script
-- from a terminal in that directory. The last command is NOT executed; its
-- words are captured instead.
function M.config_from_script(script)
  local name = vim.fn.fnamemodify(script, ":t")
  local lines = vim.fn.readfile(script)

  -- find the last non-empty, non-comment line ...
  local last
  for i = #lines, 1, -1 do
    if lines[i]:match "%S" and not lines[i]:match "^%s*#" then
      last = i
      break
    end
  end
  if not last then
    return nil, name .. " has no command"
  end
  -- ... and walk back over backslash line continuations
  local first = last
  while first > 1 and lines[first - 1]:match "\\%s*$" do
    first = first - 1
  end

  lines[first] = "__dap_capture " .. lines[first]:gsub("^%s*exec%s+", ""):gsub("^%s+", "")
  table.insert(lines, 1, [[__dap_capture() { printf '%s\0' "$PWD" "$@"; exit 0; }]])
  -- run from Neovim's cwd, like running `./path/to/script.sh` from a terminal
  -- there (relative paths in the script are relative to that, not to the script)

  local tmp = vim.fn.tempname()
  vim.fn.writefile(lines, tmp)
  local res = vim.system({ "bash", tmp }, { text = true, cwd = vim.fn.getcwd() }):wait()
  os.remove(tmp)

  local words = vim.split(res.stdout or "", "\0", { plain = true, trimempty = true })
  if #words < 2 then
    return nil, "could not parse " .. name .. ": " .. (res.stderr or "")
  end

  local cwd = table.remove(words, 1)

  -- strip a debugger wrapper: `gdb [opts] --args prog ...` / `lldb [opts] -- prog ...`
  local wrapper = vim.fs.basename(words[1])
  if wrapper:match "^gdb" or wrapper:match "^lldb" then
    for i, w in ipairs(words) do
      if w == "--args" or w == "--" then
        words = vim.list_slice(words, i + 1)
        break
      end
    end
  end
  if #words == 0 then
    return nil, "no program found in " .. name
  end

  local program = table.remove(words, 1)
  if not program:find "/" then
    program = vim.fn.exepath(program) ~= "" and vim.fn.exepath(program) or program
  elseif program:sub(1, 1) ~= "/" then
    program = vim.fs.normalize(cwd .. "/" .. program)
  end

  return {
    name = "Launch from " .. name,
    type = "codelldb",
    request = "launch",
    program = program,
    args = words,
    cwd = cwd,
    stopOnEntry = false,
  }
end

-- last script picked, offered as the default next time (kept for the session)
local last_script

-- When the "Launch from script" entry is picked, ask for the script and
-- replace the placeholder config with the one parsed from that script.
function M.setup(dap)
  dap.listeners.on_config["launch-from-script"] = function(config)
    if not config.launch_from_script then
      return config
    end
    local input = vim.fn.input("Launch script: ", last_script or (vim.fn.getcwd() .. "/"), "file")
    if input == "" then
      error "dap: no launch script given"
    end
    local script = vim.fn.fnamemodify(vim.fn.expand(input), ":p")
    if vim.fn.filereadable(script) == 0 then
      error("dap: not a readable file: " .. script)
    end
    last_script = script
    local new_config, err = M.config_from_script(script)
    if not new_config then
      error("dap: " .. err)
    end
    vim.notify(("dap: %s %s"):format(new_config.program, table.concat(new_config.args, " ")))
    return new_config
  end
end

return M
