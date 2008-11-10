From: akpm@linux-foundation.org
Subject: - documentation-update-scheduler-header-file-paths.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:37 -0800
Message-ID: <200811102034.mAAKYbXX025156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754902AbYKJUf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:35:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     documentation: update scheduler header file paths
has been removed from the -mm tree.  Its filename was
     documentation-update-scheduler-header-file-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: update scheduler header file paths
From: Randy Dunlap <randy.dunlap@oracle.com>

Update Documentation/scheduler/ files to reflect changed header files
locations.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scheduler/sched-arch.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/scheduler/sched-arch.txt~documentation-update-scheduler-header-file-paths Documentation/scheduler/sched-arch.txt
--- a/Documentation/scheduler/sched-arch.txt~documentation-update-scheduler-header-file-paths
+++ a/Documentation/scheduler/sched-arch.txt
@@ -8,7 +8,7 @@ Context switch
 By default, the switch_to arch function is called with the runqueue
 locked. This is usually not a problem unless switch_to may need to
 take the runqueue lock. This is usually due to a wake up operation in
-the context switch. See include/asm-ia64/system.h for an example.
+the context switch. See arch/ia64/include/asm/system.h for an example.
 
 To request the scheduler call switch_to with the runqueue unlocked,
 you must `#define __ARCH_WANT_UNLOCKED_CTXSW` in a header file
@@ -23,7 +23,7 @@ disabled. Interrupts may be enabled over
 introduce a significant interrupt latency by adding the line
 `#define __ARCH_WANT_INTERRUPTS_ON_CTXSW` in the same place as for
 unlocked context switches. This define also implies
-`__ARCH_WANT_UNLOCKED_CTXSW`. See include/asm-arm/system.h for an
+`__ARCH_WANT_UNLOCKED_CTXSW`. See arch/arm/include/asm/system.h for an
 example.
 
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
doc-add-printk-formatstxt.patch
doc-add-printk-formatstxt-fix.patch
doc-update-xip-method-info.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch

