boot.kernelParams = ["resume_offset=3926016"];

boot.resumeDevice = "/dev/disk/by-uuid/2d86b954-636f-4448-8fbf-86180389b796";

powerManagement.enable = true;

swapDevices = [
  {
    device = "/var/lib/swapfile";
    size = 12 * 1024; # 32GB in MB
  }
];
