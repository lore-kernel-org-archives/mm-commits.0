From: akpm@linux-foundation.org
Subject: + autofs-remove-wrong-comment.patch added to -mm tree
Date: Tue, 31 Jan 2017 15:47:54 -0800
Message-ID: <5891222a.t7LSJ1ok/gYcKub7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdAaX5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 18:57:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove wrong comment
has been added to the -mm tree.  Its filename is
     autofs-remove-wrong-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-remove-wrong-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-remove-wrong-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: remove wrong comment

This format seems to have been taken from device mapper header, but autofs
has no such file:function in both kernel and userspace.

Link: http://lkml.kernel.org/r/148577164094.9801.4775075118014742496.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/auto_dev-ioctl.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/uapi/linux/auto_dev-ioctl.h~autofs-remove-wrong-comment include/uapi/linux/auto_dev-ioctl.h
--- a/include/uapi/linux/auto_dev-ioctl.h~autofs-remove-wrong-comment
+++ a/include/uapi/linux/auto_dev-ioctl.h
@@ -120,10 +120,6 @@ static inline void init_autofs_dev_ioctl
 	in->ioctlfd = -1;
 }
 
-/*
- * If you change this make sure you make the corresponding change
- * to autofs-dev-ioctl.c:lookup_ioctl()
- */
 enum {
 	/* Get various version info */
 	AUTOFS_DEV_IOCTL_VERSION_CMD = 0x71,
_

Patches currently in -mm which might be from tkusumi@tuxera.com are

autofs-remove-wrong-comment.patch
autofs-fix-typo-in-documentation.patch
autofs-fix-wrong-ioctl-documentation-regarding-devid.patch
autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl.patch
autofs-add-command-enum-macros-for-root-dir-ioctls.patch
autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch

