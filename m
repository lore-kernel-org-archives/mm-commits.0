From: akpm@linux-foundation.org
Subject: [folded-merged]
 of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch removed
 from -mm tree
Date: Fri, 13 Oct 2017 15:51:54 -0700
Message-ID: <59e1438a.5PsORv/fUROmsdUr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39134 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbdJMWv4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, frank.rowand@sony.com, geert+renesas@glider.be, mm-commits@vger.kernel.org


The patch titled
     Subject: of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix
has been removed from the -mm tree.  Its filename was
     of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch

This patch was dropped because it was folded into of-provide-of_n_addrsize_cells-wrappers-for-config_of.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix

be consistent with surrounding code

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Frank Rowand <frank.rowand@sony.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/of.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/linux/of.h~of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix include/linux/of.h
--- a/include/linux/of.h~of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix
+++ a/include/linux/of.h
@@ -734,8 +734,15 @@ static inline struct device_node *of_get
 	return NULL;
 }
 
-static inline int of_n_addr_cells(struct device_node *np) { return 0; }
-static inline int of_n_size_cells(struct device_node *np) { return 0; }
+static inline int of_n_addr_cells(struct device_node *np)
+{
+	return 0;
+
+}
+static inline int of_n_size_cells(struct device_node *np)
+{
+	return 0;
+}
 
 static inline int of_property_read_u64(const struct device_node *np,
 				       const char *propname, u64 *out_value)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of.patch
fix-mpage_writepage-for-pages-with-buffers-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

