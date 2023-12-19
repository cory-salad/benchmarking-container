#!/bin/bash
bash smi.sh &
sleep 300
start=`date +%s`
wget https://render.otoy.com/downloads/a/61/2d40eddf-65a5-4c96-bc10-ab527f31dbee/OctaneBench_2020_1_5_linux.zip
end=`date +%s`
runtime=$((end-start))
echo $runtime
echo "BENCHMARK: octane download done, time (s) above"
start1=`date +%s`
bash octane.sh
end1=`date +%s`
echo "BENCHMARK: octane benchmark done, result above"
runtime1=$((end1-start1))
echo $runtime1
echo "BENCHMARK: octane benchmark done, time (s) above"
socat TCP6-LISTEN:8888,fork TCP4:127.0.0.1:50150 &
python3 -u server.py &
sleep 60
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
echo $infer1time
echo "BENCHMARK: first inference done, time (s) above"
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
echo $infer1time
echo "BENCHMARK: second inference done, time (s) above"
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
echo $infer3time
echo "BENCHMARK: third inference done, time (s) above"

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
echo $infer4time
echo "BENCHMARK: fourth inference done, time (s) above"

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
echo $infer5time
echo "BENCHMARK: fifth inference done, time (s) above"
