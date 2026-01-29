
# Force Feedback Auto Analyzer

ForceFeedbackAutoAnalyzer was made to automate analysis of the force feedback optical trapping data in the publication 'Enhanced processivity and collective force production of kinesin-1 at low radial forces' (https://doi.org/10.7554/eLife.109012).



## Instructions
To use this software, add all of the relevant trace files for a given load (in .csv format) to the same MATLAB directory as ForceFeedbackAutoAnalyzer.m. Upon executing ForceFeedbackAutoAnalyzer, the user will be asked to choose whether the load is assisting or hindering. Upon making this selection, the code will present three distinct views for each trajectory, which are the whole trajectory, the portion where applied load is approximately constant (with slips indicated in red), and a slip corrected trajectory. Run length and run time will be populated for each view and can be edited by the user. The user can save the parameters for any view or skip the trajectory. Once the trace files in the directory have all been reviewed, the code will output a file called 'ForceFeedbackOutput.csv' with the saved data.

## Authors

- Andrew Hensley
- Vlad Belyy (decimate_1sig.m)

