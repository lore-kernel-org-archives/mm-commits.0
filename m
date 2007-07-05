From: akpm@linux-foundation.org
Subject: + audit-rework-execve-audit-fix.patch added to -mm tree
Date: Thu, 05 Jul 2007 12:17:19 -0700
Message-ID: <200707051917.l65JHJmt013923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbXGETR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 15:17:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     audit: rework execve audit (fix)
has been added to the -mm tree.  Its filename is
     audit-rework-execve-audit-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: audit: rework execve audit (fix)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN Documentation/filesystems/proc.txt~audit-rework-execve-audit-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~audit-rework-execve-audit-fix
+++ a/Documentation/filesystems/proc.txt
@@ -1074,6 +1074,13 @@ check the amount of free space (value is
 resume it  if we have a value of 3 or more percent; consider information about
 the amount of free space valid for 30 seconds
 
+audit_argv_kb
+-------------
+
+The file contains a single value denoting the limit on the argv array size
+for execve (in KiB). This limit is only applied when system call auditing for
+execve is enabled, otherwise the value is ignored.
+
 ctrl-alt-del
 ------------
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
arch-personality-independent-stack-top.patch
audit-rework-execve-audit.patch
audit-rework-execve-audit-fix.patch
mm-variable-length-argument-support.patch
mm-variable-length-argument-support-fix.patch
mm-variable-length-argument-support-fix-2.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-various-fixes-checkpatch.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-measure-lock-bouncing-checkpatch.patch
lockstat-better-class-name-representation.patch
