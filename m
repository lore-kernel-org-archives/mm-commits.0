From: akpm@linux-foundation.org
Subject: - markers-fix-sparse-integer-as-null-pointer-warning.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:40 -0700
Message-ID: <200807252302.m6PN2eAj003843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410AbYGYXDR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     markers: fix sparse integer as NULL pointer warning
has been removed from the -mm tree.  Its filename was
     markers-fix-sparse-integer-as-null-pointer-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: fix sparse integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>

kernel/trace/trace_sysprof.c:164:20: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_sysprof.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/trace/trace_sysprof.c~markers-fix-sparse-integer-as-null-pointer-warning kernel/trace/trace_sysprof.c
--- a/kernel/trace/trace_sysprof.c~markers-fix-sparse-integer-as-null-pointer-warning
+++ a/kernel/trace/trace_sysprof.c
@@ -161,7 +161,7 @@ static void timer_notify(struct pt_regs 
 		__trace_special(tr, data, 2, regs->ip, 0);
 
 		while (i < sample_max_depth) {
-			frame.next_fp = 0;
+			frame.next_fp = NULL;
 			frame.return_address = 0;
 			if (!copy_stack_frame(fp, &frame))
 				break;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers-update.patch

