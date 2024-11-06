#!/bin/bash
# Set extra kernel options.

### Exit immediately on error.
set -e

### Set minimal base_slice_ns for BORE.
### 1000Hz = 2.0ms, 800Hz = 2.5ms, 600Hz = 1.6(6)ms, 500Hz = 2.0ms.
scripts/config --set-val MIN_BASE_SLICE_NS 1600000

### Linux default-compatible preset for BORE.
scripts/config --set-val MIGRATION_COST_BASE_NS 500000
scripts/config --set-val MIGRATION_COST_STEP_NS 0

### Disable the BPF (Berkeley Packet Filter).
scripts/config --set-str LSM "landlock,lockdown,yama,integrity"

### Cluster scheduler support improves the CPU scheduler's decision
### making when dealing with machines that have clusters of CPUs.
### Cluster usually means a couple of CPUs which are placed closely
### by sharing mid-level caches, last-level cache tags or internal
### busses.

if [[ $(uname -m) = *"x86"* ]]; then
    # Disable on X86 platform; prefer scheduling to idled CPUs.
    scripts/config -d SCHED_CLUSTER
fi

### Enable single-depth WCHAN output. (default disable in Clear config)
scripts/config -e SCHED_OMIT_FRAME_POINTER

### Build the USB Attached SCSI into the kernel versus a module.
scripts/config -e USB_UAS

### Answer unconfigured (NEW) kernel options in the CachyOS config.
scripts/config -d DRM_MGAG200_DISABLE_WRITECOMBINE
scripts/config -d INTEL_TDX_HOST
scripts/config -m GPIO_BT8XX
scripts/config -m SND_SE6X

### Disable tracers.
scripts/config -d TASKS_RUDE_RCU
scripts/config -d ATH5K_TRACER
scripts/config -d CONTEXT_SWITCH_TRACER
scripts/config -d FUNCTION_PROFILER
scripts/config -d FUNCTION_TRACER
scripts/config -d FTRACE_RECORD_RECURSION
scripts/config -d FTRACE_SORT_STARTUP_TEST
scripts/config -d FTRACE_VALIDATE_RCU_IS_WATCHING
scripts/config -d HWLAT_TRACER
scripts/config -d IRQSOFF_TRACER
scripts/config -d KPROBE_EVENTS_ON_NOTRACE
scripts/config -d MMIOTRACE
scripts/config -d MMIOTRACE_TEST
scripts/config -d OSNOISE_TRACER
scripts/config -d PM_TRACE_RTC
scripts/config -d PREEMPT_TRACER
scripts/config -d PSTORE_FTRACE
scripts/config -d SCHED_TRACER
scripts/config -d STACKTRACE_BUILD_ID
scripts/config -d STACK_TRACER
scripts/config -d TIMERLAT_TRACER
scripts/config -d SYNTH_EVENTS
scripts/config -d USER_EVENTS
scripts/config -d HIST_TRIGGERS
scripts/config -d STRICT_DEVMEM

