From: akpm@linux-foundation.org
Subject: - audit-rework-execve-audit-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:51:11 -0700
Message-ID: <200707092351.l69NpBYX021486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45400 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759532AbXGIXvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:51:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     audit: rework execve audit (fix)
has been removed from the -mm tree.  Its filename was
     audit-rework-execve-audit-fix.patch

This patch was dropped because it was folded into audit-rework-execve-audit.patch

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
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
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
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch
