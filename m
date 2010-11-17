From: akpm@linux-foundation.org
Subject: [merged] kernel-sysctlc-fix-build-failure-with-config_printk.patch removed from -mm tree
Date: Wed, 17 Nov 2010 11:43:33 -0800
Message-ID: <201011171946.oAHJktW9001836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932364Ab0KQTrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Nov 2010 14:47:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, eparis@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     kernel/sysctl.c: fix build failure with !CONFIG_PRINTK
has been removed from the -mm tree.  Its filename was
     kernel-sysctlc-fix-build-failure-with-config_printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sysctl.c: fix build failure with !CONFIG_PRINTK
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~kernel-sysctlc-fix-build-failure-with-config_printk kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctlc-fix-build-failure-with-config_printk
+++ a/kernel/sysctl.c
@@ -702,7 +702,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &ten_thousand,
 	},
-#endif
 	{
 		.procname	= "dmesg_restrict",
 		.data		= &dmesg_restrict,
@@ -712,6 +711,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
scripts-get_maintainerpl-use-git-fallback-more-often.patch
maintainers-intel-gfx-is-a-subscribers-only-mailing-list.patch
scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

