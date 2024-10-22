#!/bin/bash
# Set extra kernel options.

### Exit immediately on error.
set -e

### Set minimal base_slice_ns for BORE.
### 1000Hz = 2.0ms, 800Hz = 2.5ms, 600Hz = 1.6(6)ms, 500Hz = 2.0ms.
scripts/config --set-val MIN_BASE_SLICE_NS 1600000

### Answer unconfigured (NEW) kernel options in the CachyOS config.
scripts/config -d INTEL_TDX_HOST
scripts/config -m REGULATOR_DA903X

### Apply various Clear Linux defaults, possibly default in Cachy config.
### To skip, change the boolean check from true to false.

if true; then
    ### Enable the AMD Address Translation Library.
    ### Enable the Flexible Return and Event Delivery.
    scripts/config -e AMD_ATL
    scripts/config -e X86_FRED

    ### Disable using efivars as a pstore backend by default.
    ### Require boot parameter to enable pressure stall information tracking.
    scripts/config -m EFI_VARS_PSTORE -e EFI_VARS_PSTORE_DEFAULT_DISABLE
    scripts/config -e PSI_DEFAULT_DISABLED

    ### Default to IOMMU passthrough domain type.
    ### Enable performance events for power monitoring on modern processors.
    scripts/config -d IOMMU_DEFAULT_DMA_LAZY -e IOMMU_DEFAULT_PASSTHROUGH
    scripts/config -e PERF_EVENTS_INTEL_RAPL -e PERF_EVENTS_INTEL_CSTATE

    ### Disable randomize slab caches for normal kmalloc.
    ### Disable Linear Address Masking support.
    scripts/config -d RANDOM_KMALLOC_CACHES
    scripts/config -d ADDRESS_MASKING

    ### Disable track memory changes and idle page tracking.
    ### Disable userfaultfd() system call.
    scripts/config -d MEM_SOFT_DIRTY -d IDLE_PAGE_TRACKING
    scripts/config -d USERFAULTFD

    ### Disable the general notification queue.
    ### Disable uselib syscall (for libc5 and earlier).
    scripts/config -d WATCH_QUEUE
    scripts/config -d USELIB

    ### Disable default state of kernel stack offset randomization.
    ### Disable workqueue power-efficient mode by default.
    scripts/config -d RANDOMIZE_KSTACK_OFFSET_DEFAULT
    scripts/config -d WQ_POWER_EFFICIENT_DEFAULT

    ### Disable utilization clamping for RT/FAIR tasks.
    ### Disable enforcement of RDMA resources defined by IB stack.
    scripts/config -d UCLAMP_TASK
    scripts/config -d CGROUP_RDMA

    ### Disable PC-Speaker support.
    ### Disable sysfs syscall support no longer supported in libc.
    ### Disable 16-bit UID system calls.
    scripts/config -d PCSPKR_PLATFORM
    scripts/config -d SYSFS_SYSCALL
    scripts/config -d UID16

    ### Default to none for vsyscall table for legacy applications.
    scripts/config -d LEGACY_VSYSCALL_XONLY -e LEGACY_VSYSCALL_NONE

    ### Disable LDT (local descriptor table) to run 16-bit or segmented code such as
    ### DOSEMU or some Wine programs. Enabling this adds a small amount of overhead
    ### to context switches and increases the low-level kernel attack surface.
    scripts/config -d MODIFY_LDT_SYSCALL

    ### Disable the Extended Industry Standard Architecture (EISA) bus support.
    ### Disable the remoteproc character device interface.
    scripts/config -d EISA -d GREYBUS -d ISA_BUS -d PC104 -d COMEDI
    scripts/config -d REMOTEPROC_CDEV

    ### Disable 5-level page tables support.
    ### Disable support for extended (non-PC) x86 platforms.
    ### Disable the sysfs memory/probe interface for testing.
    scripts/config -d X86_5LEVEL
    scripts/config -d X86_EXTENDED_PLATFORM
    scripts/config -d ARCH_MEMORY_PROBE

    ### Disable the Undefined Behaviour sanity checker.
    ### Disable event debugging.
    scripts/config -d UBSAN
    scripts/config -d INPUT_EVBUG

    ### Disable Kexec and crash features.
    ### Disable strong stack protector.
    scripts/config -d KEXEC -d KEXEC_FILE -d CRASH_DUMP
    scripts/config -d STACKPROTECTOR_STRONG -e STACKPROTECTOR

    ### Disable low-overhead sampling-based memory safety error detector.
    ### Disable sample kernel code.
    scripts/config -d KFENCE
    scripts/config -d SAMPLES

    ### Force all function address 64B aligned.
    scripts/config -e DEBUG_FORCE_FUNCTION_ALIGN_64B

    ### Disable automatic stack variable initialization. (Clear and XanMod default)
    ### Enable heap memory zeroing on allocation by default. (Ubuntu and XanMod default)
    ### Disable register zeroing on function exit. (XanMod default)
    scripts/config -e INIT_STACK_NONE -d INIT_STACK_ALL_ZERO
    scripts/config -e INIT_ON_ALLOC_DEFAULT_ON
    scripts/config -d ZERO_CALL_USED_REGS

    ### The frame pointer unwinder degrades overall performance by roughly 5-10%.
    ### Default to the ORC (Oops Rewind Capability) unwinder. (XanMod default)
    scripts/config -d UNWINDER_FRAME_POINTER
    scripts/config -e UNWINDER_ORC
fi

### Apply ClearMod tuning.
### To skip, change the boolean check from true to false.

if true; then
    ### Disable call depth tracking. (XanMod default)
    scripts/config -d MITIGATION_CALL_DEPTH_TRACKING

    ### Boot time param "rcutree.enable_rcu_lazy=1"
    ### can be used to switch RCU_LAZY on.
    scripts/config -e RCU_EXPERT
    scripts/config -e RCU_LAZY
    scripts/config -e RCU_LAZY_DEFAULT_OFF
    scripts/config --set-val RCU_FANOUT 64
    scripts/config --set-val RCU_FANOUT_LEAF 16
    scripts/config -e RCU_BOOST
    scripts/config --set-val RCU_BOOST_DELAY 500
    scripts/config -d RCU_CPU_STALL_CPUTIME
    scripts/config -d RCU_EXP_KTHREAD
    scripts/config -e RCU_NOCB_CPU
    scripts/config -e RCU_NOCB_CPU_DEFAULT_ALL
    scripts/config -d RCU_NOCB_CPU_CB_BOOST
    scripts/config -d TASKS_TRACE_RCU_READ_MB
    scripts/config -e RCU_DOUBLE_CHECK_CB_TIME
    scripts/config -d RT_GROUP_SCHED
    scripts/config -e SCHED_OMIT_FRAME_POINTER
    scripts/config -d SCHED_CLUSTER
fi

