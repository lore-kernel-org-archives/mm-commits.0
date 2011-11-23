From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 23 Nov 2011 13:42:47 -0800
Message-ID: <201111232142.pANLgmij032027@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:47066 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1KWVmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2011 16:42:52 -0500
Received: by yenm12 with SMTP id m12so269732yen.1
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2011 13:42:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/Kconfig |    3 ---
 drivers/tty/tty_ldisc.c    |    3 ---
 2 files changed, 6 deletions(-)

diff -puN drivers/tty/serial/Kconfig~linux-next-git-rejects drivers/tty/serial/Kconfig
--- a/drivers/tty/serial/Kconfig~linux-next-git-rejects
+++ a/drivers/tty/serial/Kconfig
@@ -1555,8 +1555,6 @@ config SERIAL_PCH_UART
 	  for MP(Media Phone) use and ML7831 IOH is for general purpose use.
 	  ML7213/ML7223/ML7831 is companion chip for Intel Atom E6xx series.
 	  ML7213/ML7223/ML7831 is completely compatible for Intel EG20T PCH.
-<<<<<<< HEAD
-=======
 
 config SERIAL_PCH_UART_CONSOLE
 	bool "Support for console on Intel EG20T PCH UART/OKI SEMICONDUCTOR ML7213 IOH"
@@ -1566,7 +1564,6 @@ config SERIAL_PCH_UART_CONSOLE
 	  Say Y here if you wish to use the PCH UART as the system console
 	  (the system  console is the device which receives all kernel messages and
 	  warnings and which allows logins in single user mode).
->>>>>>> linux-next/akpm-end
 
 config SERIAL_MSM_SMD
 	bool "Enable tty device interface for some SMD ports"
diff -puN drivers/tty/tty_ldisc.c~linux-next-git-rejects drivers/tty/tty_ldisc.c
--- a/drivers/tty/tty_ldisc.c~linux-next-git-rejects
+++ a/drivers/tty/tty_ldisc.c
@@ -18,7 +18,6 @@
 #include <linux/bitops.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
-<<<<<<< HEAD
 #include <asm/system.h>
 
 #include <linux/kbd_kern.h>
@@ -27,8 +26,6 @@
 
 #include <linux/kmod.h>
 #include <linux/nsproxy.h>
-=======
->>>>>>> linux-next/akpm-end
 #include <linux/ratelimit.h>
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

