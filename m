From: akpm@linux-foundation.org
Subject: - fix-missing-n-in-checkpatchpl.patch removed from -mm tree
Date: Thu, 17 Jan 2008 14:18:38 -0800
Message-ID: <200801172218.m0HMIJ8l016200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757705AbYAQWSj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 17:18:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mchehab@infradead.org, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Fix missing \n in checkpatch.pl
has been removed from the -mm tree.  Its filename was
     fix-missing-n-in-checkpatchpl.patch

This patch was dropped because it was folded into update-checkpatchpl-to-version-013.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix missing \n in checkpatch.pl
From: Mauro Carvalho Chehab <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~fix-missing-n-in-checkpatchpl scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~fix-missing-n-in-checkpatchpl
+++ a/scripts/checkpatch.pl
@@ -1074,7 +1074,7 @@ sub process {
 # 		}
 
 		if ($line =~ /\bLINUX_VERSION_CODE\b/) {
-			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged" . $herecurr);
+			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);
 		}
 
 # printk should use KERN_* levels.  Note that follow on printk's on the
_

Patches currently in -mm which might be from mchehab@infradead.org are

git-dvb.patch
drivers-media-dvb-frontends-xc5000c-dont-return-garbage-from-xc5000_init.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
git-dvb-fix-drivers-media-video-bt8xx-bttv-driverc-build.patch
git-input.patch
fix-versus-precedence-in-various-places.patch
fix-missing-n-in-checkpatchpl.patch
