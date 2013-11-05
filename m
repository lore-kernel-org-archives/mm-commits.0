From: akpm@linux-foundation.org
Subject: + fs-hfs-btreeh-remove-duplicate-defines-fix.patch added to -mm
 tree
Date: Tue, 05 Nov 2013 15:38:24 -0800
Message-ID: <52798170.Jh12fIdj3ur5h4Fr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3KEXiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 18:38:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, michael.opdenacker@free-electrons.com, hch@lst.de, akpm@linux-foundation.org

Subject: + fs-hfs-btreeh-remove-duplicate-defines-fix.patch added to -mm tree
To: akpm@linux-foundation.org,hch@lst.de,michael.opdenacker@free-electrons.com,slava@dubeyko.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 15:38:24 -0800


The patch titled
     Subject: fs-hfs-btreeh-remove-duplicate-defines-fix
has been added to the -mm tree.  Its filename is
     fs-hfs-btreeh-remove-duplicate-defines-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hfs-btreeh-remove-duplicate-defines-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hfs-btreeh-remove-duplicate-defines-fix.patch

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
Subject: fs-hfs-btreeh-remove-duplicate-defines-fix

retain the comments

Cc: Christoph Hellwig <hch@lst.de>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_raw.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/hfsplus/hfsplus_raw.h~fs-hfs-btreeh-remove-duplicate-defines-fix fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~fs-hfs-btreeh-remove-duplicate-defines-fix
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -156,10 +156,10 @@ struct hfs_bnode_desc {
 } __packed;
 
 /* HFS+ BTree node types */
-#define HFS_NODE_INDEX	0x00
-#define HFS_NODE_HEADER	0x01
-#define HFS_NODE_MAP	0x02
-#define HFS_NODE_LEAF	0xFF
+#define HFS_NODE_INDEX	0x00	/* An internal (index) node */
+#define HFS_NODE_HEADER	0x01	/* The tree header node (node 0) */
+#define HFS_NODE_MAP	0x02	/* Holds part of the bitmap of used nodes */
+#define HFS_NODE_LEAF	0xFF	/* A leaf (ndNHeight==1) node */
 
 /* HFS+ BTree header */
 struct hfs_btree_header_rec {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
kfifo-api-type-safety-checkpatch-fixes.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch
linux-next.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch

