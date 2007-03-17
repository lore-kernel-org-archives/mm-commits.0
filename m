From: akpm@linux-foundation.org
Subject: + proc-maps-protection-vs-utrace.patch added to -mm tree
Date: Fri, 16 Mar 2007 18:20:31 -0700
Message-ID: <200703170122.l2H1MOpk026162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46133 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966012AbXCQBWs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 21:22:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@infradead.org, kees@outflux.net, roland@redhat.com


The patch titled
     proc-maps-protection-vs-utrace
has been added to the -mm tree.  Its filename is
     proc-maps-protection-vs-utrace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc-maps-protection-vs-utrace
From: Andrew Morton <akpm@linux-foundation.org>

fs/proc/task_mmu.c: In function 'show_map_internal':
fs/proc/task_mmu.c:145: warning: implicit declaration of function 'ptrace_may_attach'

Cc: Kees Cook <kees@outflux.net>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/task_mmu.c~proc-maps-protection-vs-utrace fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-maps-protection-vs-utrace
+++ a/fs/proc/task_mmu.c
@@ -2,6 +2,7 @@
 #include <linux/hugetlb.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
+#include <linux/ptrace.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/mempolicy.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

software-suspend-fix-suspend-when-console-is-in.patch
machzwd-warning-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
proc-maps-protection-vs-utrace.patch
