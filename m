From: akpm@linux-foundation.org
Subject: + ecryptfs-update-maintainers.patch added to -mm tree
Date: Thu, 11 Dec 2008 15:16:33 -0800
Message-ID: <200812112316.mBBNGXE0005551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782AbYLKXRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 18:17:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com


The patch titled
     eCryptfs: Update maintainers
has been added to the -mm tree.  Its filename is
     ecryptfs-update-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Update maintainers
From: Michael Halcrow <mhalcrow@us.ibm.com>

Tyler Hicks and Dustin Kirkland are now the primary contact points for
eCryptfs issues that may arise from this point forward.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Acked-by: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~ecryptfs-update-maintainers MAINTAINERS
--- a/MAINTAINERS~ecryptfs-update-maintainers
+++ a/MAINTAINERS
@@ -1524,10 +1524,10 @@ W:	http://ebtables.sourceforge.net/
 S:	Maintained
 
 ECRYPT FILE SYSTEM
-P:	Mike Halcrow, Phillip Hellewell
-M:	mhalcrow@us.ibm.com, phillip@hellewell.homeip.net
-L:	ecryptfs-devel@lists.sourceforge.net
-W:	http://ecryptfs.sourceforge.net/
+P:	Tyler Hicks, Dustin Kirkland
+M:	tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
+L:	ecryptfs-devel@lists.launchpad.net
+W:	https://launchpad.net/ecryptfs
 S:	Supported
 
 EDAC-CORE
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-update-maintainers.patch
linux-next.patch
ecryptfs-filename-encryption-tag-70-packets.patch
ecryptfs-filename-encryption-header-updates.patch
ecryptfs-filename-encryption-encoding-and-encryption-functions.patch
ecryptfs-filename-encryption-filldir-lookup-and-readlink.patch
ecryptfs-filename-encryption-mount-option.patch
ecryptfs-replace-%z-with-%z.patch
ecryptfs-fix-data-types-int-size_t.patch
ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet.patch
ecryptfs-clean-up-ecryptfs_decode_from_filename.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
notify_change-callers-must-hold-i_mutex.patch

