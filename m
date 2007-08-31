From: akpm@linux-foundation.org
Subject: + documentation-00-index-notice-ecryptfstxt-moved.patch added to -mm tree
Date: Fri, 31 Aug 2007 13:03:52 -0700
Message-ID: <200708312003.l7VK3qPj024215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbXHaUEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 16:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, mhalcrow@us.ibm.com


The patch titled
     Documentation/00-INDEX: notice ecryptfs.txt moved
has been added to the -mm tree.  Its filename is
     documentation-00-index-notice-ecryptfstxt-moved.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation/00-INDEX: notice ecryptfs.txt moved
From: Rob Landley <rob@landley.net>

ecryptfs.txt moved into filesystems, make 00-INDEX follow.

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX             |    2 --
 Documentation/filesystems/00-INDEX |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/00-INDEX~documentation-00-index-notice-ecryptfstxt-moved Documentation/00-INDEX
--- a/Documentation/00-INDEX~documentation-00-index-notice-ecryptfstxt-moved
+++ a/Documentation/00-INDEX
@@ -136,8 +136,6 @@ dvb/
 	- info on Linux Digital Video Broadcast (DVB) subsystem.
 early-userspace/
 	- info about initramfs, klibc, and userspace early during boot.
-ecryptfs.txt
-	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 eisa.txt
 	- info on EISA bus support.
 exception.txt
diff -puN Documentation/filesystems/00-INDEX~documentation-00-index-notice-ecryptfstxt-moved Documentation/filesystems/00-INDEX
--- a/Documentation/filesystems/00-INDEX~documentation-00-index-notice-ecryptfstxt-moved
+++ a/Documentation/filesystems/00-INDEX
@@ -32,6 +32,8 @@ directory-locking
 	- info about the locking scheme used for directory operations.
 dlmfs.txt
 	- info on the userspace interface to the OCFS2 DLM.
+ecryptfs.txt
+	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 ext2.txt
 	- info, mount options and specifications for the Ext2 filesystem.
 ext3.txt
_

Patches currently in -mm which might be from rob@landley.net are

docs-ramdisk-initrd-initramfs-corrections.patch
documentation-00-index-notice-ecryptfstxt-moved.patch
documentation-arm-00-index-add-missing-entries.patch
documentation-make-headers_installtxt.patch
