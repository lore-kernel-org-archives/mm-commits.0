From: akpm@linux-foundation.org
Subject: + zram-drop-not-used-table-count-member.patch added to -mm tree
Date: Tue, 04 Feb 2014 14:19:16 -0800
Message-ID: <52f16764.3amt7YUewUxR6PW7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935524AbaBDWTR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:19:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-drop-not-used-table-count-member.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:19:16 -0800


The patch titled
     Subject: zram: drop not used table `count' member
has been added to the -mm tree.  Its filename is
     zram-drop-not-used-table-count-member.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-drop-not-used-table-count-member.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-drop-not-used-table-count-member.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: drop not used table `count' member

struct table `count' member is not used.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.h~zram-drop-not-used-table-count-member drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-drop-not-used-table-count-member
+++ a/drivers/block/zram/zram_drv.h
@@ -64,7 +64,6 @@ enum zram_pageflags {
 struct table {
 	unsigned long handle;
 	u16 size;	/* object size (excluding header) */
-	u8 count;	/* object ref count (not yet used) */
 	u8 flags;
 } __aligned(4);
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch

