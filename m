From: akpm@linux-foundation.org
Subject: +
 maintainers-bcache-kent-overstreet-has-changed-email-address.patch added to -mm tree
Date: Thu, 21 May 2015 14:26:19 -0700
Message-ID: <555e4d7b.LQnOkCfBhv25SF8J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbbEUV0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 17:26:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kent.overstreet@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: BCACHE: Kent Overstreet has changed email address
has been added to the -mm tree.  Its filename is
     maintainers-bcache-kent-overstreet-has-changed-email-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-bcache-kent-overstreet-has-changed-email-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-bcache-kent-overstreet-has-changed-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1967,10 +1967,10 @@ S:	Maintained
 F:	drivers/net/hamradio/baycom*
 
 BCACHE (BLOCK LAYER CACHE)
-M:	Kent Overstreet <kmo@daterainc.com>
+M:	Kent Overstreet <kent.overstreet@gmail.com>
 L:	linux-bcache@vger.kernel.org
 W:	http://bcache.evilpiepirate.org
-S:	Maintained:
+S:	Maintained
 F:	drivers/md/bcache/
 
 BEFS FILE SYSTEM
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

maintainers-update-capabilities-pattern.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

