From: akpm@linux-foundation.org
Subject: [merged] mm-fix-config_debug_vm_rb-description.patch removed from -mm tree
Date: Mon, 21 Apr 2014 11:11:11 -0700
Message-ID: <53555f3f.oddz0MB+HyhdTaa9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaDUSLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 14:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aswin@hp.com, davidlohr@hp.com

Subject: [merged] mm-fix-config_debug_vm_rb-description.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 11:11:11 -0700


The patch titled
     Subject: mm: fix CONFIG_DEBUG_VM_RB description
has been removed from the -mm tree.  Its filename was
     mm-fix-config_debug_vm_rb-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm: fix CONFIG_DEBUG_VM_RB description

This appears to be a copy/paste error.  Update the description to reflect
extra rbtree debug and checks for the config option instead of duplicating
CONFIG_DEBUG_VM.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~mm-fix-config_debug_vm_rb-description lib/Kconfig.debug
--- a/lib/Kconfig.debug~mm-fix-config_debug_vm_rb-description
+++ a/lib/Kconfig.debug
@@ -505,8 +505,7 @@ config DEBUG_VM_RB
 	bool "Debug VM red-black trees"
 	depends on DEBUG_VM
 	help
-	  Enable this to turn on more extended checks in the virtual-memory
-	  system that may impact performance.
+	  Enable VM red-black tree debugging information and extra validations.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from davidlohr@hp.com are

mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
ipc-constify-ipc_ops.patch
linux-next.patch

