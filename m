From: akpm@linux-foundation.org
Subject: [patch 029/102] autofs: fix typos in
 Documentation/filesystems/autofs4.txt
Date: Tue, 11 Oct 2016 13:52:25 -0700
Message-ID: <57fd5109.BG4BFamRxURyz0xZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37893 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753006AbcJKUxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@gmail.com, raven@themaw.net

From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: fix typos in Documentation/filesystems/autofs4.txt

plus minor whitespace fixes.

Link: http://lkml.kernel.org/r/20160812024734.12352.17122.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/autofs4.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/autofs4.txt~autofs-fix-typos-in-documentation-filesystems-autofs4txt Documentation/filesystems/autofs4.txt
--- a/Documentation/filesystems/autofs4.txt~autofs-fix-typos-in-documentation-filesystems-autofs4txt
+++ a/Documentation/filesystems/autofs4.txt
@@ -203,9 +203,9 @@ initiated or is being considered, otherw
 Mountpoint expiry
 -----------------
 
-The VFS has a mechansim for automatically expiring unused mounts,
+The VFS has a mechanism for automatically expiring unused mounts,
 much as it can expire any unused dentry information from the dcache.
-This is guided by the MNT_SHRINKABLE flag.  This  only applies to
+This is guided by the MNT_SHRINKABLE flag.  This only applies to
 mounts that were created by `d_automount()` returning a filesystem to be
 mounted.  As autofs doesn't return such a filesystem but leaves the
 mounting to the automount daemon, it must involve the automount daemon
@@ -298,7 +298,7 @@ remove directories and symlinks using no
 autofs knows whether a process requesting some operation is the daemon
 or not based on its process-group id number (see getpgid(1)).
 
-When an autofs filesystem it mounted the pgid of the mounting
+When an autofs filesystem is mounted the pgid of the mounting
 processes is recorded unless the "pgrp=" option is given, in which
 case that number is recorded instead.  Any request arriving from a
 process in that process group is considered to come from the daemon.
@@ -450,7 +450,7 @@ Commands are:
     numbers for existing filesystems can be found in
     `/proc/self/mountinfo`.
 - **AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD**: same as `close(ioctlfd)`.
-- **AUTOFS_DEV_IOCTL_SETPIPEFD_CMD**: if the  filesystem is in
+- **AUTOFS_DEV_IOCTL_SETPIPEFD_CMD**: if the filesystem is in
     catatonic mode, this can provide the write end of a new pipe
     in `arg1` to re-establish communication with a daemon.  The
     process group of the calling process is used to identify the
_
