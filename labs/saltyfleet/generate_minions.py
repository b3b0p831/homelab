#!/usr/bin/python3
import argparse, os, logging

def main():
	parser = argparse.ArgumentParser(description="Generate Minion VMs for saltyfleet by copying pre-existing minion-vm.tf")
	parser.add_argument("minions", help="The number of minion files to generate from minion-vm.tf", type=int)
	parser.add_argument("-m", "--master-file", type=str, help="Specify the terraform file to copy (Default=./minion-vm.tf)", default="./minion-vm.tf")
	parser.add_argument("--no-prompt", action="store_true", help="Will NOT prompt user for confirmation (Default=false)", default=False)


	args = parser.parse_args()

	if not args.no_prompt:
		user_resp = input(f"Number of minion VMs to generate {args.minions}, continue?(y/n): ")
		if user_resp.strip().lower()[0] != "y":
			exit(1)

	for i in range(1,args.minions+1):
		try:
			with open(args.master_file, 'r') as in_file:
				out_file_name = "minion-vm-" + str(i) + ".tf"
				with open(out_file_name, 'w+') as out_file:
					lines_to_write = in_file.readlines()
					minion_header = ['resource "proxmox_virtual_environment_vm" "saltstack-minion-' + str(i)+ '" { \n', f'name      = "saltminion-24.04-{i}"\n']
					lines_to_write[0] = minion_header[0]
					lines_to_write[1] = minion_header[1]
					out_file.writelines(lines_to_write)


		except Exception as e:
			logging.error(e)
main()
