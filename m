From: akpm@linux-foundation.org
Subject: [merged]
 fs-remove-unneeded-forward-definition-of-mm_struct-from-fsh.patch removed
 from -mm tree
Date: Thu, 07 Sep 2017 11:40:40 -0700
Message-ID: <20170907184040.PIezY--VT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755722AbdIGSkl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlayton@redhat.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: include/linux/fs.h: remove unneeded forward definition of mm_struct
has been removed from the -mm tree.  Its filename was
     fs-remove-unneeded-forward-definition-of-mm_struct-from-fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: include/linux/fs.h: remove unneeded forward definition of mm_struct

Link: http://lkml.kernel.org/r/20170525102927.6163-1-jlayton@redhat.com
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/fs.h~fs-remove-unneeded-forward-definition-of-mm_struct-from-fsh include/linux/fs.h
--- a/include/linux/fs.h~fs-remove-unneeded-forward-definition-of-mm_struct-from-fsh
+++ a/include/linux/fs.h
@@ -1270,8 +1270,6 @@ extern void f_delown(struct file *filp);
 extern pid_t f_getown(struct file *filp);
 extern int send_sigurg(struct fown_struct *fown);
 
-struct mm_struct;
