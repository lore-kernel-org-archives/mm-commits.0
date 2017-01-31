From: akpm@linux-foundation.org
Subject: + autofs-fix-typo-in-documentation.patch added to -mm tree
Date: Tue, 31 Jan 2017 15:47:56 -0800
Message-ID: <5891222c.WuV0BWvun/94iB0Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34976 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdAaX5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 18:57:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix typo in Documentation
has been added to the -mm tree.  Its filename is
     autofs-fix-typo-in-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-fix-typo-in-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-fix-typo-in-documentation.patch

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
Subject: autofs: fix typo in Documentation

Link: http://lkml.kernel.org/r/148577164606.9801.12571810310561599401.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/autofs4.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/autofs4.txt~autofs-fix-typo-in-documentation Documentation/filesystems/autofs4.txt
--- a/Documentation/filesystems/autofs4.txt~autofs-fix-typo-in-documentation
+++ a/Documentation/filesystems/autofs4.txt
@@ -65,7 +65,7 @@ directory is a mount trap only if the fi
 and the root is empty.
 
 Directories created in the root directory are mount traps only if the
-filesystem is mounted  *indirect* and they are empty.
+filesystem is mounted *indirect* and they are empty.
 
 Directories further down the tree depend on the *maxproto* mount
 option and particularly whether it is less than five or not.
@@ -352,7 +352,7 @@ Communicating with autofs: root director
 ------------------------------------------------
 
 The root directory of an autofs filesystem will respond to a number of
-ioctls.   The process issuing the ioctl must have the CAP_SYS_ADMIN
+ioctls.  The process issuing the ioctl must have the CAP_SYS_ADMIN
 capability, or must be the automount daemon.
 
 The available ioctl commands are:
@@ -512,7 +512,7 @@ always be mounted "shared". e.g.
 
 > `mount --make-shared /autofs/mount/point`
 
-The automount daemon is only able to mange a single mount location for
+The automount daemon is only able to manage a single mount location for
 an autofs filesystem and if mounts on that are not 'shared', other
 locations will not behave as expected.  In particular access to those
 other locations will likely result in the `ELOOP` error
_

Patches currently in -mm which might be from tkusumi@tuxera.com are

autofs-remove-wrong-comment.patch
autofs-fix-typo-in-documentation.patch
autofs-fix-wrong-ioctl-documentation-regarding-devid.patch
autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl.patch
autofs-add-command-enum-macros-for-root-dir-ioctls.patch
autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch

