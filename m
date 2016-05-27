From: akpm@linux-foundation.org
Subject: [merged] nilfs2-replace-__attribute__packed-with-__packed.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:42:56 -0700
Message-ID: <57489530.49PBfAjJIHPtyupZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbcE0Sm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: replace __attribute__((packed)) with __packed
has been removed from the -mm tree.  Its filename was
     nilfs2-replace-__attribute__packed-with-__packed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: replace __attribute__((packed)) with __packed

This fixes the following checkpatch.pl warning:

WARNING: __packed is preferred over __attribute__((packed))
#23: FILE: export.h:23:
+} __attribute__ ((packed));

Link: http://lkml.kernel.org/r/1461935747-10380-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/export.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/export.h~nilfs2-replace-__attribute__packed-with-__packed fs/nilfs2/export.h
--- a/fs/nilfs2/export.h~nilfs2-replace-__attribute__packed-with-__packed
+++ a/fs/nilfs2/export.h
@@ -20,6 +20,6 @@ struct nilfs_fid {
 
 	u32 parent_gen;
 	u64 parent_ino;
-} __attribute__ ((packed));
+} __packed;
 
 #endif
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


