#if arch(wasm32)
import JavaScriptKit
#endif

public enum Tag {
    protocol Href {}

    public enum a: Href {}
    public enum abbr {}
    public enum address {}
    public enum area: Href {}
    public enum article {}
    public enum aside {}
    public enum audio {}
    public enum b {}
    public enum base {}
    public enum bdi {}
    public enum bdo {}
    public enum blockqote {}
    public enum body {}
    public enum br {}
    public enum button {}
    public enum canvas {}
    public enum caption {}
    public enum cite {}
    public enum code {}
    public enum col {}
    public enum colgroup {}
    public enum data {}
    public enum datalist {}
    public enum dd {}
    public enum del {}
    public enum details {}
    public enum dfn {}
    public enum dialog {}
    public enum div {}
    public enum dl {}
    public enum dt {}
    public enum em {}
    public enum embed {}
    public enum fieldset {}
    public enum figcaption {}
    public enum figure {}
    public enum footer {}
    public enum form {}
    public enum h {}
    public enum head {}
    public enum header {}
    public enum hgroup {}
    public enum hr {}
    public enum html {}
    public enum i {}
    public enum iframe {}
    public enum img {}
    public enum input {}
    public enum ins {}
    public enum kbd {}
    public enum label {}
    public enum legend {}
    public enum li {}
    public enum link: Href {}
    public enum main {}
    public enum map {}
    public enum mark {}
    public enum menu {}
    public enum meta {}
    public enum meter {}
    public enum nav {}
    public enum noscript {}
    public enum object {}
    public enum ol {}
    public enum optgroup {}
    public enum option {}
    public enum output {}
    public enum p {}
    public enum picture {}
    public enum pre {}
    public enum progress {}
    public enum q {}
    public enum rp {}
    public enum rt {}
    public enum ruby {}
    public enum s {}
    public enum samp {}
    public enum script {}
    public enum search {}
    public enum section {}
    public enum select {}
    public enum slot {}
    public enum small {}
    public enum source {}
    public enum span {}
    public enum strong {}
    public enum style {}
    public enum sub {}
    public enum summary {}
    public enum sup {}
    public enum table {}
    public enum tbody {}
    public enum td {}
    public enum template {}
    public enum textarea {}
    public enum tfoot {}
    public enum th {}
    public enum thead {}
    public enum time {}
    public enum title {}
    public enum tr {}
    public enum track {}
    public enum u {}
    public enum ul {}
    public enum `var` {}
    public enum video {}
    public enum wbr {}
}

public struct Element<T>: Node {
    let tag: StaticString
    var attr: [String: String]
    let child: Node?
    let isVoid: Bool

    init(tag: StaticString, attr: [String: String] = [:], child: Node? = nil, isVoid: Bool = false) {
        self.tag = tag
        self.attr = attr
        self.child = child
        self.isVoid = isVoid
    }

    public func render(_ ctx: ServerHydrationContext) {
        ctx.buffer.append("<\(tag)")

        if isHydratable() {
            ctx.buffer.append(" data-hk=\"\(ctx.index)\"")
            ctx.index += 1
        }

        for (key, value) in attr {
            ctx.buffer.append(" \(key)=\"\(value)\"")
        }

        if let child {
            ctx.buffer.append(">")
            child.render(ctx)
            ctx.buffer.append("</\(tag)>")
        } else if isVoid {
            ctx.buffer.append(">")
        } else {
            ctx.buffer.append("/>")
            ctx.buffer.append("</\(tag)>")
        }
    }

    #if arch(wasm32)
    public func render(_ ctx: RenderContext) -> JSValue {
        let element = ctx.document.createElement(tag)
        for (key, value) in attr {
            element.setAttribute(key, value)
        }
        if let child {
            let children = child.render(ctx)
            element.append(children)
        }
        return element
    }

    public func hydrate(_ ctx: ClientHydrationContext) {
        if !isHydratable() {
            child?.hydrate(ctx)
            return
        }
        let selector = "data-hk=\"\(ctx.index)\""

        print("Hydrating \(tag) with \(selector)")

        let ssrElement = ctx.document.querySelector("[\(selector)]")
        guard ssrElement != .undefined else { fatalError("Could not find \(selector)") }

        print("Hydrated \(tag) with \(selector)")

        ctx.index += 1
        child?.hydrate(ctx)
    }
    #endif

    func isHydratable() -> Bool {
        attr.contains(where: { $0.key.starts(with: "on") })
    }
}

// MARK: - Global attributes

extension Element {
    func accesskey(_ value: String) -> Self {
        var new = self
        new.attr["accesskey"] = value
        return new
    }

    enum Autocapitalize: String {
        case off, none, on, sentences, words, characters
    }

    func autocapitalize(_ value: Autocapitalize) -> Self {
        var new = self
        new.attr["autocapitalize"] = value.rawValue
        return new
    }

