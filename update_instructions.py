import argparse
import os
import pickle as pkl

def main(args):
    names_mapping = {
            "close_jar": "close_jar_peract",
            "insert_onto_square_peg": "insert_onto_square_peg_peract",
            "light_bulb_in": "light_bulb_in_peract",
            "meat_off_grill": "meat_off_grill_peract",
            "open_drawer": "open_drawer_peract",
            "place_shape_in_shape_sorter": "place_shape_in_shape_sorter_peract",
            "place_wine_at_rack_location": "place_wine_at_rack_location_peract",
            "push_buttons": "push_buttons_peract",
            "put_groceries_in_cupboard": "put_groceries_in_cupboard_peract",
            "put_item_in_drawer": "put_item_in_drawer_peract",
            "put_money_in_safe": "put_money_in_safe_peract",
            "reach_and_drag": "reach_and_drag_peract",
            "slide_block_to_color_target": "slide_block_to_color_target_peract",
            "stack_blocks": "stack_blocks_peract",
            "stack_cups": "stack_cups_peract",
            "sweep_to_dustpan_of_size": "sweep_to_dustpan_of_size_peract",
            "turn_tap": "turn_tap_peract",
            "place_cups": "place_cups_peract"
    }

    os.makedirs(args.output_dir, exist_ok=True)

    with open(os.path.join(args.instructions_dir, "instructions.pkl"), "rb") as f:
        instructions = pkl.load(f)

    for name, new_name in names_mapping.items():
        instructions[new_name] = instructions.pop(name)
        
    with open(os.path.join(args.output_dir, "instructions.pkl"), "wb") as f:
        instructions = pkl.dump(instructions, f)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--instructions_dir", type=str, required=True)
    parser.add_argument("--output_dir", type=str, required=True)


    args = parser.parse_args()
    main(args)