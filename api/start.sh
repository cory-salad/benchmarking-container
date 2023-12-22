#!/bin/bash
begin=`date +%s`
bash smi.sh &
bash utilization.sh &

#main loop
for ((i = 0 ; i < $loops ; i++)); do
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: started sleep for $sleep seconds"
sleep $sleep
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: finished sleep for $sleep seconds"

#CPU benchmark
if [ $cpu = '1' ]; then
	echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: starting CPU benchmark"
	threads=$(cat /proc/cpuinfo |grep "processor"|wc -l)
	echo -e "\nTotal number of threads: $threads"
	cpustart=`date +%s`
	python3 -u stress.py -t $threads
	cpuend=`date +%s`
	cpubench=$((cpuend-cpustart))
	echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: CPU benchmark done, $cpubench seconds to complete"
else
    echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: skipping CPU"
fi


#octane
if [ $octane = '1' ]; then
  echo "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: octane download starting"
  start=`date +%s`
  wget -q https://render.otoy.com/downloads/a/61/2d40eddf-65a5-4c96-bc10-ab527f31dbee/OctaneBench_2020_1_5_linux.zip
  end=`date +%s`
  runtime=$((end-start))
  #echo "\n$runtime"
  echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: octane download done, $runtime seconds to complete"
  start1=`date +%s`
  bash octane.sh
  end1=`date +%s`
  echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: octane benchmark done, result above"
  runtime1=$((end1-start1))
  #echo $runtime1
  echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: octane benchmark done, $runtime1 seconds to complete"
else
  echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: skipping octane"
fi

#SD
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: Stable Diffusion server starting"
socat TCP6-LISTEN:8888,fork TCP4:127.0.0.1:50150 &
python3 -u server.py &
sleep 15
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: Stable Diffusion server started"
infer1start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 25,
    "guidance_scale": 7.5,
    "width": 512,
    "height": 512,
    "seed": 3239022079,
    "num_images_per_prompt": 1
  },
  "callInputs": {
    "PIPELINE": "StableDiffusionPipeline",
    "SCHEDULER": "EulerAncestralDiscreteScheduler",
    "safety_checker": "true"
  }
}' 'http://127.0.0.1:50150/'
infer1stop=`date +%s`
infer1time=$((infer1stop-infer1start))
#echo $infer1time
echo -e "$(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: first inference done, $infer1time seconds to complete"
infer2start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 25,
    "guidance_scale": 7.5,
    "width": 512,
    "height": 512,
    "seed": 3239022079,
    "num_images_per_prompt": 1
  },
  "callInputs": {
    "PIPELINE": "StableDiffusionPipeline",
    "SCHEDULER": "EulerAncestralDiscreteScheduler",
    "safety_checker": "true"
  }
}' 'http://127.0.0.1:50150/'
infer2stop=`date +%s`
infer2time=$((infer2stop-infer2start))
#echo $infer2time
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: second inference done, $infer2time seconds to complete"
infer3start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 25,
    "guidance_scale": 7.5,
    "width": 512,
    "height": 512,
    "seed": 3239022079,
    "num_images_per_prompt": 1
  },
  "callInputs": {
    "PIPELINE": "StableDiffusionPipeline",
    "SCHEDULER": "EulerAncestralDiscreteScheduler",
    "safety_checker": "true"
  }
}' 'http://127.0.0.1:50150/'
infer3stop=`date +%s`
infer3time=$((infer3stop-infer3start))
#echo $infer3time
echo -e "/n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: third inference done, $infer3time seconds to complete"
infer4start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 25,
    "guidance_scale": 7.5,
    "width": 512,
    "height": 512,
    "seed": 3239022079,
    "num_images_per_prompt": 1
  },
  "callInputs": {
    "PIPELINE": "StableDiffusionPipeline",
    "SCHEDULER": "EulerAncestralDiscreteScheduler",
    "safety_checker": "true"
  }
}' 'http://127.0.0.1:50150/'
infer4stop=`date +%s`
infer4time=$((infer4stop-infer4start))
#echo $infer4time
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: fourth inference done, $infer4time seconds to complete"
infer5start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 25,
    "guidance_scale": 7.5,
    "width": 512,
    "height": 512,
    "seed": 3239022079,
    "num_images_per_prompt": 1
  },
  "callInputs": {
    "PIPELINE": "StableDiffusionPipeline",
    "SCHEDULER": "EulerAncestralDiscreteScheduler",
    "safety_checker": "true"
  }
}' 'http://127.0.0.1:50150/'
infer5stop=`date +%s`
infer5time=$((infer5stop-infer5start))
#echo $infer5time
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: fifth inference done, $infer5time seconds to complete"


#finishing
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: sleeping for $sleep2 seconds"
sleep $sleep2

echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: Benchmarking complete.. Took $cpubench seconds to run CPU benchmark. Took $runtime seconds to download OctaneBench, $runtime1 seconds to complete the OctaneBench benchmark. SD inference 1: $infer1time seconds. SD inference 2: $infer2time seconds. SD inference 3: $infer3time seconds. SD inference 4: $infer4time seconds. SD inference 5: $infer5time seconds."
done
end=`date +%s`
total=$((end-begin))
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: $total seconds to complete this entire benchmark container. $loops total loops."