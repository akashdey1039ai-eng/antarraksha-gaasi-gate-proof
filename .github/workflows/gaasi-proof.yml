name: 'GAASI Survivability Gate'
description: 'Pre-deployment AI agent certification via ANTARRAKSHA Survivability Gate. Blocks uncertified agents from shipping.'
branding:
  icon: 'shield'
  color: 'blue'

inputs:
  api_url:
    description: 'Survivability Gate API endpoint'
    required: false
    default: 'https://antarraksha.ai/api/survivability-gate/evaluate'
  api_key:
    description: 'ANTARRAKSHA API key (use GitHub Secrets)'
    required: true
  agent_payload_path:
    description: 'Path to agent JSON payload file'
    required: false
    default: 'gaasi-agent.json'
  fail_on:
    description: 'Verdict that fails the pipeline (BLOCKED, CONDITIONAL, or NONE)'
    required: false
    default: 'BLOCKED'
  timeout_seconds:
    description: 'Maximum seconds to wait for evaluation response'
    required: false
    default: '180'

outputs:
  verdict:
    description: 'GAASI verdict: CERTIFIED, CONDITIONAL, or BLOCKED'
    value: ${{ steps.gate.outputs.verdict }}
  gaasi_score:
    description: 'GAASI score (0-1000)'
    value: ${{ steps.gate.outputs.gaasi_score }}
  evidence_id:
    description: 'Unique evidence identifier for this evaluation'
    value: ${{ steps.gate.outputs.evidence_id }}
  evidence_hash:
    description: 'SHA-256 evidence hash for cryptographic verification'
    value: ${{ steps.gate.outputs.evidence_hash }}
  public_verdict_url:
    description: 'Public URL to view the verdict'
    value: ${{ steps.gate.outputs.public_verdict_url }}

runs:
  using: 'composite'
  steps:
    - name: Run GAASI Survivability Gate
      id: gate
      shell: bash
      env:
        GAASI_API_URL: ${{ inputs.api_url }}
        GAASI_API_KEY: ${{ inputs.api_key }}
        GAASI_PAYLOAD_PATH: ${{ inputs.agent_payload_path }}
        GAASI_FAIL_ON: ${{ inputs.fail_on }}
        GAASI_TIMEOUT: ${{ inputs.timeout_seconds }}
        INPUT_API_URL: ${{ inputs.api_url }}
        INPUT_API_KEY: ${{ inputs.api_key }}
        INPUT_AGENT_PAYLOAD_PATH: ${{ inputs.agent_payload_path }}
        INPUT_FAIL_ON: ${{ inputs.fail_on }}
        INPUT_TIMEOUT_SECONDS: ${{ inputs.timeout_seconds }}
      run: chmod +x ${{ github.action_path }}/entrypoint.sh && ${{ github.action_path }}/entrypoint.sh
