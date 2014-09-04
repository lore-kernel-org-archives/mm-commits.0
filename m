From: akpm@linux-foundation.org
Subject: + checkpatch-allow-optional-shorter-config-descriptions-v4.patch
 added to -mm tree
Date: Thu, 04 Sep 2014 14:17:10 -0700
Message-ID: <5408d6d6.EL4JNtcrenXeozmG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbaIDVRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2014 17:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbendeb@chromium.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-allow-optional-shorter-config-descriptions-v4
has been added to the -mm tree.  Its filename is
     checkpatch-allow-optional-shorter-config-descriptions-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-optional-shorter-config-descriptions-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-optional-shorter-config-descriptions-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
checkpatch-allow-optional-shorter-config-descriptions-v4.patch

