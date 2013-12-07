# CS156 Milestone 1 - Kinect Motion Capture for Neural Network design
#
# This python script prepares the collected data for use by the neural network
# as defined in the Milestone 1 assignment description.
#
# Files in "source" with ".txt" extension are read in. The output should be
# Kinect JSON output. For each sample file, for each joint, and for each frame,
# the x,y,z,r0...r8 data are aggregated and then written to files in
# output/<JSONfilename>/
#
# Files are named J1x, J1y, J1z, J1R0...J1R8
#                 J2x, J2y, J2z, J2R0...J2R8
#                           ...
#                 J24x, J24y, J24z, J24R0...J24R8
#
# Joints 5, 10, 11, and 16 are not recorded by the Kinect so no files are
# created for those numbers
#
# Written by Michael Riha for CS156 Artificial Intelligence at SJSU

import json
import os

source = "KinectMotionData"
output = "ParsedMotionData"
numJoints = 24

# Joints 5, 10, 11, and 16 are not recorded
recordedJoints = [1,2,3,4,6,7,8,9,12,13,14,15,17,18,19,20,21,22,23,24]

# Make an output directory to put the output data
if not os.path.exists(output):
    os.mkdir(output)

for root, dirs, files in os.walk(source):
    for f in files:
        
        # Open json in each .txt file to extract
        if f.endswith(".txt"):
            json_data=open(os.path.join(source, f))
            data = json.load(json_data)

            # Initialize a 2d array for each variable
            # first dimension = joint number
            # second dimension = data
            x = []
            y = []
            z = []
            R0 = []
            R1 = []
            R2 = []
            R3 = []
            R4 = []
            R5 = []
            R6 = []
            R7 = []
            R8 = []
            
            for i in range(numJoints + 1):
                x.append([])
                y.append([])
                z.append([])
                R0.append([])
                R1.append([])
                R2.append([])
                R3.append([])
                R4.append([])
                R5.append([])
                R6.append([])
                R7.append([])
                R8.append([])
            
            # Process each frame
            for frame in range(len(data["motiondata"])):
                skeleton = data["motiondata"][frame]["skeleton"]

                # Get the data for each joint and add it to the lists
                for joint in skeleton:
                    jointIdx = int(joint)
                    x[jointIdx].append(str(skeleton[joint]["position"][0]))
                    y[jointIdx].append(str(skeleton[joint]["position"][1]))
                    z[jointIdx].append(str(skeleton[joint]["position"][2]))
                    R0[jointIdx].append(str(skeleton[joint]["rotation"][0]))
                    R1[jointIdx].append(str(skeleton[joint]["rotation"][1]))
                    R2[jointIdx].append(str(skeleton[joint]["rotation"][2]))
                    R3[jointIdx].append(str(skeleton[joint]["rotation"][3]))
                    R4[jointIdx].append(str(skeleton[joint]["rotation"][4]))
                    R5[jointIdx].append(str(skeleton[joint]["rotation"][5]))
                    R6[jointIdx].append(str(skeleton[joint]["rotation"][6]))
                    R7[jointIdx].append(str(skeleton[joint]["rotation"][7]))
                    R8[jointIdx].append(str(skeleton[joint]["rotation"][8]))
                    
            # Record the data into a folder with files
            # J1x, J1y, J1z, J1R0,J1R1...J1R8
            # ...
            # J24x, J24y, J24z, J24R0, J24R1, J24R8
            
            # Make a directory for this data point (student or master)
            name = f[:-4]
            outdir = os.path.join(output, name)

            if not os.path.exists(outdir):
                os.mkdir(outdir)

            # Create a file for each dataset
            # only use joints that were recorded
            datasets = [x,y,z,R0,R1,R2,R3,R4,R5,R6,R7,R8]
            dataSetNames = ["x", "y", "z", "R0", "R1", "R2", "R3", "R4", \
                            "R5", "R6", "R7", "R8"]
            for j in recordedJoints:
                setNum = 0
                for outdata in datasets:
                    fname = "J%d%s" % (j, dataSetNames[setNum])
                    outpath = os.path.join(outdir, fname)

                    # Write the data to the file. Overwrite if it exists
                    outfile = open(outpath, "w")
                    outfile.write(' '.join(outdata[j]))
                    outfile.close()
                    
                    setNum += 1
