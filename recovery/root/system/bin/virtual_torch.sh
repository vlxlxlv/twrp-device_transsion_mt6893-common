#!/system/bin/sh

BRIGHTNESS_LEVEL=2
VIRTUAL_TORCH_DIR=/tmp/of_torch
CONTROL_NODE=$VIRTUAL_TORCH_DIR/brightness
PREVIOUS_VAL=-1

rm -rf $VIRTUAL_TORCH_DIR
mkdir -p $VIRTUAL_TORCH_DIR
echo 0 > $CONTROL_NODE
chmod 666 $CONTROL_NODE
echo $BRIGHTNESS_LEVEL > $VIRTUAL_TORCH_DIR/max_brightness

while sleep 0.1; do
    CURRENT_VAL=$(cat $CONTROL_NODE)
    [ -z "$CURRENT_VAL" ] || [ "$CURRENT_VAL" = "$PREVIOUS_VAL" ] && continue
    PREVIOUS_VAL=$CURRENT_VAL
    if [ "$CURRENT_VAL" -eq 0 ]; then
        echo 0 > /sys/class/torch/torch/torch_level
    else
        echo $BRIGHTNESS_LEVEL > /sys/class/torch/torch/torch_level
    fi
done
