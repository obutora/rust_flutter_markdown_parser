use std::vec;

use sysinfo::{CpuExt, System, SystemExt};

pub fn hello() -> String {
    String::from("Hello from Rust! 🦀")
}

pub fn markdown_to_html(markdown: String) -> String {
    let parser = pulldown_cmark::Parser::new(&markdown);

    let mut html_output = String::new();
    pulldown_cmark::html::push_html(&mut html_output, parser);

    html_output
}



pub fn system_info() -> f64 {
    let mut sys = System::new_all();
    sys.refresh_all();

    println!("total memory: {} bytes", sys.total_memory());
    println!("used memory : {} bytes", sys.used_memory());

    sys.refresh_cpu(); // Refreshing CPU information.
    let mut cpu_usages = vec![];

    for cpu in sys.cpus() {
        cpu_usages.push(cpu.cpu_usage());
    }
    println!("avg cpu usage {} %", cpu_usages.iter().sum::<f32>() / cpu_usages.len() as f32);
    // println!("total swap  : {} bytes", sys.total_swap());
    // println!("used swap   : {} bytes", sys.used_swap());

    return (100 * sys.used_memory() / sys.total_memory()) as f64;
}
