-- Planet Avenue: the satellites planet's app store lists, published as-is at
-- https://avenue.heyplanet.app/apps.json (Cloudflare Pages).
--
--   xmake validate        check apps.json
--
-- apps.json is a list of package addresses. planet installs each by
-- downloading it (crates/planet-web/src/store.rs); the file name names the
-- installed app.

set_project("planet-avenue")

task("validate")
    set_category("action")
    on_run(function ()
        import("core.base.json")

        local list = json.loadfile(path.join(os.projectdir(), "apps.json"))
        local errors = {}
        local names = {}
        if type(list) ~= "table" or (#list == 0 and next(list) ~= nil) then
            table.insert(errors, "apps.json must be a list of addresses")
            list = {}
        end
        for i, url in ipairs(list) do
            if type(url) ~= "string" or not url:match("^https://") then
                table.insert(errors, format("[%d]: %s is not an https:// address", i, tostring(url)))
            else
                local name = url:match("([^/?#]+%.satellite)$")
                if not name then
                    table.insert(errors, format("[%d]: %s doesn't end in a .satellite file name", i, url))
                elseif names[name] then
                    -- The file name is the installed app's id: two with the
                    -- same one would replace each other.
                    table.insert(errors, format("[%d]: %s is already listed", i, name))
                else
                    names[name] = true
                end
            end
        end

        if #errors > 0 then
            for _, e in ipairs(errors) do
                cprint("${red}%s${clear}", e)
            end
            raise("apps.json has %d problem(s)", #errors)
        end
        cprint("${bright green}ok${clear} %d app(s)", #list)
    end)
    set_menu {
        usage = "xmake validate",
        description = "Check apps.json",
        options = {}
    }
