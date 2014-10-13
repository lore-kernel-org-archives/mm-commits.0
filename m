From: akpm@linux-foundation.org
Subject: [folded-merged]
 checkpatch-allow-optional-shorter-config-descriptions-v4.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:36:31 -0700
Message-ID: <543c53ef.uAoo4eEBmOCgJbSy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaJMWgb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:36:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbendeb@chromium.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-allow-optional-shorter-config-descriptions-v4
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-optional-shorter-config-descriptions-v4.patch

This patch was dropped because it was folded into checkpatch-allow-optional-shorter-config-descriptions.patch

------------------------------------------------------
From: Vadim Bendebury <vbendeb@chromium.org>
Subject: checkpatch-allow-optional-shorter-config-descriptions-v4

  - added the missing trailing semicolon. Re-tested to verify that it
    still works as expected.

Signed-off-by: Vadim Bendebury <vbendeb@chromium.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-optional-shorter-config-descriptions-v4 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-optional-shorter-config-descriptions-v4
+++ a/scripts/checkpatch.pl
@@ -2290,7 +2290,7 @@ sub process {
 			}
 			if ($is_start && $is_end && $length < $min_conf_desc_length) {
 				WARN("CONFIG_DESCRIPTION",
-				     "please write a paragraph that describes the config symbol fully\n" . $herecurr)
+				     "please write a paragraph that describes the config symbol fully\n" . $herecurr);
 			}
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
_

Patches currently in -mm which might be from vbendeb@chromium.org are

checkpatch-allow-optional-shorter-config-descriptions.patch

