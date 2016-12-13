From: akpm@linux-foundation.org
Subject: [patch 117/123] scripts/checkpatch.pl: fix spelling
Date: Mon, 12 Dec 2016 16:46:26 -0800
Message-ID: <584f44e2.g4ks8QojxCX3Fi3G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932578AbcLMAq1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/checkpatch.pl: fix spelling

s/preceeded/preceded/

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-fix-spelling scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-fix-spelling
+++ a/scripts/checkpatch.pl
@@ -5925,7 +5925,7 @@ sub process {
 			}
 			if (!$has_break && $has_statement) {
 				WARN("MISSING_BREAK",
-				     "Possible switch case/default not preceeded by break or fallthrough comment\n" . $herecurr);
+				     "Possible switch case/default not preceded by break or fallthrough comment\n" . $herecurr);
 			}
 		}
 
_
