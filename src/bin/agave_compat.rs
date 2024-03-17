use clap::Parser;
use prost::Message;
use solfuzz_agave::proto::InstrContext;
use std::path::PathBuf;

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
    inputs: Vec<PathBuf>,
}

fn exec(input: &PathBuf) {
    let blob = std::fs::read(input).unwrap();
    let context = InstrContext::decode(&blob[..]).unwrap();
    let effects = solfuzz_agave::execute_instr_proto(context).unwrap();
    eprintln!("Effects: {:?}", effects);
}

fn main() {
    let cli = Cli::parse();
    for input in cli.inputs {
        exec(&input);
    }
}