### Disable debug.
scripts/config -d SLUB_DEBUG
scripts/config -d SLUB_DEBUG_ON
scripts/config -d PAGE_POISONING
scripts/config -d GDB_SCRIPTS
scripts/config -d ACPI_DEBUG
scripts/config -d PM_DEBUG
scripts/config -d PM_ADVANCED_DEBUG
scripts/config -d PM_SLEEP_DEBUG
scripts/config -d LATENCYTOP
scripts/config -d LEDS_TRIGGER_CPU
scripts/config -d SOFTLOCKUP_DETECTOR_INTR_STORM
scripts/config -d GENERIC_IRQ_STAT_SNAPSHOT
scripts/config -d PCIEAER_INJECT
scripts/config -d GENERIC_IRQ_DEBUGFS
scripts/config -d GENERIC_IRQ_INJECTION
scripts/config -d FUNCTION_ERROR_INJECTION
scripts/config -d PRINTK_INDEX
scripts/config -d 6LOWPAN_DEBUGFS
scripts/config -d AF_RXRPC_DEBUG
scripts/config -d AFS_DEBUG
scripts/config -d AFS_DEBUG_CURSOR
scripts/config -d ATH10K_DEBUG
scripts/config -d ATH10K_DEBUGFS
scripts/config -d ATH12K_DEBUG
scripts/config -d ATH5K_DEBUG
scripts/config -d ATH6KL_DEBUG
scripts/config -d ATH9K_HTC_DEBUGFS
scripts/config -d ATM_ENI_DEBUG
scripts/config -d ATM_IA_DEBUG
scripts/config -d ATM_IDT77252_DEBUG
scripts/config -d BCACHE_DEBUG
scripts/config -d BCACHEFS_DEBUG
scripts/config -d BEFS_DEBUG
scripts/config -d BLK_DEBUG_FS
scripts/config -d BT_DEBUGFS
scripts/config -d CEPH_LIB_PRETTYDEBUG
scripts/config -d CFG80211_DEBUGFS
scripts/config -d CIFS_DEBUG
scripts/config -d CIFS_DEBUG2
scripts/config -d CIFS_DEBUG_DUMP_KEYS
scripts/config -d CROS_EC_DEBUGFS
scripts/config -d CRYPTO_DEV_AMLOGIC_GXL_DEBUG
scripts/config -d CRYPTO_DEV_CCP_DEBUGFS
scripts/config -d DEBUG_BUGVERBOSE
scripts/config -d DEBUG_MEMORY_INIT
scripts/config -d DEBUG_RODATA_TEST
scripts/config -d DEBUG_RSEQ
scripts/config -d DEBUG_WX
scripts/config -d DLM_DEBUG
scripts/config -d DM_DEBUG_BLOCK_MANAGER_LOCKING
scripts/config -d DM_DEBUG_BLOCK_STACK_TRACING
scripts/config -d DRM_DEBUG_DP_MST_TOPOLOGY_REFS
scripts/config -d DRM_DEBUG_MODESET_LOCK
scripts/config -d DRM_DISPLAY_DP_TUNNEL_STATE_DEBUG
scripts/config -d DRM_I915_DEBUG
scripts/config -d DRM_I915_DEBUG_GUC
scripts/config -d DRM_I915_DEBUG_MMIO
scripts/config -d DRM_I915_DEBUG_VBLANK_EVADE
scripts/config -d DRM_I915_DEBUG_WAKEREF
scripts/config -d DRM_I915_SW_FENCE_DEBUG_OBJECTS
scripts/config -d DRM_XE_DEBUG
scripts/config -d DRM_XE_DEBUG_MEM
scripts/config -d DRM_XE_DEBUG_SRIOV
scripts/config -d DRM_XE_DEBUG_VM
scripts/config -d DVB_USB_DEBUG
scripts/config -d EXT4_DEBUG
scripts/config -d HIST_TRIGGERS_DEBUG
scripts/config -d INFINIBAND_MTHCA_DEBUG
scripts/config -d IWLEGACY_DEBUG
scripts/config -d IWLWIFI_DEBUG
scripts/config -d JFS_DEBUG
scripts/config -d LDM_DEBUG
scripts/config -d LIBERTAS_THINFIRM_DEBUG
scripts/config -d NETFS_DEBUG
scripts/config -d NFS_DEBUG
scripts/config -d NVME_TARGET_DEBUGFS
scripts/config -d OCFS2_DEBUG_FS
scripts/config -d PNP_DEBUG_MESSAGES
scripts/config -d QUOTA_DEBUG
scripts/config -d RTLWIFI_DEBUG
scripts/config -d RTW88_DEBUG
scripts/config -d RTW88_DEBUGFS
scripts/config -d RTW89_DEBUGFS
scripts/config -d RTW89_DEBUGMSG
scripts/config -d SHRINKER_DEBUG
scripts/config -d SMS_SIANO_DEBUGFS
scripts/config -d SND_SOC_SOF_DEBUG
scripts/config -d SUNRPC_DEBUG
scripts/config -d UFS_DEBUG
scripts/config -d USB_DWC2_DEBUG
scripts/config -d VFIO_DEBUGFS
scripts/config -d VIRTIO_DEBUG
scripts/config -d VISL_DEBUGFS
scripts/config -d WCN36XX_DEBUGFS
scripts/config -d WWAN_DEBUGFS
scripts/config -d XEN_DEBUG_FS

