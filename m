From: akpm@linux-foundation.org
Subject: - kernel-doc-remove-fastcall.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:09 -0500
Message-ID: <200802150719.m1F7JV4T025711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762607AbYBOHUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: remove fastcall
has been removed from the -mm tree.  Its filename was
     kernel-doc-remove-fastcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: remove fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>

fastcall is gone from the tree, no need to adjust the function prototypes
anymore for this.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    1 -
 1 file changed, 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-remove-fastcall scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-remove-fastcall
+++ a/scripts/kernel-doc
@@ -1624,7 +1624,6 @@ sub dump_function($$) {
 
     $prototype =~ s/^static +//;
     $prototype =~ s/^extern +//;
-    $prototype =~ s/^fastcall +//;
     $prototype =~ s/^asmlinkage +//;
     $prototype =~ s/^inline +//;
     $prototype =~ s/^__inline__ +//;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
