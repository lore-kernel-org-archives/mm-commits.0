From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-bcache-kent-overstreet-has-changed-email-address.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:48:13 -0700
Message-ID: <559adb7d.lVRjDBv5TVb6HnSo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbbGFTsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kent.overstreet@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: BCACHE: Kent Overstreet has changed email address
has been removed from the -mm tree.  Its filename was
     maintainers-bcache-kent-overstreet-has-changed-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: BCACHE: Kent Overstreet has changed email address

Kent's email address in MAINTAINERS seems to be invalid.
This was his last sign-off address, so use that if appropriate.

Fix the S: status entry while there.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                 |    4 ++--
 drivers/md/bcache/journal.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-bcache-kent-overstreet-has-changed-email-address MAINTAINERS
--- a/MAINTAINERS~maintainers-bcache-kent-overstreet-has-changed-email-address
+++ a/MAINTAINERS
@@ -2026,10 +2026,10 @@ S:	Maintained
 F:	drivers/net/hamradio/baycom*
 
 BCACHE (BLOCK LAYER CACHE)
-M:	Kent Overstreet <kmo@daterainc.com>
+M:	Kent Overstreet <kent.overstreet@gmail.com>
 L:	linux-bcache@vger.kernel.org
 W:	http://bcache.evilpiepirate.org
-S:	Maintained:
+S:	Maintained
 F:	drivers/md/bcache/
 
 BDISP ST MEDIA DRIVER
diff -puN drivers/md/bcache/journal.c~maintainers-bcache-kent-overstreet-has-changed-email-address drivers/md/bcache/journal.c
--- a/drivers/md/bcache/journal.c~maintainers-bcache-kent-overstreet-has-changed-email-address
+++ a/drivers/md/bcache/journal.c
@@ -157,7 +157,7 @@ int bch_journal_read(struct cache_set *c
 
 	for_each_cache(ca, c, iter) {
 		struct journal_device *ja = &ca->journal;
-		unsigned long bitmap[SB_JOURNAL_BUCKETS / BITS_PER_LONG];
+		DECLARE_BITMAP(bitmap, SB_JOURNAL_BUCKETS);
 		unsigned i, l, r, m;
 		uint64_t seq;
 
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

