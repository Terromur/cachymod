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

### Disable the BPF (Berkeley Packet Filter), using CachyOS config.
if [[ -z "$_use_clear_config" ]]; then
    scripts/config --set-str LSM "landlock,lockdown,yama,integrity"
fi

### Cluster scheduler support improves the CPU scheduler's decision
### making when dealing with machines that have clusters of CPUs.
### Cluster usually means a couple of CPUs which are placed closely
### by sharing mid-level caches, last-level cache tags or internal
### busses.

if [[ $(uname -m) = *"x86"* ]]; then
    # disable on X86 platform; prefer scheduling to idled CPUs
    scripts/config -d SCHED_CLUSTER
fi

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
scripts/config -d HWLAT_TRACER
scripts/config -d IRQSOFF_TRACER
scripts/config -d MMIOTRACE
scripts/config -d OSNOISE_TRACER
scripts/config -d PM_TRACE_RTC
scripts/config -d PREEMPT_TRACER
scripts/config -d SCHED_TRACER
scripts/config -d STACK_TRACER
scripts/config -d TIMERLAT_TRACER
scripts/config -d SYNTH_EVENTS
scripts/config -d USER_EVENTS
scripts/config -d HIST_TRIGGERS
scripts/config -d STRICT_DEVMEM

### Disable debug.
scripts/config -d SLUB_DEBUG
scripts/config -d PAGE_POISONING
scripts/config -d ACPI_DEBUG
scripts/config -d PM_DEBUG
scripts/config -d PM_ADVANCED_DEBUG
scripts/config -d PM_SLEEP_DEBUG
scripts/config -d LATENCYTOP
scripts/config -d BCACHE_DEBUG
scripts/config -d BCACHEFS_DEBUG
scripts/config -d BLK_DEBUG_FS
scripts/config -d BT_DEBUGFS
scripts/config -d CIFS_DEBUG
scripts/config -d DEBUG_BUGVERBOSE
scripts/config -d DEBUG_MEMORY_INIT
scripts/config -d DEBUG_RODATA_TEST
scripts/config -d DEBUG_WX
scripts/config -d EXT4_DEBUG
scripts/config -d LEDS_TRIGGER_CPU
scripts/config -d NETFS_DEBUG
scripts/config -d NFS_DEBUG
scripts/config -d NVME_TARGET_DEBUGFS
scripts/config -d PNP_DEBUG_MESSAGES
scripts/config -d RTLWIFI_DEBUG
scripts/config -d RTW88_DEBUGFS
scripts/config -d RTW88_DEBUG
scripts/config -d RTW89_DEBUGFS
scripts/config -d RTW89_DEBUGMSG
scripts/config -d SHRINKER_DEBUG
scripts/config -d SUNRPC_DEBUG
scripts/config -d VFIO_DEBUGFS
scripts/config -d VIRTIO_DEBUG
scripts/config -d WCN36XX_DEBUGFS
scripts/config -d WWAN_DEBUGFS

### Apply various Clear Linux defaults.
### To skip, change the boolean check from true to false.

if true; then
    ### Default to IOMMU passthrough domain type.
    scripts/config -d IOMMU_DEFAULT_DMA_LAZY -e IOMMU_DEFAULT_PASSTHROUGH

    ### Disable track memory changes and idle page tracking.
    scripts/config -d MEM_SOFT_DIRTY -d IDLE_PAGE_TRACKING

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

    ### Disable LDT (local descriptor table) to run 16-bit or segmented code such as
    ### DOSEMU or some Wine programs. Enabling this adds a small amount of overhead
    ### to context switches and increases the low-level kernel attack surface.
    scripts/config -d MODIFY_LDT_SYSCALL

    ### Disable 16-bit UID system calls.
    scripts/config -d UID16

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
fi

