From: akpm@linux-foundation.org
Subject: [patch 086/119] include/linux/fs.h: remove unneeded
 forward definition of mm_struct
Date: Wed, 06 Sep 2017 16:23:22 -0700
Message-ID: <20170906232322.1dnzZWcSN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbdIFXXY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:23:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, jlayton@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

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
