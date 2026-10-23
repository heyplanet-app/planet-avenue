-- Planet Avenue: the list of satellites planet's app store shows.
--
--   xmake validate        check satellites.json against the rules in satellites.schema.json
--
-- planet reads satellites.json (crates/planet-web/src/store.rs) and installs
-- each entry from the newest GitHub release of its repository that carries
-- its asset.

set_project("planet-avenue")

task("validate")
    set_category("action")
    on_run(function ()
        import("core.base.json")

        local file = path.join(os.projectdir(), "satellites.json")
        local doc = json.loadfile(file)
        local errors = {}
        local function fail(fmt, ...)
            table.insert(errors, format(fmt, ...))
        end

        if doc.schemaVersion ~= "v1" then
            fail("schemaVersion must be \"v1\"")
        end
        local allowed_top = {["$schema"] = true, schemaVersion = true, satellites = true}
        for key, _ in pairs(doc) do
            if not allowed_top[key] then
                fail("unknown top-level field %q", key)
            end
        end
        if type(doc.satellites) ~= "table" then
            fail("satellites must be a list")
            doc.satellites = {}
        end

        local allowed = {id = true, name = true, description = true, repository = true, asset = true}
        local ids, assets = {}, {}
        for i, s in ipairs(doc.satellites) do
            local where = format("satellites[%d]", i)
            for key, _ in pairs(s) do
                if not allowed[key] then
                    fail("%s: unknown field %q", where, key)
                end
            end
            for _, key in ipairs({"id", "name", "repository", "asset"}) do
                if type(s[key]) ~= "string" or s[key] == "" then
                    fail("%s: %s is required", where, key)
                end
            end
            if s.description ~= nil and type(s.description) ~= "string" then
                fail("%s: description must be a string", where)
            end
            if type(s.id) == "string" then
                if not s.id:match("^[a-z][a-z0-9%-]*$") then
                    fail("%s: id %q must be lowercase letters, digits and -", where, s.id)
                end
                if ids[s.id] then
                    fail("%s: id %q is already used", where, s.id)
                end
                ids[s.id] = true
            end
            if type(s.repository) == "string" and not s.repository:match("^[%w_.%-]+/[%w_.%-]+$") then
                fail("%s: repository %q must be owner/name", where, s.repository)
            end
            if type(s.asset) == "string" then
                if not s.asset:match("^[%w_.%-]+%.satellite$") then
                    fail("%s: asset %q must be a .satellite file name", where, s.asset)
                end
                -- The asset's name is the installed app's id: two entries
                -- with the same one would replace each other.
                if assets[s.asset] then
                    fail("%s: asset %q is already listed", where, s.asset)
                end
                assets[s.asset] = true
            end
        end

        if #errors > 0 then
            for _, e in ipairs(errors) do
                cprint("${red}%s${clear}", e)
            end
            raise("satellites.json has %d problem(s)", #errors)
        end
        cprint("${bright green}ok${clear} %d satellite(s)", #doc.satellites)
    end)
    set_menu {
        usage = "xmake validate",
        description = "Check satellites.json",
        options = {}
    }
