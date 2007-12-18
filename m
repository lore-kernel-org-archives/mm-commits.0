From: akpm@linux-foundation.org
Subject: + fix-missing-n-in-checkpatchpl.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:47:37 -0800
Message-ID: <200712182347.lBINlbE9028108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbXLRXsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:48:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mchehab@infradead.org, apw@shadowen.org


The patch titled
     Fix missing \n in checkpatch.pl
has been added to the -mm tree.  Its filename is
     fix-missing-n-in-checkpatchpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
git-dvb.patch
git-dvb-one-videobuf_read_start-is-enough.patch
git-input.patch
fix-versus-precedence-in-various-places.patch
fix-missing-n-in-checkpatchpl.patch
