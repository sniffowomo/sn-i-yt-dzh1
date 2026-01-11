# Implementation Notes for `envdump` CLI

This document outlines the implementation details, design choices, and usage instructions for the `envdump` command-line tool.

## 1. Project Goal

The primary goal of this project was to create a simple, readable, and well-documented Rust CLI tool to display environment variables. The key requirements were:

- Scan and display all exported environment variables.
- Present the output in a clean, colored, tabular format in the terminal.
- Provide an option to write the (uncolored) output to a text file.
- Maintain idiomatic and modular Rust code.

## 2. Design and Crate Choices

To meet the project requirements efficiently, the following external crates were chosen:

| Crate         | Version | Purpose                                                                                             | Justification                                                                                             |
|---------------|---------|-----------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| `clap`        | 4.5.x   | Command-Line Argument Parser                                                                        | `clap` is the de-facto standard for building CLIs in Rust. Its derive macros make argument parsing trivial and robust. |
| `comfy-table` | 7.2.x   | Formatted and colored terminal tables                                                               | This crate provides an easy-to-use API for creating aesthetically pleasing and dynamically arranged tables, which was a core requirement. It handles terminal width detection and coloring automatically. |
| `term_size`   | 0.3.x   | (Dependency of `comfy-table`) Detects terminal width                                                | Used to make the table responsive to the user's terminal size, preventing awkward wrapping and improving readability. |

The standard library's `std::env::vars()` function was used to fetch the environment variables, and `std::fs::File` for file I/O.

## 3. Code Structure

The application logic is contained entirely within `src/main.rs`.

- **`Args` struct**: This struct uses `clap::Parser` to define the CLI's interface. It includes one optional argument, `--output` (or `-o`), to specify a file path for the output.
- **`main()` function**:
    1.  Parses the command-line arguments using `Args::parse()`.
    2.  Initializes a `comfy_table::Table` with a preset style (`UTF8_FULL`) and dynamic content arrangement.
    3.  Detects the terminal width to ensure the table fits the screen without overflow.
    4.  Fetches environment variables using `std::env::vars()`.
    5.  Iterates through the variables, adding each key-value pair as a new row to the table.
    6.  Checks if an `--output` path was provided:
        - If **yes**, it creates the specified file and writes the plain string representation of the table to it.
        - If **no**, it prints the fully-featured, colored table directly to the console.
    7.  Returns a `std::io::Result<()>` for standard error handling.

## 4. How to Build and Run

The tool can be built and run using standard Cargo commands from within the `envdump` directory.

**Build the project:**
```bash
cargo build --release
```
The executable will be located at `target/release/envdump`.

**Run the application:**

*   **Display variables in the terminal:**
    ```bash
    cargo run
    ```

*   **Show the help menu:**
    ```bash
    cargo run -- --help
    ```

*   **Write variables to a file:**
    ```bash
    cargo run -- --output env_vars.txt
    ```

This completes the implementation of the `envdump` tool as per the project requirements.

## 5. Version History

### Version 0.1.0
- Initial release.

### Version 0.1.1
- Added color to the table output for better readability.
  - Headers are now blue.
  - Variable names are green.
  - Variable values are yellow.
- Added a descriptive help message to the `--help` flag.

