From: akpm@linux-foundation.org
Subject: + nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure.patch added to -mm tree
Date: Mon, 16 Jul 2012 14:29:26 -0700
Message-ID: <20120716212927.8D46A5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:51894 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab2GPV33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jul 2012 17:29:29 -0400
Received: by eekb47 with SMTP id b47so4174eek.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Jul 2012 14:29:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, konishi.ryusuke@lab.ntt.co.jp


The patch titled
     Subject: nilfs2: add omitted comment for ns_mount_state field of the_nilfs structure
has been added to the -mm tree.  Its filename is
     nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: nilfs2: add omitted comment for ns_mount_state field of the_nilfs structure

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure.patch

