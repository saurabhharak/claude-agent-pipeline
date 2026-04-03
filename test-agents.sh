#!/bin/bash
# Smoke test all agents — verifies they load, see their role, tools, and skills.
# Usage: bash test-agents.sh
# Requires: claude CLI installed, API key configured
# Cost: ~9 small API calls (one per agent, max 1 turn each)

set -e

PASS=0
FAIL=0
AGENTS=("manager" "brainstormer" "architect" "arch-reviewer" "security-reviewer" "ux-designer" "ux-reviewer" "implementer" "code-reviewer")

echo "=== Agent Smoke Test ==="
echo ""

for agent in "${AGENTS[@]}"; do
  echo -n "Testing $agent... "

  RESULT=$(claude --agent "$agent" -p "System check. Reply with EXACTLY this format and nothing else:
ROLE: [your role title]
TOOLS: [comma-separated list of tools you have]
SKILLS: [comma-separated list of skills assigned to you]" \
    --max-turns 1 2>&1) || {
    echo "FAIL (agent failed to load)"
    FAIL=$((FAIL + 1))
    continue
  }

  if echo "$RESULT" | grep -qi "ROLE:"; then
    echo "PASS"
    echo "  $RESULT" | head -3 | sed 's/^/  /'
    PASS=$((PASS + 1))
  else
    echo "FAIL (unexpected response)"
    echo "  $RESULT" | head -3 | sed 's/^/  /'
    FAIL=$((FAIL + 1))
  fi
  echo ""
done

echo "=== Results: $PASS passed, $FAIL failed out of ${#AGENTS[@]} agents ==="

# Test manager can see its sub-agents
echo ""
echo "=== Manager Delegation Test ==="
echo -n "Testing manager can see sub-agents... "
RESULT=$(claude --agent manager -p "List every sub-agent you can delegate to. Reply with just the names, comma-separated." \
  --max-turns 1 2>&1) || {
  echo "FAIL"
  exit 1
}

EXPECTED_AGENTS=("brainstormer" "architect" "arch-reviewer" "security-reviewer" "ux-designer" "ux-reviewer" "implementer" "code-reviewer")
MISSING=0
for sub in "${EXPECTED_AGENTS[@]}"; do
  if ! echo "$RESULT" | grep -qi "$sub"; then
    echo ""
    echo "  MISSING: $sub"
    MISSING=$((MISSING + 1))
  fi
done

if [ $MISSING -eq 0 ]; then
  echo "PASS (all 8 sub-agents visible)"
else
  echo "FAIL ($MISSING sub-agents missing)"
fi

echo ""
echo "=== Smoke test complete ==="
