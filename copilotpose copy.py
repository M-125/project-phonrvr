import mediapipe as mp
import cv2
import socket

BaseOptions = mp.tasks.BaseOptions
PoseLandmarker = mp.tasks.vision.PoseLandmarker
PoseLandmarkerOptions = mp.tasks.vision.PoseLandmarkerOptions
PoseLandmarkerResult = mp.tasks.vision.PoseLandmarkerResult
VisionRunningMode = mp.tasks.vision.RunningMode
ts=0
webcam_capture = cv2.VideoCapture(0)

udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


# Create a pose landmarker instance with the live stream mode:
def print_result(results: PoseLandmarkerResult, output_image: mp.Image, timestamp_ms: int):
    # print('pose landmarker result: {}'.format(result))
    if results!=None:
        if results.pose_landmarks:
                message=""
                # Access individual landmarks and their coordinates
                for l in results.pose_world_landmarks:
                    for landmark in l:
                        print(landmark)
                        x, y, z = landmark.x, landmark.y, landmark.z
                        message+=f"{int(x*2000)},{int(y*2000)},{int(z*8000)};"
            
                udp_socket.sendto(message.encode(), ("127.0.0.1", 6000))

options = PoseLandmarkerOptions(
    base_options=BaseOptions(model_asset_path="pose.task"),
    running_mode=VisionRunningMode.LIVE_STREAM,
    result_callback=print_result)
# Initialize webcam capture
with PoseLandmarker.create_from_options(options) as landmarker:
    while True:
        ret, frame = webcam_capture.read()
        if not ret:
            break
        
        frame_rgb= mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)

        # Process the frame using MediaPipe Pose
        results = landmarker.detect_async(frame_rgb,ts)
        ts+=1
        

        cv2.imshow('MediaPipe Pose', frame)

    # Press 'q' to exit the loop
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

webcam_capture.release()
cv2.destroyAllWindows()
