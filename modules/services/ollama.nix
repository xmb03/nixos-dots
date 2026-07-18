{ config, pkgs, ... }:

let
  inherit (config.users.users.xmb03) home;

  strictSystemPrompt = ''
    You are a strict, hyper-focused technical assistant. Efficiency and directness are your top priorities.

    CONTENT RULES:
    1. NO EMOJIS: Never use emojis, stickers, or any visual fluff under any circumstances.
    2. NO PLEASANTRIES: Do not use introductory or concluding remarks. Absolutely no conversational filler (e.g., "Sure, I can help", "Let me know if you need more"). Start directly with the answer.
    3. MINIMALISM: Provide the shortest possible answer that completely resolves the query. Cut all text formatting or commentary that doesn't add direct value.
    4. TARGET FORMAT: If the query requires code, output only the raw code block. If it requires a list, use clean, short bullet points.
    5. TONE: Strictly professional, dry, objective, and matter-of-fact.

    SELF-VERIFICATION (thinking process only, not in final output):
    During your thinking process, you MUST:
    - Interrogate your own reasoning step by step
    - Ask yourself "Is this correct? What am I missing? What assumptions am I making?"
    - Identify potential errors, edge cases, or oversimplifications
    - Validate each conclusion before proceeding to the next
    - If you find an error, trace back to its source and correct it
    - Do NOT output any of this self-verification in the final answer
  '';

  modelfile = pkgs.writeText "gemma-4-e4b-strict.Modelfile" ''
FROM /home/xmb03/ai-models/CQ_Gemma4_E4B_f16_Q4_K.gguf
PARAMETER temperature 0
PARAMETER num_ctx 131072
SYSTEM """${strictSystemPrompt}"""
'';
in
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama;
    host = "127.0.0.1";
    port = 11434;
    openFirewall = false;
  };

  systemd.services.configure-ollama-models = {
    description = "Create Ollama models with temperature 0 and strict system prompt";
    after = [ "ollama.service" ];
    wants = [ "ollama.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.ollama-cuda ];

    script = ''
      for i in $(seq 1 30); do
        OLLAMA_HOST=127.0.0.1:11434 HOME=/var/lib/ollama ollama list > /dev/null 2>&1 && break
        sleep 1
      done

      if ! OLLAMA_HOST=127.0.0.1:11434 HOME=/var/lib/ollama ollama list 2>/dev/null | grep -q "gemma-4-e4b-strict"; then
        OLLAMA_HOST=127.0.0.1:11434 HOME=/var/lib/ollama ollama create gemma-4-e4b-strict -f ${modelfile} || true
      fi

      mkdir -p ${home}/.ollama
      cat > ${home}/.ollama/config.json << 'CONFIG'
{
  "last_model": "gemma-4-e4b-strict",
  "last_selection": "run"
}
CONFIG
      chown xmb03:users ${home}/.ollama ${home}/.ollama/config.json
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
