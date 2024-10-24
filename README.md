# tumorQuant

**tumorQuant** is a package designed for the accurate quantification of brain tumor volumes from different brain regions using MRI scans. It provides user-friendly functions for volumetric analysis, integrating standard atlases and offering efficient data for radiogenomics research.

---

## Prerequisites

Before using **tumorQuant**, ensure you have the following installed and set up:

1. **FSL** installed on your system (command name: `fsl`)
2. T1 MRI images for accurate outputs
3. Segmented tumor images

---

## Usage

To install **tumorQuant**, follow these steps:

### Clone the Repository

Run the following command in your terminal:

```bash
git clone https://github.com/CGnTLab/tumorQuant.git
```
### Navigate to the Directory
```bash
cd tumorQuant
```

### Run the Installation Script
```bash
./install.sh
```

### Volume Extraction Command
```bash
tumorQuant -n SampleName -s /path/to/TumorSegment.nii.gz -t1 /path/to/MRI_t1.nii.gz -a atlas -o /path/to/output
```

### Example Code

Here’s an example of how to use tumorQuant:
```bash
tumorQuant -n Sample1 -s ./data/example/Sample1/Sample1_seg.nii.gz -t1 ./data/example/Sample1/Sample1_t1.nii.gz -a all -o ./Sample1_output
```
---

## Developer
**Kavita Kundal**
CG&T Lab, Indian Institute of Technology Hyderabad



