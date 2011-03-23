From: akpm@linux-foundation.org
Subject: [folded] crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:26:33 -0700
Message-ID: <201103232326.p2NNQXEX004744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932972Ab1CWX1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, hannes@cmpxchg.org, hpa@zytor.com, lethal@linux-sh.org, mingo@elte.hu, olaf@aepfle.de, rmk@arm.linux.org.uk, tglx@linutronix.det


The patch titled
     crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix
has been removed from the -mm tree.  Its filename was
     crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

This patch was dropped because it was folded into crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove elfcorehdr_addr export

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_dump.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix kernel/crash_dump.c
--- a/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix
+++ a/kernel/crash_dump.c
@@ -18,7 +18,6 @@ unsigned long saved_max_pfn;
  * it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
  */
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-EXPORT_SYMBOL_GPL(elfcorehdr_addr);
 
 /*
  * elfcorehdr= specifies the location of elf core header stored by the crashed
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-adfs-adfsh-fix-unsigned-comparison.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

