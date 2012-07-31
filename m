From: akpm@linux-foundation.org
Subject: [merged] nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:00 -0700
Message-ID: <20120731185300.F1E8D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37887 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2GaSxC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:02 -0400
Received: by mail-ee0-f74.google.com with SMTP id d4so295599eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add omitted comment for ns_mount_state field of the_nilfs structure
has been removed from the -mm tree.  Its filename was
     nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: add omitted comment for ns_mount_state field of the_nilfs structure

Add omitted comment for ns_mount_state field of the_nilfs structure.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/nilfs2/the_nilfs.h~nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure
+++ a/fs/nilfs2/the_nilfs.h
@@ -52,6 +52,7 @@ enum {
  * @ns_sbwtime: previous write time of super block
  * @ns_sbwcount: write count of super block
  * @ns_sbsize: size of valid data in super block
+ * @ns_mount_state: file system state
  * @ns_seg_seq: segment sequence counter
  * @ns_segnum: index number of the latest full segment.
  * @ns_nextnum: index number of the full segment index to be used next
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch

