From: akpm@linux-foundation.org
Subject: [merged] zram-add-zram-maintainers.patch removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:17 -0800
Message-ID: <52ebf681.79Yte9UgOdTI55IM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org

Subject: [merged] zram-add-zram-maintainers.patch removed from -mm tree
To: minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:17 -0800


The patch titled
     Subject: zram: add zram maintainers
has been removed from the -mm tree.  Its filename was
     zram-add-zram-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: add zram maintainers

Add maintainer information for zram into the MAINTAINERS file.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~zram-add-zram-maintainers MAINTAINERS
--- a/MAINTAINERS~zram-add-zram-maintainers
+++ a/MAINTAINERS
@@ -9740,6 +9740,14 @@ T:	Mercurial http://linuxtv.org/hg/v4l-d
 S:	Odd Fixes
 F:	drivers/media/pci/zoran/
 
+ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
+M:	Minchan Kim <minchan@kernel.org>
+M:	Nitin Gupta <ngupta@vflare.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/block/zram/
+F:	Documentation/blockdev/zram.txt
+
 ZS DECSTATION Z85C30 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
debugging-keep-track-of-page-owners.patch

