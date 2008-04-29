From: akpm@linux-foundation.org
Subject: + md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store.patch added to -mm tree
Date: Mon, 28 Apr 2008 20:56:31 -0700
Message-ID: <200804290356.m3T3uVt6032368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbYD2D4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 23:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, neilb@suse.de


The patch titled
     md: remove a stray command from a copy and paste error in resync_start_store
has been added to the -mm tree.  Its filename is
     md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2459,7 +2459,6 @@ resync_start_show(mddev_t *mddev, char *
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
md-fix-use-after-free-when-removing-rdev-via-sysfs.patch
md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store.patch
md-prevent-duplicates-in-bind_rdev_to_array.patch
md-md-raid5-rate-limit-error-printk.patch
md-md-support-blocking-writes-to-an-array-on-device-failure.patch

