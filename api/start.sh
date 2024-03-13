#!/bin/bash
begin=`date +%s`
bash smi.sh &
bash utilization.sh &

nvidiaout=$(nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,utilization.gpu,utilization.memory,enforced.power.limit,power.max_limit,memory.total,memory.free,memory.used --format=csv,noheader)




#main loop
#for ((i = 0 ; i < $loops ; i++)); do
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
  bash octane.sh > octaneoutput.log
  end1=`date +%s`
  octanescore=`awk -F "score:" '/score/{print $2}' octaneoutput.log`
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

sdstart=`date +%s%3N`

infer1start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 50,
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
}' 'http://127.0.0.1:50150/' > sd1output.log
infer1stop=`date +%s`
sd1score=`awk -F: '{print $7}' sd1output.log`
infer1time=$((infer1stop-infer1start))


echo -e "\n\n"
sd1sanitised=$(echo $sd1score | sed 's/[^0-9]*//g')
echo $sd1sanitised
#echo $infer1time
echo -e "$(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: first inference done, $infer1time seconds to complete"



infer2start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 50,
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
}' 'http://127.0.0.1:50150/' > sd2output.log
infer2stop=`date +%s`
sd2score=`awk -F: '{print $6}' sd2output.log`
infer2time=$((infer2stop-infer2start))
echo $sd2score
echo -e "\n\n"
sd2sanitised=$(echo $sd2score | sed 's/[^0-9]*//g')
echo $sd2sanitised
#echo $infer2time
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: second inference done, $infer2time seconds to complete"



infer3start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 50,
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
}' 'http://127.0.0.1:50150/' > sd3output.log
infer3stop=`date +%s`
infer3time=$((infer3stop-infer3start))
#echo $infer3time
echo -e "/n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: third inference done, $infer3time seconds to complete"
sd3score=`awk -F: '{print $6}' sd3output.log`
echo -e "\n\n"
echo $sd3score
sd3sanitised=$(echo $sd3score | sed 's/[^0-9]*//g')
echo $sd3sanitised



infer4start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 50,
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
}' 'http://127.0.0.1:50150/' > sd4output.log
infer4stop=`date +%s`
infer4time=$((infer4stop-infer4start))
#echo $infer4time
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: fourth inference done, $infer4time seconds to complete"
sd4score=`awk -F: '{print $6}' sd4output.log`
echo -e "\n\n"
echo $sd4score
sd4sanitised=$(echo $sd4score | sed 's/[^0-9]*//g')
echo $sd4sanitised




infer5start=`date +%s`
curl -XPOST -H "Content-type: application/json" -d '{
  "modelInputs": {
    "prompt": "A long-haired lion sleeping on a beach",
    "negative_prompt": "short hair, two heads, two tails",
    "num_inference_steps": 50,
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
}' 'http://127.0.0.1:50150/' > sd5output.log
infer5stop=`date +%s`
infer5time=$((infer5stop-infer5start))

sdstop=`date +%s%3N`
totalsdtimems=$((sdstop-sdstart))
#echo $infer5time
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: fifth inference done, $infer5time seconds to complete"
sd5score=`awk -F: '{print $6}' sd5output.log`
echo -e "\n\n"
echo $sd5score
sd5sanitised=$(echo $sd5score | sed 's/[^0-9]*//g')
echo $sd5sanitised




#finishing
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: sleeping for $sleep2 seconds"
sleep $sleep2

echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: Benchmarking complete.. Took $cpubench seconds to run CPU benchmark. Took $runtime seconds to download OctaneBench, $runtime1 seconds to complete the OctaneBench benchmark. SD inference 1: $infer1time seconds. SD inference 2: $infer2time seconds. SD inference 3: $infer3time seconds. SD inference 4: $infer4time seconds. SD inference 5: $infer5time seconds."
end=`date +%s`
total=$((end-begin))
echo -e "\n $(date -u +'%Y/%m/%d %H:%M:%S:%3N'), BENCHMARK: $total seconds to complete this entire benchmark container. $loops total loops."



echo "NCW BENCHMARK RESULTS, $nvidiaout, $sd1sanitised, $sd2sanitised, $sd3sanitised, $sd4sanitised, $sd5sanitised, $octanescore"

# date, tag, total time for SD, total time for SD after first, octane benchmark, first sample gpu %, first sample VRAM %, driver version, card, machine ID
echo -e "\n NCW BENCHMARK RESULTS, $nvidiaout, $sd1sanitised, $sd2sanitised, $sd3sanitised, $sd4sanitised, $sd5sanitised,$octanescore"