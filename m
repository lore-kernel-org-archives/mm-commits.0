From: akpm@linux-foundation.org
Subject: + fs-hfs-btreeh-remove-duplicate-defines.patch added to -mm tree
Date: Tue, 05 Nov 2013 15:38:21 -0800
Message-ID: <5279816d.a3XHZz/t3yiXXDnH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab3KEXiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 18:38:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, hch@lst.de, michael.opdenacker@free-electrons.com

Subject: + fs-hfs-btreeh-remove-duplicate-defines.patch added to -mm tree
To: michael.opdenacker@free-electrons.com,hch@lst.de,slava@dubeyko.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 15:38:21 -0800


The patch titled
     Subject: fs/hfs/btree.h: remove duplicate defines
has been added to the -mm tree.  Its filename is
     fs-hfs-btreeh-remove-duplicate-defines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hfs-btreeh-remove-duplicate-defines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hfs-btreeh-remove-duplicate-defines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: fs/hfs/btree.h: remove duplicate defines

This patch removes duplicate defines from fs/hfs/btree.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/btree.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/hfs/btree.h~fs-hfs-btreeh-remove-duplicate-defines fs/hfs/btree.h
--- a/fs/hfs/btree.h~fs-hfs-btreeh-remove-duplicate-defines
+++ a/fs/hfs/btree.h
@@ -153,11 +153,6 @@ struct hfs_btree_header_rec {
 	u32 reserved3[16];
 } __packed;
 
-#define HFS_NODE_INDEX	0x00	/* An internal (index) node */
-#define HFS_NODE_HEADER	0x01	/* The tree header node (node 0) */
-#define HFS_NODE_MAP		0x02	/* Holds part of the bitmap of used nodes */
-#define HFS_NODE_LEAF		0xFF	/* A leaf (ndNHeight==1) node */
