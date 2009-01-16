From: akpm@linux-foundation.org
Subject: [merged] jbd-fix-missing-kernel-doc.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:58 -0800
Message-ID: <200901161916.n0GJGw0Q025532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbZAPTTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:19:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     jbd: fix missing kernel-doc
has been removed from the -mm tree.  Its filename was
     jbd-fix-missing-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: fix missing kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix jbd header file kernel-doc notation:

Warning(linux-2.6.28-git13//include/linux/jbd.h:823): No description found for parameter 'j_average_commit_time'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/jbd.h~jbd-fix-missing-kernel-doc include/linux/jbd.h
--- a/include/linux/jbd.h~jbd-fix-missing-kernel-doc
+++ a/include/linux/jbd.h
@@ -614,6 +614,8 @@ struct transaction_s
  * @j_wbufsize: maximum number of buffer_heads allowed in j_wbuf, the
  *	number that will fit in j_blocksize
  * @j_last_sync_writer: most recent pid which did a synchronous write
+ * @j_average_commit_time: the average amount of time in nanoseconds it
+ *	takes to commit a transaction to the disk.
  * @j_private: An opaque pointer to fs-private information.
  */
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
oom-documentation-update.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
pci-fix-missing-kernel-doc-and-typos.patch
pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

