use comfy_table::{Cell, Color, Table, ContentArrangement};
use comfy_table::presets::UTF8_FULL;
use clap::Parser;
use std::env; // Standard library for accessing env variables 
use std::fs::File;
use std::io::{self, Write};

#[derive(Parser, Debug)]
#[command(author, version, about = "A simple CLI to display environment variables in a colored table.", long_about = None)]
struct Args {
    /// Optional: File path to write the output to.
    #[arg(short, long)]
    output: Option<String>,
}

fn main() -> io::Result<()> {
    let args = Args::parse();

    let mut table = Table::new();
    table
        .load_preset(UTF8_FULL)
        .set_content_arrangement(ContentArrangement::Dynamic)
        .set_header(vec![
            Cell::new("Variable").fg(Color::Blue),
            Cell::new("Value").fg(Color::Blue),
        ]);

    let vars: Vec<(String, String)> = env::vars().collect(); // Variables being collected here into a Vector
    let max_width = if let Some((width, _)) = term_size::dimensions() {
        width
    } else {
        80 // Default width if terminal size can't be determined
    };

    // Adjust table width to fit the terminal
    table.set_width(max_width as u16);

    for (key, value) in vars {
        table.add_row(vec![
            Cell::new(key).fg(Color::Green),
            Cell::new(value).fg(Color::Yellow),
        ]);
    }

    let table_output = table.to_string();
    
    match args.output {
        Some(file_path) => {
            let mut file = File::create(&file_path)?;
            // comfy-table does not support writing colored output to a file directly.
            // Writing the plain table string.
            writeln!(file, "{}", table_output)?;
            println!("Output successfully written to {}", file_path);
        }
        None => {
            println!("{table}");
        }
    }

    Ok(())
}