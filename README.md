https://salad.com

Docker Image designed to benchmark an NVIDIA GPU, using OctaneBench and Stable Diffusion 1.5

1. Logs nvidia-smi output every 10 seconds to STDOUT
2. Ddles for 5 minutes to get baseline GPU usage of the node
3. Downloads OctaneBench to test download speed, reports in seconds in STDOUT
4. Runs octaneBench, and returns results + time to run in seconds, in STDOUT
5. Starts up Stable Diffusion 1.5
6. Runs 5x benchmark images at 25 steps, 512x512 withe EulerAncestral, outputs time to complete in seconds, in STDOUT


To edit: Head into the API folder, and configure start.sh, smi.sh, or octane.sh
