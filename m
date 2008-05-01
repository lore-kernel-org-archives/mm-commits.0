From: akpm@linux-foundation.org
Subject: - md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:37 -0700
Message-ID: <200805010925.m419PblY030219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbYEAJ0L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:26:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: remove a stray command from a copy and paste error in resync_start_store
has been removed from the -mm tree.  Its filename was
     md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: remove a stray command from a copy and paste error in resync_start_store
From: Dan Williams <dan.j.williams@intel.com>

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/md/md.c~md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store drivers/md/md.c
--- a/drivers/md/md.c~md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store
+++ a/drivers/md/md.c
@@ -2460,7 +2460,6 @@ resync_start_show(mddev_t *mddev, char *
 static ssize_t
 resync_start_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	/* can only set chunk_size if array is not yet active */
 	char *e;
 	unsigned long long n = simple_strtoull(buf, &e, 10);
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

