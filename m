From: akpm@linux-foundation.org
Subject: - jbd-remove-excess-kernel-doc-notation.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:09 -0800
Message-ID: <200901082247.n08Ml9tq026644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761355AbZAHWtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:49:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     jbd: remove excess kernel-doc notation
has been removed from the -mm tree.  Its filename was
     jbd-remove-excess-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: remove excess kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Remove excess kernel-doc from fs/jbd/transaction.c:

Warning(linux-2.6.28-git5//fs/jbd/transaction.c:764): Excess function parameter 'credits' description in 'journal_get_write_access'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/jbd/transaction.c~jbd-remove-excess-kernel-doc-notation fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-remove-excess-kernel-doc-notation
+++ a/fs/jbd/transaction.c
@@ -754,7 +754,6 @@ out:
  * int journal_get_write_access() - notify intent to modify a buffer for metadata (not data) update.
  * @handle: transaction to add buffer modifications to
  * @bh:     bh to be used for metadata writes
- * @credits: variable that will receive credits for the buffer
  *
  * Returns an error code or 0 on success.
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

