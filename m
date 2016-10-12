From: akpm@linux-foundation.org
Subject: [merged] autofs-remove-obsolete-sb-fields.patch removed from -mm
 tree
Date: Wed, 12 Oct 2016 12:23:49 -0700
Message-ID: <57fe8dc5.ETpsgw2Q5olhqPeD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33191 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755983AbcJLTYf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove obsolete sb fields
has been removed from the -mm tree.  Its filename was
     autofs-remove-obsolete-sb-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: remove obsolete sb fields

These two were left from aa55ddf3 which removed unused ioctls.

Link: http://lkml.kernel.org/r/20160812024810.12352.96377.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs-remove-obsolete-sb-fields fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs-remove-obsolete-sb-fields
+++ a/fs/autofs4/autofs_i.h
@@ -111,8 +111,6 @@ struct autofs_sb_info {
 	int max_proto;
 	unsigned long exp_timeout;
 	unsigned int type;
-	int reghost_enabled;
-	int needs_reghost;
 	struct super_block *sb;
 	struct mutex wq_mutex;
 	struct mutex pipe_mutex;
_

Patches currently in -mm which might be from kusumi.tomohiro@gmail.com are


