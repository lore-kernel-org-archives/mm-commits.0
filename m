From: akpm@linux-foundation.org
Subject: + parse_integer-convert-mm-fix.patch added to -mm tree
Date: Thu, 16 Jul 2015 14:20:24 -0700
Message-ID: <55a82018.simRDfXnmsnQdYil%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbGPVUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jul 2015 17:20:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: fixup mm/memcontrol.c conversion
has been added to the -mm tree.  Its filename is
     parse_integer-convert-mm-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-convert-mm-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-convert-mm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: fixup mm/memcontrol.c conversion

Fix copypasterro: efd => cfd.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~parse_integer-convert-mm-fix mm/memcontrol.c
--- a/mm/memcontrol.c~parse_integer-convert-mm-fix
+++ a/mm/memcontrol.c
@@ -3910,7 +3910,7 @@ static ssize_t memcg_write_event_control
 	buf += ret;
 	if (*buf++ != ' ')
 		return -EINVAL;
-	ret = parse_integer(buf, 10, &efd);
+	ret = parse_integer(buf, 10, &cfd);
 	if (ret < 0)
 		return ret;
 	buf += ret;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-fixup-empty-argv-case-for-proc-pid-cmdline.patch
kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-mm-fix.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch
parse_integer-add-checkpatchpl-notice.patch

