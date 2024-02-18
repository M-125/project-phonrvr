
import mediapipe as mp
import cv2
import numpy as np
ip=input("ip:  ")
if ip=="":
	ip="127.0.0.1"

# Initialize webcam capture
webcam_capture = cv2.VideoCapture(0)
print("Webcam started")
# Set up MediaPipe components
mp_pose = mp.solutions.pose
pose_landmarker = mp_pose.Pose(
	static_image_mode=False,
	model_complexity=1,
	min_detection_confidence=0.7,
	min_tracking_confidence=0.5,
)
import socket

# Create a UDP socket
udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Send data to a specific address and port



while True:
	# Read a frame from the webcam
	ret, frame = webcam_capture.read()
	if not ret:
		break  # Exit the loop if no frame is received

	# Convert the frame to RGB format
	frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

	# Process the frame using MediaPipe Pose
	results = pose_landmarker.process(frame_rgb)

	# Draw skeleton (connecting adjacent landmarks)
	if results.pose_landmarks:
		message = ''
		
		
		for connection in mp_pose.POSE_CONNECTIONS:
			start_idx, end_idx = connection
			start_point = (int(results.pose_landmarks.landmark[start_idx].x * frame.shape[1]),
						   int(results.pose_landmarks.landmark[start_idx].y * frame.shape[0]))
			end_point = (int(results.pose_landmarks.landmark[end_idx].x * frame.shape[1]),
						 int(results.pose_landmarks.landmark[end_idx].y * frame.shape[0]))
			cv2.line(frame, start_point, end_point, (0, 255, 0), 2)
		
		
		for e in results.pose_landmarks.landmark:
			message+=f"{int(e.x*2000)},{int(e.y*2000)},{int(e.z*2000)};"
		for i in range(len(results.pose_landmarks.landmark)):
			e=results.pose_landmarks.landmark[i]
			cv2.putText(frame, str(i), (int(e.x * frame.shape[1]),int(e.y * frame.shape[0])), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0))
			
		udp_socket.sendto(message.encode(), (ip, 6000))

	# Display the processed frame
	cv2.imshow('MediaPipe Pose', frame)

	# Press 'q' to exit the loop
	if cv2.waitKey(1) & 0xFF == ord('q'):
		break

# Release the webcam and close all windows
webcam_capture.release()
cv2.destroyAllWindows()
# Close the socket
udp_socket.close()