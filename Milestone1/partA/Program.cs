using System;
using System.Threading;
using System.Globalization;
using System.IO;
using System.Web.Script.Serialization;

namespace DataParser
{
    class Program
    {
        static void Main(string[] args)
        {
            //This is needed so my Norwegian computer prints decimals correctly.
            Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture("en-US");

            bool dataFound = false;

            //Prepare folder for data.
            string rootfolder = Environment.CurrentDirectory + "\\jointdata\\";
            if (!Directory.Exists(rootfolder))
                Directory.CreateDirectory(rootfolder);

            Console.WriteLine("Output folder '\\jointdata' created.");
            Console.WriteLine("Looking for capture data files in current directory... ");
            Console.WriteLine();

            //Iterate through all files in current directory.
            string[] files = Directory.GetFiles(Environment.CurrentDirectory);
            foreach (string path in files)
            {
                //Filter out files that aren't relevant.
                if (!path.EndsWith("_u0.txt")) continue;
                else dataFound = true;

                //Create folder for this data.
                string capturename = path.Substring(path.LastIndexOf('\\') + 1, path.LastIndexOf('_') - path.LastIndexOf('\\') - 1);
                string directorypath = rootfolder + capturename + "\\";
                if (!Directory.Exists(directorypath))
                    Directory.CreateDirectory(directorypath);

                //Read capture data.
                Console.Write("Parsing data from file '" + capturename + "'\t...");
                string inJSON = "";
                using (StreamReader sr = new StreamReader(path))
                    inJSON = sr.ReadToEnd();

                //Deserialize JSON.
                var deserialized = new JavaScriptSerializer().Deserialize<dynamic>(inJSON);
                var motiondata = deserialized["motiondata"];

                //Parse all the data.
                for (int jointID = 0; jointID < 25; jointID++)
                {
                    string[] jointdata = new string[12];
                    foreach (var iteration in motiondata)
                    {
                        if (!iteration["skeleton"].ContainsKey(jointID.ToString()))
                            break; //Ignore the joint if no data about it was captured.

                        for (int i = 0; i < 3; i++)
                            jointdata[i] += iteration["skeleton"][jointID.ToString()]["position"][i] + " ";
                        for (int i = 0; i < 9; i++)
                            jointdata[i + 3] += iteration["skeleton"][jointID.ToString()]["rotation"][i] + " ";
                    }

                    if (String.IsNullOrEmpty(jointdata[0]))
                        continue; //Don't output the uncaptured joints.

                    //Write the data to seperate files.
                    string jointfilename = "J" + jointID;

                    //Write positions to files named like J1x.txt, J20y.txt etc.
                    using (StreamWriter sw = new StreamWriter(directorypath + jointfilename + "x.txt"))
                        sw.Write(jointdata[0]);
                    using (StreamWriter sw = new StreamWriter(directorypath + jointfilename + "y.txt"))
                        sw.Write(jointdata[1]);
                    using (StreamWriter sw = new StreamWriter(directorypath + jointfilename + "z.txt"))
                        sw.Write(jointdata[2]);

                    //Write rotations to files named like J5R3.txt, J16R0.txt etc.
                    for (int i = 0; i < 9; i++)
                        using (StreamWriter sw = new StreamWriter(directorypath + jointfilename + "R" + i + ".txt"))
                            sw.Write(jointdata[i + 3]);

                    Console.Write(".");
                }
                Console.WriteLine(" DONE!");
            }

            Console.WriteLine();
            Console.WriteLine("------------------------------------------------------------------------");

            if (!dataFound)
                Console.WriteLine("The program couldn't find any capture data files. Make sure the program is placed in the same directory as the .txt files!");
            else
                Console.WriteLine("All capture data files found in current directory has been parsed.");
           
            Console.WriteLine("Press ENTER to exit...");
            Console.Read();
        }
    }
}
