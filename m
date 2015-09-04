From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-create-and-use-seq_show_option-for-escaping-fix.patch removed from -mm
 tree
Date: Fri, 04 Sep 2015 15:24:37 -0700
Message-ID: <55ea1a25.1nf924Q68U0SheXG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760622AbbIDWYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-create-and-use-seq_show_option-for-escaping-fix
has been removed from the -mm tree.  Its filename was
     fs-create-and-use-seq_show_option-for-escaping-fix.patch

This patch was dropped because it was folded into fs-create-and-use-seq_show_option-for-escaping.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-create-and-use-seq_show_option-for-escaping-fix

add lost chunk, per Kees

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ceph/ceph_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ceph/ceph_common.c~fs-create-and-use-seq_show_option-for-escaping-fix net/ceph/ceph_common.c
--- a/net/ceph/ceph_common.c~fs-create-and-use-seq_show_option-for-escaping-fix
+++ a/net/ceph/ceph_common.c
@@ -520,7 +520,7 @@ int ceph_print_client_options(struct seq
 	if (opt->name) {
 		seq_puts(m, "name=");
 		seq_escape(m, opt->name, ", \t\n\\");
-		seq_putc(',');
+		seq_putc(m, ',');
 	}
 	if (opt->key)
 		seq_puts(m, "secret=<hidden>,");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
fs-create-and-use-seq_show_option-for-escaping.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-activate-syscall-fix-2.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch

