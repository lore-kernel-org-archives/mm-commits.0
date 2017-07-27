From: akpm@linux-foundation.org
Subject: +
 fs-remove-unneeded-forward-definition-of-mm_struct-from-fsh.patch added to
 -mm tree
Date: Thu, 27 Jul 2017 16:46:11 -0700
Message-ID: <597a7b43.505s5SnbsTVxSVal%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751697AbdG0XqM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/fs.h: remove unneeded forward definition of mm_struct
has been added to the -mm tree.  Its filename is
     fs-remove-unneeded-forward-definition-of-mm_struct-from-fsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-remove-unneeded-forward-definition-of-mm_struct-from-fsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-remove-unneeded-forward-definition-of-mm_struct-from-fsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1268,8 +1268,6 @@ extern void f_delown(struct file *filp);
 extern pid_t f_getown(struct file *filp);
 extern int send_sigurg(struct fown_struct *fown);
 
-struct mm_struct;
