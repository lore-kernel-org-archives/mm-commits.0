From: akpm@linux-foundation.org
Subject: + of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch added to -mm tree
Date: Mon, 02 Oct 2017 15:57:36 -0700
Message-ID: <59d2c460.Rh105HygscQCq/q5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdJBW5h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 18:57:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, frank.rowand@sony.com, geert+renesas@glider.be, mm-commits@vger.kernel.org


The patch titled
     Subject: of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix
has been added to the -mm tree.  Its filename is
     of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

