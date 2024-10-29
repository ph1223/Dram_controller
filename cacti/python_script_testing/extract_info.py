import os
import re
import csv

def extract_log_info(log_file):
    info = {}
    with open(log_file, 'r') as file:
        lines = file.readlines()

    timing_section = False
    power_section = False
    area_section = False
    tsv_section = False

    for line in lines:
        if "Timing Components:" in line:
            timing_section = True
            power_section = False
            area_section = False
            tsv_section = False
            continue
        elif "Power Components:" in line:
            timing_section = False
            power_section = True
            area_section = False
            tsv_section = False
            continue
        elif "Area Components:" in line:
            timing_section = False
            power_section = False
            area_section = True
            tsv_section = False
            continue
        elif "TSV Components:" in line:
            timing_section = False
            power_section = False
            area_section = False
            tsv_section = True
            continue

        # Extract memory parameters
        if "Total memory size (Gb)" in line:
            info['Total memory size (Gb)'] = float(line.split(':')[1].strip().split()[0])
        elif "Stacked die count" in line:
            info['Stacked die count'] = int(line.split(':')[1].strip().split()[0])
        elif "Page size" in line:
            info['Page size'] = int(line.split(':')[1].strip().split()[0])
        elif "Chip IO width" in line:
            info['Chip IO width'] = int(line.split(':')[1].strip().split()[0])

        if timing_section:
            def calculate_time_in_tck(value):
                time_in_tck = value * 1000 / 1250
                return round(time_in_tck) if time_in_tck % 1 >= 0.5 else round(time_in_tck) + 1

            if "t_RCD" in line:
                value = float(line.split(':')[1].strip().split()[0])
                info['t_RCD'] = calculate_time_in_tck(value)
            elif "t_RAS" in line:
                value = float(line.split(':')[1].strip().split()[0])
                info['t_RAS'] = calculate_time_in_tck(value)
            elif "t_RC" in line:
                value = float(line.split(':')[1].strip().split()[0])
                info['t_RC'] = calculate_time_in_tck(value)
            elif "t_CAS" in line:
                value = float(line.split(':')[1].strip().split()[0])
                info['t_CAS'] = calculate_time_in_tck(value)
            elif "t_RP" in line:
                value = float(line.split(':')[1].strip().split()[0])
                info['t_RP'] = calculate_time_in_tck(value)
            elif "t_RRD" in line:
                value = float(line.split(':')[1].strip().split()[0])
                info['t_RRD'] = calculate_time_in_tck(value)

        if power_section:
            if "Activation energy" in line:
                info['Activation energy'] = float(line.split(':')[1].strip().split()[0])
            elif "Read energy" in line:
                info['Read energy'] = float(line.split(':')[1].strip().split()[0])
            elif "Write energy" in line:
                info['Write energy'] = float(line.split(':')[1].strip().split()[0])
            elif "Precharge energy" in line:
                info['Precharge energy'] = float(line.split(':')[1].strip().split()[0])

        if area_section:
            if "Area efficiency" in line:
                info['Area efficiency'] = float(line.split(':')[1].strip().split()[0].replace('%', ''))

        if tsv_section:
            if "TSV area overhead" in line:
                info['TSV area overhead'] = float(line.split(':')[1].strip().split()[0])
            elif "TSV latency overhead" in line:
                info['TSV latency overhead'] = float(line.split(':')[1].strip().split()[0])
            elif "TSV energy overhead per access" in line:
                info['TSV energy overhead per access'] = float(line.split(':')[1].strip().split()[0])

    return info

def save_to_csv(infos, csv_file):
    # Define the order of headers, with Memory Parameters at the front
    memory_headers = ['Total memory size (Gb)', 'Stacked die count', 'Page size', 'Chip IO width']
    other_headers = sorted(set(infos[0].keys()) - set(memory_headers))
    headers = memory_headers + other_headers

    with open(csv_file, 'w', newline='') as file:
        writer = csv.writer(file, delimiter='\t')
        writer.writerow(headers)
        for info in infos:
            row = [info.get(header, '') for header in headers]
            # Add extra tabs for spacing
            spaced_row = ['\t' + str(value) + '\t'+' ' for value in row]
            writer.writerow(spaced_row)

if __name__ == "__main__":
    log_dir = '/root/user/3D_DRAM_MODELING_MASTER/cacti/python_script_testing/3DDRAM_Design_Exploration/Logs'  # Replace with your log directory path
    csv_file = 'extracted_info.csv'  # Replace with your desired CSV file path

    infos = []
    for log_file in os.listdir(log_dir):
        if log_file.endswith('.log'):
            log_file_path = os.path.join(log_dir, log_file)
            info = extract_log_info(log_file_path)
            infos.append(info)

    save_to_csv(infos, csv_file)
    print(f"Extracted information saved to {csv_file}")