### Apply various Clear Linux defaults, using the CachyOS config.
### Uncomment the exit line to skip.

### exit 0

if [ -z "$_use_clear_config" ]; then
    ### Default to IOMMU passthrough domain type.
    scripts/config -d IOMMU_DEFAULT_DMA_LAZY -e IOMMU_DEFAULT_PASSTHROUGH

    ### Disable track memory changes and idle page tracking.
    scripts/config -d MEM_SOFT_DIRTY -d IDLE_PAGE_TRACKING

    ### Require boot parameter to enable pressure stall information tracking.
    scripts/config -e PSI_DEFAULT_DISABLED

    if [[ $(uname -m) = *"x86"* ]]; then
        ### Force all function address 64B aligned.
        scripts/config -e DEBUG_FORCE_FUNCTION_ALIGN_64B

        ### Set the physical address where the kernel is loaded and alignment.
        scripts/config --set-val PHYSICAL_START 0x100000
        scripts/config --set-val PHYSICAL_ALIGN 0x1000000

        ### Set the physical memory mapping padding.
        scripts/config --set-val RANDOMIZE_MEMORY_PHYSICAL_PADDING 0x1

        ### Enable the hardware random number generator support.
        scripts/config -e HW_RANDOM_INTEL
        scripts/config -e HW_RANDOM_AMD
        scripts/config -e HW_RANDOM_VIRTIO
    fi

    ### Disable DAMON: Data Access Monitoring Framework.
    scripts/config -d DAMON

    ### Disable the virtual ELF core file of the live kernel.
    scripts/config -d PROC_KCORE

    ### Set the default setting of memory_corruption_check.
    scripts/config -d X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK

    ### Disable reroute for broken boot IRQs.
    scripts/config -d X86_REROUTE_FOR_BROKEN_BOOT_IRQS

    ### Disable statistic for Change Page Attribute.
    scripts/config -d X86_CPA_STATISTICS

    ### Disable x86 instruction decoder selftest.
    scripts/config -d X86_DECODER_SELFTEST

    ### Disable EFI mixed-mode support.
    scripts/config -d EFI_MIXED

    ### Disable x32 ABI for 64-bit mode.
    scripts/config -d X86_X32_ABI

    ### Disable locking event counts collection.
    scripts/config -d LOCK_EVENT_COUNTS

    ### Disable userfaultfd() system call.
    scripts/config -d USERFAULTFD

    ### Disable the general notification queue.
    scripts/config -d WATCH_QUEUE

    ### Disable strong stack protector.
    scripts/config -d STACKPROTECTOR_STRONG -e STACKPROTECTOR

    ### Disable default state of kernel stack offset randomization.
    scripts/config -d RANDOMIZE_KSTACK_OFFSET_DEFAULT

    ### Disable workqueue power-efficient mode by default.
    scripts/config -d WQ_POWER_EFFICIENT_DEFAULT

    ### Default to none for vsyscall table for legacy applications.
    scripts/config -d LEGACY_VSYSCALL_XONLY -e LEGACY_VSYSCALL_NONE

    ### Disable mitigate Straight-Line-Speculation.
    scripts/config -d MITIGATION_SLS

    ### Disable LDT (local descriptor table) to run 16-bit or segmented code such as
    ### DOSEMU or some Wine programs. Enabling this adds a small amount of overhead
    ### to context switches and increases the low-level kernel attack surface.
    scripts/config -d UID16 -d X86_16BIT -d MODIFY_LDT_SYSCALL

    ### Disable obsolete sysfs syscall support.
    scripts/config -d SYSFS_SYSCALL

    ### Enforce strict size checking for sigaltstack.
    scripts/config -e STRICT_SIGALTSTACK_SIZE

    ### Disable 5-level page tables support.
    scripts/config -d X86_5LEVEL

    ### Disable Kexec and crash features.
    scripts/config -d KEXEC -d KEXEC_FILE -d CRASH_DUMP

    ### Disable low-overhead sampling-based memory safety error detector.
    scripts/config -d KFENCE

    ### Disable automatic stack variable initialization. (Clear and XanMod default)
    scripts/config -d INIT_STACK_ALL_ZERO -e INIT_STACK_NONE

    ### Disable utilization clamping for RT/FAIR tasks.
    scripts/config -d UCLAMP_TASK

    ### Disable the RDMA controller.
    scripts/config -d CGROUP_RDMA

    ### Disable support for latency based cgroup IO protection.
    scripts/config -d BLK_CGROUP_IOLATENCY

    ### Disable support for cost model based cgroup IO controller.
    scripts/config -d BLK_CGROUP_IOCOST

    ### Disable cgroup I/O controller for assigning an I/O priority class.
    scripts/config -d BLK_CGROUP_IOPRIO

    ### Disable PCI Express ECRC settings control.
    scripts/config -d PCIE_ECRC

    ### Disable PCI Express Downstream Port Containment support.
    scripts/config -d PCIE_DPC

    ### Disable PCI Express ASPM L0s and L1, even if the BIOS enabled them.
    scripts/config -d PCIEASPM_DEFAULT -e PCIEASPM_PERFORMANCE

    ### Set default CPUFreq governor
    scripts/config -d CPU_FREQ_DEFAULT_GOV_SCHEDUTIL -e CPU_FREQ_DEFAULT_GOV_PERFORMANCE

    ### Disable EDAC (Error Detection And Correction) reporting.
    scripts/config -d EDAC

    ### Disable PMIC (Power Management Integrated Circuit) operation region support.
    scripts/config -d PMIC_OPREGION

    ### Disable Hardware Spinlock drivers.
    scripts/config -d HWSPINLOCK

    ### Disable filter media drivers and SDR platform devices.
    scripts/config -d MEDIA_SUPPORT_FILTER -d SDR_PLATFORM_DRIVERS

    ### Disable remote controller support and DVB Core/Drivers.
    scripts/config -d RC_CORE -d DVB_PLATFORM_DRIVERS -d DVB_CORE

    ### Disable USB Serial Converter support.
    scripts/config -d USB_SERIAL

    ### Disable Watchdog Timer Support.
    scripts/config -d WATCHDOG

    ### Default to the 2:1 compression allocator (zbud) as the default allocator.
    scripts/config -d ZSWAP_DEFAULT_ON -d ZSWAP_SHRINKER_DEFAULT_ON
    scripts/config -d ZSWAP_ZPOOL_DEFAULT_ZSMALLOC -d ZSMALLOC_STAT
    scripts/config -e ZSWAP_ZPOOL_DEFAULT_ZBUD -e ZBUD
    scripts/config --set-str ZSWAP_ZPOOL_DEFAULT "zbud"

    ### Disable support for memory balloon compaction.
    scripts/config -d BALLOON_COMPACTION

    ### Disable HWPoison pages injector.
    scripts/config -d HWPOISON_INJECT

    ### Disable khugepaged to put read-only file-backed pages in THP.
    scripts/config -d READ_ONLY_THP_FOR_FS

    ### Disable the Contiguous Memory Allocator.
    scripts/config -d CMA
fi

