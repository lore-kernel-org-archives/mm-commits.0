From: akpm@linux-foundation.org
Subject: - ecryptfs-update-maintainers.patch removed from -mm tree
Date: Tue, 16 Dec 2008 12:30:17 -0800
Message-ID: <200812162030.mBGKUHbE006432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbYLPUbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 15:31:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Update maintainers
has been removed from the -mm tree.  Its filename was
     ecryptfs-update-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1527,10 +1527,10 @@ W:	http://ebtables.sourceforge.net/
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

origin.patch
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

