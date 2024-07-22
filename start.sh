nohup telegraf &
nohup nvidia_gpu_exporter --web.listen-address=":40101" &
jupyter lab --notebook /workspace/ --allow-root --ip=0.0.0.0 --port 40102