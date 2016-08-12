From: akpm@linux-foundation.org
Subject: + autofs-remove-obsolete-sb-fields.patch added to -mm tree
Date: Thu, 11 Aug 2016 20:07:14 -0700
Message-ID: <57ad3d62.BmwY0I7uPj29pVbT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbcHLDHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 23:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove obsolete sb fields
has been added to the -mm tree.  Its filename is
     autofs-remove-obsolete-sb-fields.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-remove-obsolete-sb-fields.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-remove-obsolete-sb-fields.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

autofs-fix-typos-in-documentation-filesystems-autofs4txt.patch
autofs-drop-unnecessary-extern-in-autofs_ih.patch
autofs-test-autofs-versions-first-on-sb-initialization.patch
autofs-add-warn_on1-for-non-dir-link-inode-case.patch
autofs-use-autofs4_free_ino-to-kfree-dentry-data.patch
autofs-remove-obsolete-sb-fields.patch
autofs-dont-fail-to-free_dev_ioctlparam.patch
autofs-remove-autofs_devid_len.patch
autofs-fix-documentation-regarding-devid-on-ioctl.patch
autofs-update-struct-autofs_dev_ioctl-in-documentation.patch
autofs-fix-pr_debug-message.patch
autofs-fix-print-format-for-ioctl-warning-message.patch
autofs-move-inclusion-of-linux-limitsh-to-uapi.patch

