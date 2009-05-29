From: akpm@linux-foundation.org
Subject: [merged] cred-include-inith-in-credh.patch removed from -mm tree
Date: Fri, 29 May 2009 11:42:52 -0700
Message-ID: <200905291842.n4TIgqNp011165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbZE2Snl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dhowells@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     cred: #include init.h in cred.h
has been removed from the -mm tree.  Its filename was
     cred-include-inith-in-credh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cred: #include init.h in cred.h
From: Alexey Dobriyan <adobriyan@gmail.com>

linux/cred.h can't be included as first header (alphabetical order)
because it uses __init which is enough to break compilation on some archs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/cred.h~cred-include-inith-in-credh include/linux/cred.h
--- a/include/linux/cred.h~cred-include-inith-in-credh
+++ a/include/linux/cred.h
@@ -13,6 +13,7 @@
 #define _LINUX_CRED_H
 
 #include <linux/capability.h>
+#include <linux/init.h>
 #include <linux/key.h>
 #include <asm/atomic.h>
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-export-pg_hwpoison.patch
pagemap-export-pg_hwpoison-fix.patch
groups-move-code-to-kernel-groupsc.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
proc-merge-arrayc-into-basec.patch
pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch
nsproxy-extract-create_nsproxy.patch
ipcns-3-4-make-free_ipc_ns-static.patch
ipcns-move-free_ipcs-proto.patch

