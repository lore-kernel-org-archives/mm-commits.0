From: akpm@linux-foundation.org
Subject: [folded-merged] fs-hfs-btreeh-remove-duplicate-defines-fix.patch
 removed from -mm tree
Date: Tue, 12 Nov 2013 14:44:09 -0800
Message-ID: <5282af39.LhlwQtVpNDQ1AAC6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab3KLWoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, michael.opdenacker@free-electrons.com, hch@lst.de, akpm@linux-foundation.org

Subject: [folded-merged] fs-hfs-btreeh-remove-duplicate-defines-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,hch@lst.de,michael.opdenacker@free-electrons.com,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:44:09 -0800


The patch titled
     Subject: fs-hfs-btreeh-remove-duplicate-defines-fix
has been removed from the -mm tree.  Its filename was
     fs-hfs-btreeh-remove-duplicate-defines-fix.patch

This patch was dropped because it was folded into fs-hfs-btreeh-remove-duplicate-defines.patch

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

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch
drivers-rtc-rtc-as3722-add-rtc-driver.patch
fs-hfs-btreeh-remove-duplicate-defines.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch

