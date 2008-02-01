From: akpm@linux-foundation.org
Subject: - add-documentation-x86-64-00-index.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:41 -0800
Message-ID: <200802012230.m11MUfwZ001927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720AbYBAWro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:47:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, mingo@elte.hu, tglx@linutronix.de, vojtech@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Add Documentation/x86-64/00-INDEX
has been removed from the -mm tree.  Its filename was
     add-documentation-x86-64-00-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add Documentation/x86-64/00-INDEX
From: Rob Landley <rob@landley.net>

Add Documentation/x86_64/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/00-INDEX |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN /dev/null Documentation/x86_64/00-INDEX
--- /dev/null
+++ a/Documentation/x86_64/00-INDEX
@@ -0,0 +1,16 @@
+00-INDEX
+	- This file
+boot-options.txt
+	- AMD64-specific boot options.
+cpu-hotplug-spec
+	- Firmware support for CPU hotplug under Linux/x86-64
+fake-numa-for-cpusets
+	- Using numa=fake and CPUSets for Resource Management
+kernel-stacks
+	- Context-specific per-processor interrupt stacks.
+machinecheck
+	- Configurable sysfs parameters for the x86-64 machine check code.
+mm.txt
+	- Memory layout of x86-64 (4 level page tables, 46 bits physical).
+uefi.txt
+	- Booting Linux via Unified Extensible Firmware Interface.
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
git-x86.patch
documentation-about-unaligned-memory-access.patch
add-missing-section-ids-to-genericirqtmpl.patch
add-missing-section-ids-to-genericirqtmpl-updated.patch
add-missing-section-id-to-lsmtmpl.patch
add-section-ids-to-mtdnandtmpl.patch
add-missing-ids-to-procfs-guidetmpl.patch
add-section-ids-to-rapidiotmpl.patch
add-table-ids-to-videobooktmpl.patch
add-chapter-ids-to-z8530booktmpl.patch
