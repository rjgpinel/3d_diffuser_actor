exp=3d_diffuser_actor

tasks=(
    # close_jar_peract insert_onto_square_peg_peract light_bulb_in_peract meat_off_grill_peract open_drawer_peract place_shape_in_shape_sorter_peract place_wine_at_rack_location_peract push_buttons_peract put_groceries_in_cupboard_peract put_item_in_drawer_peract put_money_in_safe_peract reach_and_drag_peract slide_block_to_color_target_peract stack_blocks_peract stack_cups_peract sweep_to_dustpan_of_size_peract turn_tap_peract place_cups_peract
    put_groceries_in_cupboard_peract
)
data_dir=$DATASET/peract_polarnet/microsteps/test/
num_episodes=100
gripper_loc_bounds_file=tasks/18_peract_tasks_location_bounds.json
use_instruction=1
max_tries=2
verbose=1
interpolation_length=2
single_task_gripper_loc_bounds=0
embedding_dim=120
cameras="left_shoulder,right_shoulder,wrist,front"
fps_subsampling_factor=5
lang_enhanced=0
relative_action=0
seed=0
checkpoint=$WORK/pretrained_models/diffuser_actor_peract.pth
quaternion_format=wxyz  # IMPORTANT: change this to be the same as the training script IF you're not using our checkpoint

export PYTHONBIN=/lustre/fsn1/projects/rech/pvn/uqn73qm/3d_diffuser_actor/bin/python
export LD_LIBRARY_PATH=/lustre/fsn1/projects/rech/pvn/uqn73qm/3d_diffuser_actor/lib:$LD_LIBRARY_PATH

export COPPELIASIM_ROOT=$WORK/LocalCode/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$WORK/LocalCode/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04/
export QT_QPA_PLATFORM_PLUGIN_PATH=$WORK/LocalCode/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04/
export PYTHONPATH=$PYTHONPATH:$WORK/Code/3d_diffuser_actor/:$WORK/RVTRLBench/RLBench/

export SINGULARITYENV_COPPELIASIM_ROOT=$WORK/LocalCode/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04/
export SINGULARITYENV_LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$WORK/LocalCode/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04/
export SINGULARITYENV_QT_QPA_PLATFORM_PLUGIN_PATH=$WORK/LocalCode/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04/

export SINGULARITYENV_PYTHONPATH=$PYTHONPATH:$WORK/Code/3d_diffuser_actor/:/lustre/fswork/projects/rech/pvn/uqn73qm/RVTRLBench:/lustre/fsn1/projects/rech/pvn/uqn73qm/3d_diffuser_actor/lib 


num_ckpts=${#tasks[@]}
for ((i=0; i<$num_ckpts; i++)); do
    singularity exec --bind $WORK:$WORK,$SCRATCH:$SCRATCH,$NEWSCRATCH:$NEWSCRATCH,$HOME:$HOME,/gpfswork/rech/pvn/uqn73qm/:/gpfswork/rech/pvn/uqn73qm/ --nv $SINGULARITY_ALLOWED_DIR/nvcuda_v2.sif \
    xvfb-run -a $PYTHONBIN online_evaluation_rlbench/evaluate_policy.py \
    --tasks ${tasks[$i]} \
    --checkpoint $checkpoint \
    --diffusion_timesteps 100 \
    --fps_subsampling_factor $fps_subsampling_factor \
    --lang_enhanced $lang_enhanced \
    --relative_action $relative_action \
    --num_history 3 \
    --test_model 3d_diffuser_actor \
    --cameras $cameras \
    --verbose $verbose \
    --action_dim 8 \
    --collision_checking 0 \
    --predict_trajectory 1 \
    --embedding_dim $embedding_dim \
    --rotation_parametrization "6D" \
    --single_task_gripper_loc_bounds $single_task_gripper_loc_bounds \
    --data_dir $data_dir \
    --num_episodes $num_episodes \
    --output_file $WORK/eval_logs/$exp/seed$seed/${tasks[$i]}.json  \
    --use_instruction $use_instruction \
    --instructions $WORK/instructions/peract_new/instructions.pkl \
    --variations {0..60} \
    --max_tries $max_tries \
    --max_steps 25 \
    --seed $seed \
    --gripper_loc_bounds_file $gripper_loc_bounds_file \
    --gripper_loc_bounds_buffer 0.04 \
    --quaternion_format $quaternion_format \
    --interpolation_length $interpolation_length \
    --dense_interpolation 1
done

