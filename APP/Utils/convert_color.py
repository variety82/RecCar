def convert_to_pink(arr):
    pink = [240, 15, 135]
    for i in range(512):
        for j in range(512):
            if(arr[i][j][0] == 1):
                arr[i][j] = pink
    return arr

def convert_to_blue(arr):
    blue = [75, 150, 200]
    for i in range(512):
        for j in range(512):
            if(arr[i][j][0] == 1):
                arr[i][j] = blue
    return arr

def convert_to_black(arr):
    black = [64, 64, 64]
    for i in range(512):
        for j in range(512):
            if(arr[i][j][0] == 1):
                arr[i][j] = black
    return arr