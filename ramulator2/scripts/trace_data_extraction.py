import os
import re
import json
from collections import defaultdict

KEY_SEP = re.compile(r'\s*[:=,]\s*', re.IGNORECASE)

def parse_number_nj_to_mj(s: str):
    """Parse number from string and convert nJ -> mJ."""
    m = re.search(r'([-+]?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)', s)
    if not m:
        return None
    return float(m.group(1)) * 1e-6  # convert nJ to mJ

def parse_number_plain(s: str):
    """Parse integer number (for cycles)."""
    m = re.search(r'([-+]?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)', s)
    return int(float(m.group(1))) if m else None

def is_utilization_array_line(key: str, val: str) -> bool:
    key_l = key.lower()
    if 'utilization' in key_l and ('[' in val or ']' in val):
        return True
    if 'bandwidth_utilization' in key_l:
        return True
    return False

def base_name_without_part(filename_noext: str) -> str:
    m = re.match(r'(.+?)(\d+)?$', filename_noext)
    return m.group(1) if m else filename_noext

def parse_log_file(path: str):
    out = {
        'total_energy_mJ': 0.0,
        'total_refresh_energy_mJ': 0.0,
        'total_wupr_energy_mJ': 0.0,
        'memory_system_cycles': 0,
        'average_bandwidth': 0.0
    }

    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        for raw in f:
            line = raw.strip()
            if not line or line.startswith('#'):
                continue

            parts = KEY_SEP.split(line, maxsplit=1)
            if len(parts) != 2:
                tokens = line.split()
                if len(tokens) >= 2:
                    key = tokens[0]
                    val = ' '.join(tokens[1:])
                else:
                    continue
            else:
                key, val = parts[0].strip(), parts[1].strip()

            if is_utilization_array_line(key, val):
                continue

            key_l = key.lower()

            if key_l == 'total_energy':
                v = parse_number_nj_to_mj(val)
                if v is not None:
                    out['total_energy_mJ'] += v
                continue

            if key_l == 'total_refresh_energy':
                v = parse_number_nj_to_mj(val)
                if v is not None:
                    out['total_refresh_energy_mJ'] += v
                continue

            if key_l == 'total_wupr_energy':
                v = parse_number_nj_to_mj(val)
                if v is not None:
                    out['total_wupr_energy_mJ'] += v
                continue

            if 'memory_system_cycles' in key_l:
                v = parse_number_plain(val)
                if v is not None:
                    out['memory_system_cycles'] += v
                continue

            if 'average_bandwidth' in key_l:
                try:
                    v = float(val)
                    out['average_bandwidth'] += v
                except ValueError:
                    pass
                continue

    return out

def format_float_2dp(value):
    """Format a float with exactly 2 decimal places."""
    return float(f"{value:.2f}")

def process_log_files(log_dir, output_json='Temperature_log_aggregate.json'):
    groups = {}
    counts = defaultdict(int)

    for filename in os.listdir(log_dir):
        if not filename.endswith('.log'):
            continue

        base = base_name_without_part(os.path.splitext(filename)[0])
        path = os.path.join(log_dir, filename)

        parsed = parse_log_file(path)

        if base not in groups:
            groups[base] = {
                'total_energy_mJ': 0.0,
                'total_refresh_energy_mJ': 0.0,
                'total_wupr_energy_mJ': 0.0,
                'memory_system_cycles': 0,
                'average_bandwidth_sum': 0.0
            }

        g = groups[base]
        g['total_energy_mJ'] += parsed['total_energy_mJ']
        g['total_refresh_energy_mJ'] += parsed['total_refresh_energy_mJ']
        g['total_wupr_energy_mJ'] += parsed['total_wupr_energy_mJ']
        g['memory_system_cycles'] += parsed['memory_system_cycles']
        g['average_bandwidth_sum'] += parsed['average_bandwidth']

        counts[base] += 1

    result = []
    for base, agg in groups.items():
        n = counts[base]
        result.append({
            "name": base,
            "total_energy_mJ": format_float_2dp(agg['total_energy_mJ']),
            "total_refresh_energy_mJ": format_float_2dp(agg['total_refresh_energy_mJ']),
            "total_wupr_energy_mJ": format_float_2dp(agg['total_wupr_energy_mJ']),
            "memory_system_cycles": agg['memory_system_cycles'],
            "average_bandwidth_GBps": format_float_2dp((agg['average_bandwidth_sum'] / n) if n > 0 else 0)
        })

    with open(output_json, 'w', encoding='utf-8') as jf:
        json.dump(result, jf, indent=2)

    for row in result:
        print(row)

# Example:
process_log_files('../traces_log/', 'subarray_analysis_trace_summary.json')
