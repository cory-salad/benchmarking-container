#!/bin/bash
for ((i = 0 ; i < $sd ; i++)); do
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
    inferstop=`date +%s`
    infer1time=$((infer1stop-infer1start))
    echo " $(date -u +'%Y/%m/%d %H:%M:%S:%3N') BENCHMARK: first inference done, $infer1time to complete"
done