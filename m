From: akpm@linux-foundation.org
Subject: [patch 07/78] autofs: fix typo in Documentation
Date: Mon, 27 Feb 2017 14:27:02 -0800
Message-ID: <58b4a7b6.6IjbyZokDfUOr1eD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44836 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdB0W3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tkusumi@tuxera.com, raven@themaw.net

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
