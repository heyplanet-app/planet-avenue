-- Planet Avenue: the satellites planet's app store lists, published as-is at
-- https://avenue.heyplanet.app/apps.json (Cloudflare Pages).
--
--   xmake validate        check apps.json
--
-- apps.json is a list of GitHub repository addresses. planet reads the rest
-- from each repository (crates/planet-web/src/store.rs): name, description
-- and version from manifest.yaml, the icon from icon.* at its root, the
-- package from <manifest id>.satellite in its newest release.

set_project("planet-avenue")

task("validate")
    set_category("action")
    on_run(function ()
        import("core.base.json")

        local list = json.loadfile(path.join(os.projectdir(), "apps.json"))
        local errors = {}
        local seen = {}
        if type(list) ~= "table" or (#list == 0 and next(list) ~= nil) then
            table.insert(errors, "apps.json must be a list of repository addresses")
            list = {}
        end
        for i, url in ipairs(list) do
            local repo = type(url) == "string" and url:match("^https://github%.com/([%w_.%-]+/[%w_.%-]+)/?$")
            if not repo then
                table.insert(errors, format("[%d]: %s is not https://github.com/<owner>/<name>", i, tostring(url)))
            elseif seen[repo:lower()] then
                table.insert(errors, format("[%d]: %s is already listed", i, repo))
            else
                seen[repo:lower()] = true
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
