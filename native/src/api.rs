pub fn hello() -> String {
    String::from("Hello from Rust! 🦀")
}

pub fn markdown_to_html(markdown : String) -> String {
    let parser = pulldown_cmark::Parser::new(&markdown);

    let mut html_output = String::new();
    pulldown_cmark::html::push_html(&mut html_output, parser);

    html_output
}