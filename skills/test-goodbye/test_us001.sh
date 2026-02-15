#!/bin/bash
# Test for US-001: Create test-goodbye skill structure

SKILL_DIR="/home/setrox/.openclaw/skills/test-goodbye"
SKILL_FILE="$SKILL_DIR/SKILL.md"

if [ -d "$SKILL_DIR" ]; then
    echo "PASS: Directory $SKILL_DIR exists"
else
    echo "FAIL: Directory $SKILL_DIR does not exist"
    exit 1
fi

if [ -f "$SKILL_FILE" ]; then
    echo "PASS: File $SKILL_FILE exists"
else
    echo "FAIL: File $SKILL_FILE does not exist"
    exit 1
fi

if grep -q "name: test-goodbye" "$SKILL_FILE"; then
    echo "PASS: SKILL.md contains 'name: test-goodbye'"
else
    echo "FAIL: SKILL.md does not contain 'name: test-goodbye'"
    exit 1
fi

if grep -q "Echo 'Goodbye, World!'" "$SKILL_FILE"; then
    echo "PASS: SKILL.md contains 'Echo 'Goodbye, World!''"
else
    echo "FAIL: SKILL.md does not contain 'Echo 'Goodbye, World!''"
    exit 1
fi

echo "All US-001 tests passed!"
exit 0
