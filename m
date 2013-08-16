From: akpm@linux-foundation.org
Subject: [failures] drivers-block-brdc-make-rd_size-static.patch removed
 from -mm tree
Date: Fri, 16 Aug 2013 00:18:56 -0700
Message-ID: <520dd260.vEiJhr+oAg1DxGil%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3HPHVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Aug 2013 03:21:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [failures] drivers-block-brdc-make-rd_size-static.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 16 Aug 2013 00:18:53 -0700


The patch titled
     Subject: drivers/block/brd.c: make 'rd_size' static
has been removed from the -mm tree.  Its filename was
     drivers-block-brdc-make-rd_size-static.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/block/brd.c: make 'rd_size' static

'rd_size' is used only in this file.  Fix the following sparse warning:

drivers/block/brd.c:432:5: warning: symbol 'rd_size' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/brd.c~drivers-block-brdc-make-rd_size-static drivers/block/brd.c
--- a/drivers/block/brd.c~drivers-block-brdc-make-rd_size-static
+++ a/drivers/block/brd.c
@@ -429,7 +429,7 @@ static const struct block_device_operati
  * And now the modules code and kernel interface.
  */
 static int rd_nr;
-int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 static int max_part;
 static int part_shift;
 module_param(rd_nr, int, S_IRUGO);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

block-replace-strict_strtoul-with-kstrtoul.patch
block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
drivers-block-mg_diskc-make-mg_times_out-static.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
kernel-replace-strict_strto-with-kstrto.patch
documentation-replace-strict_strtoul-with-kstrtoul.patch
w1-replace-strict_strtol-with-kstrtol.patch
linux-next.patch

