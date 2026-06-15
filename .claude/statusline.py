#!/usr/bin/env python3
"""Claude Code status line.

Inline: 5h & 7d rate limits (thin bar + % + local reset time), then
context as used/total tokens. Reads the JSON Claude Code pipes in on
stdin. Requires Claude Code v2.1+ for the rate_limits block.
"""
import json
import sys
import time

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")

data = json.load(sys.stdin)

R = "\033[0m"
DIM = "\033[2m"
PURPLE = "\033[38;2;184;176;245m"  # Claude progress lavender
WIDTH = 8  # bar cells


def bar(pct, width=WIDTH):
    """Square bar: purple filled squares, dim empty squares."""
    pct = min(max(pct, 0), 100)
    full = min(round(pct * width / 100), width)
    return f"{PURPLE}{'▰' * full}{R}{DIM}{'▱' * (width - full)}{R}"


def human(n):
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M".replace(".0M", "M")
    if n >= 1_000:
        return f"{round(n / 1_000)}k"
    return str(n)


def at(epoch, with_day=False):
    if not epoch:
        return ""
    fmt = "%a %-I:%M%p" if with_day else "%-I:%M%p"
    return f" {DIM}{time.strftime(fmt, time.localtime(epoch)).lower()}{R}"


# Rate limits, then context — all inline
parts = []
rl = data.get("rate_limits", {})
for key, with_day in (("five_hour", False), ("seven_day", True)):
    w = rl.get(key, {})
    p = w.get("used_percentage")
    if p is not None:
        parts.append(f"{bar(p)} {round(p)}%{at(w.get('resets_at'), with_day)}")

cw = data.get("context_window", {})
ctx = cw.get("used_percentage")
if ctx is not None:
    size = cw.get("context_window_size") or 0
    used = cw.get("total_input_tokens") or round(ctx / 100 * size)
    parts.append(f"{human(used)}{DIM}/{human(size)}{R}" if size else f"{round(ctx)}%")

print(f"{DIM} │ {R}".join(parts), end="")
