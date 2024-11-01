(* Run as `ocaml gen.ml` *)

let count = 1000

let () =
  Out_channel.with_open_text "dune" (fun dunech ->
      let dprintfn fmt = Format.kasprintf (Printf.fprintf dunech "%s\n") fmt in
      dprintfn "; This file was autogenerated\n";
      dprintfn "(cram (deps ../src/Driver.exe ../runtime/Std.i))\n";

      for i = 0 to count - 1 do
        let cram_buf = Buffer.create 100 in
        let cram_printfn fmt =
          Format.kasprintf (Printf.bprintf cram_buf "%s\n") fmt
        in
        let cram_file = ref (Printf.sprintf "test%03d.t" i) in
        let lama_file = ref (Printf.sprintf "test%03d.lama" i) in
        let input_file = ref (Printf.sprintf "test%03d.input" i) in


        let found =
          if Sys.file_exists !lama_file then (
            cram_printfn
              "../src/Driver.exe -i test%03d.lama < \
               test%03d.input"
              i i;
            true)
          else   false
        in
        if found then (
          dprintfn "(cram (applies_to test%03d)"            i;
          dprintfn "  (deps %s %s))" !lama_file !input_file;
          Out_channel.with_open_text !cram_file (fun ch ->
              output_string ch (Buffer.contents cram_buf)))
      done)