    func autofocus(_ value: Bool = true) -> Self {
        var new = self
        if value {
            new.attr["autofocus"] = ""
        } else {
            new.attr.removeValue(forKey: "autofocus")
        }
        return new
    }

    func `class`(_ value: String) -> Self {
        var new = self
        new.attr["class"] = value
        return new
    }

    func `class`(_ value: [String]) -> Self {
        var new = self
        new.attr["class"] = value.joined(separator: " ")
        return new
    }

    enum Contenteditable: String {
        case `true`, `false`, plaintextOnly = "plaintext-only"
    }

    func contenteditable(_ value: Contenteditable) -> Self {
        var new = self
        new.attr["contenteditable"] = value.rawValue
        return new
    }

    func data(key: String, value: String) -> Self {
        var new = self
        new.attr["data-\(key)"] = value
        return new
    }

    enum Dir: String {
        case ltr, rtl, auto
    }

    func dir(_ value: Dir) -> Self {
        var new = self
        new.attr["dir"] = value.rawValue
        return new
    }

    func draggable(_ value: Bool) -> Self {
        var new = self
        new.attr["draggable"] = String(value)
        return new
    }

    enum EnterKeyHint: String {
        case enter, done, go, next, previous, search, send
    }

    func enterkeyhint(_ value: EnterKeyHint) -> Self {
        var new = self
        new.attr["enterkeyhint"] = value.rawValue
        return new
    }

    func exportparts(_ value: String) -> Self {
        var new = self
        new.attr["exportparts"] = value
        return new
    }

    func hidden() -> Self {
        var new = self
        new.attr["hidden"] = ""
        return new
    }

    enum Hidden: String {
        case visible, hidden, untilFound = "until-found"
    }

    func hidden(_ value: Hidden) -> Self {
        var new = self
        switch value {
        case .visible:
            new.attr.removeValue(forKey: "hidden")
        case .hidden:
            new.attr["hidden"] = ""
        case .untilFound:
            new.attr["hidden"] = "until-found"
        }
        return new
    }

    func id(_ value: String) -> Self {
        var new = self
        new.attr["id"] = value
        return new
    }

    func inert() -> Self {
        var new = self
        new.attr["inert"] = ""
        return new
    }

    enum InputMode: String {
        case none, text, tel, url, email, numeric, decimal, search
    }

    func inputmode(_ value: InputMode) -> Self {
        var new = self
        new.attr["inputmode"] = value.rawValue
        return new
    }

    func itemid(_ value: String) -> Self {
        var new = self
        new.attr["itemid"] = value
        return new
    }

    func itemprop(_ value: String) -> Self {
        var new = self
        new.attr["itemprop"] = value
        return new
    }

    func itemref(_ value: String) -> Self {
        var new = self
        new.attr["itemref"] = value
        return new
    }

    func itemscope() -> Self {
        var new = self
        new.attr["itemscope"] = ""
        return new
    }

    func lang(_ value: String) -> Self {
        var new = self
        new.attr["lang"] = value
        return new
    }

    func nonce(_ value: String) -> Self {
        var new = self
        new.attr["nonce"] = value
        return new
    }

    func part(_ value: String) -> Self {
        var new = self
        new.attr["part"] = value
        return new
    }

    func popover() -> Self {
        var new = self
        new.attr["popover"] = ""
        return new
    }

    func slot(_ value: String) -> Self {
        var new = self
        new.attr["slot"] = value
        return new
    }

    func style(_ value: String) -> Self {
        var new = self
        new.attr["style"] = value
        return new
    }

    // func style(_ value: [String: String]) -> Self {
    //    var new = self
    //    new.attr["style"] = value
    //    return new
    // }

    func spellcheck(_ value: Bool) -> Self {
        var new = self
        new.attr["spellcheck"] = String(value)
        return new
    }

    func tabindex(_ value: Int) -> Self {
        var new = self
        new.attr["tabindex"] = String(value)
        return new
    }

    func title(_ value: String) -> Self {
        var new = self
        new.attr["title"] = value
        return new
    }

    enum Translate: String {
        case yes, no
    }

    func translate(_ value: Translate) -> Self {
        var new = self
        new.attr["translate"] = value.rawValue
        return new
    }
}

extension Element where T == Tag.button {
    public enum ButtonType: String {
        case button, submit, reset
    }

    func type(_ value: ButtonType) -> Self {
        var new = self
        new.attr["type"] = value.rawValue
        return new
    }

    func onClick(_ value: String) -> Self {
        var new = self
        new.attr["onclick"] = value
        return new
    }
}

extension Element where T: Tag.Href {
    func href(_ value: String) -> Self {
        var new = self
        new.attr["href"] = value
        return new
    }
}
